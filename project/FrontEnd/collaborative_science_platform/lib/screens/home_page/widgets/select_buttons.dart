import 'package:collaborative_science_platform/helpers/select_buttons_helper.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/select_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectButtons extends StatefulWidget {
  final Function onTypeChange;
  const SelectButtons(this.onTypeChange, {super.key});

  @override
  State<SelectButtons> createState() => _SelectButtonsState();
}

class _SelectButtonsState extends State<SelectButtons> {
  void selectOne(int index) async {
    setState(() {
      SelectButtonsHelper.selectedIndex = index;
    });
    widget.onTypeChange(index);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectButton(
                index: 0,
                name: "Trending",
                selected: 0 == SelectButtonsHelper.selectedIndex,
                onPressed: selectOne),
            const SizedBox(width: 10.0),
            SelectButton(
                index: 1,
                name: "Latest",
                selected: 1 == SelectButtonsHelper.selectedIndex,
                onPressed: selectOne),
            const SizedBox(width: 10.0),
            SelectButton(
                index: 2,
                name: "Most Read",
                selected: 2 == SelectButtonsHelper.selectedIndex,
                onPressed: selectOne),
            const SizedBox(width: 10.0),
            SelectButton(
                index: 3,
                name: "Random",
                selected: 3 == SelectButtonsHelper.selectedIndex,
                onPressed: selectOne),
            if (Provider.of<Auth>(context).isSignedIn)
              Row(
                children: [
                  const SizedBox(width: 10.0),
                  SelectButton(
                      index: 4,
                      name: "For You",
                      selected: 4 == SelectButtonsHelper.selectedIndex,
                      onPressed: selectOne),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
