class User {
  int id;
  String email;
  String firstName;
  String lastName;

  User({required this.id, required this.email, required this.firstName, required this.lastName});

  factory User.fromJson(Map<String, dynamic> jsonString) {
    return User(
        id: jsonString['id'],
        firstName: jsonString['name'],
        lastName: jsonString['surname'],
        email: jsonString['email']);
  }
}
