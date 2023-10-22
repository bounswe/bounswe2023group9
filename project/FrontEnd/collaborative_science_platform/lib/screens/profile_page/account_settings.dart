import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/screens/profile_page/components/settings_widget.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';

class AccountSettingsPage extends StatefulWidget {
  static const routeName = '/profile-page/account-settings';
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPage();
}

class _AccountSettingsPage extends State<AccountSettingsPage> {
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final aboutMeController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final surnameFocusNode = FocusNode();
  final aboutMeFocusNode = FocusNode();

  @override
  void dispose() {
    passwordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    aboutMeController.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    surnameFocusNode.dispose();
    aboutMeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: SingleChildScrollView(
          // To avoid Render Pixel Overflow
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: Responsive.isMobile(context) ? double.infinity : 450,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile-page');
                  },
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                ),
                const Text(
                  'Account Settings',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile-page');
                  },
                  icon: const Icon(
                    Icons.done,
                  ),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          width: Responsive.isMobile(context) ? double.infinity : 450,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SettingsWidget(
                  controller: nameController,
                  focusNode: nameFocusNode,
                  textType: "Name:",
                  textContent: "Bengisu",
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SettingsWidget(
                  controller: surnameController,
                  focusNode: surnameFocusNode,
                  textType: "Surname:",
                  textContent: "Takkin",
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SettingsWidget(
                  controller: aboutMeController,
                  focusNode: aboutMeFocusNode,
                  textType: "About Me:",
                  textContent:
                      "Hello, I am a senior computer engineering student in Bogazici University!",
                  prefixIcon:
                      const Icon(Icons.info, color: AppColors.primaryColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SettingsWidget(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  textType: "Password:",
                  textContent: "***********",
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
