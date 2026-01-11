import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../widgets/notification_card.dart';
import 'notification_detail_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Color primaryGreen = const Color(0xFF2E7D32);
  final NotificationRemoteDataSource _dataSource = NotificationRemoteDataSource();
  
  List<NotificationEntity> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (_notifications.isEmpty) setState(() => _isLoading = true);
    
    try {
      final result = await _dataSource.fetchNotifications();
      if (mounted) {
        setState(() {
          _notifications = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onNotificationTap(NotificationEntity item) async {
    if (!item.isRead) {
      setState(() {
        item.isRead = true;
      });
      await _dataSource.markAsRead(item.id);
    }

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationDetailPage(item: item),
        ),
      );
      _loadData(); 
    }
  }

  void _deleteItem(int index) async {
    final item = _notifications[index];
  
    setState(() {
      _notifications.removeAt(index);
    });

    await _dataSource.deleteItem(item.id);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notifikasi dihapus"), duration: Duration(seconds: 1)),
      );
    }
  }

  void _deleteAll() async {
    if (_notifications.isEmpty) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Semua?"),
        content: const Text("Apakah Anda yakin ingin menghapus semua notifikasi?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      List<String> idsToRemove = _notifications.map((e) => e.id).toList();
      
      setState(() {
        _notifications.clear();
      });

      await _dataSource.deleteAll(idsToRemove);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Notifikasi",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryGreen,
          ),
        ),
        centerTitle: false, 
        actions: [
          if (_notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.grey),
              tooltip: "Hapus Semua",
              onPressed: _deleteAll,
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text("Tidak ada notifikasi", style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final item = _notifications[index];
                        
                        return Dismissible(
                          key: Key(item.id), 
                          direction: DismissDirection.endToStart, 
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            _deleteItem(index);
                          },
                          child: NotificationCard(
                            item: item,
                            onTap: () => _onNotificationTap(item),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}