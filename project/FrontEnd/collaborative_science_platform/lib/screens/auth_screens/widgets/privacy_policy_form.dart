import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyForm extends StatefulWidget {
  const PrivacyPolicyForm({super.key});

  @override
  State<PrivacyPolicyForm> createState() => _PrivacyPolicyForm();
}

class _PrivacyPolicyForm extends State<PrivacyPolicyForm> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.all(18.0),

        //TODO latex
        //TODO use actual text
        child: Text('''Privacy Policy for Collobrative Science Platform

          Thank you for choosing this Science Platform. This Privacy Policy is designed to help you understand how we collect, use, and safeguard your personal information when you visit our website or use our services.

          1. Information We Collect:
          a. Personal Information:
          We may collect personal information such as your name, email address, and affiliation when you register for an account or subscribe to our services.
          
          b. Usage Information:
          We automatically collect information about your interaction with our platform, including your IP address, device information, and browsing behavior.
          
          2. How We Use Your Information:
          a. Providing Services:
          We use your personal information to provide you with access to our science platform, including personalized content and features based on your preferences.
          
          b. Communication:
          We may use your contact information to send you important updates, newsletters, and information related to our platform. You can opt out of promotional emails at any time.
          
          c. Improving Services:
          We analyze user behavior to improve our platform, enhance user experience, and develop new features.

          3. Information Sharing:
          a. Third-Party Service Providers:
          We may share your information with third-party service providers who assist us in delivering and improving our services.
          
          b. Legal Compliance:
          We may disclose your information if required by law or in response to legal requests.
          
          4. Data Security:
          We employ industry-standard security measures to protect your information from unauthorized access, disclosure, alteration, and destruction.
          
          5. Cookies and Tracking Technologies:
          We use cookies and similar technologies to collect information about your usage patterns and preferences. You can manage your cookie preferences through your browser settings.
          
          6. Your Choices:
          You have the right to access, correct, or delete your personal information. You can manage your communication preferences and account settings through your profile.
          
          7. Childrens Privacy:
          Our platform is not intended for children under the age of 13. We do not knowingly collect personal information from children.
          
          8. Changes to This Privacy Policy:
          We may update this Privacy Policy to reflect changes in our practices. We encourage you to review this page periodically for the latest information.
          
          9. Contact Us:
          If you have any questions or concerns about this Privacy Policy, please contact us at some-mail@science.com.tr
          By using Science Platform, you agree to the terms outlined in this Privacy Policy. Please review this policy regularly for updates.
          '''),

      ),
    );
  }
}

