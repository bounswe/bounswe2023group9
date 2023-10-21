import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/widgets/settings_widget.dart';

class AccountSettingsPage extends StatefulWidget {
  static const routeName = '/account-settings';
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPage();
}

class _AccountSettingsPage extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.close,
              color: Colors.white,
            ),
            Text(
              'Account Settings',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.done,
              color: Colors.white,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1.0,
                      color: AppColors.primaryColor), // Line below the text
                ),
              ),
              child: SettingsWidget(
                textType: "Name:",
                textContent: const Text(
                  "Bengisu",
                  style:
                      TextStyle(color: AppColors.primaryColor, fontSize: 20.0),
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  color: AppColors.primaryColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1.0,
                      color: AppColors.primaryColor), // Line below the text
                ),
              ),
              child: SettingsWidget(
                textType: "Surname:",
                textContent: const Text(
                  "Takkin",
                  style:
                      TextStyle(color: AppColors.primaryColor, fontSize: 20.0),
                ),
                prefixIcon: const Icon(
                  Icons.person,
                  color: AppColors.primaryColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1.0,
                      color: AppColors.primaryColor), // Line below the text
                ),
              ),
              child: SettingsWidget(
                textType: "About Me:",
                textContent: const Text(
                  "Hello, I am a senior computer engineering student in Bogazici University!",
                  style:
                      TextStyle(color: AppColors.primaryColor, fontSize: 17.0),
                ),
                prefixIcon:
                    const Icon(Icons.info, color: AppColors.primaryColor),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1.0,
                      color: AppColors.primaryColor), // Line below the text
                ),
              ),
              child: SettingsWidget(
                textType: "Password:",
                textContent: const Text(
                  "***********",
                  style:
                      TextStyle(color: AppColors.primaryColor, fontSize: 20.0),
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: AppColors.primaryColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
