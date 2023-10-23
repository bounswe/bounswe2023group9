import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';

class AboutMeEdit extends StatelessWidget {
  final TextEditingController controller;
  const AboutMeEdit(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.primaryColor,
        ),
        color: Colors.white,
      ),
      child: TextField(
        autocorrect: false,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 10,
        controller: controller,
        cursorColor: AppColors.primaryColor,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        decoration: const InputDecoration(
          hintText: "Type your description",
          hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
