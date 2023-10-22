import 'package:collaborative_science_platform/exceptions/auth_exceptions.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/auth_screens/widgets/strong_password_checks.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final surnameFocusNode = FocusNode();

  bool buttonState = false;
  bool isLoading = false;

  bool obscuredPassword = true;
  bool error = false;

  bool passwordMatchError = false;
  bool weakPasswordError = false;

  String errorMessage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    surnameController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    surnameFocusNode.dispose();
    super.dispose();
  }

  void authenticate() async {
    if (!validate()) {
      return;
    }
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      setState(() {
        isLoading = true;
      });
      await auth.signup(nameController.text, surnameController.text, emailController.text, passwordController.text);
    } on UserExistException {
      setState(() {
        error = true;
        errorMessage = "A user with that username already exists";
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void validateStrongPassword() {
    if (StrongPasswordChecks.passedAllPasswordCriteria(passwordController.text, confirmPasswordController.text) &&
        nameController.text.isNotEmpty &&
        surnameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      setState(() {
        buttonState = true;
      });
    } else {
      setState(() {
        buttonState = false;
      });
    }
  }

  bool validate() {
    if (nameController.text.isEmpty ||
        surnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        error = true;
        errorMessage = "All fields are mandatory!";
      });
      return false;
    } else if (!StrongPasswordChecks.passedAllPasswordCriteria(
        passwordController.text, confirmPasswordController.text)) {
      setState(() {
        error = true;
        weakPasswordError = true;
        errorMessage = "Your password is not strong enough!";
      });
      return false;
    } else if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        error = true;
        passwordMatchError = true;
        errorMessage = "Passwords do not match!";
      });
      return false;
    } else {
      setState(() {
        error = false;
        weakPasswordError = false;
        passwordMatchError = false;
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/logo.svg",
                    width: 394.0,
                    height: 120.0,
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: nameController,
                          focusNode: nameFocusNode,
                          hintText: 'Name',
                          color: error && nameController.text.isEmpty ? AppColors.dangerColor : AppColors.primaryColor,
                          obscureText: false,
                          prefixIcon: const Icon(Icons.person),
                          height: 64.0,
                          onChanged: (_) {
                            validateStrongPassword();
                          },
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: AppTextField(
                          controller: surnameController,
                          focusNode: surnameFocusNode,
                          hintText: 'Surname',
                          color:
                              error && surnameController.text.isEmpty ? AppColors.dangerColor : AppColors.primaryColor,
                          obscureText: false,
                          prefixIcon: const Icon(Icons.person),
                          height: 64.0,
                          onChanged: (_) {
                            validateStrongPassword();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    controller: emailController,
                    focusNode: emailFocusNode,
                    hintText: 'Email',
                    color: error && emailController.text.isEmpty ? AppColors.dangerColor : AppColors.primaryColor,
                    obscureText: false,
                    prefixIcon: const Icon(Icons.mail),
                    height: 64.0,
                    onChanged: (_) {
                      validateStrongPassword();
                    },
                  ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    hintText: 'Password',
                    color: error && (passwordMatchError || passwordController.text.isEmpty || weakPasswordError)
                        ? AppColors.dangerColor
                        : AppColors.primaryColor,
                    obscureText: obscuredPassword,
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
                    onChanged: (_) {
                      validateStrongPassword();
                    },
                  ),
                  const SizedBox(height: 10.0),
                  if (passwordController.text.isNotEmpty)
                    StrongPasswordChecks(
                      password: passwordController.text,
                      confirmPassword: confirmPasswordController.text,
                    ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    controller: confirmPasswordController,
                    focusNode: confirmPasswordFocusNode,
                    hintText: 'Confirm Password',
                    color: error && (passwordMatchError || confirmPasswordController.text.isEmpty)
                        ? AppColors.dangerColor
                        : AppColors.primaryColor,
                    obscureText: obscuredPassword,
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
                    onChanged: (_) {
                      validateStrongPassword();
                    },
                  ),
                  const SizedBox(height: 10.0),
                  if (error)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: AppColors.dangerColor),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  AppButton(
                    onTap: authenticate,
                    text: "Sign Up",
                    height: 64,
                    isActive: buttonState,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Already have an account?",
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
                            Navigator.pushNamed(context, '/');
                          },
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.hyperTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
