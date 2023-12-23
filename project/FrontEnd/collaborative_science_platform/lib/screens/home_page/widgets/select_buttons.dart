import 'package:collaborative_science_platform/screens/home_page/widgets/select_button.dart';
import 'package:flutter/material.dart';

class SelectButtons extends StatefulWidget {
  final Function onTypeChange;
  const SelectButtons(this.onTypeChange, {super.key});

  @override
  State<SelectButtons> createState() => _SelectButtonsState();
}

class _SelectButtonsState extends State<SelectButtons> {
  int selectedIndex = 0;

  void selectOne(int index) async {
    setState(() {
      selectedIndex = index;
    });
    widget.onTypeChange(index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectButton(
            index: 0, name: "Trending", selected: selectedIndex == 0, onPressed: selectOne),
        const SizedBox(width: 10.0),
        SelectButton(index: 1, name: "Latest", selected: selectedIndex == 1, onPressed: selectOne),
        const SizedBox(width: 10.0),
        SelectButton(
            index: 2, name: "Most Read", selected: selectedIndex == 2, onPressed: selectOne),
        const SizedBox(width: 10.0),
        SelectButton(index: 3, name: "Random", selected: selectedIndex == 3, onPressed: selectOne),
        // if (Provider.of<Auth>(context).isSignedIn)
        //   Row(
        //     children: [
        //       const SizedBox(width: 10.0),
        //       SelectButton(
        //           index: 4, name: "For You", selected: selectedIndex == 4, onPressed: selectOne),
        //     ],
        //   ),
      ],
    );
  }
}
