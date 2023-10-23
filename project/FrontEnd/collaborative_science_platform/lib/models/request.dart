import 'package:collaborative_science_platform/models/status.dart';

abstract class Request {
  int requestID;
  int senderUserID;
  int receiverUserID;
  String title;
  String body;
  Status status;

  Request({
    required this.requestID,
    required this.senderUserID,
    required this.receiverUserID, 
    required this.title,
    required this.body,
    required this.status
    });
}