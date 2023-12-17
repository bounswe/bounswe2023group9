import 'package:collaborative_science_platform/exceptions/search_exceptions.dart';
import 'package:collaborative_science_platform/models/semantic_tag.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SemanticSearchBar extends StatefulWidget {
  final Function addSemanticTags;

  const SemanticSearchBar({
    super.key,
    required this.addSemanticTags,
  });

  @override
  State<SemanticSearchBar> createState() => _SemanticSearchBarState();
}

class _SemanticSearchBarState extends State<SemanticSearchBar> {
  final List<String> semantics = [];

  Future<List<String>> _getSuggestions(String query) async {
    semantics.clear();
    if (query.length < 3) return [];
    final NodeProvider nodeProvider = Provider.of<NodeProvider>(context, listen: false);
    try {
      await nodeProvider.semanticSuggestions(query);
    } on SearchError {
      return [];
    }
    semantics.addAll(nodeProvider.semanticTags.map((e) => e.label));
    return semantics;
  }

  SemanticTag getTag(String label) {
    final NodeProvider nodeProvider = Provider.of<NodeProvider>(context, listen: false);
    return nodeProvider.getSemanticTag(label);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: EasySearchBar(
        searchHintText: "Search",
        searchBackgroundColor: Colors.teal.shade100,
        backgroundColor: Colors.grey.shade300,
        title: const SizedBox(),
        elevation: 5,
        searchBackIconTheme: const IconThemeData(color: Colors.grey),
        titleTextStyle: TextStyle(color: Colors.grey[600]!),
        searchTextStyle: const TextStyle(color: Colors.grey),
        onSearch: (value) { },
        asyncSuggestions: (value) => _getSuggestions(value),
        suggestionLoaderBuilder: () => const Center(child: CircularProgressIndicator()),
        suggestionBuilder: (label) {
          final SemanticTag tag = getTag(label);
          return ListTile(
            title: Text(tag.label),
            subtitle: Text(tag.description),
          );
        },
        onSuggestionTap: (label) {
          final SemanticTag tag = getTag(label);
          widget.addSemanticTags(<String>[tag.id]);
          setState(() { });
        },
      ),
    );
  }
}
