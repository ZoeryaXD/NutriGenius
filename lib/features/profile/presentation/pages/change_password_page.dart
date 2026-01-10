import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_text_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Password")),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
          if (state.status == ProfileStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Pastikan password baru Anda sulit ditebak namun mudah Anda ingat.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ProfileTextField(
                    label: "Password Baru",
                    controller: _newPasswordCtrl,
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 16),
                  ProfileTextField(
                    label: "Konfirmasi Password Baru",
                    controller: _confirmPasswordCtrl,
                    icon: Icons.lock_reset,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          state.status == ProfileStatus.loading
                              ? null
                              : () => _handleSubmit(),
                      child:
                          state.status == ProfileStatus.loading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text("Perbarui Password"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordCtrl.text == _confirmPasswordCtrl.text) {
        context.read<ProfileBloc>().add(
          ChangePasswordRequested(_newPasswordCtrl.text),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Konfirmasi password tidak cocok"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
