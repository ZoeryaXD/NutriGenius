import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_bloc.dart';
// Import bloc dan common widgets lainnya

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isObscure = true;

  // Regex Password: Minimal 8 char, ada angka, ada simbol
  final _passRegex = RegExp(r'^(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$');

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
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("Verifikasi Email"),
                content: Text("Link verifikasi telah dikirim ke email Anda. Silakan cek dan klik link tersebut sebelum login."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup Dialog
                      Navigator.pop(context); // Kembali ke Login Page
                    },
                    child: Text("OK"),
                  )
                ],
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Buat Akun Baru", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[800])),
                SizedBox(height: 8),
                Text("Mulai perjalanan sehatmu hari ini!", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 30),

                // Nama Lengkap
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => val!.isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => !val!.contains('@') ? "Email tidak valid" : null,
                ),
                SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Password wajib diisi";
                    if (!_passRegex.hasMatch(val)) {
                      return "Password harus kombinasi angka & simbol (!@#\$&*~)";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Konfirmasi Password
                TextFormField(
                  controller: _confirmPassController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    labelText: "Konfirmasi Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => val != _passController.text ? "Password tidak sama" : null,
                ),
                SizedBox(height: 30),

                // Tombol Register
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(RegisterRequested(
                          _nameController.text,
                          _emailController.text,
                          _passController.text,
                        ));
                      }
                    },
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return state is AuthLoading 
                          ? CircularProgressIndicator(color: Colors.white) 
                          : Text("REGISTER", style: TextStyle(fontSize: 18, color: Colors.white));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                
                // Link ke Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah punya akun? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text("Login", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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