class User {
  String username;
  String email;
  String firstName;
  String lastName;

  User(
      {required this.username,
      required this.email,
      required this.firstName,
      required this.lastName});

  factory User.fromJson(Map<String, dynamic> jsonString) {
    return User(
        email: jsonString['username'],
        firstName: jsonString['name'],
        lastName: jsonString['surname'],
        username: jsonString['username']);
  }
}
