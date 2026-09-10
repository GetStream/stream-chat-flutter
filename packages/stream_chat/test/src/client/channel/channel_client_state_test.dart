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

  group('updateChannelState identity guard', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    setUpAll(() {
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(
          shouldRetry: (_, __, ___) => false,
          delayFactor: Duration.zero,
        ),
      );
      when(() => client.state).thenReturn(FakeClientState());
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    Channel _seededChannel() {
      final base = _generateChannelState(channelId, channelType);
      final now = DateTime.now();
      final seeded = base.copyWith(
        messages: [
          Message(id: 'm1', text: '1', createdAt: now),
          Message(id: 'm2', text: '2', createdAt: now.add(const Duration(seconds: 1))),
          Message(id: 'm3', text: '3', createdAt: now.add(const Duration(seconds: 2))),
        ],
      );
      return Channel.fromState(client, seeded);
    }

    test(
      'preserves messages reference when updatedState.messages is null',
      () {
        final channel = _seededChannel();
        addTearDown(channel.dispose);

        final before = channel.state!.messages;
        channel.state!.updateChannelState(
          ChannelState(channel: channel.state!.channelState.channel),
        );
        final after = channel.state!.messages;

        expect(identical(before, after), isTrue);
      },
    );

    test(
      'preserves messages reference when updatedState.messages is identical',
      () {
        final channel = _seededChannel();
        addTearDown(channel.dispose);

        final before = channel.state!.messages;
        // copyWith without messages keeps the same `messages` reference, so
        // updateChannelState should hit the identity-guard fast path.
        channel.state!.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [
              Read(
                user: User(id: 'me'),
                lastRead: DateTime.now(),
                unreadMessages: 1,
              ),
            ],
          ),
        );
        final after = channel.state!.messages;

        expect(identical(before, after), isTrue);
      },
    );

    test(
      'still merges messages when updatedState.messages is a different list',
      () {
        final channel = _seededChannel();
        addTearDown(channel.dispose);

        final newMessage = Message(
          id: 'm4',
          text: '4',
          createdAt: DateTime.now().add(const Duration(seconds: 10)),
        );
        channel.state!.updateChannelState(
          ChannelState(
            channel: channel.state!.channelState.channel,
            messages: [newMessage],
          ),
        );

        expect(
          channel.state!.messages.map((m) => m.id),
          ['m1', 'm2', 'm3', 'm4'],
        );
      },
    );

    test('cold-path merge interleaves new messages in sorted order', () {
      final channel = _seededChannel();
      addTearDown(channel.dispose);

      final base = channel.state!.messages.first.createdAt;
      // Incoming list is sorted ascending by createdAt and slots between
      // the existing m1, m2, m3.
      final incoming = [
        Message(
          id: 'm1.5',
          text: 'between m1 and m2',
          createdAt: base.add(const Duration(milliseconds: 500)),
        ),
        Message(
          id: 'm2.5',
          text: 'between m2 and m3',
          createdAt: base.add(const Duration(milliseconds: 1500)),
        ),
      ];
      channel.state!.updateChannelState(
        ChannelState(
          channel: channel.state!.channelState.channel,
          messages: incoming,
        ),
      );

      expect(
        channel.state!.messages.map((m) => m.id),
        ['m1', 'm1.5', 'm2', 'm2.5', 'm3'],
      );
    });

    test('cold-path merge runs syncWith on overlapping ids', () {
      final channel = _seededChannel();
      addTearDown(channel.dispose);

      final localStamp = DateTime.now();
      // Seed m2 with a localCreatedAt that the incoming version doesn't
      // carry, so we can verify syncWith fired during the merge.
      channel.state!.updateMessage(
        Message(
          id: 'm2',
          text: '2',
          createdAt: channel.state!.messages.firstWhere((m) => m.id == 'm2').createdAt,
        ).copyWith(localCreatedAt: localStamp),
      );

      final incoming = [
        Message(
          id: 'm2',
          text: '2 (server)',
          createdAt: channel.state!.messages.firstWhere((m) => m.id == 'm2').createdAt,
        ),
      ];
      channel.state!.updateChannelState(
        ChannelState(
          channel: channel.state!.channelState.channel,
          messages: incoming,
        ),
      );

      final m2 = channel.state!.messages.firstWhere((m) => m.id == 'm2');
      expect(m2.text, '2 (server)');
      // Local-only field carried over by syncWith during the merge.
      expect(m2.localCreatedAt, localStamp);
    });
  });

  group('updateMessage quoted-rewrite', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    setUpAll(() {
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(
          shouldRetry: (_, __, ___) => false,
          delayFactor: Duration.zero,
        ),
      );
      when(() => client.state).thenReturn(FakeClientState());
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    Channel _seededChannel({required List<Message> messages}) {
      final base = _generateChannelState(channelId, channelType);
      return Channel.fromState(client, base.copyWith(messages: messages));
    }

    test(
      'rewrites quotedMessage on every quoter when target is deleted',
      () {
        final now = DateTime.now();
        final target = Message(id: 'target', text: 'hi', createdAt: now);
        final quoter1 = Message(
          id: 'q1',
          text: 'reply',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 1)),
        );
        final unrelated = Message(
          id: 'u1',
          text: 'other',
          createdAt: now.add(const Duration(seconds: 2)),
        );
        final quoter2 = Message(
          id: 'q2',
          text: 'reply2',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 3)),
        );

        final channel = _seededChannel(messages: [target, quoter1, unrelated, quoter2]);
        addTearDown(channel.dispose);

        final unrelatedBefore = channel.state!.messages.firstWhere((m) => m.id == 'u1');

        final deleted = target.copyWith(
          type: MessageType.deleted,
          deletedAt: now.add(const Duration(seconds: 5)),
        );
        channel.state!.updateMessage(deleted);

        final after = channel.state!.messages;
        final q1After = after.firstWhere((m) => m.id == 'q1');
        final q2After = after.firstWhere((m) => m.id == 'q2');
        final uAfter = after.firstWhere((m) => m.id == 'u1');

        expect(q1After.quotedMessage?.deletedAt, isNotNull);
        expect(q1After.quotedMessage?.type, MessageType.deleted);
        expect(q2After.quotedMessage?.deletedAt, isNotNull);
        expect(q2After.quotedMessage?.type, MessageType.deleted);
        // Unrelated messages must not be rebuilt by the rewrite.
        expect(identical(uAfter, unrelatedBefore), isTrue);
      },
    );

    test(
      'preserves messages reference when no message quotes the deleted one',
      () {
        final now = DateTime.now();
        final target = Message(id: 'target', text: 'hi', createdAt: now);
        final unrelated = Message(
          id: 'u1',
          text: 'other',
          createdAt: now.add(const Duration(seconds: 1)),
        );

        final channel = _seededChannel(messages: [target, unrelated]);
        addTearDown(channel.dispose);

        final deleted = target.copyWith(
          type: MessageType.deleted,
          deletedAt: now.add(const Duration(seconds: 5)),
        );
        channel.state!.updateMessage(deleted);

        // No message quotes `target`, so `updateIf` short-circuits and the
        // remaining messages keep their identities (only `target` itself was
        // replaced by `sortedUpsert`).
        final unrelatedAfter = channel.state!.messages.firstWhere((m) => m.id == 'u1');
        expect(identical(unrelatedAfter, unrelated), isTrue);
      },
    );

    test(
      'does not rewrite quotes when an existing quoted target is updated '
      'without being deleted',
      () {
        final now = DateTime.now();
        final target = Message(id: 'target', text: 'original', createdAt: now);
        final quoter = Message(
          id: 'q1',
          text: 'reply',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 1)),
        );

        final channel = _seededChannel(messages: [target, quoter]);
        addTearDown(channel.dispose);

        final quoterBefore = channel.state!.messages.firstWhere((m) => m.id == 'q1');

        // Plain text update — not a deletion.
        channel.state!.updateMessage(target.copyWith(text: 'edited'));

        final quoterAfter = channel.state!.messages.firstWhere((m) => m.id == 'q1');
        // `updateIf` is gated on `message.isDeleted`, so the quoter must keep
        // its identity (no allocation, no quoted-message overwrite).
        expect(identical(quoterAfter, quoterBefore), isTrue);
      },
    );
  });
}

// region Test Helpers

ChannelState _generateChannelState(
  String channelId,
  String channelType, {
  DateTime? lastMessageAt,
  List<ChannelCapability>? ownCapabilities,
  bool mockChannelConfig = false,
}) {
  ChannelConfig? config;
  if (mockChannelConfig) {
    config = MockChannelConfig();
    when(() => config!.readEvents).thenReturn(true);
    when(() => config!.typingEvents).thenReturn(true);
  }
  final channel = ChannelModel(
    id: channelId,
    type: channelType,
    config: config,
    ownCapabilities: ownCapabilities,
    lastMessageAt: lastMessageAt,
  );
  return ChannelState(channel: channel);
}

Logger _createLogger(String name) {
  final logger = Logger.detached(name)..level = Level.ALL;
  logger.onRecord.listen(print);
  return logger;
}

// endregion
