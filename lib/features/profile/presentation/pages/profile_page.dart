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
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(LoadProfile()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          title: Text(
            "Profil Saya",
            style: TextStyle(
              color: isDark ? Colors.white : colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              );
            } else if (state is ProfileError) {
              return _buildErrorState(context, state.message, colorScheme);
            } else if (state is ProfileLoaded) {
              return isLandscape
                  ? _buildLandscapeLayout(
                    context,
                    state.profile,
                    colorScheme,
                    isDark,
                  )
                  : _buildPortraitLayout(
                    context,
                    state.profile,
                    colorScheme,
                    isDark,
                  );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    ProfileEntity data,
    ColorScheme cs,
    bool isDark,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildHeaderInfo(data, cs),
          const SizedBox(height: 32),
          _buildStatsRow(data, cs, isDark),
          const SizedBox(height: 40),
          _buildMenuSection(context, data, cs, isDark),
          const SizedBox(height: 48),
          _buildLogoutButton(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    ProfileEntity data,
    ColorScheme cs,
    bool isDark,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeaderInfo(data, cs),
                const SizedBox(height: 32),
                _buildStatsRow(data, cs, isDark),
              ],
            ),
          ),
        ),

        VerticalDivider(width: 1, color: cs.outlineVariant.withOpacity(0.5)),

        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMenuSection(context, data, cs, isDark),
                const SizedBox(height: 40),
                _buildLogoutButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderInfo(ProfileEntity data, ColorScheme cs) {
    String? imageUrl;
    if (data is ProfileModel) imageUrl = data.fullImageUrl;
    bool hasImage =
        data.profilePicture != null && data.profilePicture!.isNotEmpty;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: cs.primary.withOpacity(0.2), width: 3),
          ),
          child: CircleAvatar(
            radius: 55,
            backgroundColor: cs.primary.withOpacity(0.1),
            backgroundImage:
                (hasImage && imageUrl != null) ? NetworkImage(imageUrl) : null,
            child:
                !hasImage
                    ? Icon(Icons.person_rounded, size: 60, color: cs.primary)
                    : null,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          data.fullName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getHealthLabel(data.healthId),
            style: TextStyle(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ProfileEntity data, ColorScheme cs, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceVariant.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statItem("${data.weight.toInt()}", "kg", "Berat", cs),
            _vDivider(cs),
            _statItem("${data.height.toInt()}", "cm", "Tinggi", cs),
            _vDivider(cs),
            _statItem("${data.age}", "th", "Umur", cs),
          ],
        ),
      ),
    );
  }

  Widget _vDivider(ColorScheme cs) => VerticalDivider(
    width: 1,
    color: cs.outlineVariant,
    thickness: 1,
    indent: 5,
    endIndent: 5,
  );

  Widget _statItem(String val, String unit, String label, ColorScheme cs) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              val,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                unit,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    ProfileEntity data,
    ColorScheme cs,
    bool isDark,
  ) {
    return Column(
      children: [
        _menuTile(
          context,
          icon: Icons.person_outline_rounded,
          label: "Edit Profil",
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<ProfileBloc>(),
                        child: EditProfilePage(currentData: data),
                      ),
                ),
              ),
          cs: cs,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        _menuTile(
          context,
          icon: Icons.settings_outlined,
          label: "Pengaturan",
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<ProfileBloc>(),
                        child: const SettingsPage(),
                      ),
                ),
              ),
          cs: cs,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ColorScheme cs,
    required bool isDark,
  }) {
    return ListTile(
      onTap: onTap,
      tileColor: isDark ? cs.surfaceVariant.withOpacity(0.1) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cs.outlineVariant.withOpacity(0.2)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: cs.primary, size: 22),
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => context.read<ProfileBloc>().add(LogoutRequested()),
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        label: const Text(
          "Keluar Akun",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.redAccent.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String msg, ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: cs.error),
          const SizedBox(height: 16),
          Text(msg, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<ProfileBloc>().add(LoadProfile()),
            child: const Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }

  String _getHealthLabel(int id) {
    switch (id) {
      case 2:
        return "Diabetes";
      case 3:
        return "Obesitas";
      case 4:
        return "Hipertensi";
      default:
        return "Normal / Sehat";
    }
  }
}
