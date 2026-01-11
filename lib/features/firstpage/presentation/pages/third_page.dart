import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/firstpage_event.dart';
import '../bloc/firstpage_state.dart';
import '../bloc/firstpage_bloc.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<FirstPageBloc, FirstPageState>(
      listener: (context, state) {
        if (state.status == FirstPageStatus.successSubmit) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Langkah 3 dari 3",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Target Nutrisi Kamu",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // CIRCLE PROGRESS TARGET
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 12,
                      color: colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: 0.75, // Visual saja
                      strokeWidth: 12,
                      color: colorScheme.primary,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        color: colorScheme.primary,
                        size: 48,
                      ),
                      Text(
                        "${state.tdee.toInt()}",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "kkal / hari",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 48),

              _buildInfoCard(context, isDark, state),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  onPressed:
                      state.status == FirstPageStatus.calculating
                          ? null
                          : () {
                            final email =
                                FirebaseAuth.instance.currentUser?.email;
                            if (email != null)
                              context.read<FirstPageBloc>().add(
                                SubmitProfile(email),
                              );
                          },
                  child:
                      state.status == FirstPageStatus.calculating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "MASUK KE DASHBOARD",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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

  Widget _buildInfoCard(
    BuildContext context,
    bool isDark,
    FirstPageState state,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          _buildRow(
            "Energi Dasar (BMR)",
            "${state.bmr.toInt()} kkal",
            colorScheme,
          ),
          const Divider(height: 32),
          _buildRow(
            "Tambahan Aktivitas",
            "+${(state.tdee - state.bmr).toInt()} kkal",
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
