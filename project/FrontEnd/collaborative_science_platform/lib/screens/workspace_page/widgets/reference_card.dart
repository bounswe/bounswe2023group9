import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class ReferenceCard extends StatelessWidget {
  final double height = 60.0;

  const ReferenceCard({super.key});

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
            onTap: () { /* Navigate to the node page of the theorem */ },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height/2.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Reference Theorem Title",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
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
