import 'package:collaborative_science_platform/providers/settings_provider.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/settings_input_widget.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:provider/provider.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({
    super.key,
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

  String errorMessage ="Current password do not match with given password.";
  bool error = false;

  final currentPass = "pforo111";  //TEST PASSWORD
  @override
  void dispose() {
    oldPassController.dispose();
    passwordFocusNode.dispose();
    newPassController.dispose();
    newPassFocusNode.dispose();
    super.dispose();
  }

  void changePass() async {
    
      if (currentPass != "" && oldPassController.text != "") {
        final settingsProvider = Provider.of<SettingsProvider>(context,listen: false);
        await settingsProvider.changePassword(oldPassController.text, newPassController.text); 
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
                controller:oldPassController,
                focusNode: passwordFocusNode,
                textType: "Current password",
                prefixIcon: Icons.lock,
                widgetWidth: screenWidth,
              ),
              const SizedBox(height: 20.0),
              SettingsWidget(
                controller: newPassController,
                focusNode: newPassFocusNode,
                textType: "New password",
                prefixIcon: Icons.lock,
                widgetWidth: screenWidth,
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => changePass(),
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor, borderRadius: BorderRadius.circular(5.0)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Save',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
