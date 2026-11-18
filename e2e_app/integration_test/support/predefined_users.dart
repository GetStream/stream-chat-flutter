class UserCredentials {
  const UserCredentials({required this.id, required this.name});

  final String id;
  final String name;
}

/// The users the e2e suite logs in as, the same ones the other Stream SDKs'
/// e2e suites use.
///
/// The mock server's fixtures and JWTs are recorded for [luke], so he is the
/// [currentUser]. [hanSolo] only connects after `backendRobot.setAppUser` makes
/// the mock server answer as him.
abstract final class PredefinedUsers {
  static const luke = UserCredentials(id: 'luke_skywalker', name: 'Luke Skywalker');
  static const hanSolo = UserCredentials(id: 'han_solo', name: 'Han Solo');

  static const currentUser = luke;
}
