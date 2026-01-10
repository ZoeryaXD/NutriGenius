import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/firstpage/presentation/bloc/firstpage_event.dart';
import 'package:nutrigenius/features/firstpage/presentation/bloc/firstpage_state.dart';
import '../bloc/firstpage_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SecondPage extends StatefulWidget {
  final PageController pageController;
  const SecondPage({required this.pageController});

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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.green),
                SizedBox(height: 10),
                Text("Mengambil data server..."),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap:
                    () => widget.pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      "Langkah 2 dari 3",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              Text(
                "Seberapa aktif\nkeseharianmu?",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 30),
              if (state.activityLevels.isEmpty &&
                  state.status == FirstPageStatus.successMaster)
                Text("Data aktivitas kosong"),

              ...state.activityLevels.map((activity) {
                String label =
                    "${activity.levelName} (${activity.description})";
                return _buildActivityButton(activity.id, label);
              }).toList(),

              SizedBox(height: 30),

              Text(
                "Tujuan Kamu:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 10),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _healthId,
                    hint: Text(
                      "Pilih Tujuan Kesehatan",
                      style: TextStyle(color: Colors.white70),
                    ),
                    isExpanded: true,
                    dropdownColor: Colors.green[700],
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    items:
                        state.healthConditions.map((condition) {
                          return DropdownMenuItem<int>(
                            value: condition.id,
                            child: _buildHealthItem(
                              _getIconForHealth(condition.conditionName),
                              condition.conditionName,
                            ),
                          );
                        }).toList(),
                    onChanged: (v) => setState(() => _healthId = v!),
                  ),
                ),
              ),

              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_activityId == null || _healthId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
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
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: Text(
                    "Hitung",
                    style: TextStyle(
                      color: Colors.green[800],
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

  Widget _buildHealthItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 10),
        Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildActivityButton(int id, String text) {
    bool isSelected = _activityId == id;
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _activityId = id),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green[700] : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 14,
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
    return Icons.accessibility;
  }
}