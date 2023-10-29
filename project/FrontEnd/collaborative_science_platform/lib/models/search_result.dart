class SearchResult {
  List<NodeResult> nodes;
  List<AuthorResult> authors;

  SearchResult({required this.nodes, required this.authors});
}

class NodeResult {
  int id;
  String title;
  DateTime date;
  List<AuthorResult> authors;

  NodeResult(
      {required this.id,
      required this.title,
      required this.date,
      required this.authors});
}

class AuthorResult {
  String name;
  String surname;
  String username;

  AuthorResult(
      {required this.name, required this.surname, required this.username});
}
