import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/firstpage_bloc.dart';

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirstPageBloc, FirstPageState>(
      listener: (context, state) {
        if (state.status == FirstPageStatus.successSubmit) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (route) => false,
          );
        } else if (state.status == FirstPageStatus.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              // Navigasi Back Text
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Langkah 3 dari 3",
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),

              Text(
                "Target Nutrisi Kamu",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 40),

              // Lingkaran Besar
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green[700]!, width: 10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.green[700],
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${state.tdee.toInt()} Kkal",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    Text(
                      "Batas Harian Kamu",
                      style: TextStyle(fontSize: 12, color: Colors.green[800]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Rincian (Bullet Points)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Rincian:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildDotInfo("BMR (Energi Dasar): ${state.bmr.toInt()} kkal"),
              _buildDotInfo(
                "Aktivitas Harian: +${(state.tdee - state.bmr).toInt()} kkal",
              ),

              SizedBox(height: 40),
              Text(
                "Mulai hari ini, kami akan membantumu tetap di bawah angka ${state.tdee.toInt()} kkal!",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16, color: Colors.green[700]),
              ),

              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final email = FirebaseAuth.instance.currentUser?.email;
                    if (email != null) {
                      context.read<FirstPageBloc>().add(SubmitProfile(email));
                    }
                  },
                  child: Text(
                    "Masuk Dashboard",
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

  Widget _buildDotInfo(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.circle, size: 14, color: Colors.green[700]),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[900],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
