import 'package:collaborative_science_platform/models/request.dart';
import 'package:collaborative_science_platform/models/status.dart';
import 'package:collaborative_science_platform/models/review.dart';

class ReviewRequest extends Request {
  int workspaceID;
  Review review;

  ReviewRequest({
    required int requestID,
    required int senderUserID,
    required int receiverUserID,
    required String title,
    required String body,
    required Status status,
    required this.workspaceID,
    required this.review,
  }) : super(
          requestID: requestID,
          senderUserID: senderUserID,
          receiverUserID: receiverUserID,
          title: title,
          body: body,
          status: status,
        );
}
