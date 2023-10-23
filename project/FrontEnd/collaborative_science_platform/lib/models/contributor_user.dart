import 'package:collaborative_science_platform/models/account.dart';
import 'package:collaborative_science_platform/models/annotation.dart';
import 'package:collaborative_science_platform/models/basic_user.dart';
import 'package:collaborative_science_platform/models/collaboration_request.dart';
import 'package:collaborative_science_platform/models/workspace.dart';

import 'notification.dart';

class Contributor extends BasicUser {
  List<Workspace> workspaces;
  List<CollaborationRequest> collaborationRequestsGotten;

  Contributor({
    required int sessionID,
    required DateTime logDate,
    required bool privacyPoliciesAccepted,
    required int userId,
    required Account account,
    required List<Notification> notifications,
    required List<Annotation> annotations,
    required this.workspaces,
    required this.collaborationRequestsGotten,
  }) : super(
          sessionID: sessionID,
          logDate: logDate,
          privacyPoliciesAccepted: privacyPoliciesAccepted,
          userId: userId,
          account: account,
          notifications: notifications,
          annotations: annotations
        );
}
