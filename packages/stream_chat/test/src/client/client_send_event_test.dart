import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test('StreamChatClient.sendEvent sends the type, parent id and custom data and returns the response', () async {
    const request = api.SendEventRequest(
      event: api.EventRequest(
        type: 'party_started',
        parentId: 'parent-id',
        custom: {
          'theme': 'disco',
          'guests': 12,
          'snacks': {'chips': true},
        },
      ),
    );

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.sendEvent(type: 'messaging', id: 'general', sendEventRequest: request),
    ).thenAnswer((_) async => Result.success(_response('party_started', duration: '4.21ms')));
    final client = _client(defaultApi);

    final res = await client.sendEvent(
      'general',
      'messaging',
      type: 'party_started',
      parentId: 'parent-id',
      custom: const {
        'theme': 'disco',
        'guests': 12,
        'snacks': {'chips': true},
      },
    );

    expect(res.getOrNull(), const EventResponse(duration: '4.21ms'));
    verify(() => defaultApi.sendEvent(type: 'messaging', id: 'general', sendEventRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.sendEvent sends only the type when nothing else is given and returns the response', () async {
    const request = api.SendEventRequest(event: api.EventRequest(type: EventType.typingStart));

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.sendEvent(type: 'messaging', id: 'general', sendEventRequest: request),
    ).thenAnswer((_) async => Result.success(_response(EventType.typingStart, duration: '0.53ms')));
    final client = _client(defaultApi);

    final res = await client.sendEvent('general', 'messaging', type: EventType.typingStart);

    expect(res.getOrNull(), const EventResponse(duration: '0.53ms'));
    verify(() => defaultApi.sendEvent(type: 'messaging', id: 'general', sendEventRequest: request)).called(1);
  });

  test('StreamChatClient.sendEvent returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.sendEvent(
        type: any(named: 'type'),
        id: any(named: 'id'),
        sendEventRequest: any(named: 'sendEventRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.sendEvent('general', 'messaging', type: 'party_started');

    expect(res.exceptionOrNull(), error);
  });
}

api.EventResponse _response(String type, {required String duration}) => api.EventResponse(
  duration: duration,
  event: api.WSEvent.fromJson({
    'type': type,
    'created_at': '2024-06-01T10:00:00Z',
    'custom': <String, Object?>{},
  }),
);

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
