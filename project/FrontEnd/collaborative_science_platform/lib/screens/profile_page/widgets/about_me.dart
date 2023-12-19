import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutMe extends StatefulWidget {
  final String email;
  final String name;
  final String surname;
  final int noWorks;
  final String aboutMe;
  final bool isBanned;
  final bool isReviewer;
  final String userType;
  final bool isValidUser; //Contributor or reviewer
  final Function() onTap;
  final Function() onTapReviewerButton;
  const AboutMe(
      {super.key,
      required this.email,
      required this.name,
      required this.surname,
      required this.noWorks,
      required this.aboutMe,
      required this.isBanned,
      required this.isReviewer,
      required this.userType,
      required this.isValidUser,
      required this.onTap,
      required this.onTapReviewerButton});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableText(
                  "${widget.name} ${widget.surname}",
                  style: const TextStyle(
                    color: AppColors.primaryDarkColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: ((widget.userType == "admin" ? true : false) && widget.isValidUser),
                      child: widget.isReviewer
                          ? SizedBox(
                              width: 220,
                              child: AppButton(
                                text: "Give Reviewer Status",
                                height: 40,
                                icon: const Icon(
                                  CupertinoIcons.add_circled_solid,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                type: "safe",
                                onTap: widget.onTapReviewerButton,
                              ),
                            )
                          : SizedBox(
                              width: 220,
                              child: AppButton(
                                text: "Remove Reviewer Status",
                                height: 40,
                                icon: const Icon(
                                  CupertinoIcons.minus_circle_fill,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                type: "danger",
                                onTap: widget.onTapReviewerButton,
                              ),
                            ),
                    ),
                    const SizedBox(height: 10.0),
                    Visibility(
                      visible: (widget.userType == "admin" ? true : false),
                      child: widget.isBanned
                          ? SizedBox(
                              width: 220,
                              child: AppButton(
                                text: "Unban User",
                                height: 40,
                                icon: const Icon(
                                  CupertinoIcons.lock_open,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                type: "grey",
                                onTap: widget.onTap,
                              ),
                            )
                          : SizedBox(
                              width: 220,
                              child: AppButton(
                                text: "Ban User",
                                height: 40,
                                icon: const Icon(
                                  CupertinoIcons.lock,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                type: "danger",
                                onTap: widget.onTap,
                              ),
                            ),
                    ),
                  ],
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
                  child: SelectableText(
                    widget.aboutMe,
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
                SelectableText(
                  "${widget.email}",
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
                SelectableText(
                  "Published works: ${widget.noWorks}",
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
