import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/profile_page/account_settings_app_bar.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/about_me_edit.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/screens/profile_page/widgets/settings_widget.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:provider/provider.dart';

class AccountSettingsPage extends StatelessWidget {
  static const routeName = '/account-settings';
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageWithAppBar(
      appBar: AccountSettingsAppBar(),
      child: EditProfileForm(),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({
    super.key,
  });

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final aboutMeController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final surnameFocusNode = FocusNode();
  final aboutMeFocusNode = FocusNode();

  bool firstTime = true;

  @override
  void didChangeDependencies() {
    final User user = Provider.of<Auth>(context).user!;

    if (firstTime) {
      nameController.text = user.firstName;
      surnameController.text = user.lastName;
      aboutMeController.text = "This is my about";
      firstTime = false;
    }

    super.didChangeDependencies();
  }

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: Responsive.getGenericPageWidth(context),
      child: Column(
        children: [
          const Divider(height: 40.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("About", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 10),
          AboutMeEdit(aboutMeController),
          const Divider(height: 40.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 10),
          SettingsWidget(
            controller: nameController,
            focusNode: nameFocusNode,
            textType: "Name",
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 10),
          SettingsWidget(
            controller: surnameController,
            focusNode: surnameFocusNode,
            textType: "Surname",
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width - 80,
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
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
