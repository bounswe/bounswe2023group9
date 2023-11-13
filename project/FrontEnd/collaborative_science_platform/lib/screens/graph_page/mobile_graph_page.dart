import 'package:carousel_slider/carousel_slider.dart';
import 'package:collaborative_science_platform/models/contributor_user.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_node_card.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/models/small_node.dart';
import 'package:flutter/material.dart';

// See the examples and implementations for sliding pages:
// https://pub.dev/packages/carousel_slider

class MobileGraphPage extends StatefulWidget {
  final SmallNode smallNode;
  const MobileGraphPage({
    super.key,
    required this.smallNode,
  });

  @override
  State<StatefulWidget> createState() {
    return _MobileGraphPageState();
  }
}

class _MobileGraphPageState extends State<MobileGraphPage> {
  int current = 1;
  final CarouselController controller = CarouselController();
  List<SmallNode> references = [];
  List<SmallNode> referents = [];
  bool areReferencesLoading = false;
  bool areReferentsLoading = false;

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

  void getReferents() {
    setState(() {
      areReferentsLoading = true;
    });
    referents = List<SmallNode>.generate(
      10,
      (index) => SmallNode(
        nodeId: index + 1,
        nodeTitle: "Referent ${index + 1}",
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
      areReferentsLoading = false;
    });
  }

  Widget referencesCardList() {
    // pre
    getReferences();
    return ListView.builder(
      itemCount: references.length,
      itemBuilder: (context, index) => HomePageNodeCard(
        smallNode: references[index],
        onTap: () {/* Orientate the node in the middle */},
      ),
    );
  }

  Widget referentsCardList() {
    // post
    getReferents();
    return ListView.builder(
      itemCount: referents.length,
      itemBuilder: (context, index) => HomePageNodeCard(
        smallNode: referents[index],
        onTap: () {/* Orientate the node to the middle */},
      ),
    );
  }

  Widget slidingPages(BuildContext context) {
    List<Widget> subpages = <Widget>[
      !areReferencesLoading
          ? referencesCardList()
          : const Center(child: CircularProgressIndicator()),
      Center(
        child: SizedBox(
          height: 200,
          child: HomePageNodeCard(
            smallNode: widget.smallNode,
            onTap: () {/* Navigate to the Node Page */},
          ),
        ),
      ),
      !areReferentsLoading ? referentsCardList() : const Center(child: CircularProgressIndicator()),
    ];
    return Column(
      children: [
        Expanded(
          child: Center(
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

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      isScrollable: false,
      appBar: const HomePageAppBar(),
      child: slidingPages(context),
    );
  }
}
