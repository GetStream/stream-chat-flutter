import 'package:sample_app/utils/app_config.dart';

class UserCredentials {
  const UserCredentials({
    required this.id,
    required this.name,
    required this.token,
    this.apiKey = kDefaultStreamApiKey,
  });

  final String id;
  final String name;
  final String token;
  final String apiKey;
}

abstract final class PredefinedUsers {
  static const qaTest1 = UserCredentials(
    id: 'qatest1',
    name: 'QA test 1',
    token:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicWF0ZXN0MSJ9.fnelU7HcP7QoEEsCGteNlF1fppofzNlrnpDQuIgeKCU',
  );

  static const currentUser = qaTest1;
}
