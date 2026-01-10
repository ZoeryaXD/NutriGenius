import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/firstpage/presentation/bloc/firstpage_event.dart';
import 'package:nutrigenius/features/firstpage/presentation/bloc/firstpage_state.dart';
import '../bloc/firstpage_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SecondPage extends StatefulWidget {
  final PageController pageController;
  const SecondPage({super.key, required this.pageController});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int? _activityId;
  int? _healthId;

  @override
  void initState() {
    super.initState();
    final state = context.read<FirstPageBloc>().state;
    if (state.activityLevels.isEmpty || state.healthConditions.isEmpty) {
      context.read<FirstPageBloc>().add(LoadMasterData());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return BlocConsumer<FirstPageBloc, FirstPageState>(
      listener: (context, state) {
        if (state.status == FirstPageStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? "Terjadi kesalahan"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == FirstPageStatus.loadingMaster) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap:
                    () => widget.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      "Langkah 2 dari 3",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Seberapa aktif\nkeseharianmu?",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 30),
              ...state.activityLevels
                  .map(
                    (activity) => _buildActivityButton(
                      context,
                      activity.id,
                      "${activity.levelName} (${activity.description})",
                    ),
                  )
                  .toList(),
              const SizedBox(height: 30),
              Text(
                "Tujuan Kamu:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _healthId,
                    hint: Text(
                      "Pilih Tujuan Kesehatan",
                      style: TextStyle(color: theme.hintColor),
                    ),
                    isExpanded: true,
                    dropdownColor: theme.colorScheme.surface,
                    icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                    items:
                        state.healthConditions.map((condition) {
                          return DropdownMenuItem<int>(
                            value: condition.id,
                            child: _buildHealthItem(
                              context,
                              _getIconForHealth(condition.conditionName),
                              condition.conditionName,
                            ),
                          );
                        }).toList(),
                    onChanged: (v) => setState(() => _healthId = v!),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_activityId == null || _healthId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Harap pilih aktivitas dan tujuan kesehatan!",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    context.read<FirstPageBloc>().add(
                      HealthGoalChanged(_healthId!),
                    );
                    context.read<FirstPageBloc>().add(
                      CalculateStep2Data(_activityId!),
                    );
                    widget.pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: const Text(
                    "Hitung",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHealthItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildActivityButton(BuildContext context, int id, String text) {
    final theme = Theme.of(context);
    bool isSelected = _activityId == id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _activityId = id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? theme.colorScheme.primary : theme.dividerColor,
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForHealth(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('diabetes')) return Icons.bloodtype;
    if (lowerName.contains('obesitas')) return FontAwesomeIcons.weightScale;
    if (lowerName.contains('hipertensi')) return FontAwesomeIcons.heartPulse;
    return Icons.spa_rounded;
  }
}
