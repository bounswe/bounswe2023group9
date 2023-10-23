import 'package:collaborative_science_platform/models/account.dart';
import 'package:collaborative_science_platform/models/annotation.dart';
import 'package:collaborative_science_platform/models/base_user.dart';
import 'package:collaborative_science_platform/models/notification.dart';

class BasicUser extends BaseUser {
  int userId;
  Account account;
  List<Notification> notifications;
  List<Annotation> annotations;

  BasicUser({
    required int sessionID,
    required DateTime logDate,
    required bool privacyPoliciesAccepted,
    required this.userId,
    required this.account,
    required this.notifications,
    required this.annotations,
  }) : super(
          sessionID: sessionID,
          logDate: logDate,
          privacyPoliciesAccepted: privacyPoliciesAccepted,
        );
}
