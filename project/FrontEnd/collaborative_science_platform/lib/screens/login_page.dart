
import 'package:collaborative_science_platform/widgets/app_button.dart';
import 'package:collaborative_science_platform/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView( // To avoid Render Pixel Overflow
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
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const SizedBox(width: 16.0),
                    GestureDetector(
                      onTap: () { /* Direct user to the password recovery page */ },
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                AppButton(
                    onTap: () {/* Button Functionality */},
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
                    GestureDetector(
                      onTap: () { /* Direct user to the sign up page */ },
                      child: Text(
                        "Sign up now",
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
