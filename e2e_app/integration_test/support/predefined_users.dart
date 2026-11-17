class UserCredentials {
  const UserCredentials({required this.id, required this.name});

  final String id;
  final String name;
}

abstract final class PredefinedUsers {
  static const qaTest1 = UserCredentials(id: 'qatest1', name: 'QA test 1');
  static const qaTest2 = UserCredentials(id: 'qatest2', name: 'QA test 2');

  static const currentUser = qaTest1;

  /// Who the mock server takes the logged-in user to be, whichever user was
  /// picked: it answers every connect with its own fixture user, so this is
  /// the id the app ends up with as its current user.
  static const mockServerUser = UserCredentials(id: 'luke_skywalker', name: 'Luke Skywalker');
}
