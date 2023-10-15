import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final nameFocusNode = FocusNode();

  bool obscuredPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
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
                  controller: nameController,
                  focusNode: nameFocusNode,
                  hintText: 'Full Name',
                  obscureText: false,
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: null,
                  height: 64.0,
                ),
                const SizedBox(height: 10.0),
                AppTextField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  hintText: 'Email',
                  obscureText: false,
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: null,
                  height: 64.0,
                ),
                const SizedBox(height: 10.0),
                AppTextField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  hintText: 'Password',
                  obscureText: obscuredPassword,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscuredPassword = !obscuredPassword;
                      });
                    },
                    icon: obscuredPassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  height: 64.0,
                ),
                const SizedBox(height: 10.0),
                AppTextField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocusNode,
                  hintText: 'Confirm Password',
                  obscureText: obscuredPassword,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscuredPassword = !obscuredPassword;
                      });
                    },
                    icon: obscuredPassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                  height: 64.0,
                ),
                const SizedBox(height: 20.0),
                AppButton(
                  onTap: () {/* Button Functionality */},
                  text: "Sign Up",
                  height: 64,
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do you have an account?",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
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
    );
  }
}
