class NodeDoesNotExist implements Exception {
  String message;
  NodeDoesNotExist({this.message = "Node Does Not Exist"});
}

// this exception is not used anywhere
class ProofDoesNotExist implements Exception {
  String message;
  ProofDoesNotExist({this.message = "Proof Does Not Exist"});
}

// this exception is not used anywhere
class TheoremDoesNotExist implements Exception {
  String message;
  TheoremDoesNotExist({this.message = "Theorem Does Not Exist"});
}
