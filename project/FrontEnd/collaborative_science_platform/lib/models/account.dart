import 'package:collaborative_science_platform/models/basic_user.dart';

class Account {
  BasicUser user;
  String firstName;
  String lastName;
  String email;
  String password;
  String profilePictureURL;
  String idDocumentURL;
  DateTime registrationDate;
  String aboutMe;
  bool notificationsEnabled;

  Account({
    required this.user,
    required this.firstName,
    required this.lastName, 
    required this.email,
    required this.password,
    required this.profilePictureURL,
    required this.idDocumentURL,
    required this.registrationDate,
    required this.aboutMe,
    required this.notificationsEnabled
    });
}
