// ignore_for_file: lines_longer_than_80_chars, cascade_invocations, deprecated_member_use_from_same_package, avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

void main() {
  group('Local unread count', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    final currentUser = OwnUser(id: 'current-user-id');

    late final client = MockStreamChatClient();

    setUpAll(() {
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(shouldRetry: (_, __, ___) => false, delayFactor: Duration.zero),
      );
      when(() => client.state).thenReturn(FakeClientState(currentUser: currentUser));
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
      when(
        () => client.channelDeliveryReporter.reconcileDelivery(any()),
      ).thenAnswer((_) async {});
      client.isLocalUnreadCountEnabled = true;
    });

    // A "livestream-like" channel: read events are disabled, both via the
    // channel-type config and the current user's own capabilities.
    Channel _createLivestreamChannel({
      StreamChatClient? overrideClient,
      List<Message>? messages,
      List<Read>? reads,
    }) {
      final channelState = ChannelState(
        channel: ChannelModel(
          id: channelId,
          type: channelType,
          config: ChannelConfig(readEvents: false),
          ownCapabilities: const [], // No readEvents capability.
        ),
        messages: messages,
        read: reads,
      );

      final channel = Channel.fromState(overrideClient ?? client, channelState);
      addTearDown(channel.dispose);
      return channel;
    }

    test(
      'increments unreadCount locally for new messages when the channel has '
      'no read events capability',
      () async {
        final channel = _createLivestreamChannel();
        expect(channel.state?.unreadCount, equals(0));

        final message = Message(
          id: 'message-1',
          text: 'Hello',
          user: User(id: 'other-user'),
          createdAt: DateTime(2024, 1, 1),
        );

        client.addEvent(
          Event(cid: channel.cid, type: EventType.messageNew, message: message),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state?.unreadCount, equals(1));
      },
    );

    test(
      'does not increment unreadCount when local unread count tracking is '
      'disabled',
      () async {
        final disabledClient = MockStreamChatClient();
        when(() => disabledClient.detachedLogger(any())).thenAnswer((invocation) {
          final name = invocation.positionalArguments.first;
          return _createLogger(name);
        });
        when(() => disabledClient.retryPolicy).thenReturn(
          RetryPolicy(shouldRetry: (_, __, ___) => false),
        );
        when(() => disabledClient.state).thenReturn(FakeClientState(currentUser: currentUser));
        when(() => disabledClient.logger).thenReturn(_createLogger('mock-client-logger'));
        when(
          () => disabledClient.channelDeliveryReporter.submitForDelivery(any()),
        ).thenAnswer((_) async {});
        // `isLocalUnreadCountEnabled` defaults to `false` on the mock.

        final channel = _createLivestreamChannel(overrideClient: disabledClient);

        final message = Message(
          id: 'message-1',
          text: 'Hello',
          user: User(id: 'other-user'),
          createdAt: DateTime(2024, 1, 1),
        );

        disabledClient.addEvent(
          Event(cid: channel.cid, type: EventType.messageNew, message: message),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state?.unreadCount, equals(0));
      },
    );

    test('decrements unreadCount when a counted message is hard-deleted', () async {
      final message = Message(
        id: 'message-1',
        text: 'Hello',
        user: User(id: 'other-user'),
        createdAt: DateTime(2024, 1, 1),
      );
      final channel = _createLivestreamChannel(
        messages: [message],
        reads: [
          Read(
            user: currentUser,
            lastRead: message.createdAt.subtract(const Duration(days: 1)),
          ),
        ],
      );
      channel.state!.unreadCount = 1;
      expect(channel.state?.unreadCount, equals(1));

      client.addEvent(
        Event(
          cid: channel.cid,
          type: EventType.messageDeleted,
          message: message,
          hardDelete: true,
        ),
      );
      await Future.delayed(Duration.zero);

      expect(channel.state?.unreadCount, equals(0));
    });

    test('does not decrement unreadCount when a message is soft-deleted', () async {
      final message = Message(
        id: 'message-1',
        text: 'Hello',
        user: User(id: 'other-user'),
        createdAt: DateTime(2024, 1, 1),
      );
      final channel = _createLivestreamChannel(
        messages: [message],
        reads: [
          Read(
            user: currentUser,
            lastRead: message.createdAt.subtract(const Duration(days: 1)),
          ),
        ],
      );
      channel.state!.unreadCount = 1;

      client.addEvent(
        Event(
          cid: channel.cid,
          type: EventType.messageDeleted,
          message: message,
          hardDelete: false,
        ),
      );
      await Future.delayed(Duration.zero);

      expect(channel.state?.unreadCount, equals(1));
    });

    test(
      'markRead resets unreadCount locally without making a network request',
      () async {
        final channel = _createLivestreamChannel();
        channel.state!.unreadCount = 3;
        expect(channel.state?.unreadCount, equals(3));

        await expectLater(channel.markRead(), completes);

        expect(channel.state?.unreadCount, equals(0));
        verifyNever(
          () => client.markChannelRead(
            any(),
            any(),
            messageId: any(named: 'messageId'),
          ),
        );
      },
    );

    test(
      'markUnreadByTimestamp recomputes unreadCount locally without making a '
      'network request',
      () async {
        final now = DateTime(2024, 1, 1);
        final messages = [
          Message(
            id: 'm1',
            text: '1',
            user: User(id: 'other-user'),
            createdAt: now,
          ),
          Message(
            id: 'm2',
            text: '2',
            user: User(id: 'other-user'),
            createdAt: now.add(const Duration(minutes: 1)),
          ),
          Message(
            id: 'm3',
            text: '3',
            user: User(id: 'other-user'),
            createdAt: now.add(const Duration(minutes: 2)),
          ),
        ];
        final channel = _createLivestreamChannel(
          messages: messages,
          reads: [
            Read(user: currentUser, lastRead: now.add(const Duration(minutes: 5))),
          ],
        );
        expect(channel.state?.unreadCount, equals(0));

        await expectLater(
          channel.markUnreadByTimestamp(now.add(const Duration(seconds: 30))),
          completes,
        );

        // Only m2 and m3 were created after the given timestamp.
        expect(channel.state?.unreadCount, equals(2));
        verifyNever(
          () => client.markChannelUnreadByTimestamp(any(), any(), any()),
        );
      },
    );

    test(
      'markUnread throws when the message is not locally known',
      () async {
        final channel = _createLivestreamChannel();

        await expectLater(
          channel.markUnread('unknown-message-id'),
          throwsA(isA<StreamChatError>()),
        );
        verifyNever(
          () => client.markChannelUnread(any(), any(), any()),
        );
      },
    );

    test(
      'markRead reconciles pending delivery receipts',
      () async {
        final channel = _createLivestreamChannel();
        channel.state!.unreadCount = 2;

        await expectLater(channel.markRead(), completes);

        verify(
          () => client.channelDeliveryReporter.reconcileDelivery([channel]),
        ).called(1);
      },
    );

    group('local read boundary anchors', () {
      final start = DateTime(2024, 1, 1);
      final messages = [
        Message(
          id: 'm1',
          text: '1',
          user: User(id: 'other-user'),
          createdAt: start,
        ),
        Message(
          id: 'm2',
          text: '2',
          user: User(id: 'other-user'),
          createdAt: start.add(const Duration(minutes: 1)),
        ),
        Message(
          id: 'm3',
          text: '3',
          user: User(id: 'other-user'),
          createdAt: start.add(const Duration(minutes: 2)),
        ),
      ];

      test(
        'markUnread is inclusive of the anchor and points lastReadMessageId at '
        'the previous message',
        () async {
          final channel = _createLivestreamChannel(
            messages: messages,
            reads: [
              Read(user: currentUser, lastRead: start.add(const Duration(minutes: 5))),
            ],
          );

          await expectLater(channel.markUnread('m2'), completes);

          // m2 (the anchor) and m3 are unread; m1 stays read.
          expect(channel.state?.unreadCount, equals(2));
          expect(channel.state?.currentUserRead?.lastReadMessageId, equals('m1'));
          verifyNever(() => client.markChannelUnread(any(), any(), any()));
        },
      );

      test(
        'markUnread leaves lastReadMessageId null when the anchor is the oldest '
        'known message',
        () async {
          final channel = _createLivestreamChannel(
            messages: messages,
            reads: [
              Read(user: currentUser, lastRead: start.add(const Duration(minutes: 5))),
            ],
          );

          await expectLater(channel.markUnread('m1'), completes);

          expect(channel.state?.unreadCount, equals(3));
          expect(channel.state?.currentUserRead?.lastReadMessageId, isNull);
        },
      );

      test(
        'markUnreadByTimestamp is exclusive of the boundary and points '
        'lastReadMessageId at the newest message at or before it',
        () async {
          final channel = _createLivestreamChannel(
            messages: messages,
            reads: [
              Read(user: currentUser, lastRead: start.add(const Duration(minutes: 5))),
            ],
          );

          // Exactly m2's createdAt: m2 stays read, only m3 becomes unread.
          await expectLater(channel.markUnreadByTimestamp(messages[1].createdAt), completes);

          expect(channel.state?.unreadCount, equals(1));
          expect(channel.state?.currentUserRead?.lastReadMessageId, equals('m2'));
          verifyNever(() => client.markChannelUnreadByTimestamp(any(), any(), any()));
        },
      );

      test(
        'markUnread(id) and markUnreadByTimestamp(createdAt) intentionally '
        'differ by the anchor message',
        () async {
          final byId = _createLivestreamChannel(
            messages: messages,
            reads: [
              Read(user: currentUser, lastRead: start.add(const Duration(minutes: 5))),
            ],
          );
          final byTimestamp = _createLivestreamChannel(
            messages: messages,
            reads: [
              Read(user: currentUser, lastRead: start.add(const Duration(minutes: 5))),
            ],
          );

          await byId.markUnread('m2');
          await byTimestamp.markUnreadByTimestamp(messages[1].createdAt);

          // `markUnread` includes m2, `markUnreadByTimestamp` excludes it.
          expect(byId.state?.unreadCount, equals(2));
          expect(byTimestamp.state?.unreadCount, equals(1));

          // ...and they agree once the timestamp is nudged below the anchor.
          await byTimestamp.markUnreadByTimestamp(
            messages[1].createdAt.subtract(const Duration(microseconds: 1)),
          );
          expect(byTimestamp.state?.unreadCount, equals(2));
          expect(byTimestamp.state?.currentUserRead?.lastReadMessageId, equals('m1'));
        },
      );
    });

    test(
      'server payloads do not clobber the locally-tracked read state',
      () async {
        final channel = _createLivestreamChannel();
        channel.state!.unreadCount = 5;

        final serverRead = Read(
          user: currentUser,
          lastRead: DateTime.now(),
          unreadMessages: 0,
        );
        channel.state!.updateChannelStateFromServer(
          channel.state!.channelState.copyWith(read: [serverRead]),
        );

        expect(channel.state?.unreadCount, equals(5));
      },
    );

    test(
      'local (non-remote) state updates are not affected by the server-merge '
      'guard',
      () async {
        final channel = _createLivestreamChannel();
        channel.state!.unreadCount = 5;

        // A plain local mutation (via updateChannelState, not
        // updateChannelStateFromServer) should still be able to change the
        // locally-tracked read state.
        await expectLater(channel.markRead(), completes);

        expect(channel.state?.unreadCount, equals(0));
      },
    );
  });
}

// region Test Helpers

Logger _createLogger(String name) {
  final logger = Logger.detached(name)..level = Level.ALL;
  logger.onRecord.listen(print);
  return logger;
}

// endregion
