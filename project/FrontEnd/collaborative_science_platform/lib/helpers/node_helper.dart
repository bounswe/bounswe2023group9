import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'dart:convert';

class NodeHelper {
  // Type = true: all text, false: only first 500 characters
  static getNodeContentLatex(NodeDetailed node, String type) {
    if (node.theorem == null) {
      return '<b>Theorem Content:</b> No theorem';
    }
    String theorem = node.theorem!.theoremContent;
    if (type == "long") {
      //<b>Theorem Content:</b>
      return utf8.decode(theorem.codeUnits);
    }
    if (theorem.length > 500) {
      return '${utf8.decode(theorem.substring(0, 500).codeUnits)}...';
    }
    return utf8.decode(theorem.codeUnits);
  }
}
