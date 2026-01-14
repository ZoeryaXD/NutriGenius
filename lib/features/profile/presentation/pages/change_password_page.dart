import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ChangePasswordPage extends StatefulWidget {
  final String currentEmail;
  const ChangePasswordPage({super.key, required this.currentEmail});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController _emailCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.currentEmail);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: const Text(
          "Ganti Password",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      isLandscape
                          ? _buildLandscapeLayout(colorScheme, isDark)
                          : _buildPortraitLayout(colorScheme, isDark),

                      const SizedBox(height: 60),

                      _buildCopyright(isDark),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(ColorScheme cs, bool isDark) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildIllustration(cs, isLandscape: false),
        const SizedBox(height: 32),
        _buildFormHeader(isDark),
        const SizedBox(height: 40),
        _buildEmailForm(cs, isDark),
      ],
    );
  }

  Widget _buildLandscapeLayout(ColorScheme cs, bool isDark) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIllustration(cs, isLandscape: true),
                const SizedBox(height: 20),
                _buildFormHeader(isDark),
              ],
            ),
          ),

          Container(
            width: 1,
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            color: cs.outlineVariant.withOpacity(0.5),
          ),

          Expanded(flex: 5, child: _buildEmailForm(cs, isDark)),
        ],
      ),
    );
  }

  Widget _buildIllustration(ColorScheme cs, {required bool isLandscape}) {
    return Container(
      padding: EdgeInsets.all(isLandscape ? 16 : 24),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lock_reset_rounded,
        size: isLandscape ? 60 : 80,
        color: cs.primary,
      ),
    );
  }

  Widget _buildFormHeader(bool isDark) {
    return Column(
      children: [
        const Text(
          "Konfirmasi Email",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Kami akan mengirimkan link untuk mereset password Anda ke email terdaftar.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailForm(ColorScheme cs, bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailCtrl,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Email Terdaftar",
              prefixIcon: Icon(Icons.email_outlined, color: cs.primary),
              filled: true,
              fillColor:
                  isDark
                      ? cs.surfaceVariant.withOpacity(0.1)
                      : Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: cs.outlineVariant),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSubmitButton(cs),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(ColorScheme cs) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final isLoading = state is ProfileLoading;
          return ElevatedButton(
            onPressed:
                isLoading
                    ? null
                    : () {
                      context.read<ProfileBloc>().add(
                        ChangePasswordRequested(_emailCtrl.text),
                      );
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child:
                isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                    : const Text(
                      "Kirim Link Reset",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildCopyright(bool isDark) {
    return Text(
      "© 2026 NutriGenius Project",
      style: TextStyle(
        color: isDark ? Colors.grey[600] : Colors.grey[400],
        fontSize: 12,
        letterSpacing: 1.1,
      ),
    );
  }
}
