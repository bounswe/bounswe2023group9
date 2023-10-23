import 'package:collaborative_science_platform/models/basic_user.dart';

class Notification {
  int notificationID;
  BasicUser sender;
  BasicUser receiver;
  String notificationBody;
  DateTime notifiedAt;
  bool readByUser;
  String notificationType;
  String notificationTitle;

  Notification(
      {required this.notificationID,
      required this.sender,
      required this.receiver,
      required this.notificationBody,
      required this.notifiedAt,
      required this.readByUser,
      required this.notificationType,
      required this.notificationTitle});
}
