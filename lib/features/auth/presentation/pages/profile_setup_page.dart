import 'package:flutter/material.dart';
import 'package:nutrigenius/core/theme/app_colors.dart';
import 'package:nutrigenius/core/theme/app_text_styles.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_button.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  int _currentStep = 1;
  String? _selectedGender;
  double _weight = 65.0;
  double _height = 170.0;
  DateTime? _selectedDate;
  String? _selectedActivity;
  String? _selectedGoal;

  final List<String> _activityLevels = [
    'Light Active (Olahraga 1-3x/minggu)',
    'Sedentary (Duduk seharian/Office)',
    'Active (Olahraga 3-5x/minggu)',
    'Very Active (Fisik berat/Atlet)',
  ];

  final List<String> _goals = [
    'Pasien Diabetes',
    'Menurunkan Berat Badan',
    'Menjaga Berat Badan',
    'Menaikkan Berat Badan',
    'Meningkatkan Kebugaran',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stepper(
        currentStep: _currentStep - 1,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() {
              _currentStep++;
            });
          } else {
            // Simpan data dan pergi ke dashboard
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        },
        onStepCancel: () {
          if (_currentStep > 1) {
            setState(() {
              _currentStep--;
            });
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: [
                if (_currentStep > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Kembali',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 1) const SizedBox(width: 12),
                Expanded(
                  child: AuthButton(
                    text: _currentStep == 3 ? 'Selesai' : 'Lanjut',
                    onPressed: details.onStepContinue ?? () {},
                  ),
                ),
              ],
            ),
          );
        },
        steps: [
          // Step 1: Data Diri
          Step(
            title: const Text('Data Diri'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Halo! Yuk Kenalan Dulu',
                  style: AppTextStyles.heading1.copyWith(
                    fontSize: 24,
                    color: AppColors.gray800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Data ini membantu kami menghitung kebutuhan tubuhmu.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Jenis Kelamin
                Text(
                  'Jenis Kelamin:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Laki-laki'),
                        selected: _selectedGender == 'Laki-laki',
                        onSelected: (selected) {
                          setState(() {
                            _selectedGender = selected ? 'Laki-laki' : null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Perempuan'),
                        selected: _selectedGender == 'Perempuan',
                        onSelected: (selected) {
                          setState(() {
                            _selectedGender = selected ? 'Perempuan' : null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Berat dan Tinggi Badan
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Berat Badan:',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            value: _weight,
                            min: 30,
                            max: 150,
                            divisions: 120,
                            label: '${_weight.round()} kg',
                            onChanged: (value) {
                              setState(() {
                                _weight = value;
                              });
                            },
                          ),
                          Text(
                            '${_weight.round()} kg',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tinggi Badan:',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            value: _height,
                            min: 100,
                            max: 220,
                            divisions: 120,
                            label: '${_height.round()} cm',
                            onChanged: (value) {
                              setState(() {
                                _height = value;
                              });
                            },
                          ),
                          Text(
                            '${_height.round()} cm',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Tanggal Lahir
                Text(
                  'Tanggal Lahir:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray700,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gray50,
                    foregroundColor: AppColors.gray800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.gray500),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Pilih Tanggal Lahir',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                if (_selectedDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Usia: ${DateTime.now().year - _selectedDate!.year} Tahun',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Step 2: Aktivitas & Tujuan
          Step(
            title: const Text('Aktivitas & Tujuan'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Seberapa aktif keseharianmu?',
                  style: AppTextStyles.heading1.copyWith(
                    fontSize: 20,
                    color: AppColors.gray800,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Pilihan Aktivitas
                ..._activityLevels.map((activity) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      tileColor: _selectedActivity == activity
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.gray50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: Radio<String>(
                        value: activity,
                        groupValue: _selectedActivity,
                        onChanged: (value) {
                          setState(() {
                            _selectedActivity = value;
                          });
                        },
                      ),
                      title: Text(
                        activity,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gray800,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedActivity = activity;
                        });
                      },
                    ),
                  );
                }).toList(),
                
                const SizedBox(height: 24),
                Text(
                  'Tujuan Kamu:',
                  style: AppTextStyles.heading1.copyWith(
                    fontSize: 20,
                    color: AppColors.gray800,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Pilihan Tujuan
                ..._goals.map((goal) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      tileColor: _selectedGoal == goal
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.gray50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: Radio<String>(
                        value: goal,
                        groupValue: _selectedGoal,
                        onChanged: (value) {
                          setState(() {
                            _selectedGoal = value;
                          });
                        },
                      ),
                      title: Text(
                        goal,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gray800,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedGoal = goal;
                        });
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          
          // Step 3: Hasil
          Step(
            title: const Text('Hasil'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Target Nutrisi Kamu',
                  style: AppTextStyles.heading1.copyWith(
                    fontSize: 24,
                    color: AppColors.gray800,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Kalori Harian
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '2000 Kkal',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Batas Harian Kamu',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                Text(
                  'Rincian:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• BMR (Energi Dasar): 1.600 kkal',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                Text(
                  '• Aktivitas Harian: +400 kkal',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Mulai hari ini, kami akan membantumu tetap di bawah angka 2000 kkal!',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}