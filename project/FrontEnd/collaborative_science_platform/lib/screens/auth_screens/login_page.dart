import 'package:collaborative_science_platform/exceptions/auth_exceptions.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/auth_screens/signup_page.dart';
import 'package:collaborative_science_platform/screens/home_page/home_page.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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
  bool isLoading = false;
  bool buttonState = false;

  String errorMessage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<bool> authenticate() async {
    if (!validate()) {
      return false;
    }
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      await auth.login(emailController.text, passwordController.text);
    } on WrongPasswordException {
      setState(() {
        error = true;
        errorMessage = "Username or password is wrong.";
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return error ? false : true;
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width : 600,
            padding: const EdgeInsets.only(top: 40.0, right: 16, left: 16),
            child: SingleChildScrollView(
              // To avoid Render Pixel Overflow
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        context.go(HomePage.routeName);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: SvgPicture.asset(
                          "assets/images/logo.svg",
                          width: 394.0,
                          height: 120.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0), //to add space
                  AppTextField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    hintText: 'Email',
                    obscureText: false,
                    color: error && emailController.text.isEmpty
                        ? AppColors.dangerColor
                        : AppColors.primaryColor,
                    prefixIcon: const Icon(Icons.person),
                    height: 64.0,
                    onChanged: (_) {
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                        setState(() {
                          buttonState = false;
                        });
                      } else {
                        setState(() {
                          buttonState = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8.0),
                  AppTextField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    hintText: 'Password',
                    obscureText: obscuredPassword,
                    color: error && passwordController.text.isEmpty
                        ? AppColors.dangerColor
                        : AppColors.primaryColor,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscuredPassword = !obscuredPassword; //eye icon to work
                        });
                      },
                      icon: obscuredPassword
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                    height: 64.0,
                    onChanged: (_) {
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                        setState(() {
                          buttonState = false;
                        });
                      } else {
                        setState(() {
                          buttonState = true;
                        });
                      }
                    },
                  ),
                  if (error) //all error messages
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SelectableText(
                        errorMessage,
                        style: const TextStyle(color: AppColors.dangerColor),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  SingleChildScrollView(
                    // To avoid Render Pixel Overflow
                    scrollDirection: Axis.horizontal,
                    child: Row(
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
                  ),
                  const SizedBox(height: 20.0),
                  AppButton(
                    onTap: () async {
                      if (await authenticate() && mounted) {
                        // Navigate to home page if authentication is successful
                        context.go(HomePage.routeName);
                      }
                    },
                    text: "Log in",
                    height: 64,
                    isLoading: isLoading,
                    isActive: buttonState,
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SelectableText(
                          "Don't have an account?",
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            context.go(SignUpPage.routeName);
                          },
                          child: const Text(
                            "Sign up now",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: AppColors.hyperTextColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
