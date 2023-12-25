import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/screens/node_details_page/node_details_page.dart';
import 'package:collaborative_science_platform/utils/constants.dart';
import 'package:share_plus/share_plus.dart';

class SharePage {
  static void shareNodeView(NodeDetailed node) {
    Share.share(
        'Check out this on Collaborative Science Platform: ${node.nodeTitle} at ${Constants.appUrl}${NodeDetailsPage.routeName}/${node.nodeId}');
  }
}
