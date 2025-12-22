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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              Text(
                'Buat Akun Baru',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.gray800,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Mulai perjalanan sehatmu hari ini!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray600,
                ),
              ),
              
              const SizedBox(height: 40),
              
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
              
              const SizedBox(height: 32),
              
              AuthButton(
                text: 'REGISTER',
                onPressed: () {
                },
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.gray300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ATAU',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.gray300,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              Center(
                child: Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}