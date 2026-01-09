import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_event.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_state.dart';
import 'package:nutrigenius/features/auth/presentation/pages/register_page.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_button_field.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_dialogs.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('email', _emailController.text.trim());

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Berhasil!"), backgroundColor: Colors.green),
            );
            
            // Navigasi
            if (state.isOnboarded) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else {
              Navigator.pushReplacementNamed(context, '/firstpage');
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is AuthResetEmailSent) {
            AuthDialogs.showResetSuccess(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/logo.png', height: 100),
              const SizedBox(height: 20),
              Text(
                "NutriGenius",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              Text("Cara Genius Hidup Sehat", style: TextStyle(fontSize: 16, color: Colors.green[600])),
              
              const SizedBox(height: 50),

              AuthTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),

              AuthTextField(
                controller: _passController,
                label: "Password",
                icon: Icons.lock_outline,
                isObscure: _isObscure,
                suffixIcon: IconButton(
                  icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => AuthDialogs.showForgotPassword(context),
                  child: Text("Lupa Password?", style: TextStyle(color: Colors.grey[600])),
                ),
              ),
              
              const SizedBox(height: 20),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return AuthButton(
                    text: "LOGIN",
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            LoginRequested(
                              _emailController.text,
                              _passController.text,
                            ),
                          );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),
              
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("ATAU")),
                  Expanded(child: Divider()),
                ],
              ),
              
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Daftar Sekarang",
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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