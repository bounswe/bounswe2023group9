import 'package:collaborative_science_platform/exceptions/auth_exceptions.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/signup_page.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool obscuredPassword = true;
  bool error = false;

  String errorMessage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void authenticate() async {
    if (!validate()) {
      return;
    }
    try {
      await Provider.of<Auth>(context, listen: false).login(emailController.text, passwordController.text);
    } on NoUserFound {
      setState(() {
        error = true;
        errorMessage = "User not found.";
      });
    } on WrongPasswordException {
      setState(() {
        error = true;
        errorMessage = "Password is wrong.";
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong.";
      });
    }
  }

  bool validate() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        error = true;
        errorMessage = "All fields are mandatory.";
      });
      return false;
    } else {
      setState(() {
        error = false;
        errorMessage = "";
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: Responsive.isMobile(context) ? double.infinity : 600,
            child: SingleChildScrollView(
              // To avoid Render Pixel Overflow
              scrollDirection: Axis.vertical,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/logo.svg",
                    width: 394.0,
                    height: 120.0,
                  ),
                  const SizedBox(height: 40.0),
                  AppTextField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    hintText: 'Email',
                    obscureText: false,
                    color: error && emailController.text.isEmpty ? AppColors.dangerColor : AppColors.primaryColor,
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: null,
                    height: 64.0,
                  ),
                  const SizedBox(height: 20.0),
                  AppTextField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    hintText: 'Password',
                    obscureText: obscuredPassword,
                    color: error && passwordController.text.isEmpty ? AppColors.dangerColor : AppColors.primaryColor,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscuredPassword = !obscuredPassword;
                        });
                      },
                      icon: obscuredPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                    ),
                    height: 64.0,
                  ),
                  if (error)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: AppColors.dangerColor),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const SizedBox(width: 16.0),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {/* Direct user to the password recovery page */},
                          child: const Text(
                            "Forgot your password?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.hyperTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  AppButton(
                    onTap: authenticate,
                    text: "Log in",
                    height: 64,
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpPage.routeName);
                          },
                          child: const Text(
                            "Sign up now",
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.hyperTextColor),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
