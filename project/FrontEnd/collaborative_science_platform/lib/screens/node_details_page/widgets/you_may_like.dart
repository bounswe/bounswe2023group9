import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/suggestion_node_card.dart';
import 'package:collaborative_science_platform/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class YouMayLike extends StatelessWidget {
  final bool isLoading;
  final bool error;
  const YouMayLike({super.key, required this.isLoading, required this.error});

  @override
  Widget build(BuildContext context) {
    final List<Node> nodes = Provider.of<NodeProvider>(context).youMayLikeNodeResult;

    return Container(
      padding: const EdgeInsets.only(top: 16),
      width: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "You may also like",
            style: TextStyle(
              color: AppColors.secondaryDarkColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          error
              ? const Text(
                  "Something went wrong!",
                  style: TextStyle(color: Colors.red),
                )
              : isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : nodes.isEmpty
                      ? const Text("No nodes found")
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: nodes.length,
                            itemBuilder: (context, index) {
                              return SuggestionNodeCard(
                                  smallNode: nodes[index],
                                  onTap: () {
                                    context.push('${NodeDetailsPage.routeName}/${nodes[index].id}');
                                  });
                            },
                          ),
                        ),
        ],
      ),
    );
  }
}
