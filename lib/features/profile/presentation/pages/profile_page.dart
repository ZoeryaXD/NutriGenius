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
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(LoadProfile()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],

        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 24,
                height: 24,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Icon(Icons.eco, color: Colors.green),
              ),
              SizedBox(width: 8),
              Text(
                "NutriGenius",
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
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
              return Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 10),
                    Text(state.message, textAlign: TextAlign.center),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                      child: Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileLoaded) {
              final data = state.profile;
              return SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Profil Saya",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    _buildProfilePicture(data),

                    SizedBox(height: 16),

                    Text(
                      data.fullName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        data.healthLabel,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem("${data.weight.toInt()} kg", "Berat"),
                        _buildStatItem("${data.height.toInt()} cm", "Tinggi"),
                        _buildStatItem("${data.age} th", "Umur"),
                      ],
                    ),
                    SizedBox(height: 40),

                    _buildMenuButton(
                      context,
                      icon: Icons.person,
                      label: "Edit Profil",
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider.value(
                                  value:
                                      context
                                          .read<
                                            ProfileBloc
                                          >(),
                                  child: EditProfilePage(currentData: data),
                                ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    _buildMenuButton(
                      context,
                      icon: Icons.settings,
                      label: "Pengaturan",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider.value(
                                  value:
                                      context
                                          .read<
                                            ProfileBloc
                                          >(), 
                                  child: SettingsPage(),
                                ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 40),

                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(LogoutRequested());
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Keluar",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildProfilePicture(ProfileEntity data) {
    String? imageUrl;
    if (data is ProfileModel) {
      imageUrl = data.fullImageUrl;
    }

    bool hasImage =
        (data.profilePicture != null && data.profilePicture!.isNotEmpty);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.green, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.green[100],
        backgroundImage:
            (hasImage && imageUrl != null) ? NetworkImage(imageUrl) : null,
        child:
            (!hasImage)
                ? Icon(Icons.person, size: 60, color: Colors.green)
                : null,
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.green[700], size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
