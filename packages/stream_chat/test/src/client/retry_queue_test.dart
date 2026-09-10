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
  late final channel = _MockChannel();
  late final logger = _MockLogger();
  late RetryQueue retryQueue;

  setUpAll(() {
    final retryPolicy = RetryPolicy(
      shouldRetry: (_, __, error) {
        return error is StreamChatNetworkError && error.isRetriable;
      },
    );
    when(() => channel.client.retryPolicy).thenReturn(retryPolicy);
  });

  setUp(() {
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
