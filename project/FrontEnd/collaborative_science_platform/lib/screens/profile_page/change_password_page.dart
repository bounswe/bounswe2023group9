import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/settings_appbar.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/settings_input_widget.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';

class ChangePasswordPage extends StatelessWidget {
  static const routeName = '/change-password';
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageWithAppBar(
      appBar: AccountSettingsAppBar(),
      child: ChangePasswordForm(),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({
    super.key,
  });

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  ProfileData profileData = ProfileData();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final double x = 300;
  @override
  void dispose() {
    passwordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordController.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<Auth>(context).user;
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
                controller: passwordController,
                focusNode: passwordFocusNode,
                textType: "New password",
                prefixIcon: Icons.lock,
                widgetWidth: screenWidth,
              ),
              const SizedBox(height: 20.0),
              SettingsWidget(
                controller: confirmPasswordController,
                focusNode: confirmPasswordFocusNode,
                textType: "Confirm New password",
                prefixIcon: Icons.lock,
                widgetWidth: screenWidth,
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(5.0)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Save',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
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
