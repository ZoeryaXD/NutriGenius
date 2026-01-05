import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgets/weekly_report_card.dart';
import '../widgets/history_list_item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(LoadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'History Log',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            if (state.histories.isEmpty) return _buildEmptyState();

            return isLandscape
                ? _buildWideLayout(state)
                : _buildPortraitLayout(state);
          } else if (state is HistoryError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPortraitLayout(HistoryLoaded state) {
    return RefreshIndicator(
      onRefresh: () async => context.read<HistoryBloc>().add(LoadHistory()),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          WeeklyReportCard(weeklyData: state.chartData),
          const SizedBox(height: 24),
          const Text(
            'Riwayat Scan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.histories.length,
            itemBuilder:
                (context, index) =>
                    HistoryListItem(food: state.histories[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(HistoryLoaded state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Row(
            children: [
              Expanded(
                flex: 45,
                child: const Text(
                  "Laporan Mingguan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 55,
                child: const Text(
                  "Riwayat Scan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 45,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 12, 24),
                  child: WeeklyReportCard(weeklyData: state.chartData),
                ),
              ),

              Expanded(
                flex: 55,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 24, 24),
                  itemCount: state.histories.length,
                  itemBuilder:
                      (context, index) =>
                          HistoryListItem(food: state.histories[index]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Tidak ada riwayat scan.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
