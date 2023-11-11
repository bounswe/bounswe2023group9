import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_user_card.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class UserCards extends StatelessWidget {
  final List<ProfileData> userList;
  final bool firstSearch;

  const UserCards({
    super.key,
    required this.userList,
    required this.firstSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: firstSearch && userList.isEmpty
          ? const Center(
              child: Text("No results found."),
            )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return HomePageUserCard(
                  profileData: userList[index],
                  onTap: () {
                    Navigator.pushNamed(context, ProfilePage.routeName,
                        arguments: userList[index].email);
                  },
                  color: AppColors.primaryLightColor,
                  profilePagePath: "assets/images/gumball.jpg",
                );
              },
            ),
    );
  }
}