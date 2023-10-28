
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap, //Navigate to the Profile Page of the User
            child: Card(
              color: color,
              elevation: 8.0,
              shadowColor: AppColors.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32.0,
                          backgroundColor: AppColors.primaryColor,
                          child: (profilePagePath != null) ? Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(profilePagePath!),
                                )
                            )
                          ) : const CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                              size: 36.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${profileData.name} ${profileData.surname}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              profileData.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      profileData.aboutMe,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
}
