class User {
  int id;
  String email;
  String firstName;
  String lastName;

  User({this.id = 0, required this.email, required this.firstName, required this.lastName});

  factory User.fromJson(Map<String, dynamic> jsonString) {
    return User(
      //id: jsonString['id'],
      email: jsonString['username'],
      firstName: jsonString['name'],
      lastName: jsonString['surname'],
    );
  }
  factory User.fromJsonforNodeDetailPage(Map<String, dynamic> jsonString) {
    return User(
      id: jsonString['id'],
      email: jsonString['username'],
      firstName: jsonString['first_name'],
      lastName: jsonString['last_name'],
    );
  }
}
