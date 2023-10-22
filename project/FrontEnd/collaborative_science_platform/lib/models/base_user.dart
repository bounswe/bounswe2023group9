abstract class BaseUser {
  int sessionID;
  DateTime logDate;
  bool privacyPoliciesAccepted;

  BaseUser({
    required this.sessionID,
    required this.logDate,
    required this.privacyPoliciesAccepted, 
    });
}
