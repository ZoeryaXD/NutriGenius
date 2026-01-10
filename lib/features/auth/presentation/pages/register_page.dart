import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_event.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_state.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_button_field.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/auth_dialogs.dart';
import 'package:nutrigenius/features/auth/presentation/widgets/password_strength_meter.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  
  bool _isObscure = true;
  PasswordStrength _passwordStrength = PasswordStrength.weak;

  PasswordStrength _checkPasswordStrength(String password) {
    if (password.length < 6) return PasswordStrength.weak;
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSymbol = password.contains(RegExp(r'[!@#\$&*~]'));

    if (password.length >= 8 && hasUpper && hasLower && hasNumber && hasSymbol) {
      return PasswordStrength.strong;
    }
    if (hasLower && hasNumber) return PasswordStrength.medium;
    return PasswordStrength.weak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthEmailVerificationRequired) {
            AuthDialogs.showRegisterSuccess(context);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Buat Akun Baru",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[700]),
                ),
                const SizedBox(height: 8),
                const Text("Mulai perjalanan sehatmu hari ini!", style: TextStyle(color: Colors.grey)),
                
                const SizedBox(height: 30),

                AuthTextField(
                  controller: _nameController,
                  label: "Nama Lengkap",
                  icon: Icons.person_outline,
                  validator: (val) => val!.isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                
                const SizedBox(height: 16),

                AuthTextField(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => !val!.contains('@') ? "Email tidak valid" : null,
                ),
                
                const SizedBox(height: 16),

                AuthTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock_outline,
                  isObscure: _isObscure,
                  onChanged: (value) {
                    setState(() {
                      _passwordStrength = _checkPasswordStrength(value);
                    });
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Password wajib diisi";
                    if (val.length < 6) return "Password minimal 6 karakter";
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                PasswordStrengthMeter(strength: _passwordStrength),

                const SizedBox(height: 16),

                AuthTextField(
                  controller: _confirmPassController,
                  label: "Konfirmasi Password",
                  icon: Icons.lock_outline,
                  isObscure: _isObscure,
                  validator: (val) => val != _passwordController.text ? "Password tidak sama" : null,
                ),
                
                const SizedBox(height: 30),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return AuthButton(
                      text: "REGISTER",
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                RegisterRequested(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                        }
                      },
                    );
                  },
                ),
                
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}