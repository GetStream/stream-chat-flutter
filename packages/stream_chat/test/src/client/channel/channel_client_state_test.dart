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

  group('Message enrichment preservation on merge', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late Channel channel;

    setUpAll(() {
      registerFallbackValue(FakeMessage());
      registerFallbackValue(<Message>[]);

      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));

      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);
    });

    setUp(() {
      final channelState = _generateChannelState(channelId, channelType);
      channel = Channel.fromState(client, channelState);
    });

    tearDown(() {
      channel.dispose();
      clearInteractions(client);
    });

    test(
      'preserves the `poll` on a quotedMessage when the server omits it during '
      're-sync (regression: poll quote disappears after foregrounding)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-1',
          name: 'Pizza or pasta?',
          options: const [
            PollOption(id: 'opt-1', text: 'Pizza'),
            PollOption(id: 'opt-2', text: 'Pasta'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-1',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-1',
          text: 'Voting now',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'reply-user'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        // Seed channel state with the fully-enriched messages (mirrors what
        // the local DB load produces).
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, replyToPoll],
          ),
        );

        // Simulate a re-sync from the API: the server echoes the reply with
        // a `quoted_message` that has only `poll_id` (no `poll` object).
        // Constructed directly (not via copyWith) because copyWith cannot
        // clear `poll` — see Message.copyWith.
        final strippedPollSnapshot = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
        );
        final reSyncedReply = replyToPoll.copyWith(quotedMessage: strippedPollSnapshot);

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [reSyncedReply],
          ),
        );

        final mergedReply = channel.state?.messages.firstWhere((it) => it.id == replyToPoll.id);

        expect(mergedReply, isNotNull);
        expect(mergedReply!.quotedMessage, isNotNull);
        expect(mergedReply.quotedMessage!.id, pollMessage.id);
        expect(mergedReply.quotedMessage!.poll, isNotNull);
        expect(mergedReply.quotedMessage!.poll!.id, poll.id);
        expect(mergedReply.quotedMessage!.poll!.name, poll.name);
      },
    );

    test(
      'preserves a nested quotedMessage (poll) two levels deep when the '
      'server omits it during re-sync (regression: quote-of-quote of a poll '
      'disappears completely after foregrounding)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-2',
          name: 'Coffee or tea?',
          options: const [
            PollOption(id: 'opt-a', text: 'Coffee'),
            PollOption(id: 'opt-b', text: 'Tea'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-2',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-A',
          text: 'My pick',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'user-a'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        final replyToReply = Message(
          id: 'reply-B',
          text: 'Same here',
          quotedMessageId: replyToPoll.id,
          quotedMessage: replyToPoll,
          user: User(id: 'user-b'),
          createdAt: DateTime.utc(2026, 4, 29, 12),
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, replyToPoll, replyToReply],
          ),
        );

        // Simulate the server response where:
        // - replyA's nested quoted poll is missing the `poll` object.
        // - replyB's nested quoted replyA is missing its own `quoted_message`
        //   (the server typically does not nest two levels deep).
        // Stripped poll snapshot is constructed directly because copyWith
        // cannot clear `poll` — see Message.copyWith.
        final strippedPollSnapshot = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
        );
        final strippedReplyA = replyToPoll.copyWith(quotedMessage: null);

        final reSyncedReplyA = replyToPoll.copyWith(quotedMessage: strippedPollSnapshot);
        final reSyncedReplyB = replyToReply.copyWith(quotedMessage: strippedReplyA);

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, reSyncedReplyA, reSyncedReplyB],
          ),
        );

        final mergedReplyA = channel.state?.messages.firstWhere((it) => it.id == replyToPoll.id);
        final mergedReplyB = channel.state?.messages.firstWhere((it) => it.id == replyToReply.id);

        // First-level quote (reply A's quote of the poll) must keep the poll.
        expect(mergedReplyA?.quotedMessage?.poll, isNotNull);
        expect(mergedReplyA?.quotedMessage?.poll?.id, poll.id);

        // Second-level quote (reply B's quote of reply A) must keep reply A's
        // own nested quotedMessage so the poll preview still resolves.
        expect(mergedReplyB?.quotedMessage, isNotNull);
        expect(mergedReplyB?.quotedMessage?.id, replyToPoll.id);
        expect(mergedReplyB?.quotedMessage?.quotedMessage, isNotNull);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.id, pollMessage.id);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.poll, isNotNull);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.poll?.id, poll.id);
      },
    );

    test(
      'still preserves quotedMessage when the updated payload has no '
      'quoted_message at all (existing behavior should not regress)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-3',
          name: 'Beach or mountains?',
          options: const [
            PollOption(id: 'opt-x', text: 'Beach'),
            PollOption(id: 'opt-y', text: 'Mountains'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-3',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-3',
          text: 'Definitely beach',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'reply-user'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, replyToPoll],
          ),
        );

        // Simulate an update event that touches the reply but doesn't echo
        // the nested quoted_message at all (only quotedMessageId is set).
        final reSyncedReply = Message(
          id: replyToPoll.id,
          text: 'Definitely beach (edited)',
          quotedMessageId: pollMessage.id,
          user: replyToPoll.user,
          createdAt: replyToPoll.createdAt,
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [reSyncedReply],
          ),
        );

        final mergedReply = channel.state?.messages.firstWhere((it) => it.id == replyToPoll.id);

        expect(mergedReply, isNotNull);
        expect(mergedReply!.text, 'Definitely beach (edited)');
        expect(mergedReply.quotedMessage, isNotNull);
        expect(mergedReply.quotedMessage!.poll?.id, poll.id);
      },
    );

    test(
      'preserves the top-level `poll` when the server emits a `message.updated`'
      ' that omits the `poll` object (regression: poll disappears from the '
      'parent message after a thread reply is added)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-thread',
          name: 'What is for lunch?',
          options: const [
            PollOption(id: 'opt-1', text: 'Burgers'),
            PollOption(id: 'opt-2', text: 'Salads'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'parent-poll-msg',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
          replyCount: 0,
        );

        // Seed channel state with the fully-enriched parent poll message.
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage],
          ),
        );

        // Simulate the `message.updated` event the backend fires for the
        // parent after a thread reply is added: bookkeeping fields are bumped
        // (`reply_count`, `updated_at`) but the `poll` object is omitted from
        // the payload — only `pollId` is set. Constructed directly because
        // copyWith cannot clear `poll` — see Message.copyWith.
        final strippedParentUpdate = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
          replyCount: 1,
          updatedAt: DateTime.utc(2026, 4, 29, 11),
        );

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.messageUpdated,
            message: strippedParentUpdate,
          ),
        );

        // Wait for the event to be processed.
        await Future.delayed(Duration.zero);

        final merged = channel.state?.messages.firstWhere((it) => it.id == pollMessage.id);

        // Parent poll message must remain in the channel state after a thread reply.
        expect(merged, isNotNull);
        // Bookkeeping fields from the event should still apply.
        expect(merged!.replyCount, 1);
        // Locally-known poll must be preserved when the server omits it from a
        // `message.updated` payload (e.g. when a thread reply bumps reply_count).
        expect(merged.poll, isNotNull);
        expect(merged.poll!.id, poll.id);
        expect(merged.poll!.name, poll.name);
        expect(merged.pollId, poll.id);
      },
    );

    test(
      'still uses the updated `poll` when the server includes one in '
      '`message.updated` (poll edits should not be reverted to the locally '
      'cached version)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-edit',
          name: 'Initial name',
          options: const [
            PollOption(id: 'opt-1', text: 'Original A'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'edit-parent',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage],
          ),
        );

        final updatedPoll = poll.copyWith(name: 'Edited name');
        final updatedParent = pollMessage.copyWith(poll: updatedPoll, updatedAt: DateTime.utc(2026, 4, 29, 12));

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.messageUpdated,
            message: updatedParent,
          ),
        );

        await Future.delayed(Duration.zero);

        final merged = channel.state?.messages.firstWhere((it) => it.id == pollMessage.id);

        // Server-echoed poll must override the locally cached one — poll edits
        // should not be reverted by the local-fallback merge.
        expect(merged?.poll, isNotNull);
        expect(merged?.poll?.name, 'Edited name');
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
