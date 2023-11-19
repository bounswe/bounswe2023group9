import 'package:collaborative_science_platform/models/node.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/colors.dart';
import '../../node_details_page/node_details_page.dart';

class ReferenceCard extends StatelessWidget {
  final double height = 60.0;
  final Node reference;
  const ReferenceCard({
    super.key,
    required this.reference,
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
            onTap: () { // Navigate to the node page of the theorem
              context.push('${NodeDetailsPage.routeName}/${reference.id}');
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height/2.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  reference.nodeTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
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
