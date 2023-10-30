import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final Function? onTap;
  const CardContainer({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    //if (onTap == null) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
    //}
    // else {
    //   return MouseRegion(
    //     cursor: SystemMouseCursors.click,
    //     child: GestureDetector(
    //       onTap: () {
    //         onTap!();
    //       },
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(5),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.grey.withOpacity(0.3),
    //               blurRadius: 7,
    //               offset: const Offset(0, 2),
    //             ),
    //           ],
    //         ),
    //         child: Padding(
    //           padding: const EdgeInsets.all(16),
    //           child: child,
    //         ),
    //       ),
    //     ),
    //   );
    // }
  }
}
