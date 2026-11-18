import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A user the login screen offers, with a token for it.
///
/// The SDK decodes the token on the device, so it has to be a well-formed
/// JWT; the mock server does not check it.
class E2eUser {
  const E2eUser({required this.id, required this.name, required this.token});

  final String id;
  final String name;
  final String token;

  User toUser() => User(id: id, name: name);
}

/// The users the other Stream SDKs' e2e apps offer, with the same tokens.
const e2eUsers = [
  E2eUser(
    id: 'luke_skywalker',
    name: 'Luke Skywalker',
    token:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibHVrZV9za3l3YWxrZXIifQ.kFSLHRB5X62t0Zlc7nwczWUfsQMwfkpylC6jCUZ6Mc0',
  ),
  E2eUser(
    id: 'han_solo',
    name: 'Han Solo',
    token:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiaGFuX3NvbG8ifQ.R6PkQeGPcusALmhvaST50lwroL_JkZnI3Q7hQ1Hvj3k',
  ),
];
