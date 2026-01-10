import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_stat_card.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';
import '../../../auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(LoadProfileData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profil Saya",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: primaryColor,
        ),
        body: SafeArea(
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state.status == ProfileStatus.initial &&
                  state.profile == null) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              if ((state.status == ProfileStatus.loading ||
                      state.status == ProfileStatus.initial) &&
                  state.profile == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == ProfileStatus.error &&
                  state.profile == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Koneksi Gagal",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message ?? "Terjadi kesalahan saat memuat data",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed:
                              () => context.read<ProfileBloc>().add(
                                LoadProfileData(),
                              ),
                          child: const Text("COBA LAGI"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final data = state.profile;
              if (data == null) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text("Data profil tidak tersedia"),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileBloc>().add(LoadProfileData());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: [
                          ProfileHeader(user: data, primaryColor: primaryColor),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ProfileStatCard(
                                value: "${data.weight.toInt()} kg",
                                label: "Berat",
                                color: primaryColor,
                              ),
                              _buildDivider(),
                              ProfileStatCard(
                                value: "${data.height.toInt()} cm",
                                label: "Tinggi",
                                color: primaryColor,
                              ),
                              _buildDivider(),
                              ProfileStatCard(
                                value: "${data.age} th",
                                label: "Umur",
                                color: primaryColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          ProfileMenuItem(
                            icon: Icons.person_outline,
                            label: "Edit Profil",
                            onTap:
                                () => _navigateTo(
                                  context,
                                  EditProfilePage(currentData: data),
                                ),
                            color: primaryColor,
                          ),
                          const SizedBox(height: 16),
                          ProfileMenuItem(
                            icon: Icons.settings_outlined,
                            label: "Pengaturan",
                            onTap:
                                () =>
                                    _navigateTo(context, const SettingsPage()),
                            color: primaryColor,
                          ),
                          const SizedBox(height: 40),
                          ProfileMenuItem(
                            icon: Icons.logout_rounded,
                            label: "Keluar Akun",
                            isDestructive: true,
                            onTap: () => _showLogoutDialog(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.withOpacity(0.3));
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (contextInside) => BlocProvider.value(
              value: context.read<ProfileBloc>(),
              child: page,
            ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Keluar"),
            content: const Text("Apakah Anda yakin ingin keluar?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<ProfileBloc>().add(LogoutRequested());
                },
                child: const Text(
                  "Ya, Keluar",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
