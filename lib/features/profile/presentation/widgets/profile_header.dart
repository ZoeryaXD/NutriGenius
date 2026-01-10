import 'package:flutter/material.dart';
import '../../domain/entities/profile_entity.dart';
import '../../data/models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileEntity user;
  final Color primaryColor;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    if (user is ProfileModel) {
      imageUrl = (user as ProfileModel).fullImageUrl;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor.withOpacity(0.2), width: 4),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: primaryColor.withOpacity(0.1),
            backgroundImage:
                (imageUrl != null && imageUrl.isNotEmpty)
                    ? NetworkImage(imageUrl)
                    : null,
            child:
                (imageUrl == null || imageUrl.isEmpty)
                    ? Icon(Icons.person, size: 50, color: primaryColor)
                    : null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.fullName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            user.healthLabel,
            style: TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
