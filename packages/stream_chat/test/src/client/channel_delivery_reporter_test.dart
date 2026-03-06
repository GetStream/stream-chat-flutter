import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  group('ChannelDeliveryReporter', () {
    late StreamChatClient client;
    late List<MessageDelivery> capturedDeliveries;
    late ChannelDeliveryReporter reporter;

    setUpAll(() {
      registerFallbackValue(
        const MessageDelivery(
          channelCid: 'test:test',
          messageId: 'test-message-id',
        ),
      );
    });

    setUp(() {
      client = _createMockClient();
      capturedDeliveries = [];
      reporter = ChannelDeliveryReporter(
        throttleDuration: const Duration(milliseconds: 100),
        onMarkChannelsDelivered: (deliveries) async {
          capturedDeliveries.addAll(deliveries);
        },
      );
    });

    tearDown(() {
      reporter.cancel();
    });

    group('submitForDelivery', () {
      test('should submit channels with valid messages', () async {
        final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
        final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));

        final channel1 = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message1,
        );

        final channel2 = _createDeliverableChannel(
          client,
          cid: 'test:channel-2',
          message: message2,
        );

        await reporter.submitForDelivery([channel1, channel2]);
        await delay(150);

        expect(capturedDeliveries, hasLength(2));
        expect(
          capturedDeliveries.any(
            (d) => d.channelCid == 'test:channel-1' && d.messageId == 'message-1',
          ),
          isTrue,
        );
        expect(
          capturedDeliveries.any(
            (d) => d.channelCid == 'test:channel-2' && d.messageId == 'message-2',
          ),
          isTrue,
        );
      });

      test('should skip channels without cid', () async {
        final channel = Channel(client, 'test-type', null);

        await reporter.submitForDelivery([channel]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should skip channels without last message', () async {
        final channel = _createChannel(client, cid: 'test:channel-1');

        await reporter.submitForDelivery([channel]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should skip channels without delivery capability', () async {
        final channel = _createChannelWithoutCapability(
          client,
          cid: 'test:channel-1',
        );

        await reporter.submitForDelivery([channel]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should skip messages from current user', () async {
        final channel = _createChannelWithOwnMessage(
          client,
          cid: 'test:channel-1',
        );

        await reporter.submitForDelivery([channel]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should skip messages that are already read', () async {
        final message = _createMessage(
          (m) => m.copyWith(
            id: 'message-1',
            createdAt: DateTime(2023),
          ),
        );

        final channel = _createChannel(
          client,
          cid: 'test:channel-1',
          lastMessage: message,
          currentUserRead: _createCurrentUserRead(
            client,
            lastRead: DateTime(2023, 1, 2),
            lastReadMessageId: message.id,
          ),
        );

        await reporter.submitForDelivery([channel]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should skip messages that are already delivered', () async {
        final message = _createMessage(
          (m) => m.copyWith(
            id: 'message-1',
            createdAt: DateTime(2023),
          ),
        );

        final channel = _createChannel(
          client,
          cid: 'test:channel-1',
          lastMessage: message,
          currentUserRead: _createCurrentUserRead(
            client,
            lastDeliveredAt: DateTime(2023, 1, 2),
            lastDeliveredMessageId: message.id,
          ),
        );

        await reporter.submitForDelivery([channel]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should update existing candidates with newer messages', () async {
        final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
        final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));

        final channel1 = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message1,
        );
        await reporter.submitForDelivery([channel1]);

        final channel1Updated = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message2,
        );
        await reporter.submitForDelivery([channel1Updated]);

        await delay(150);

        expect(capturedDeliveries, hasLength(1));
        expect(capturedDeliveries.first.channelCid, 'test:channel-1');
        expect(capturedDeliveries.first.messageId, 'message-2');
      });

      test('should throttle multiple submit calls', () async {
        final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
        final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));
        final message3 = _createMessage((m) => m.copyWith(id: 'message-3'));

        final channel1 = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message1,
        );
        final channel2 = _createDeliverableChannel(
          client,
          cid: 'test:channel-2',
          message: message2,
        );
        final channel3 = _createDeliverableChannel(
          client,
          cid: 'test:channel-3',
          message: message3,
        );

        // Submit 3 different channels in quick succession
        await reporter.submitForDelivery([channel1]);
        await reporter.submitForDelivery([channel2]);
        await reporter.submitForDelivery([channel3]);

        // All 3 should be batched into a single delivery call due to throttling
        await delay(150);

        expect(capturedDeliveries, hasLength(3));
      });
    });

    group('reconcileDelivery', () {
      test('should remove candidates that are now read', () async {
        final message = _createMessage(
          (m) => m.copyWith(
            id: 'message-1',
            createdAt: DateTime(2023),
          ),
        );

        final channel = _createChannel(
          client,
          cid: 'test:channel-1',
          lastMessage: message,
        );
        await reporter.submitForDelivery([channel]);

        final channelRead = _createChannel(
          client,
          cid: 'test:channel-1',
          lastMessage: message,
          currentUserRead: _createCurrentUserRead(
            client,
            lastRead: DateTime(2023, 1, 2),
            lastReadMessageId: message.id,
          ),
        );
        await reporter.reconcileDelivery([channelRead]);

        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should remove candidates that are now delivered', () async {
        final message = _createMessage(
          (m) => m.copyWith(
            id: 'message-1',
            createdAt: DateTime(2023),
          ),
        );

        final channel = _createChannel(
          client,
          cid: 'test:channel-1',
          lastMessage: message,
        );
        await reporter.submitForDelivery([channel]);

        final channelDelivered = _createChannel(
          client,
          cid: 'test:channel-1',
          lastMessage: message,
          currentUserRead: _createCurrentUserRead(
            client,
            lastDeliveredAt: DateTime(2023, 1, 2),
            lastDeliveredMessageId: message.id,
          ),
        );
        await reporter.reconcileDelivery([channelDelivered]);

        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should keep candidates that still need delivery', () async {
        final message = _createMessage((m) => m.copyWith(id: 'message-1'));
        final channel = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message,
        );

        await reporter.submitForDelivery([channel]);
        await reporter.reconcileDelivery([channel]);

        await delay(150);

        expect(capturedDeliveries, hasLength(1));
        expect(capturedDeliveries.first.messageId, 'message-1');
      });

      test('should handle channels not in candidates', () async {
        final message = _createMessage((m) => m.copyWith(id: 'message-1'));
        final channel = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message,
        );

        await reporter.reconcileDelivery([channel]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should handle channels without cid', () async {
        final channel = Channel(client, 'test-type', null);

        await reporter.reconcileDelivery([channel]);
      });
    });

    group('cancelDelivery', () {
      test('should remove channels from candidates', () async {
        final message = _createMessage((m) => m.copyWith(id: 'message-1'));
        final channel = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message,
        );

        await reporter.submitForDelivery([channel]);
        await reporter.cancelDelivery(['test:channel-1']);

        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should handle channels not in candidates', () async {
        await reporter.cancelDelivery(['test:channel-1']);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should cancel specific channels only', () async {
        final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
        final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));

        final channel1 = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message1,
        );
        final channel2 = _createDeliverableChannel(
          client,
          cid: 'test:channel-2',
          message: message2,
        );

        await reporter.submitForDelivery([channel1, channel2]);
        await reporter.cancelDelivery(['test:channel-1']);

        await delay(150);

        expect(capturedDeliveries, hasLength(1));
        expect(capturedDeliveries.first.channelCid, 'test:channel-2');
      });
    });

    group('Batching and throttling', () {
      test('should batch deliveries with max 100 channels', () async {
        final channels = List.generate(
          150,
          (index) {
            final message = _createMessage(
              (m) => m.copyWith(id: 'message-$index'),
            );
            return _createDeliverableChannel(
              client,
              cid: 'test:channel-$index',
              message: message,
            );
          },
        );

        await reporter.submitForDelivery(channels);
        await delay(150);

        expect(capturedDeliveries, hasLength(100));

        await delay(150);

        expect(capturedDeliveries, hasLength(150));
      });

      test(
        'should only deliver latest message when updated before throttle',
        () async {
          final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
          final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));

          final channel1 = _createDeliverableChannel(
            client,
            cid: 'test:channel-1',
            message: message1,
          );
          await reporter.submitForDelivery([channel1]);

          final channel1Updated = _createDeliverableChannel(
            client,
            cid: 'test:channel-1',
            message: message2,
          );
          await reporter.submitForDelivery([channel1Updated]);

          await delay(150);

          expect(capturedDeliveries, hasLength(1));
          expect(capturedDeliveries[0].messageId, 'message-2');
        },
      );

      test('should handle delivery errors gracefully', () async {
        var shouldFail = true;
        final errorReporter = ChannelDeliveryReporter(
          throttleDuration: const Duration(milliseconds: 50),
          onMarkChannelsDelivered: (deliveries) async {
            if (shouldFail) {
              shouldFail = false;
              throw Exception('Network error');
            }
            capturedDeliveries.addAll(deliveries);
          },
        );

        try {
          final message = _createMessage((m) => m.copyWith(id: 'message-1'));
          final channel = _createDeliverableChannel(
            client,
            cid: 'test:channel-1',
            message: message,
          );

          await errorReporter.submitForDelivery([channel]);
          await delay(100);

          expect(capturedDeliveries, isEmpty);

          await errorReporter.submitForDelivery([channel]);
          await delay(100);

          expect(capturedDeliveries, hasLength(1));
        } finally {
          errorReporter.cancel();
        }
      });
    });

    group('cancel', () {
      test('should clear all candidates', () async {
        final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
        final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));

        final channel1 = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message1,
        );
        final channel2 = _createDeliverableChannel(
          client,
          cid: 'test:channel-2',
          message: message2,
        );

        await reporter.submitForDelivery([channel1, channel2]);

        reporter.cancel();

        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should cancel pending throttled calls', () async {
        final message = _createMessage((m) => m.copyWith(id: 'message-1'));
        final channel = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message,
        );

        await reporter.submitForDelivery([channel]);

        reporter.cancel();

        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should be safe to call multiple times', () {
        reporter.cancel();
        reporter.cancel();
        reporter.cancel();
        // Should not throw
      });
    });

    group('edge cases', () {
      test('should handle empty channel list in submitForDelivery', () async {
        await reporter.submitForDelivery([]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should handle empty channel list in reconcileDelivery', () async {
        await reporter.reconcileDelivery([]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should handle empty channel list in cancelDelivery', () async {
        await reporter.cancelDelivery([]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should handle channel with empty state', () async {
        final channel = Channel(client, 'test-type', 'test-id');
        await reporter.submitForDelivery([channel]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should handle concurrent submitForDelivery calls', () async {
        final channels = List.generate(10, (i) {
          final message = _createMessage((m) => m.copyWith(id: 'message-$i'));
          return _createDeliverableChannel(
            client,
            cid: 'test:channel-$i',
            message: message,
          );
        });

        // Submit concurrently
        await Future.wait([
          reporter.submitForDelivery(channels.sublist(0, 5)),
          reporter.submitForDelivery(channels.sublist(5, 10)),
        ]);

        await delay(150);

        expect(capturedDeliveries, hasLength(10));
      });

      test('should handle concurrent reconcileDelivery calls', () async {
        final message = _createMessage((m) => m.copyWith(id: 'message-1'));
        final channel = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message,
        );

        await reporter.submitForDelivery([channel]);

        // Reconcile concurrently
        await Future.wait([
          reporter.reconcileDelivery([channel]),
          reporter.reconcileDelivery([channel]),
        ]);

        await delay(150);

        expect(capturedDeliveries, hasLength(1));
      });

      test('should handle concurrent cancelDelivery calls', () async {
        final message = _createMessage((m) => m.copyWith(id: 'message-1'));
        final channel = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message,
        );

        await reporter.submitForDelivery([channel]);

        // Cancel concurrently
        await Future.wait([
          reporter.cancelDelivery(['test:channel-1']),
          reporter.cancelDelivery(['test:channel-1']),
        ]);

        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should preserve newer message when updated during delivery', () async {
        var deliveryCount = 0;
        final slowReporter = ChannelDeliveryReporter(
          throttleDuration: const Duration(milliseconds: 50),
          onMarkChannelsDelivered: (deliveries) async {
            deliveryCount++;
            if (deliveryCount == 1) {
              // Simulate slow network
              await Future.delayed(const Duration(milliseconds: 100));
            }
            capturedDeliveries.addAll(deliveries);
          },
        );

        try {
          final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
          final channel1 = _createDeliverableChannel(
            client,
            cid: 'test:channel-1',
            message: message1,
          );

          await slowReporter.submitForDelivery([channel1]);
          await delay(75);

          // Update with newer message while first delivery is in progress
          final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));
          final channel1Updated = _createDeliverableChannel(
            client,
            cid: 'test:channel-1',
            message: message2,
          );
          await slowReporter.submitForDelivery([channel1Updated]);

          await delay(200);

          // Should have both deliveries
          expect(deliveryCount, 2);
          expect(
            capturedDeliveries.any((d) => d.messageId == 'message-1'),
            isTrue,
          );
          expect(
            capturedDeliveries.any((d) => d.messageId == 'message-2'),
            isTrue,
          );
        } finally {
          slowReporter.cancel();
        }
      });

      test('should handle message without id', () async {
        final message = Message(
          text: 'Test message',
          user: User(id: 'other-user-id'),
          createdAt: DateTime.now(),
        );

        final channel = _createChannel(
          client,
          cid: 'test:channel-1',
          lastMessage: message,
        );

        await reporter.submitForDelivery([channel]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should handle very long throttle duration', () async {
        final longReporter = ChannelDeliveryReporter(
          throttleDuration: const Duration(seconds: 10),
          onMarkChannelsDelivered: (deliveries) async {
            capturedDeliveries.addAll(deliveries);
          },
        );

        try {
          final message = _createMessage((m) => m.copyWith(id: 'message-1'));
          final channel = _createDeliverableChannel(
            client,
            cid: 'test:channel-1',
            message: message,
          );

          await longReporter.submitForDelivery([channel]);
          await delay(100);

          // Should not have delivered yet
          expect(capturedDeliveries, isEmpty);

          longReporter.cancel();
        } finally {
          longReporter.cancel();
        }
      });

      test('should handle zero throttle duration', () async {
        final zeroReporter = ChannelDeliveryReporter(
          throttleDuration: Duration.zero,
          onMarkChannelsDelivered: (deliveries) async {
            capturedDeliveries.addAll(deliveries);
          },
        );

        try {
          final message = _createMessage((m) => m.copyWith(id: 'message-1'));
          final channel = _createDeliverableChannel(
            client,
            cid: 'test:channel-1',
            message: message,
          );

          await zeroReporter.submitForDelivery([channel]);
          await delay(50);

          expect(capturedDeliveries, hasLength(1));
        } finally {
          zeroReporter.cancel();
        }
      });

      test('should handle exactly 100 channels', () async {
        final channels = List.generate(100, (i) {
          final message = _createMessage((m) => m.copyWith(id: 'message-$i'));
          return _createDeliverableChannel(
            client,
            cid: 'test:channel-$i',
            message: message,
          );
        });

        await reporter.submitForDelivery(channels);
        await delay(150);

        expect(capturedDeliveries, hasLength(100));
      });

      test('should handle 101 channels in two batches', () async {
        final channels = List.generate(101, (i) {
          final message = _createMessage((m) => m.copyWith(id: 'message-$i'));
          return _createDeliverableChannel(
            client,
            cid: 'test:channel-$i',
            message: message,
          );
        });

        await reporter.submitForDelivery(channels);
        await delay(150);

        expect(capturedDeliveries, hasLength(100));

        await delay(150);

        expect(capturedDeliveries, hasLength(101));
      });

      test('should handle reporter with logger', () async {
        final loggedReporter = ChannelDeliveryReporter(
          logger: client.logger,
          throttleDuration: const Duration(milliseconds: 50),
          onMarkChannelsDelivered: (deliveries) async {
            capturedDeliveries.addAll(deliveries);
          },
        );

        try {
          final message = _createMessage((m) => m.copyWith(id: 'message-1'));
          final channel = _createDeliverableChannel(
            client,
            cid: 'test:channel-1',
            message: message,
          );

          await loggedReporter.submitForDelivery([channel]);
          await delay(100);

          expect(capturedDeliveries, hasLength(1));
        } finally {
          loggedReporter.cancel();
        }
      });

      test('should handle submitForDelivery after cancel', () async {
        final message = _createMessage((m) => m.copyWith(id: 'message-1'));
        final channel = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message,
        );

        await reporter.submitForDelivery([channel]);
        reporter.cancel();

        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should handle reconcileDelivery with channel that was never submitted', () async {
        final message = _createMessage((m) => m.copyWith(id: 'message-1'));
        final channel = _createDeliverableChannel(
          client,
          cid: 'test:channel-1',
          message: message,
        );

        // Reconcile without submitting first
        await reporter.reconcileDelivery([channel]);
        await delay(150);

        expect(capturedDeliveries, isEmpty);
      });

      test('should handle mixed valid and invalid channels', () async {
        final validMessage = _createMessage((m) => m.copyWith(id: 'valid'));
        final validChannel = _createDeliverableChannel(
          client,
          cid: 'test:valid',
          message: validMessage,
        );

        final invalidChannel = Channel(client, 'test-type', null);

        await reporter.submitForDelivery([validChannel, invalidChannel]);
        await delay(150);

        expect(capturedDeliveries, hasLength(1));
        expect(capturedDeliveries.first.messageId, 'valid');
      });
    });
  });
}

// region Test Helpers

Logger _createLogger(String name) {
  final logger = Logger.detached(name)..level = Level.ALL;
  logger.onRecord.listen(print);
  return logger;
}

StreamChatClient _createMockClient() {
  final client = MockStreamChatClient();
  final clientState = FakeClientState(
    currentUser: OwnUser(id: 'current-user-id'),
  );

  when(() => client.state).thenReturn(clientState);
  when(() => client.detachedLogger(any())).thenAnswer((invocation) {
    return _createLogger(invocation.positionalArguments.first as String);
  });
  when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
  when(() => client.retryPolicy).thenReturn(
    RetryPolicy(shouldRetry: (_, __, ___) => false),
  );

  return client;
}

Message _createMessage([Message Function(Message)? builder]) {
  final baseMessage = Message(
    id: 'default-id',
    text: 'Test message',
    user: User(id: 'other-user-id'),
    createdAt: DateTime.now(),
  );

  return builder?.call(baseMessage) ?? baseMessage;
}

Channel _createChannel(
  StreamChatClient client, {
  required String cid,
  Message? lastMessage,
  bool hasDeliveryCapability = true,
  Read? currentUserRead,
}) {
  final channelState = ChannelState(
    channel: ChannelModel(
      cid: cid,
      config: ChannelConfig(deliveryEvents: hasDeliveryCapability),
      ownCapabilities: [
        if (hasDeliveryCapability) ChannelCapability.deliveryEvents,
      ],
    ),
    messages: [if (lastMessage != null) lastMessage],
    read: [if (currentUserRead != null) currentUserRead],
  );

  return Channel.fromState(client, channelState);
}

Channel _createDeliverableChannel(
  StreamChatClient client, {
  required String cid,
  required Message message,
}) {
  return _createChannel(
    client,
    cid: cid,
    lastMessage: message,
  );
}

Channel _createChannelWithoutCapability(
  StreamChatClient client, {
  required String cid,
}) {
  return _createChannel(
    client,
    cid: cid,
    lastMessage: _createMessage(),
    hasDeliveryCapability: false,
  );
}

Channel _createChannelWithOwnMessage(
  StreamChatClient client, {
  required String cid,
}) {
  final currentUser = client.state.currentUser!;
  return _createChannel(
    client,
    cid: cid,
    lastMessage: _createMessage(
      (m) => m.copyWith(user: currentUser),
    ),
  );
}

Read _createCurrentUserRead(
  StreamChatClient client, {
  DateTime? lastRead,
  String? lastReadMessageId,
  DateTime? lastDeliveredAt,
  String? lastDeliveredMessageId,
  int? unreadMessages,
}) {
  final currentUser = client.state.currentUser!;
  return Read(
    user: currentUser,
    lastRead: lastRead ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    lastReadMessageId: lastReadMessageId,
    lastDeliveredAt: lastDeliveredAt,
    lastDeliveredMessageId: lastDeliveredMessageId,
    unreadMessages: unreadMessages,
  );
}

// endregion