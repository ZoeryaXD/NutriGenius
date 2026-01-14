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

  List<int> _selectedIds = [];
  bool _isSelectionMode = false;

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

  void _cancelSelection() {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  List<HistoryEntity> _getFilteredData(List<HistoryEntity> data) {
    if (_selectedMealType == "Semua") return data;
    return data.where((item) {
      return item.mealType.toLowerCase() == _selectedMealType.toLowerCase();
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
        if (state is HistoryLoaded) {
          context.read<DashboardBloc>().add(RefreshDashboard());
        }
        if (state is HistoryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          leading:
              _isSelectionMode
                  ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _cancelSelection,
                  )
                  : null,
          title: Text(
            _isSelectionMode
                ? "${_selectedIds.length} Terpilih"
                : "Riwayat Makan",
            style: TextStyle(
              color: isDark ? Colors.white : colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            if (_isSelectionMode && _selectedIds.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(context),
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
              return _buildErrorState(state.message);
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
            return const SizedBox();
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
          if (!_isSelectionMode) ...[
            WeeklyReportCard(
              weeklyCalories: state.weeklyCalories,
              totalCalories: state.totalCaloriesThisWeek,
              dailyAverage: state.dailyAverage,
            ),
            const SizedBox(height: 32),
          ],
          _buildMealFilter(cs, isDark),
          const SizedBox(height: 24),
          _buildHeader(
            _isSelectionMode
                ? "Pilih Item"
                : "Menu $_selectedMealType (${filtered.length})",
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
        if (!_isSelectionMode)
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
        if (!_isSelectionMode)
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
                _isSelectionMode
                    ? "Pilih Item"
                    : "Menu $_selectedMealType (${filtered.length})",
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

  Widget _buildList(List<HistoryEntity> histories) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: histories.length,
      itemBuilder: (context, index) {
        final item = histories[index];
        final isSelected = _selectedIds.contains(item.id);

        return GestureDetector(
          onLongPress: () {
            setState(() {
              _isSelectionMode = true;
              if (!isSelected) _selectedIds.add(item.id);
            });
          },
          onTap: () {
            if (_isSelectionMode) {
              setState(() {
                if (isSelected) {
                  _selectedIds.remove(item.id);
                  if (_selectedIds.isEmpty) _isSelectionMode = false;
                } else {
                  _selectedIds.add(item.id);
                }
              });
            }
          },
          child: Row(
            children: [
              if (_isSelectionMode)
                Checkbox(
                  value: isSelected,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedIds.add(item.id);
                      } else {
                        _selectedIds.remove(item.id);
                        if (_selectedIds.isEmpty) _isSelectionMode = false;
                      }
                    });
                  },
                ),
              Expanded(
                child: HistoryListItem(item: item, userEmail: userEmail ?? ''),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Hapus Sekaligus?"),
            content: Text(
              "Kamu akan menghapus ${_selectedIds.length} riwayat secara permanen.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  context.read<HistoryBloc>().add(
                    DeleteHistoryEvent(ids: _selectedIds, email: userEmail!),
                  );

                  Navigator.pop(ctx);
                  _cancelSelection();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sedang menghapus data...")),
                  );
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

  Widget _buildMealFilter(ColorScheme cs, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "KATEGORI MAKAN",
          style: TextStyle(
            fontSize: 11,
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
                      onSelected: (val) {
                        if (!_isSelectionMode)
                          setState(() => _selectedMealType = type);
                      },
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

  Widget _buildErrorState(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadInitialData(),
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      ),
    );
  }
}
