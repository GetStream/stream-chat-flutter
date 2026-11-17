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

const e2eUsers = [
  E2eUser(
    id: 'qatest1',
    name: 'QA test 1',
    token:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicWF0ZXN0MSJ9.fnelU7HcP7QoEEsCGteNlF1fppofzNlrnpDQuIgeKCU',
  ),
  E2eUser(
    id: 'qatest2',
    name: 'QA test 2',
    token:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicWF0ZXN0MiJ9.vSCqAEbs2WVmMWsOsa7065Fsjq-rsTih6qsHPynl7XM',
  ),
];
