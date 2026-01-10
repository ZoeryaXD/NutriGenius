import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/profile_entity.dart';
import '../../data/models/profile_model.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';
import '../../../auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(LoadProfile()),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileLoaded) {
                final data = state.profile;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profil Saya",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          isLandscape
                              ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: _buildInfoFisik(
                                      data,
                                      primaryColor,
                                      isDark,
                                      theme,
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  Expanded(
                                    flex: 6,
                                    child: _buildMenuAksi(
                                      context,
                                      data,
                                      primaryColor,
                                    ),
                                  ),
                                ],
                              )
                              : Column(
                                children: [
                                  _buildInfoFisik(
                                    data,
                                    primaryColor,
                                    isDark,
                                    theme,
                                  ),
                                  const SizedBox(height: 40),
                                  _buildMenuAksi(context, data, primaryColor),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoFisik(
    ProfileEntity data,
    Color color,
    bool isDark,
    ThemeData theme,
  ) {
    return Column(
      children: [
        _buildProfilePicture(data, color, isDark, theme),
        const SizedBox(height: 16),
        Text(
          data.fullName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildHealthLabel(data, color),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem("${data.weight.toInt()} kg", "Berat", color),
            _buildStatItem("${data.height.toInt()} cm", "Tinggi", color),
            _buildStatItem("${data.age} th", "Umur", color),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuAksi(BuildContext context, ProfileEntity data, Color color) {
    return Column(
      children: [
        _buildMenuButton(context, Icons.person, "Edit Profil", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<ProfileBloc>(),
                    child: EditProfilePage(currentData: data),
                  ),
            ),
          );
        }, color),
        const SizedBox(height: 16),
        _buildMenuButton(context, Icons.settings, "Pengaturan", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<ProfileBloc>(),
                    child: const SettingsPage(),
                  ),
            ),
          );
        }, color),
        const SizedBox(height: 40),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildProfilePicture(
    ProfileEntity data,
    Color color,
    bool isDark,
    ThemeData theme,
  ) {
    String? imageUrl;
    if (data is ProfileModel) imageUrl = data.fullImageUrl;
    bool hasImage =
        (data.profilePicture != null && data.profilePicture!.isNotEmpty);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 3),
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: color.withOpacity(0.1),
        backgroundImage:
            (hasImage && imageUrl != null) ? NetworkImage(imageUrl) : null,
        child: (!hasImage) ? Icon(Icons.person, size: 60, color: color) : null,
      ),
    );
  }

  Widget _buildHealthLabel(ProfileEntity data, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        data.healthLabel,
        style: TextStyle(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
    Color color,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                theme.brightness == Brightness.dark ? 0.2 : 0.05,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => context.read<ProfileBloc>().add(LogoutRequested()),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text(
          "Keluar",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
