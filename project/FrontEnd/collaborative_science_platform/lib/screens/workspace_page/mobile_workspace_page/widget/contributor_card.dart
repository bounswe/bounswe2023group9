import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/screens/profile_page/profile_page.dart';


class ContributorCard extends StatelessWidget {
  final User contributor;
  final bool pending;

  const ContributorCard({
    super.key,
    required this.contributor,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: SizedBox(
        height: 90.0,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
            onTap: () {
              // Navigate to the contributor's profile page
              final String encodedEmail = Uri.encodeComponent(contributor.email);
              context.push('${ProfilePage.routeName}/$encodedEmail');
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${contributor.firstName} ${contributor.lastName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        contributor.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  if (pending) IconButton(
                    icon: const Icon(
                      CupertinoIcons.clear_circled,
                      color: AppColors.warningColor,
                    ),
                    onPressed: () {
                      // function to delete collaboration request
                      //TODO - requests id's are absent for now.
                      //updateRequest();
                    },
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
