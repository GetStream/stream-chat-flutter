import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../utils.dart';
import '../ws/fake_chat_server.dart';

void main() {
  test('StreamChatClient.connectUser connects again after an expired token was refused', () async {
    final user = User(id: 'test-user-id');
    final token = testUserToken(user.id).rawValue;
    final server = FakeChatServer(user: OwnUser.fromUser(user))..refusal = connectionErrorFrame();
    final client = StreamChatClient(
      'test-api-key',
      defaultApi: FakeDefaultApi(),
      chatApi: FakeChatApi(),
      wsProvider: server.connect,
    );
    addTearDown(client.dispose);

    await expectLater(
      client.connectUser(user, token),
      throwsA(isA<StreamApiException>().having((it) => it.isTokenExpired, 'isTokenExpired', isTrue)),
    );

    server.refusal = null;
    final connected = await client.connectUser(user, token);

    expect(connected.id, user.id);
  });
}
