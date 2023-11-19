import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/user.dart';
import '../../../utils/colors.dart';
import '../../profile_page/profile_page.dart';

class ContributorCard extends StatelessWidget {
  final double height = 60.0;
  final User contributor;

  const ContributorCard({
    super.key,
    required this.contributor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: SizedBox(
        height: height,
        child: Card(
          elevation: 4.0,
          color: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height/2.0),
          ),
          child: InkWell(
            onTap: () { // Navigate to the contributor's profile page
              final String encodedEmail = Uri.encodeComponent(contributor.email);
              context.push('${ProfilePage.routeName}/$encodedEmail');
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height/2.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "${contributor.firstName} ${contributor.lastName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
