import 'package:flutter/material.dart';

class StrongPasswordChecks extends StatelessWidget {
  static const int minPasswordLength = 8;
  final String password;
  final String confirmPassword;

  const StrongPasswordChecks({
    super.key,
    required this.password,
    required this.confirmPassword,
  });

  static bool passedAllPasswordCriteria(String password, String confirmPassword) {
    bool minLengthIsMet = password.length >= minPasswordLength;
    bool atLeastOneLowerCaseIsPresent = RegExp(r'[a-z]').hasMatch(password);
    bool atLeastOneUpperCaseIsPresent = RegExp(r'[A-Z]').hasMatch(password);
    bool atLeastOneNumberIsPresent = RegExp(r'\d').hasMatch(password);
    bool atLeastOneSpecialCharacterIsPresent =
        RegExp(r'[!@#$%^&*/()_\-+{}\[\]:;<>,.?~\\|]').hasMatch(password);
    return minLengthIsMet &&
        atLeastOneLowerCaseIsPresent &&
        atLeastOneUpperCaseIsPresent &&
        atLeastOneNumberIsPresent &&
        atLeastOneSpecialCharacterIsPresent &&
        password == confirmPassword;
  }

  Widget conditionWidget(String message, bool conditionIsMet) {
    return SingleChildScrollView(
      // To avoid Render Pixel Overflow
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          (conditionIsMet)
              ? const Icon(Icons.check, color: Colors.green)
              : const Icon(Icons.close, color: Colors.red),
          const SizedBox(width: 6.0),
          SelectableText(
            message,
            style: TextStyle(
              color: (conditionIsMet) ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool minLengthIsMet = password.length >= minPasswordLength;
    bool atLeastOneLowerCaseIsPresent = RegExp(r'[a-z]').hasMatch(password);
    bool atLeastOneUpperCaseIsPresent = RegExp(r'[A-Z]').hasMatch(password);
    bool atLeastOneNumberIsPresent = RegExp(r'\d').hasMatch(password);
    bool atLeastOneSpecialCharacterIsPresent =
        RegExp(r'[!@#$%^&*/()_\-+{}\[\]:;<>,.?~\\|]').hasMatch(password);

    return Column(
      children: [
        conditionWidget("At least $minPasswordLength characters long", minLengthIsMet),
        conditionWidget("At least one lowercase letter", atLeastOneLowerCaseIsPresent),
        conditionWidget("At least one uppercase letter", atLeastOneUpperCaseIsPresent),
        conditionWidget("At least one number", atLeastOneNumberIsPresent),
        conditionWidget("At least one special character", atLeastOneSpecialCharacterIsPresent),
        conditionWidget("Passwords do not match", password == confirmPassword),
      ],
    );
  }
}
