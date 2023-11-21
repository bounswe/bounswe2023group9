import 'package:collaborative_science_platform/exceptions/node_details.exceptions.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/screens/graph_page/mobile_graph_page.dart';
import 'package:collaborative_science_platform/screens/graph_page/web_graph_page.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphPage extends StatefulWidget {
  static const routeName = '/graph';
  final int nodeId;
  const GraphPage({super.key, required this.nodeId});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  NodeDetailed node = NodeDetailed();
  bool _isFirstTime = true;
  bool isLoading = false;
  bool error = false;
  String errorMessage = "";

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getNode();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void getNode() async {
    try {
      final nodeProvider = Provider.of<NodeProvider>(context, listen: false);
      setState(() {
        error = false;
        isLoading = true;
      });
      if (nodeProvider.nodeDetailed != null) {
        if (nodeProvider.nodeDetailed!.nodeId == widget.nodeId) {
          setState(() {
            node = nodeProvider.nodeDetailed!;
            isLoading = false;
          });
          return;
        }
      }
      await nodeProvider.getNode(widget.nodeId);
      setState(() {
        node = nodeProvider.nodeDetailed!;
        isLoading = false;
      });
    } on NodeDoesNotExist {
      setState(() {
        isLoading = false;
        error = true;
        errorMessage = "Node does not exist!";
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = true;
        errorMessage = "Something went wrong!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || error) {
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
    } else {
      return Responsive(
        mobile: MobileGraphPage(node: node),
        desktop: WebGraphPage(node: node),
      );
    }
  }
}


  // void getDummyNode() async {
  //   final references = List<Node>.generate(
  //     10,
  //     (index) => Node(
  //       id: index + 1,
  //       nodeTitle: "Reference ${index + 1}",
  //       contributors: [
  //         User(
  //             firstName: "Contributor Name ${index + 1}",
  //             lastName: "Contributor Surname ${index + 1}",
  //             email: "contributor${index + 1}@mail.com"),
  //       ],
  //       publishDate: DateTime(1590, 12, 12),
  //     ),
  //   );
  //   final referents = List<Node>.generate(
  //     10,
  //     (index) => Node(
  //       id: index + 1,
  //       nodeTitle: "Referent ${index + 1}",
  //       contributors: [
  //         User(
  //             firstName: "Contributor Name ${index + 1}",
  //             lastName: "Contributor Surname ${index + 1}",
  //             email: "contributor${index + 1}@mail.com"),
  //       ],
  //       publishDate: DateTime(1590, 12, 12),
  //     ),
  //   );
  //   setState(() {
  //     isLoading = true;
  //   });
  //   node = NodeDetailed(
  //     nodeId: 1,
  //     nodeTitle: "Node Title",
  //     contributors: [User(email: "abc", firstName: "abc", lastName: "edf")],
  //     publishDate: DateTime(1590, 12, 12),
  //     references: references,
  //     citations: referents,
  //   );
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
