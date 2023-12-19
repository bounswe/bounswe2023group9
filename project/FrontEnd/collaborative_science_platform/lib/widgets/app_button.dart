import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double height;
  final void Function() onTap;
  final bool isActive;
  final bool isLoading;
  final Widget? icon;
  final String type;

  const AppButton({
    super.key,
    required this.text,
    required this.height,
    required this.onTap,
    this.isActive = true,
    this.isLoading = false,
    this.icon,
    this.type = "primary",
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive ? onTap : () {},
      style: type != "outlined"
          ? ElevatedButton.styleFrom(
              backgroundColor: isActive
                  ? (type == "primary"
                      ? const Color.fromRGBO(8, 155, 171, 1)
                      : (type == "secondary"
                          ? AppColors.secondaryColor
                          : (type == "danger"
                              ? AppColors.dangerColor
                              : (type == "grey"
                                  ? Colors.grey[600]
                                  : (type == "safe"
                                      ? Color.fromARGB(255, 141, 208, 141)
                                      : Colors.grey[600])))))
                  : Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, height),
            )
          : ElevatedButton.styleFrom(
              backgroundColor: isActive ? Colors.white : Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, height),
              side: const BorderSide(color: AppColors.primaryColor)),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) icon!,
                if (icon != null) const SizedBox(width: 6),
                Text(text,
                    style: TextStyle(
                      fontSize: height / 3.0,
                      fontWeight: FontWeight.bold,
                      color: (type != "outlined" ? Colors.white : AppColors.primaryColor),
                    )),
              ],
            ),
    );
  }
}
