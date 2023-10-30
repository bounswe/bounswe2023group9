class WrongSearchTypeError implements Exception {
  String message;
  WrongSearchTypeError({this.message = "Wrong Search Type Error"});
}

class SearchError implements Exception {
  String message;
  SearchError({this.message = "Search Error"});
}
