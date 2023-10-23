import 'package:collaborative_science_platform/models/request.dart';
import 'package:collaborative_science_platform/models/status.dart';

class CollaborationRequest extends Request {
  int workspaceID;

  CollaborationRequest({
    required int requestID,
    required int senderUserID,
    required int receiverUserID,
    required String title,
    required String body,
    required Status status,
    required this.workspaceID,
  }) : super(
          requestID: requestID,
          senderUserID: senderUserID,
          receiverUserID: receiverUserID,
          title: title,
          body: body,
          status: status,
        );
}