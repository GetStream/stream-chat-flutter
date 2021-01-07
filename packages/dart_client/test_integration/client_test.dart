import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat/src/client.dart';
import 'package:stream_chat/stream_chat.dart';

const API_KEY = '6xjf3dex3n7d';
const TOKEN =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo';

void main() {
  test('test', () async {
    final client = Client(
      '6xjf3dex3n7d',
      logLevel: Level.INFO,
      tokenProvider: (_) async => '',
    );
    final user = User(id: 'wild-breeze-7');

    await client.setGuestUser(user);
  });
}
