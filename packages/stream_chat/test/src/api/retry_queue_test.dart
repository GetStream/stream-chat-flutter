import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/retry_policy.dart';
import 'package:stream_chat/src/client/retry_queue.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  late final channel = MockRetryQueueChannel();
  late final logger = MockLogger();
  late RetryQueue retryQueue;

  setUpAll(() {
    final retryPolicy = RetryPolicy(
      shouldRetry: (_, attempt, __) => attempt < 5,
      retryTimeout: (_, attempt, __) => Duration(seconds: attempt),
    );
    when(() => channel.client.retryPolicy).thenReturn(retryPolicy);

    when(() => channel.client.on(EventType.connectionRecovered)).thenAnswer(
      (_) => Stream.value(Event(
        type: EventType.connectionRecovered,
        online: false,
      )),
    );

    when(() => channel.on(any(), any(), any(), any())).thenAnswer(
      (_) => Stream.value(
        Event(type: EventType.any),
      ),
    );
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

    test('should return if queue already contains the message', () {
      final message = Message(
        id: 'test-message-id',
        text: 'Sample message test',
      );
      retryQueue.add([message]);
      expect(() => retryQueue.add([message]), returnsNormally);
      // Called only for the first message
      verify(() => logger.info('Adding 1 messages')).called(1);
    });

    test('`.add` should add failed request to the queue', () async {
      final message = Message(
        id: 'test-message-id',
        text: 'Sample message test',
      );
      retryQueue.add([message]);
      expect(retryQueue.hasMessages, isTrue);
    });
  });

  // TODO: Add more tests once macbook is fixed :(
}
