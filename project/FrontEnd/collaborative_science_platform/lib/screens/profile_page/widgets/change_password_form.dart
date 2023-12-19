import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/settings_provider.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/settings_input_widget.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:provider/provider.dart';

class ChangePasswordForm extends StatefulWidget {
  final User? user;
  const ChangePasswordForm({
    super.key,
    required this.user,
  });

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  ProfileData profileData = ProfileData();
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final newPassFocusNode = FocusNode();
  final double x = 300;

  bool buttonState = false;
  String errorMessage = "";
  bool error = false;

  @override
  void dispose() {
    oldPassController.dispose();
    passwordFocusNode.dispose();
    newPassController.dispose();
    newPassFocusNode.dispose();
    super.dispose();
  }

  void changePass() async {
    try {
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      final int response = await settingsProvider.changePassword(
          widget.user, oldPassController.text, newPassController.text);

      if (response == 200) {
        setState(() {
          error = false;
          errorMessage = "Password Changed Successfully.";
        });
      } else if (response == 400) {
        setState(() {
          error = true;
          errorMessage = "Current password do not match with given password.";
        });
      }
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    }
  }

  void controllerCheck() {
    if (newPassController.text.isNotEmpty && oldPassController.text.isNotEmpty) {
      setState(() {
        buttonState = true;
      });
    } else {
      setState(() {
        buttonState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      width: Responsive.getGenericPageWidth(context),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              SettingsWidget(
                controller: oldPassController,
                focusNode: passwordFocusNode,
                textType: "Current password",
                prefixIcon: Icons.lock,
                widgetWidth: screenWidth,
                controllerCheck: controllerCheck,
              ),
              const SizedBox(height: 20.0),
              SettingsWidget(
                controller: newPassController,
                focusNode: newPassFocusNode,
                textType: "New password",
                prefixIcon: Icons.lock,
                widgetWidth: screenWidth,
                controllerCheck: controllerCheck,
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          AppButton(
            onTap: () => oldPassController.text.isNotEmpty && newPassController.text.isNotEmpty
                ? changePass()
                : {},
            text: "Save",
            height: 50,
            isActive: buttonState,
          ),
          const SizedBox(height: 10.0),
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
