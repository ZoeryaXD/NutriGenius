import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/firstpage_bloc.dart';
import '../bloc/firstpage_event.dart';
import '../bloc/firstpage_state.dart';

class SecondPage extends StatefulWidget {
  final PageController pageController;
  const SecondPage({super.key, required this.pageController});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int? _activityId;
  int? _healthId;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<FirstPageBloc, FirstPageState>(
      builder: (context, state) {
        if (state.status == FirstPageStatus.loadingMaster) {
          return Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              const Text(
                "Seberapa aktif keseharianmu?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              ...state.activityLevels.map((activity) {
                bool isSelected = _activityId == activity.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => setState(() => _activityId = activity.id),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? colorScheme.primary
                                : (isDark
                                    ? colorScheme.surface
                                    : Colors.grey[100]),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.levelName,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.white
                                          : Colors.black87),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity.description,
                            style: TextStyle(
                              color: isSelected ? Colors.white70 : Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 32),
              const Text(
                "Pilih Tujuan Kesehatan:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.surface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _healthId,
                    isExpanded: true,
                    dropdownColor:
                        isDark ? const Color(0xFF161D16) : Colors.white,
                    hint: const Text("Pilih Tujuan"),
                    items:
                        state.healthConditions.map((condition) {
                          return DropdownMenuItem<int>(
                            value: condition.id,
                            child: Text(condition.conditionName),
                          );
                        }).toList(),
                    onChanged: (v) => setState(() => _healthId = v!),
                  ),
                ),
              ),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _onCalculate,
                  child: const Text(
                    "Hitung Kebutuhan Saya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onCalculate() {
    if (_activityId == null || _healthId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih aktivitas dan tujuan dulu ya!")),
      );
      return;
    }
    context.read<FirstPageBloc>().add(HealthGoalChanged(_healthId!));
    context.read<FirstPageBloc>().add(CalculateStep2Data(_activityId!));
    widget.pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onTap:
          () => widget.pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            "Langkah 2 dari 3",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
