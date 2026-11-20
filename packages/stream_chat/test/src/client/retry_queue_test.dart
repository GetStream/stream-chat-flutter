import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/retry_queue.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  late final channel = MockRetryQueueChannel();
  late RetryQueue retryQueue;
  late List<StreamLogRecord> records;

  setUpAll(() {
    final retryPolicy = RetryPolicy(
      shouldRetry: (_, __, error) => error?.isRetriable ?? false,
    );
    when(() => channel.client.retryPolicy).thenReturn(retryPolicy);
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
}

class _CapturingHandler extends StreamLogHandler {
  const _CapturingHandler(this._onRecord);

  final void Function(StreamLogRecord) _onRecord;

  @override
  void handle(StreamLogRecord record) => _onRecord(record);
}
