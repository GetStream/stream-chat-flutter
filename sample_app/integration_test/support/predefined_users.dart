class UserCredentials {
  const UserCredentials({required this.id, required this.name});

  final String id;
  final String name;
}

abstract final class PredefinedUsers {
  static const qaTest1 = UserCredentials(id: 'qatest1', name: 'QA test 1');

  static const currentUser = qaTest1;
}
