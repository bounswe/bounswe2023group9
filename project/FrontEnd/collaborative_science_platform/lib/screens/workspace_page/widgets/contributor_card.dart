import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class ContributorCard extends StatelessWidget {
  final double height = 60.0;

  const ContributorCard({super.key});

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
            onTap: () { /* Navigate to the contributors profile page */ },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height/2.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Contributor Name",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
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
