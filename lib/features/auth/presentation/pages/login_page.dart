import 'package:flutter/material.dart';
import 'package:nutrigenius/core/theme/app_colors.dart';
import 'package:nutrigenius/core/theme/app_text_styles.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_button.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              
              Image.asset(
                'assets/images/logo.png', 
                height: 120,
              ),
              
              const SizedBox(height: 40),
              
              Text(
                'NutriGenius',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.primary,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Cara Genius Hidup Sehat',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray600,
                ),
              ),
              
              const SizedBox(height: 40),
              
              AuthTextField(
                label: 'Email',
                hintText: 'Masukkan email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              
              const SizedBox(height: 16),
              
              AuthTextField(
                label: 'Password',
                hintText: 'Masukkan password',
                obscureText: true,
                prefixIcon: Icons.lock_outlined,
                suffixIcon: Icons.visibility_off_outlined,
              ),
              
              const SizedBox(height: 24),
              
              AuthButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
              ),
              
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun? ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Daftar',
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