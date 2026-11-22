import 'package:e2e_app/auth/users.dart' as users;

export 'package:e2e_app/auth/users.dart' show E2eUser;

/// The users the e2e suite logs in as, the same ones the login screen offers.
///
/// The mock server's fixtures and JWTs are recorded for [luke], so he is the
/// [currentUser]. [hanSolo] only connects after `backendRobot.setAppUser` makes
/// the mock server answer as him.
abstract final class PredefinedUsers {
  static const luke = users.luke;
  static const hanSolo = users.hanSolo;

  static const currentUser = luke;
}
