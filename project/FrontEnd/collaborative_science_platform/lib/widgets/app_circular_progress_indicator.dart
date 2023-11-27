import 'package:flutter/material.dart';

import '../screens/home_page/widgets/home_page_appbar.dart';
import '../screens/page_with_appbar/page_with_appbar.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  final bool isLoading;
  final bool error;
  final String errorMessage;
  const AppCircularProgressIndicator({
    required this.isLoading,
    required this.error,
    required this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : error
            ? SelectableText(errorMessage)
            : const SelectableText("Something went wrong!"),
      ),
    );
  }
}
