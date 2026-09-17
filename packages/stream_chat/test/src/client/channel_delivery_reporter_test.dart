import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

import '../utils.dart';

void main() {
  group('ChannelDeliveryReporter', () {
    late List<MessageDelivery> capturedDeliveries;
    late ChannelDeliveryReporter reporter;

    setUp(() {
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
      chatClientTest(
        'should submit channels with valid messages',
        body: (tester) async {
          final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
          final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));

          final channel1 = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message1,
          );

          final channel2 = _createDeliverableChannel(
            tester.client,
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
        },
      );

      chatClientTest(
        'should skip channels without cid',
        body: (tester) async {
          final channel = Channel(tester.client, 'test-type', null);

          await reporter.submitForDelivery([channel]);
          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should skip channels without last message',
        body: (tester) async {
          final channel = _createChannel(tester.client, cid: 'test:channel-1');

          await reporter.submitForDelivery([channel]);
          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should skip channels without delivery capability',
        body: (tester) async {
          final channel = _createChannelWithoutCapability(
            tester.client,
            cid: 'test:channel-1',
          );

          await reporter.submitForDelivery([channel]);
          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should skip messages from current user',
        body: (tester) async {
          final channel = _createChannelWithOwnMessage(
            tester.client,
            cid: 'test:channel-1',
          );

          await reporter.submitForDelivery([channel]);
          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should skip messages that are already read',
        body: (tester) async {
          final message = _createMessage(
            (m) => m.copyWith(
              id: 'message-1',
              createdAt: DateTime(2023),
            ),
          );

          final channel = _createChannel(
            tester.client,
            cid: 'test:channel-1',
            lastMessage: message,
            currentUserRead: _createCurrentUserRead(
              tester.client,
              lastRead: DateTime(2023, 1, 2),
              lastReadMessageId: message.id,
            ),
          );

          await reporter.submitForDelivery([channel]);
          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should skip messages that are already delivered',
        body: (tester) async {
          final message = _createMessage(
            (m) => m.copyWith(
              id: 'message-1',
              createdAt: DateTime(2023),
            ),
          );

          final channel = _createChannel(
            tester.client,
            cid: 'test:channel-1',
            lastMessage: message,
            currentUserRead: _createCurrentUserRead(
              tester.client,
              lastDeliveredAt: DateTime(2023, 1, 2),
              lastDeliveredMessageId: message.id,
            ),
          );

          await reporter.submitForDelivery([channel]);
          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should update existing candidates with newer messages',
        body: (tester) async {
          final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
          final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));

          final channel1 = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message1,
          );
          await reporter.submitForDelivery([channel1]);

          final channel1Updated = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message2,
          );
          await reporter.submitForDelivery([channel1Updated]);

          await delay(150);

          expect(capturedDeliveries, hasLength(1));
          expect(capturedDeliveries.first.channelCid, 'test:channel-1');
          expect(capturedDeliveries.first.messageId, 'message-2');
        },
      );

      chatClientTest(
        'should throttle multiple submit calls',
        body: (tester) async {
          final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
          final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));
          final message3 = _createMessage((m) => m.copyWith(id: 'message-3'));

          final channel1 = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message1,
          );
          final channel2 = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-2',
            message: message2,
          );
          final channel3 = _createDeliverableChannel(
            tester.client,
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
        },
      );
    });

    group('reconcileDelivery', () {
      chatClientTest(
        'should remove candidates that are now read',
        body: (tester) async {
          final message = _createMessage(
            (m) => m.copyWith(
              id: 'message-1',
              createdAt: DateTime(2023),
            ),
          );

          final channel = _createChannel(
            tester.client,
            cid: 'test:channel-1',
            lastMessage: message,
          );
          await reporter.submitForDelivery([channel]);

          final channelRead = _createChannel(
            tester.client,
            cid: 'test:channel-1',
            lastMessage: message,
            currentUserRead: _createCurrentUserRead(
              tester.client,
              lastRead: DateTime(2023, 1, 2),
              lastReadMessageId: message.id,
            ),
          );
          await reporter.reconcileDelivery([channelRead]);

          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should remove candidates that are now delivered',
        body: (tester) async {
          final message = _createMessage(
            (m) => m.copyWith(
              id: 'message-1',
              createdAt: DateTime(2023),
            ),
          );

          final channel = _createChannel(
            tester.client,
            cid: 'test:channel-1',
            lastMessage: message,
          );
          await reporter.submitForDelivery([channel]);

          final channelDelivered = _createChannel(
            tester.client,
            cid: 'test:channel-1',
            lastMessage: message,
            currentUserRead: _createCurrentUserRead(
              tester.client,
              lastDeliveredAt: DateTime(2023, 1, 2),
              lastDeliveredMessageId: message.id,
            ),
          );
          await reporter.reconcileDelivery([channelDelivered]);

          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should keep candidates that still need delivery',
        body: (tester) async {
          final message = _createMessage((m) => m.copyWith(id: 'message-1'));
          final channel = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message,
          );

          await reporter.submitForDelivery([channel]);
          await reporter.reconcileDelivery([channel]);

          await delay(150);

          expect(capturedDeliveries, hasLength(1));
          expect(capturedDeliveries.first.messageId, 'message-1');
        },
      );

      chatClientTest(
        'should handle channels not in candidates',
        body: (tester) async {
          final message = _createMessage((m) => m.copyWith(id: 'message-1'));
          final channel = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message,
          );

          await reporter.reconcileDelivery([channel]);
          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should handle channels without cid',
        body: (tester) async {
          final channel = Channel(tester.client, 'test-type', null);

          await reporter.reconcileDelivery([channel]);
          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );
    });

    group('cancelDelivery', () {
      chatClientTest(
        'should remove channels from candidates',
        body: (tester) async {
          final message = _createMessage((m) => m.copyWith(id: 'message-1'));
          final channel = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message,
          );

          await reporter.submitForDelivery([channel]);
          await reporter.cancelDelivery(['test:channel-1']);

          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should handle channels not in candidates',
        body: (tester) async {
          await reporter.cancelDelivery(['test:channel-1']);
          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should cancel specific channels only',
        body: (tester) async {
          final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
          final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));

          final channel1 = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message1,
          );
          final channel2 = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-2',
            message: message2,
          );

          await reporter.submitForDelivery([channel1, channel2]);
          await reporter.cancelDelivery(['test:channel-1']);

          await delay(150);

          expect(capturedDeliveries, hasLength(1));
          expect(capturedDeliveries.first.channelCid, 'test:channel-2');
        },
      );
    });

    group('Batching and throttling', () {
      chatClientTest(
        'should batch deliveries with max 100 channels',
        body: (tester) async {
          final channels = List.generate(
            150,
            (index) {
              final message = _createMessage(
                (m) => m.copyWith(id: 'message-$index'),
              );
              return _createDeliverableChannel(
                tester.client,
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
        },
      );

      chatClientTest(
        'should only deliver latest message when updated before throttle',
        body: (tester) async {
          final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
          final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));

          final channel1 = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message1,
          );
          await reporter.submitForDelivery([channel1]);

          final channel1Updated = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message2,
          );
          await reporter.submitForDelivery([channel1Updated]);

          await delay(150);

          expect(capturedDeliveries, hasLength(1));
          expect(capturedDeliveries[0].messageId, 'message-2');
        },
      );

      chatClientTest(
        'should handle delivery errors gracefully',
        body: (tester) async {
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
              tester.client,
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
        },
      );
    });

    group('cancel', () {
      chatClientTest(
        'should clear all candidates',
        body: (tester) async {
          final message1 = _createMessage((m) => m.copyWith(id: 'message-1'));
          final message2 = _createMessage((m) => m.copyWith(id: 'message-2'));

          final channel1 = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message1,
          );
          final channel2 = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-2',
            message: message2,
          );

          await reporter.submitForDelivery([channel1, channel2]);

          reporter.cancel();

          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );

      chatClientTest(
        'should cancel pending throttled calls',
        body: (tester) async {
          final message = _createMessage((m) => m.copyWith(id: 'message-1'));
          final channel = _createDeliverableChannel(
            tester.client,
            cid: 'test:channel-1',
            message: message,
          );

          await reporter.submitForDelivery([channel]);

          reporter.cancel();

          await delay(150);

          expect(capturedDeliveries, isEmpty);
        },
      );
    });
  });
}

// region Test Helpers

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
