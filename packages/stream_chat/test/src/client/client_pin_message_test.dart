import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateMessagePartialRequest()));

  test('StreamChatClient.pinMessage sends a pin without expiry and returns a success', () async {
    const request = api.UpdateMessagePartialRequest(set: {'pinned': true, 'pin_expires': null}, skipEnrichUrl: false);
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.updateMessagePartial(id: 'message-id', updateMessagePartialRequest: request)).thenAnswer(
      (_) async => Result.success(api.UpdateMessagePartialResponse(duration: '0.01ms', message: generatedMessage)),
    );
    final client = _client(defaultApi);

    final res = await client.pinMessage('message-id');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.updateMessagePartial(id: 'message-id', updateMessagePartialRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.pinMessage sends the expiry date it is given in UTC', () async {
    final expiry = DateTime.utc(2026, 3, 1, 12).toLocal();

    final set = await _pinnedSet(timeoutOrExpirationDate: expiry);

    expect(set, {'pinned': true, 'pin_expires': '2026-03-01T12:00:00.000Z'});
  });

  test('StreamChatClient.pinMessage sends an expiry that many seconds from now', () async {
    final before = DateTime.now();

    final set = await _pinnedSet(timeoutOrExpirationDate: 300);

    final expires = DateTime.parse(set['pin_expires']! as String);
    expect(expires.isUtc, isTrue);
    expect(expires.difference(before).inSeconds, inInclusiveRange(299, 301));
  });

  test('StreamChatClient.pinMessage throws for an expiry that is neither a date nor a number', () async {
    final client = _client(MockDefaultApi());

    // The check runs in an assert before the first await, so the call throws
    // synchronously and must stay in a closure.
    await expectLater(
      () => client.pinMessage('message-id', timeoutOrExpirationDate: 'tomorrow'),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('StreamChatClient.unpinMessage sends an unpin and returns a success', () async {
    const request = api.UpdateMessagePartialRequest(set: {'pinned': false}, skipEnrichUrl: false);
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.updateMessagePartial(id: 'message-id', updateMessagePartialRequest: request)).thenAnswer(
      (_) async => Result.success(api.UpdateMessagePartialResponse(duration: '0.01ms', message: generatedMessage)),
    );
    final client = _client(defaultApi);

    final res = await client.unpinMessage('message-id');

    expect(res.isSuccess, isTrue);
    verify(() => defaultApi.updateMessagePartial(id: 'message-id', updateMessagePartialRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });
}

// Pins a message through a client and returns the fields the request set.
Future<Map<String, Object?>> _pinnedSet({Object? timeoutOrExpirationDate}) async {
  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.updateMessagePartial(
      id: 'message-id',
      updateMessagePartialRequest: any(named: 'updateMessagePartialRequest'),
    ),
  ).thenAnswer(
    (_) async => Result.success(api.UpdateMessagePartialResponse(duration: '0.01ms', message: generatedMessage)),
  );
  final client = _client(defaultApi);

  await client.pinMessage('message-id', timeoutOrExpirationDate: timeoutOrExpirationDate);

  final captured = verify(
    () => defaultApi.updateMessagePartial(
      id: 'message-id',
      updateMessagePartialRequest: captureAny(named: 'updateMessagePartialRequest'),
    ),
  ).captured;
  return (captured.single as api.UpdateMessagePartialRequest).set!;
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
