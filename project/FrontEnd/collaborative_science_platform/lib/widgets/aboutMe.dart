import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';

class AboutMe extends StatefulWidget {
  final String userId; // email de olabilir? getUserData neyle çalışacaksa?
  const AboutMe({super.key, required this.userId});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  /*
  these values will be updated after the implementation of userData provider
  */
  String name = "Name";
  String surname = "Surname";
  String email = "user@collaborativescience.com";
  String aboutMe =
      "I am a senior cmpe studentfshdjfkhdjkghjfkdhgjfdhgjkfhdgjfhgjkfhdgkhfdgjkhfjdghfkjdhfd";
  int noWorks = 12;

  bool error = false;
  String errorMessage = "";

  //  @override
  // void initState() {
  //   super.initState();
  //   getUserData();
  // }

  // void getUserData() async {
  //   try{
  //     userData = await Provider.of<User>(context, listen: true).getUserData(userId);
  //     setState(() {
  //       name = userData['name'];
  //       surname = userData['surname'];
  //       email = userData['email'];
  //       aboutMe = userData['aboutMe'];
  //       noWorks = userData['noWorks'];
  //     });
  //   }catch (e) {
  //     setState(() {
  //       error = true;
  //       errorMessage = "Something went wrong!";
  //     });
  // }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: error
              ? [Text(errorMessage)]
              : [
                  Row(
                    children: [
                      Text(
                        "$name $surname",
                        style: const TextStyle(
                          color: AppColors.primaryDarkColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: Responsive.isMobile(context)
                            ? MediaQuery.of(context).size.width * 0.9
                            : MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          aboutMe,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.mail,
                        color: AppColors.secondaryColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Published works: $noWorks",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: AppColors.tertiaryColor,
                  )
                ],
        ),
      ),
    );
  }
}
