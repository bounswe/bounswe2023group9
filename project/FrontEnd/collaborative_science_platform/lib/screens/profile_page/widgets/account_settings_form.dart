import 'package:collaborative_science_platform/models/basic_user.dart';
import 'package:collaborative_science_platform/models/profile_data.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/settings_provider.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/about_me_edit.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/change_password_form.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSettingsForm extends StatefulWidget {
  const AccountSettingsForm({super.key});

  @override
  State<AccountSettingsForm> createState() => _AccountSettingsFormState();
}

class _AccountSettingsFormState extends State<AccountSettingsForm> {
  ProfileData profileData = ProfileData();
  BasicUser basicUser = BasicUser();

  final passwordController = TextEditingController();
  final aboutMeController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final aboutMeFocusNode = FocusNode();

  bool isSwitched = false;
  bool isSwitched2 = false;
  bool error = false;
  String message = "";

  bool isLoading = false;
  bool _isFirstTime = true;

  @override
  void dispose() {
    passwordController.dispose();
    aboutMeController.dispose();
    passwordFocusNode.dispose();
    aboutMeFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      try {
        getBasicUser();
      } catch (e) {
        setState(() {
          error = true;
          message = "Something went wrong!";
        });
      }
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void getBasicUser() async {
    final User? user = Provider.of<Auth>(context).user;
    if (user != null) {
      try {
        final auth = Provider.of<Auth>(context);  //for token
        basicUser = (auth.basicUser ?? {} as BasicUser);
        isLoading = true;
        // user = (auth.user ?? {} as User);
      } catch (e) {
        setState(() {
          error = true;
          message = "Something went wrong!";
        });
        rethrow;
      } finally {
        setState(() {
          isSwitched = basicUser.emailNotificationPreference;
          isSwitched2 = basicUser.showActivity;
          isLoading = false;
        });
      }
    }
  }

  void changePreff() async {
    try {
      final User? user = Provider.of<Auth>(context, listen: false).user;
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      await settingsProvider.changePreferences(
          user, aboutMeController.text, isSwitched, isSwitched2);
      error = false;
      message = "Changed Successfully.";
    } catch (e) {
      setState(() {
        error = true;
        message = "Something went wrong!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<Auth>(context).user;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: Responsive.getGenericPageWidth(context),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SelectableText('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 10),
          AboutMeEdit(aboutMeController),
          const Divider(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SelectableText(
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
              const SelectableText(
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
          const SizedBox(height: 20.0),
          Container(
            width: 400,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => changePreff(),
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
          ),
          const SizedBox(height: 10),
          Text(message),
          const Divider(height: 40.0),
          Container(
            width: 400,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const SizedBox(
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
                      content: ChangePasswordForm(user: user),
                    ),
                  );
                },
                child: Container(
                  height: 40.0,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor, borderRadius: BorderRadius.circular(5.0)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Change Password',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
