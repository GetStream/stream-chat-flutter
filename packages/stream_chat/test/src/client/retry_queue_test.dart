import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/retry_queue.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  late final channel = MockRetryQueueChannel();
  late final logger = MockLogger();
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
