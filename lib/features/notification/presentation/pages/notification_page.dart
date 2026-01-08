import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/network/api_client.dart'; // Pastikan path ApiClient benar
import '../../data/models/notification_model.dart'; // Pastikan path Model benar

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Variabel untuk menampung data
  late Future<List<NotificationModel>> _notificationFuture;

  @override
  void initState() {
    super.initState();
    _notificationFuture = fetchNotifications();
  }

  // FUNGSI API (Pengganti Bloc sementara biar cepat)
  Future<List<NotificationModel>> fetchNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) throw Exception("User belum login");

    try {
      final url = Uri.parse('${ApiClient.baseUrl}/notifications'); 
      final response = await http.post(
        url,
        headers: ApiClient.headers,
        body: jsonEncode({'email': user.email}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          List data = jsonResponse['data'];
          return data.map((e) => NotificationModel.fromJson(e)).toList();
        }
      }
      return []; // Return kosong jika gagal
    } catch (e) {
      print("Error Notif: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Notifikasi", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.green));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Belum ada notifikasi"));
          }

          final notifications = snapshot.data!;
          
          // Pisahkan Hari Ini & Kemarin (Logic Sederhana)
          final today = DateTime.now();
          final listToday = notifications.where((n) => 
            n.createdAt.day == today.day && n.createdAt.month == today.month).toList();
            
          final listYesterday = notifications.where((n) => 
            !(n.createdAt.day == today.day && n.createdAt.month == today.month)).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (listToday.isNotEmpty) ...[
                  _buildSectionTitle("Hari ini"),
                  SizedBox(height: 10),
                  ...listToday.map((n) => _buildDynamicCard(n, true)).toList(),
                  SizedBox(height: 20),
                ],

                if (listYesterday.isNotEmpty) ...[
                  _buildSectionTitle("Kemarin"),
                  SizedBox(height: 10),
                  ...listYesterday.map((n) => _buildDynamicCard(n, false)).toList(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper Judul
  Widget _buildSectionTitle(String text) => Text(text, style: TextStyle(fontSize: 16, color: Colors.green[700], fontWeight: FontWeight.w500));

  // WIDGET CARD DINAMIS (Menyesuaikan Kategori dari Database)
  Widget _buildDynamicCard(NotificationModel item, bool isToday) {
    // 1. Tentukan Warna & Icon berdasarkan Kategori di Database
    Color color;
    IconData icon;
    
    switch (item.category) {
      case 'sugar':
        color = Colors.red;
        icon = Icons.warning_amber_rounded;
        break;
      case 'lunch':
        color = Colors.orange;
        icon = Icons.lunch_dining;
        break;
      case 'hydration':
        color = Colors.blue;
        icon = Icons.water_drop;
        break;
      case 'protein':
        color = Colors.green;
        icon = Icons.emoji_events;
        break;
      case 'weekly':
        color = Colors.purple;
        icon = Icons.bar_chart;
        break;
      case 'recipe':
        color = Colors.teal;
        icon = Icons.menu_book;
        break;
      default:
        color = Colors.grey;
        icon = Icons.notifications;
    }

    if (isToday) {
      // Tampilan "Hari Ini" (Ada Border)
      return Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green[900])),
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(item.body, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Tampilan "Kemarin" (Abu-abu)
      return Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green[800]?.withOpacity(0.7))),
                  SizedBox(height: 4),
                  Text(item.body, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}