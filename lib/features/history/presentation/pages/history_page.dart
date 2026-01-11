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
    userEmail = prefs.getString('email');
    if (userEmail != null && mounted) {
      context.read<HistoryBloc>().add(LoadHistoryEvent(userEmail!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          "Riwayat Makan",
          style: TextStyle(
            color: isDark ? Colors.white : colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colorScheme.primary),
            onPressed: () {
              if (userEmail != null) {
                context.read<HistoryBloc>().add(LoadHistoryEvent(userEmail!));
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }
          if (state is HistoryLoaded) {
            if (state.histories.isEmpty)
              return _buildEmptyState(colorScheme, isDark);
            return RefreshIndicator(
              onRefresh: () async {
                if (userEmail != null)
                  context.read<HistoryBloc>().add(LoadHistoryEvent(userEmail!));
              },
              color: colorScheme.primary,
              child:
                  isLandscape
                      ? _buildLandscape(state, colorScheme, isDark)
                      : _buildPortrait(state, colorScheme, isDark),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPortrait(HistoryLoaded state, ColorScheme cs, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WeeklyReportCard(
            weeklyCalories: state.weeklyCalories,
            totalCalories: state.totalCaloriesThisWeek,
            dailyAverage: state.dailyAverage,
          ),
          const SizedBox(height: 32),
          _buildHeader("Riwayat Scan", cs, isDark),
          const SizedBox(height: 16),
          _buildList(state),
        ],
      ),
    );
  }

  Widget _buildLandscape(HistoryLoaded state, ColorScheme cs, bool isDark) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: WeeklyReportCard(
              weeklyCalories: state.weeklyCalories,
              totalCalories: state.totalCaloriesThisWeek,
              dailyAverage: state.dailyAverage,
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          color: isDark ? Colors.white10 : Colors.black12,
        ),
        Expanded(
          flex: 5,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildHeader("Riwayat Scan", cs, isDark),
              const SizedBox(height: 16),
              _buildList(state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String title, ColorScheme cs, bool isDark) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildList(HistoryLoaded state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.histories.length,
      itemBuilder:
          (context, index) => HistoryListItem(
            item: state.histories[index],
            userEmail: userEmail ?? '',
          ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off_rounded,
            size: 80,
            color: cs.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "Belum ada riwayat",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
