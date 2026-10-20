import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/retry_queue.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  late final channel = MockRetryQueueChannel();
  late RetryQueue retryQueue;
  late List<StreamLogRecord> records;

  setUpAll(() {
    final retryPolicy = RetryPolicy(
      shouldRetry: (_, __, error) => error?.isRetriable ?? false,
    );
    when(() => channel.client.retryPolicy).thenReturn(retryPolicy);

    registerFallbackValue(FakeMessage());
    // Every retry succeeds, so a queued message leaves the queue after its
    // first attempt.
    when(() => channel.retryMessage(any())).thenAnswer(
      (invocation) async => Result.success(
        SendMessageResponse(duration: '0.01ms', message: invocation.positionalArguments.first as Message),
      ),
    );
  });

  setUp(() {
    // The queue owns its logger, so what it reports is observed through the
    // handler rather than through an injected mock.
    records = [];
    StreamLogger.handler = _CapturingHandler(records.add);
    StreamLogger.priority = StreamLogPriority.verbose;
    retryQueue = RetryQueue(channel: channel);
  });

  tearDown(() {
    retryQueue.dispose();
    StreamLogger.reset();
  });

  group('`.add`', () {
    test('should return if message list is empty', () {
      expect(() => retryQueue.add([]), returnsNormally);
      expect(records, isEmpty);
    });

    test('should throw if message state is not failed', () {
      final message = Message(
        id: 'test-message-id',
        text: 'Sample message test',
        state: MessageState.sent,
      );
      expect(() => retryQueue.add([message]), throwsA(isA<AssertionError>()));
    });

    test('should return if queue already contains the message', () {
      final message = Message(
        id: 'test-message-id',
        text: 'Sample message test',
        state: MessageState.sendingFailed(
          skipPush: false,
          skipEnrichUrl: false,
        ),
      );
      retryQueue.add([message]);
      expect(() => retryQueue.add([message]), returnsNormally);
      // Called only for the first message
      expect(records.where((it) => it.message == 'Adding 1 messages to the queue'), hasLength(1));
    });

    test('`.add` should add failed request to the queue', () async {
      final message = Message(
        id: 'test-message-id',
        text: 'Sample message test',
        state: MessageState.sendingFailed(
          skipPush: false,
          skipEnrichUrl: false,
        ),
      );
      retryQueue.add([message]);
      expect(retryQueue.hasMessages, isTrue);
    });
  });

  test('RetryQueue gives up on a retriable failure after the maximum number of attempts', () async {
    final channel = _channelThatRetries(shouldRetry: true);
    final state = channel.state!;
    final message = _failedMessage();
    when(() => channel.retryMessage(message)).thenAnswer((_) async => Result.failure(apiException(statusCode: 500)));

    _retryQueue(channel).add([message]);
    await pumpEventQueue();

    verify(() => channel.retryMessage(message)).called(3);
    verify(() => state.updateMessage(message)).called(1);
  });

  test('RetryQueue stops retrying a message once a retry succeeds', () async {
    final channel = _channelThatRetries(shouldRetry: true);
    final state = channel.state!;
    final message = _failedMessage();
    final results = <Result<Object>>[
      Result.failure(apiException(statusCode: 500)),
      Result.success(SendMessageResponse(duration: '0.01ms', message: message)),
    ];
    when(() => channel.retryMessage(message)).thenAnswer((_) async => results.removeAt(0));

    _retryQueue(channel).add([message]);
    await pumpEventQueue();

    verify(() => channel.retryMessage(message)).called(2);
    verifyNever(() => state.updateMessage(any()));
  });

  test('RetryQueue gives up on a failure the retry policy declines to retry', () async {
    final channel = _channelThatRetries(shouldRetry: false);
    final state = channel.state!;
    final message = _failedMessage();
    when(() => channel.retryMessage(message)).thenAnswer((_) async => Result.failure(apiException(statusCode: 500)));

    _retryQueue(channel).add([message]);
    await pumpEventQueue();

    verify(() => channel.retryMessage(message)).called(1);
    verify(() => state.updateMessage(message)).called(1);
  });

  test('RetryQueue gives up on a failure that is not a StreamChatException', () async {
    final channel = _channelThatRetries(shouldRetry: true);
    final state = channel.state!;
    final message = _failedMessage();
    when(() => channel.retryMessage(message)).thenAnswer((_) async => Result.failure(StateError('x')));

    _retryQueue(channel).add([message]);
    await pumpEventQueue();

    verify(() => channel.retryMessage(message)).called(1);
    verify(() => state.updateMessage(message)).called(1);
  });

  test('RetryQueue gives up on a message whose retry throws', () async {
    final channel = _channelThatRetries(shouldRetry: true);
    final state = channel.state!;
    final message = _failedMessage();
    when(() => channel.retryMessage(message)).thenThrow(StateError('x'));
    final queue = _retryQueue(channel)..add([message]);
    await pumpEventQueue();

    verify(() => state.updateMessage(message)).called(1);
    expect(queue.hasMessages, isFalse);
  });
}

// A channel with its own state whose client retries up to three attempts
// without waiting between them, as long as [shouldRetry] allows it.
MockRetryQueueChannel _channelThatRetries({required bool shouldRetry}) {
  final channel = MockRetryQueueChannel();
  final retryPolicy = RetryPolicy(
    shouldRetry: (_, __, ___) => shouldRetry,
    delayFactor: Duration.zero,
    maxRetryAttempts: 3,
  );
  when(() => channel.client.retryPolicy).thenReturn(retryPolicy);
  final state = _MockChannelClientState();
  when(() => channel.state).thenReturn(state);
  return channel;
}

RetryQueue _retryQueue(Channel channel) {
  final queue = RetryQueue(channel: channel);
  addTearDown(queue.dispose);
  return queue;
}

// A message whose send failed. It carries the local creation time a real
// send stamps, which the queue orders its messages by.
Message _failedMessage() => Message(
  id: 'failed-message-id',
  text: 'Sample message test',
  localCreatedAt: DateTime.utc(2026),
  state: MessageState.sendingFailed(skipPush: false, skipEnrichUrl: false),
);

class _MockChannelClientState extends Mock implements ChannelClientState {}

class _CapturingHandler extends StreamLogHandler {
  const _CapturingHandler(this._onRecord);

  final void Function(StreamLogRecord) _onRecord;

  @override
  void handle(StreamLogRecord record) => _onRecord(record);
}
