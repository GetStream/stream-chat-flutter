import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('StreamChatClient.deleteChannel sends the channel and returns the deleted channel', () async {
    final response = api.DeleteChannelResponse(
      duration: '0.01ms',
      channel: api.ChannelResponse(
        cid: 'messaging:general',
        id: 'general',
        type: 'messaging',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026, 2),
        deletedAt: DateTime.utc(2026, 3),
        custom: const {'name': 'General'},
        disabled: false,
        frozen: false,
      ),
    );

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.deleteChannel(type: 'messaging', id: 'general')).thenAnswer(
      (_) async => Result.success(response),
    );
    final client = _client(defaultApi);

    final res = await client.deleteChannel('general', 'messaging');

    expect(res.getOrNull()!.duration, '0.01ms');
    final channel = res.getOrNull()!.channel!;
    expect(channel.cid, 'messaging:general');
    expect(channel.name, 'General');
    expect(channel.createdAt, DateTime.utc(2026));
    expect(channel.updatedAt, DateTime.utc(2026, 2));
    expect(channel.deletedAt, DateTime.utc(2026, 3));
    verify(() => defaultApi.deleteChannel(type: 'messaging', id: 'general')).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.deleteChannel returns a null channel when the response has none', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.deleteChannel(type: 'messaging', id: 'general')).thenAnswer(
      (_) async => const Result.success(api.DeleteChannelResponse(duration: '0.01ms')),
    );
    final client = _client(defaultApi);

    final res = await client.deleteChannel('general', 'messaging');

    expect(res, const Result.success(DeleteChannelResponse(duration: '0.01ms')));
  });

  test('StreamChatClient.deleteChannel returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.deleteChannel(
        type: any(named: 'type'),
        id: any(named: 'id'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.deleteChannel('general', 'messaging');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
