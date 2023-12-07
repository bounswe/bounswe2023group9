import 'package:carousel_slider/carousel_slider.dart';
import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/screens/graph_page/widgets/graph_page_node_card.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_node_card.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/screens/workspace_page/mobile_workspace_page/widget/subsection_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:collaborative_science_platform/screens/graph_page/graph_page.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';

class MobileGraphPage extends StatefulWidget {
  final NodeDetailed node;
  final bool isLoading;
  const MobileGraphPage({
    super.key,
    required this.node,
    this.isLoading = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _MobileGraphPageState();
  }
}

class _MobileGraphPageState extends State<MobileGraphPage> {
  int current = 1;
  final CarouselController controller = CarouselController();

  Widget referencesCardList() {
    // pre
    return Column(
      children: [
        const SubSectionTitle(title: "References"),
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(3),
          itemCount: widget.node.references.length,
          itemBuilder: (context, index) => HomePageNodeCard(
            smallNode: widget.node.references[index],
            onTap: () {
              context.push("${GraphPage.routeName}/${widget.node.citations[index].id}");
            },
          ),
        ),
      ],
    );
  }

  Widget referentsCardList() {
    return Column(
      children: [
        const SubSectionTitle(title: "Referents"),
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(3),
          itemCount: widget.node.citations.length,
          itemBuilder: (context, index) => HomePageNodeCard(
            smallNode: widget.node.citations[index],
            onTap: () {
              context.push("${GraphPage.routeName}/${widget.node.citations[index].id}");
            },
          ),
        ),
      ],
    );
  }

  Widget slidingPages(BuildContext context) {
    List<Widget> subpages = <Widget>[
      !widget.isLoading ? referencesCardList() : const Center(child: CircularProgressIndicator()),
      Column(
        children: [
          const SubSectionTitle(title: "Theorem"),
          GraphPageNodeCard(
            node: widget.node,
            onTap: () {
              context.push("${NodeDetailsPage.routeName}/${widget.node.nodeId}");
            },
          ),
        ],
      ),
      !widget.isLoading ? referentsCardList() : const Center(child: CircularProgressIndicator()),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              carouselController: controller,
              items: subpages,
              options: CarouselOptions(
                scrollPhysics: const ScrollPhysics(),
                autoPlay: false,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                initialPage: current,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                enlargeFactor: 0.3,
                onPageChanged: (index, reason) {
                  setState(() {
                    current = index;
                  });
                },
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: subpages.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (current == entry.key) ? Colors.indigo[700] : Colors.indigo[200]),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Node createSmallNode(NodeDetailed node) {
    return Node(
      id: node.nodeId,
      nodeTitle: node.nodeTitle,
      contributors: node.contributors,
      publishDate: node.publishDate!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      isScrollable: false,
      appBar: const HomePageAppBar(),
      child: slidingPages(context),
    );
  }
}
