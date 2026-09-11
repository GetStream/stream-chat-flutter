import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/retry_queue.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

class _MockClient extends Mock implements StreamChatClient {
  @override
  Stream<Event> on([
    String? eventType,
    String? eventType2,
    String? eventType3,
    String? eventType4,
  ]) => const Stream.empty();
}

class _MockChannel extends Mock implements Channel {
  final _client = _MockClient();

  @override
  StreamChatClient get client => _client;
}

class _MockLogger extends Mock implements Logger {
  @override
  Level get level => Level.ALL;
}

void main() {
  // Built per test: the logger assertions below count interactions, so sharing
  // the doubles would make them depend on the order the tests run in.
  late _MockChannel channel;
  late _MockLogger logger;
  late RetryQueue retryQueue;

  setUp(() {
    channel = _MockChannel();
    logger = _MockLogger();

    final retryPolicy = RetryPolicy(
      shouldRetry: (_, __, error) {
        return error is StreamChatNetworkError && error.isRetriable;
      },
    );
    when(() => channel.client.retryPolicy).thenReturn(retryPolicy);

    retryQueue = RetryQueue(channel: channel, logger: logger);
  });

  tearDown(() {
    retryQueue.dispose();
  });

  group('`.add`', () {
    test('should return if message list is empty', () {
      expect(() => retryQueue.add([]), returnsNormally);
      verifyNever(() => logger.info(any()));
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
      verify(() => logger.info('Adding 1 messages to the queue')).called(1);
    });

    // The queue consults the retry policy through `retryIf` whenever an
    // attempt fails with a `StreamChatError`; a policy that declines has to
    // end the retrying rather than back off and try again.
    //
    // `createdAt` is explicit on purpose. `Message.createdAt` falls back to
    // `DateTime.now()` on every read when neither timestamp is set, which
    // makes the queue's date comparator non-reflexive — the message then
    // cannot be located for removal and gets retried an arbitrary number of
    // times.
    test('should stop retrying when the policy declines the error', () async {
      final message = Message(
        id: 'test-message-id',
        text: 'Sample message test',
        createdAt: DateTime.utc(2021),
        state: MessageState.sendingFailed(
          skipPush: false,
          skipEnrichUrl: false,
        ),
      );

      // Non-retriable: a network error that carries response data.
      final error = StreamChatNetworkError(
        ChatErrorCode.internalSystemError,
        statusCode: 500,
        data: ErrorResponse()
          ..code = ChatErrorCode.internalSystemError.code
          ..message = ChatErrorCode.internalSystemError.message
          ..statusCode = 500,
      );
      expect(error.isRetriable, isFalse);

      when(() => channel.retryMessage(message)).thenAnswer((_) => Future.error(error));

      retryQueue.add([message]);
      await pumpEventQueue();

      verify(() => channel.retryMessage(message)).called(1);
      expect(retryQueue.hasMessages, isFalse);
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
}
