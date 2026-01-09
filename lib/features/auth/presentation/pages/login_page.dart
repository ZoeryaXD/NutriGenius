import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_event.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_state.dart';
import 'package:nutrigenius/features/auth/presentation/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isObscure = true;

  void _showForgotPasswordDialog() {
    final _resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Lupa Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Masukkan email Anda, kami akan mengirimkan link reset password.",
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _resetEmailController,
                  decoration: InputDecoration(hintText: "Email Anda"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    ForgotPasswordRequested(_resetEmailController.text),
                  );
                  Navigator.pop(context);
                },
                child: Text("Kirim"),
              ),
            ],
          ),
    );
  }

  void _showResetPasswordSuccessDialog() {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "ResetPasswordSuccess",
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
                  Icons.mark_email_read_rounded,
                  color: Colors.green,
                  size: 80,
                ),
                SizedBox(height: 16),
                Text(
                  "Email Terkirim 📩",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Link reset password telah dikirim ke email kamu.\nSilakan cek inbox atau spam.",
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
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
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
              const SnackBar(
                content: Text("Login Berhasil!"),
                backgroundColor: Colors.green,
              ),
            );
            if (state.isOnboarded) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else {
              Navigator.pushReplacementNamed(context, '/firstpage');
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthResetEmailSent) {
            _showResetPasswordSuccessDialog();
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.asset('assets/images/logo.png', height: 100),
              SizedBox(height: 20),
              Text(
                "NutriGenius",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              Text(
                "Cara Genius Hidup Sehat",
                style: TextStyle(fontSize: 16, color: Colors.green[600]),
              ),
              SizedBox(height: 50),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: "Email",
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: "Password",
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: Text(
                    "Lupa Password?",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(height: 20),

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
                    context.read<AuthBloc>().add(
                      LoginRequested(
                        _emailController.text,
                        _passController.text,
                      ),
                    );
                  },
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return state is AuthLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          );
                    },
                  ),
                ),
              ),

              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("ATAU"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Daftar Sekarang",
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
    );
  }
}