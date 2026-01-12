import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/presentation/bloc/dashboard_event.dart';
import '../../domain/entities/history_entity.dart';
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
  String _selectedMealType = "Semua";

  final List<String> _mealCategories = [
    "Semua",
    "Sarapan",
    "Makan Siang",
    "Makan Malam",
    "Snack / Camilan",
  ];

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

  List<HistoryEntity> _getFilteredData(List<HistoryEntity> data) {
    if (_selectedMealType == "Semua") return data;
    return data.where((item) {
      final type = item.mealType;
      return type.toLowerCase() == _selectedMealType.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return BlocListener<HistoryBloc, HistoryState>(
      listener: (context, state) {
        if (state is DeleteHistoryEvent) {
          context.read<DashboardBloc>().add(RefreshDashboard());
          if (userEmail != null) {
            context.read<HistoryBloc>().add(LoadHistoryEvent(userEmail!));
          }
        }
      },
      child: Scaffold(
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
                  context.read<DashboardBloc>().add(RefreshDashboard());
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
            if (state is HistoryFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Gagal memuat: ${state.message}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
            if (state is HistoryLoaded) {
              final filteredList = _getFilteredData(state.histories);
              if (state.histories.isEmpty)
                return _buildEmptyState(colorScheme, isDark);

              return RefreshIndicator(
                onRefresh: () async {
                  if (userEmail != null) {
                    context.read<HistoryBloc>().add(
                      LoadHistoryEvent(userEmail!),
                    );
                    context.read<DashboardBloc>().add(RefreshDashboard());
                  }
                },
                color: colorScheme.primary,
                child:
                    isLandscape
                        ? _buildLandscape(
                          state,
                          filteredList,
                          colorScheme,
                          isDark,
                        )
                        : _buildPortrait(
                          state,
                          filteredList,
                          colorScheme,
                          isDark,
                        ),
              );
            }
            return const Center(child: Text("Menunggu data..."));
          },
        ),
      ),
    );
  }

  Widget _buildPortrait(
    HistoryLoaded state,
    List<HistoryEntity> filtered,
    ColorScheme cs,
    bool isDark,
  ) {
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
          _buildMealFilter(cs, isDark),
          const SizedBox(height: 24),
          _buildHeader(
            "Menu $_selectedMealType (${filtered.length})",
            cs,
            isDark,
          ),
          const SizedBox(height: 16),
          _buildList(filtered),
        ],
      ),
    );
  }

  Widget _buildLandscape(
    HistoryLoaded state,
    List<HistoryEntity> filtered,
    ColorScheme cs,
    bool isDark,
  ) {
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
              _buildMealFilter(cs, isDark),
              const SizedBox(height: 24),
              _buildHeader(
                "Menu $_selectedMealType (${filtered.length})",
                cs,
                isDark,
              ),
              const SizedBox(height: 16),
              _buildList(filtered),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealFilter(ColorScheme cs, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "KATEGORI MAKAN",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white54 : Colors.black54,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                _mealCategories.map((type) {
                  final isSelected = _selectedMealType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected:
                          (val) => setState(() => _selectedMealType = type),
                      selectedColor: cs.primary,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black87),
                      ),
                      backgroundColor:
                          isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildList(List<HistoryEntity> histories) {
    if (histories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(child: Text("Tidak ada riwayat untuk kategori ini")),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: histories.length,
      itemBuilder:
          (context, index) => HistoryListItem(
            item: histories[index],
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
