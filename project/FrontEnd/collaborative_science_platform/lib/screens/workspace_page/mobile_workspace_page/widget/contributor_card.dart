import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/user.dart';
import '../../../profile_page/profile_page.dart';


class ContributorCard extends StatelessWidget {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
          ),
        ),
      ),
    );
  }
}
