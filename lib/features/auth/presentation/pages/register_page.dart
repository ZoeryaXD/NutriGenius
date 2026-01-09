import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_event.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_state.dart';

enum PasswordStrength { weak, medium, strong }

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
    if (password.length < 6) {
      return PasswordStrength.weak;
    }

    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSymbol = password.contains(RegExp(r'[!@#\$&*~]'));

    if (password.length >= 8 &&
        hasUpper &&
        hasLower &&
        hasNumber &&
        hasSymbol) {
      return PasswordStrength.strong;
    }

    if (hasLower && hasNumber) {
      return PasswordStrength.medium;
    }

    return PasswordStrength.weak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthEmailVerificationRequired) {
            showGeneralDialog(
              context: context,
              barrierDismissible: false,
              barrierLabel: "RegisterSuccess",
              transitionDuration: Duration(milliseconds: 400),
              pageBuilder: (_, __, ___) {
                return Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.all(24),
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 80,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Registrasi Berhasil 🎉",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Link verifikasi telah dikirim ke email kamu.\nSilakan cek sebelum login.",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              transitionBuilder: (_, anim, __, child) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: anim,
                    curve: Curves.easeOutBack,
                  ),
                  child: FadeTransition(opacity: anim, child: child),
                );
              },
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Buat Akun Baru",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Mulai perjalanan sehatmu hari ini!",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 30),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (val) => val!.isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (val) => !val!.contains('@') ? "Email tidak valid" : null,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  onChanged: (value) {
                    setState(() {
                      _passwordStrength = _checkPasswordStrength(value);
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Password wajib diisi";
                    }
                    if (val.length < 6) {
                      return "Password minimal 6 karakter";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value:
                            _passwordStrength == PasswordStrength.weak
                                ? 0.33
                                : _passwordStrength == PasswordStrength.medium
                                ? 0.66
                                : 1.0,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _passwordStrength == PasswordStrength.weak
                              ? Colors.red
                              : _passwordStrength == PasswordStrength.medium
                              ? Colors.orange
                              : Colors.green,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      _passwordStrength == PasswordStrength.weak
                          ? "Lemah"
                          : _passwordStrength == PasswordStrength.medium
                          ? "Sedang"
                          : "Kuat",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            _passwordStrength == PasswordStrength.weak
                                ? Colors.red
                                : _passwordStrength == PasswordStrength.medium
                                ? Colors.orange
                                : Colors.green,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPassController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: "Konfirmasi Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (val) =>
                          val != _passwordController.text
                              ? "Password tidak sama"
                              : null,
                ),
                SizedBox(height: 30),

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
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return state is AuthLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              "REGISTER",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah punya akun? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
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
