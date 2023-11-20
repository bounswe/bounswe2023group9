class NodeDoesNotExist implements Exception {
  String message;
  NodeDoesNotExist({this.message = "Node Does Not Exist"});
}

class ProofDoesNotExist implements Exception {
  String message;
  ProofDoesNotExist({this.message = "Proof Does Not Exist"});
}

class TheoremDoesNotExist implements Exception {
  String message;
  TheoremDoesNotExist({this.message = "Theorem Does Not Exist"});
}
