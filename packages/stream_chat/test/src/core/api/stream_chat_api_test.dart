import 'package:stream_chat/src/core/api/stream_chat_api.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  const apiKey = 'test-api-key';
  late final client = MockHttpClient();
  late StreamChatApi streamChatApi;

  setUp(() {
    streamChatApi = StreamChatApi(
      apiKey,
      client: client,
    );
  });

  test('`.user`', () {
    expect(streamChatApi.user, isNotNull);
  });

  test('`.message`', () {
    expect(streamChatApi.message, isNotNull);
  });

  test('`.channel`', () {
    expect(streamChatApi.channel, isNotNull);
  });

  test('`.pushPreferences`', () {
    expect(streamChatApi.pushPreferences, isNotNull);
  });

  test('`.moderation`', () {
    expect(streamChatApi.moderation, isNotNull);
  });

  test('`.general`', () {
    expect(streamChatApi.general, isNotNull);
  });
}
