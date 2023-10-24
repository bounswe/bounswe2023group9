import 'package:collaborative_science_platform/models/account.dart';
import 'package:collaborative_science_platform/models/annotation.dart';
import 'package:collaborative_science_platform/models/collaboration_request.dart';
import 'package:collaborative_science_platform/models/contributor_user.dart';
import 'package:collaborative_science_platform/models/notification.dart';
import 'package:collaborative_science_platform/models/review_request.dart';
import 'package:collaborative_science_platform/models/workspace.dart';

class Reviewer extends Contributor {
  List<ReviewRequest> reviewRequestsGotten;

  Reviewer({
    required int sessionID,
    required DateTime logDate,
    required bool privacyPoliciesAccepted,
    required Account account,
    required List<Notification> notifications,
    required int userId,
    required List<Annotation> annotations,
    required List<Workspace> workspaces,
    required List<CollaborationRequest> collaborationRequestsGotten,
    required this.reviewRequestsGotten,
  }) : super(
            sessionID: sessionID,
            logDate: logDate,
            privacyPoliciesAccepted: privacyPoliciesAccepted,
            account: account,
            notifications: notifications,
            userId: userId,
            workspaces: workspaces,
            collaborationRequestsGotten: collaborationRequestsGotten,
            annotations: annotations);
}
