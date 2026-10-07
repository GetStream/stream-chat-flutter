import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.MarkDeliveredRequest()));

  test('StreamChatClient.markChannelsDelivered sends the receipts and returns the response', () async {
    const request = api.MarkDeliveredRequest(
      latestDeliveredMessages: [
        api.DeliveredMessagePayload(cid: 'messaging:general', id: 'message-1'),
        api.DeliveredMessagePayload(cid: 'messaging:random', id: 'message-2'),
      ],
    );

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markDelivered(markDeliveredRequest: request),
    ).thenAnswer((_) async => const Result.success(api.MarkDeliveredResponse(duration: '0.01ms')));
    final client = _client(defaultApi);

    final res = await client.markChannelsDelivered(const [
      MessageDelivery(channelCid: 'messaging:general', messageId: 'message-1'),
      MessageDelivery(channelCid: 'messaging:random', messageId: 'message-2'),
    ]);

    expect(res.getOrNull(), const MarkDeliveredResponse(duration: '0.01ms'));
    verify(() => defaultApi.markDelivered(markDeliveredRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.markChannelsDelivered returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.markDelivered(markDeliveredRequest: any(named: 'markDeliveredRequest')),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.markChannelsDelivered(const [
      MessageDelivery(channelCid: 'messaging:general', messageId: 'message-1'),
    ]);

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
