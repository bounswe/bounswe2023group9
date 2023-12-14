import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../node_details_page/node_details_page.dart';

class ReferenceCard extends StatelessWidget {
  final Node reference;
  const ReferenceCard({
    super.key,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        elevation: 4.0,
        //shadowColor: AppColors.primaryColor,
        //color: AppColors.primaryLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to the node page of the theorem
            context.push('${NodeDetailsPage.routeName}/${reference.id}');
          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 4.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Responsive.getGenericPageWidth(context)-100,
                      child: Text(
                        reference.nodeTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-100,
                      child: Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: reference.contributors.length,
                            itemBuilder: (context, index) => Text(
                              "${reference.contributors[index].firstName} ${reference.contributors[index].lastName}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      reference.publishDateFormatted,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                      // textAlign: TextAlign.start,
                    ),
                  ],
                ),
                const Expanded(child: SizedBox(width: 4.0)),
                IconButton(
                  onPressed: () { //remove reference

                  },
                  icon: const Icon(Icons.delete),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
