class NoUserFound implements Exception {
  String message;
  NoUserFound({this.message = "No User Found"});
}

class WrongPasswordException implements Exception {
  String message;
  WrongPasswordException({this.message = "Wrong Password"});
}

class UserExistException implements Exception {
  String message;
  UserExistException({this.message = "A user with that username already exists"});
}