import 'package:flutter/material.dart';

class PrivacyPolicyForm extends StatefulWidget {
  const PrivacyPolicyForm({super.key});

  @override
  State<PrivacyPolicyForm> createState() => _PrivacyPolicyForm();
}

class _PrivacyPolicyForm extends State<PrivacyPolicyForm> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 450,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy for Collaborative Science Platform',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Text('Updated: 23 December 2023',
                  style: TextStyle(fontStyle: FontStyle.italic)),
                  SizedBox(height:4.0),
                  Divider(),
                  SizedBox(height:6.0),
              Text('Introduction', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
              Text(
                  'Welcome to the Collaborative Science Platform. This Privacy Policy outlines our commitment to protecting the privacy and personal information of our users. This policy applies to all information collected through our platform by "Guests," "Basic Users," "Contributors," "Reviewers," and "Admins."\n',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              Text('Information Collection and Use',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
                  SizedBox(height:8.0),
              Text('Personal Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Text(
                '''We collect information that you provide to us directly, such as when you create an account or use our services. This may include:
- Name and Contact Data (email address)
- Passwords (stored in a secure, hashed format)
- ORCID-ID for contributors (for identity verification)
- Any other information you choose to provide
''',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Usage Data',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '''We may also collect information on how our platform is accessed and used ("Usage Data"). This includes information such as your computer's Internet Protocol address (IP address), browser type, browser version, the pages of our platform that you visit, the time and date of your visit, and other diagnostic data.\n''',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Data Use',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '''We use the collected data for various purposes:
- To provide and maintain our platform
- To notify you about changes to our platform
- To allow you to participate in interactive features when you choose to do so
- To provide customer support
- To gather analysis or valuable information so that we can improve our platform
- To monitor the usage of our platform
- To detect, prevent, and address technical issues
''',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Data Sharing and Disclosure',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '''We may disclose your Personal Data in the following situations:
- To Comply with Laws:** If we are required to disclose your information in accordance with legal or regulatory requirements.
- For Platform Administration:** To administer our platform, including troubleshooting, data analysis, testing, and research.
- For External Processing:** To our affiliates, service providers, and other trusted businesses or persons who process it for us, based on our instructions and in compliance with our Privacy Policy and other appropriate confidentiality and security measures.
''',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Data Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The security of your data is important to us. We strive to use commercially acceptable means to protect your Personal Data, but remember that no method of transmission over the Internet or method of electronic storage is 100% secure.\n',                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Your Data Protection Rights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'In accordance with GDPR and KVKK, you have certain data protection rights. These include the right to access, update, or delete the information we hold about you, the right of rectification, the right to object, the right of restriction, the right to data portability, and the right to withdraw consent.\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Changes to This Privacy Policy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. We will let you know via email and/or a prominent notice on our platform, prior to the change becoming effective and update the "effective date" at the top of this Privacy Policy.\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'If you have any questions about this Privacy Policy, please contact us.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
