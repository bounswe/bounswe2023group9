import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/utils/textStyles.dart';
import 'package:collaborative_science_platform/widgets/card_container.dart';
import 'package:flutter/material.dart';

class References extends StatelessWidget {
  final List<User> references;
  const References({super.key, required this.references});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: references.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: CardContainer(
                child: Column(
                  children: [
                    Text(
                      "${references[index].firstName} ${references[index].lastName}",
                      style: TextStyles.title4,
                    ),
                    Text(
                      references[index].email,
                      style: TextStyles.bodyGrey,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
