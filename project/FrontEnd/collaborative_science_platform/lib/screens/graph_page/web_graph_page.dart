import 'package:collaborative_science_platform/models/contributor_user.dart';
import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/center_node.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/node_list.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_node_card.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';

class WebGraphPage extends StatefulWidget {
  final SmallNode smallNode;

  const WebGraphPage({
    super.key,
    required this.smallNode,
  });

  @override
  State<WebGraphPage> createState() => _WebGraphPageState();
}

class _WebGraphPageState extends State<WebGraphPage> {
  List<SmallNode> references = [];
  List<SmallNode> citations = [];
  bool areReferencesLoading = false;
  bool areCitationsLoading = false;

  void getReferences() {
    setState(() {
      areReferencesLoading = true;
    });
    references = List<SmallNode>.generate(
      10,
      (index) => SmallNode(
        nodeId: index + 1,
        nodeTitle: "Reference ${index + 1}",
        contributors: [
          Contributor(
              name: "Contributor Name ${index + 1}",
              surname: "Contributor Surname ${index + 1}",
              email: "contributor${index + 1}@mail.com"),
        ],
        publishDate: DateTime(1590, 12, 12),
      ),
    );
    setState(() {
      areReferencesLoading = false;
    });
  }

  void getCitations() {
    setState(() {
      areCitationsLoading = true;
    });
    citations = List<SmallNode>.generate(
      10,
      (index) => SmallNode(
        nodeId: index + 1,
        nodeTitle: "Citation ${index + 1}",
        contributors: [
          Contributor(
              name: "Contributor Name ${index + 1}",
              surname: "Contributor Surname ${index + 1}",
              email: "contributor${index + 1}@mail.com"),
        ],
        publishDate: DateTime(1990, 12, 12),
      ),
    );
    setState(() {
      areCitationsLoading = false;
    });
  }

  Widget referencesCardList() {
    getReferences();
    return ListView.builder(
      itemCount: references.length,
      itemBuilder: (context, index) => HomePageNodeCard(
        smallNode: references[index],
        onTap: () {/* Orientate the node in the middle */},
      ),
    );
  }

  Widget citationsCardList() {
    getCitations();
    return ListView.builder(
      itemCount: citations.length,
      itemBuilder: (context, index) => HomePageNodeCard(
        smallNode: citations[index],
        onTap: () {/* Orientate the node to the middle */},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const listRatio = 0.2;

    return PageWithAppBar(
      appBar: const HomePageAppBar(),
      pageColor: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3.2,
            height: MediaQuery.of(context).size.height,
            child: referencesCardList(),
          ),
          Container(
               width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 30.0),
                Flexible(
                  flex: 6,
                  child: CenterNode(
                    node: widget.smallNode,
                    width: Responsive.getGenericPageWidth(context) * (1 - listRatio * 2),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3.2,
            height: MediaQuery.of(context).size.height,
            child: citationsCardList(),
          ),
        ],
      ),
    );
  }
}
