import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class HomePageUserCard extends StatelessWidget {
  final ProfileData profileData;
  final Function() onTap;
  final Color color;
  final String? profilePagePath;

  const HomePageUserCard({
    super.key,
    required this.profileData,
    required this.onTap,
    required this.color,
    this.profilePagePath,
  });

  // Remove this function when it is no longer needed
  Widget profilePhoto() {
    return CircleAvatar(
      radius: 48.0,
      backgroundColor: AppColors.primaryColor,
      backgroundImage: profilePagePath != null ? AssetImage(profilePagePath!) : null,
      child: profilePagePath == null
          ? const Icon(
              Icons.person,
              size: 36.0,
              color: Colors.white,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Reduced elevation for a subtle shadow
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap, // Navigate to the Profile Page of the User
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              profilePhoto(),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      "${profileData.name} ${profileData.surname}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SelectableText(
                      profileData.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      profileData.aboutMe,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
