class User {
  int id;
  String email;
  String firstName;
  String lastName;

  User({required this.id, required this.email, required this.firstName, required this.lastName});

  factory User.fromJson(Map<String, dynamic> jsonString) {
    return User(
        email: jsonString['username'],
        firstName: jsonString['name'],
        lastName: jsonString['surname'],
        id: jsonString['id']);
  }
}
