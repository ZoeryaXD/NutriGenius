import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/history_entity.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

class DetailHistoryPage extends StatelessWidget {
  final HistoryEntity history;
  final String email;

  const DetailHistoryPage({
    super.key,
    required this.history,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final imageUrl =
        "${ApiClient.baseUrl.replaceAll('/api', '')}/uploads/scans/${history.imagePath}";
    final date = DateFormat(
      'EEEE, d MMM yyyy • HH:mm',
      'id_ID',
    ).format(history.createdAt);

    return BlocListener<HistoryBloc, HistoryState>(
      listener: (context, state) {
        if (state is HistoryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        if (state is HistoryLoaded) {
          // Jika state berubah jadi Loaded setelah kita delete, berarti hapus berhasil
          // Kita tidak perlu pop di sini karena sudah dihandle di tombol hapus,
          // tapi ini menjaga agar UI sinkron.
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body:
            isLandscape
                ? _buildLandscapeLayout(
                  context,
                  imageUrl,
                  date,
                  isDark,
                  theme,
                  cs,
                )
                : _buildPortraitLayout(
                  context,
                  imageUrl,
                  date,
                  isDark,
                  theme,
                  cs,
                ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    String url,
    String date,
    bool isDark,
    ThemeData theme,
    ColorScheme cs,
  ) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: isDark ? const Color(0xFF0A0F0A) : Colors.green,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(url, fit: BoxFit.cover),
          ),
          leading: _backBtn(context, isDark),
          actions: [_delBtn(context, isDark)],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _content(date, isDark, cs, false),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    String url,
    String date,
    bool isDark,
    ThemeData theme,
    ColorScheme cs,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              Positioned.fill(child: Image.network(url, fit: BoxFit.cover)),
              Positioned(top: 40, left: 20, child: _backBtn(context, isDark)),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [_delBtn(context, isDark)],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _content(date, isDark, cs, true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _content(String date, bool isDark, ColorScheme cs, bool isLandscape) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          history.foodName,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.green[800],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(date, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          "Informasi Nutrisi",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isLandscape ? 3 : 2,
          childAspectRatio: 2.2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _card(
              "🔥 Kalori",
              "${history.calories.toInt()} kkal",
              Colors.orange,
              isDark,
            ),
            _card(
              "🥩 Protein",
              "${history.protein?.toInt() ?? 0}g",
              Colors.blue,
              isDark,
            ),
            _card(
              "🍞 Karbo",
              "${history.carbs?.toInt() ?? 0}g",
              Colors.brown,
              isDark,
            ),
            _card(
              "🥑 Lemak",
              "${history.fat?.toInt() ?? 0}g",
              Colors.teal,
              isDark,
            ),
            _card(
              "🍬 Gula",
              "${history.sugar?.toInt() ?? 0}g",
              Colors.pink,
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _card(String l, String v, Color c, bool d) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: d ? c.withOpacity(0.1) : c.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l,
            style: TextStyle(
              fontSize: 11,
              color: c,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            v,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: d ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _backBtn(BuildContext context, bool d) => IconButton(
    icon: CircleAvatar(
      backgroundColor: d ? Colors.black54 : Colors.white,
      child: Icon(Icons.arrow_back, color: d ? Colors.white : Colors.green),
    ),
    onPressed: () => Navigator.pop(context),
  );

  Widget _delBtn(BuildContext context, bool d) => IconButton(
    icon: const CircleAvatar(
      backgroundColor: Colors.red,
      child: Icon(Icons.delete, color: Colors.white),
    ),
    onPressed: () => _confirm(context, d),
  );

  void _confirm(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF161D16) : Colors.white,
            title: const Text("Hapus Riwayat?"),
            content: const Text("Data ini akan dihapus permanen."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  context.read<HistoryBloc>().add(
                    DeleteHistoryEvent(id: history.id, email: email),
                  );
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
