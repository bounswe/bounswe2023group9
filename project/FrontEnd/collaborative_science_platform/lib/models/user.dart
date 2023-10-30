class User {
  int id;
  String email;
  String firstName;
  String lastName;

  User(
      {this.id = 0,
      required this.email,
      required this.firstName,
      required this.lastName});

  factory User.fromJson(Map<String, dynamic> jsonString) {
    return User(
        email: jsonString['username'],
        firstName: jsonString['name'],
        lastName: jsonString['surname'],
    );
  }
}
