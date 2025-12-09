import 'package:flutter/material.dart';
import 'package:nutrigenius/core/theme/app_colors.dart';
import 'package:nutrigenius/core/theme/app_text_styles.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_button.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Title
              Text(
                'Daftar',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.primary,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'Buat akun NutriGenius Anda',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray600,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Registration Form
              AuthTextField(
                label: 'Nama Lengkap',
                hintText: 'Masukkan nama lengkap',
                prefixIcon: Icons.person_outline,
              ),
              
              const SizedBox(height: 16),
              
              AuthTextField(
                label: 'Email',
                hintText: 'Masukkan email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              
              const SizedBox(height: 16),
              
              AuthTextField(
                label: 'Password',
                hintText: 'Buat password',
                obscureText: true,
                prefixIcon: Icons.lock_outlined,
              ),
              
              const SizedBox(height: 16),
              
              AuthTextField(
                label: 'Konfirmasi Password',
                hintText: 'Ulangi password',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
              ),
              
              const SizedBox(height: 24),
              
              // Register Button
              AuthButton(
                text: 'Daftar',
                onPressed: () {
                  // Navigasi ke halaman data diri atau login
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              
              const SizedBox(height: 20),
              
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah punya akun? ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Login',
                      style: AppTextStyles.bodySmallBold.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}