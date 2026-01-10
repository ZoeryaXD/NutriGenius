import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgets/history_list_item.dart';
import '../widgets/weekly_report_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email');
    });
    if (userEmail != null) {
      context.read<HistoryBloc>().add(LoadHistoryEvent(userEmail!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                if (userEmail != null) {
                  context.read<HistoryBloc>().add(LoadHistoryEvent(userEmail!));
                }
              },
              color: Colors.green,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: const Text(
                      "Riwayat",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  if (state is HistoryLoaded)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      sliver:
                          isLandscape
                              ? _buildLandscapeLayout(state)
                              : _buildPortraitLayout(state),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(HistoryLoaded state) {
    return SliverList(
      delegate: SliverChildListDelegate([
        WeeklyReportCard(
          weeklyCalories: state.weeklyCalories,
          totalCalories: state.totalCaloriesThisWeek,
          dailyAverage: state.dailyAverage,
        ),
        const SizedBox(height: 24),
        const Text(
          "Aktivitas Terbaru",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        _buildList(state.histories),
      ]),
    );
  }

  Widget _buildLandscapeLayout(HistoryLoaded state) {
    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: WeeklyReportCard(
              weeklyCalories: state.weeklyCalories,
              totalCalories: state.totalCaloriesThisWeek,
              dailyAverage: state.dailyAverage,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Aktivitas Terbaru",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                _buildList(state.histories),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List histories) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: histories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder:
          (context, index) => HistoryListItem(
            item: histories[index],
            userEmail: userEmail ?? '',
          ),
    );
  }
}
