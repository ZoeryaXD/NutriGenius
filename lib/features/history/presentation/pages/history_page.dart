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
  String _selectedFilter = "Semua";
  final List<String> _mealTypes = [
    "Semua",
    "Sarapan",
    "Makan Siang",
    "Makan Malam",
    "Cemilan",
  ];

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
    final theme = Theme.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                if (userEmail != null) {
                  context.read<HistoryBloc>().add(LoadHistoryEvent(userEmail!));
                }
              },
              color: theme.colorScheme.primary,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    elevation: 0,
                    centerTitle: false,
                    title: Text(
                      "Riwayat",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
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
                              ? _buildLandscapeLayout(state, theme)
                              : _buildPortraitLayout(state, theme),
                    ),
                  if (state is HistoryLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(HistoryLoaded state, ThemeData theme) {
    final filteredHistories =
        _selectedFilter == "Semua"
            ? state.histories
            : state.histories
                .where((h) => h.mealType == _selectedFilter)
                .toList();

    return SliverList(
      delegate: SliverChildListDelegate([
        WeeklyReportCard(
          weeklyCalories: state.weeklyCalories,
          totalCalories: state.totalCaloriesThisWeek,
          dailyAverage: state.dailyAverage,
        ),
        const SizedBox(height: 24),
        _buildFilterSection(theme),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Aktivitas Terbaru",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            if (_selectedFilter != "Semua")
              Text(
                "${filteredHistories.length} ditemukan",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _buildList(filteredHistories),
      ]),
    );
  }

  Widget _buildLandscapeLayout(HistoryLoaded state, ThemeData theme) {
    final filteredHistories =
        _selectedFilter == "Semua"
            ? state.histories
            : state.histories
                .where((h) => h.mealType == _selectedFilter)
                .toList();

    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                WeeklyReportCard(
                  weeklyCalories: state.weeklyCalories,
                  totalCalories: state.totalCaloriesThisWeek,
                  dailyAverage: state.dailyAverage,
                ),
                const SizedBox(height: 16),
                _buildFilterSection(theme),
              ],
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
                _buildList(filteredHistories),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Filter Kategori",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                _mealTypes.map((type) {
                  bool isSelected = _selectedFilter == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedFilter = type;
                        });
                      },
                      selectedColor: theme.colorScheme.primary,
                      backgroundColor: theme.colorScheme.surface,
                      labelStyle: TextStyle(
                        color:
                            isSelected
                                ? Colors.white
                                : theme.colorScheme.primary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildList(List histories) {
    if (histories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.no_meals_rounded,
                size: 64,
                color: Colors.grey.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              const Text(
                "Tidak ada riwayat untuk kategori ini",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
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
