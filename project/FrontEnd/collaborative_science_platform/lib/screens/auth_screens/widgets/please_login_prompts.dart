import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/text_styles.dart';
import 'package:flutter/material.dart';

class NotificationExplanation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Text(
            "Stay connected and informed with notifications! Up-to-date on the activities related to your interests and contributions.",
            style: TextStyles.title4,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
          child: Text(
            "including:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryDarkColor,
            ),
          ),
        ),
        SizedBox(height: 8.0), // Add space between texts
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Text(
            '''
\u2022 Get notified when your questions receive replies, fostering knowledge exchange.
\u2022 Stay informed when your contributions are reviewed with valuable feedback.
\u2022 Embrace collaboration! Receive alerts for collaboration requests.
\u2022 Stay connected when users ask questions about your contributed nodes
\u2022 Customize your preferences to enhance engagement on our platform!
             ''',
            style: TextStyles.bodyBlack,
          ),
        ),
      ],
    );
  }
}

class WorkspaceExplanation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Text(
            "Workspaces empower your collaborative work, providing a dynamic, flexible and all-in-one hub for your contributions.",
            style: TextStyles.title4,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
          child: Text(
            "including:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryDarkColor,
            ),
          ),
        ),
        SizedBox(height: 8.0), // Add space between texts
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Text(
            '''
\u2022 Send collaboration requests to contributors of your choice.
\u2022 Add and edit entries collaboratively.
\u2022 Effortlessly cite references in your work.
\u2022 Exclusive visibility, ensuring a private space for your team.
\u2022 Create different workspaces for various projects with diverse contributors.
             ''',
            style: TextStyles.bodyBlack,
          ),
        ),
      ],
    );
  }
}

class ProfileExplanation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Text(
            "Signing up brings a host of benefits",
            style: TextStyles.title4,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
          child: Text(
            "including:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryDarkColor,
            ),
          ),
        ),
        SizedBox(height: 8.0), // Add space between texts
        Container(
          margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: Text(
            '''
\u2022 Personalize your profile for easy identification by others.
\u2022 Showcase your activity on your profile.
\u2022 Explore and connect with like-minded individuals in similar activities.
\u2022 Enable others to find you easily and engage in meaningful collaborations.
\u2022 Edit your profile information effortlessly.
\u2022 Change your password with ease.
             ''',
            style: TextStyles.bodyBlack,
          ),
        ),
      ],
    );
  }
}
