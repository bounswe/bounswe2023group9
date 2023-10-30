import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/change_password_page.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/settings_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/about_me_edit.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:collaborative_science_platform/providers/profile_data_provider.dart';
import 'package:collaborative_science_platform/models/profile_data.dart';

class AccountSettingsPage extends StatelessWidget {
  static const routeName = '/account-settings';
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageWithAppBar(
      appBar: AccountSettingsAppBar(),
      child: AccountSettingsForm(),
    );
  }
}

class AccountSettingsForm extends StatefulWidget {
  const AccountSettingsForm({
    super.key,
  });

  @override
  State<AccountSettingsForm> createState() => _AccountSettingsFormState();
}

class _AccountSettingsFormState extends State<AccountSettingsForm> {
  ProfileData profileData = ProfileData();
  final passwordController = TextEditingController();
  final aboutMeController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final aboutMeFocusNode = FocusNode();

  bool isSwitched = false;
  bool isSwitched2 = false;

  bool firstTime = true;
  int noWorks = 0;
  bool error = false;
  String errorMessage = "";
  bool isLoading = false;
  bool _isFirstTime = true;

  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getUserData();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void getUserData() async {
    try {
      final User user = Provider.of<Auth>(context).user!;
      final profileDataProvider = Provider.of<ProfileDataProvider>(context);
      setState(() {
        isLoading = true;
      });
      await profileDataProvider.getData(user.email);
      setState(() {
        profileData = (profileDataProvider.profileData ?? {} as ProfileData);
        noWorks = profileData.nodes.length;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    aboutMeController.dispose();
    passwordFocusNode.dispose();
    aboutMeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: Responsive.getGenericPageWidth(context),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 10),
          AboutMeEdit(aboutMeController),
          const Divider(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Send Email Notifications",
                style: TextStyles.bodyBold,
              ),
              Switch(
                value: isSwitched,
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value; // Update the state when the switch is toggled
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Show Activity in Profile Page",
                style: TextStyles.bodyBold,
              ),
              Switch(
                value: isSwitched2,
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    isSwitched2 = value; // Update the state when the switch is toggled
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(5.0)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 40.0),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                // Show Popup with EditProfileForm content
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    title: SizedBox(
                      width: 500,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Change Password', style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.white,
                    shadowColor: Colors.white,
                    content: ChangePasswordForm(),
                  ),
                );
              },
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(5.0)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Change Password',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
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
