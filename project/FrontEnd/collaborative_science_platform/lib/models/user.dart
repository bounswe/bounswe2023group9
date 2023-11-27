class User {
  int id;
  String email;
  String firstName;
  String lastName;
  String token;

  User(
      {this.id = 0,
      this.token = '',
      required this.email,
      required this.firstName,
      required this.lastName});

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
