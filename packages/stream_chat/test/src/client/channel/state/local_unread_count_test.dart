import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

/// A "livestream-like" channel state: read events are disabled, both via the
/// channel-type config and the current user's own capabilities.
ChannelState _livestreamChannelState({
  String cid = _channelCid,
  List<Message> messages = const [],
  List<Read> read = const [],
  List<ChannelCapability> ownCapabilities = const [], // No readEvents capability.
}) {
  return createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: cid,
      config: createDefaultChannelConfig(readEvents: false),
      ownCapabilities: ownCapabilities,
    ),
    messages: messages,
    read: read,
  );
}

void main() {
  group('Local unread count', () {
    // A message from another user that counts as unread once seeded together
    // with a read state older than the message.
    final countedMessage = Message(
      id: 'message-1',
      text: 'Hello',
      user: User(id: 'other-user'),
      createdAt: DateTime.utc(2024),
    );

    channelTest(
      'increments unreadCount locally for new messages when the channel has '
      'no read events capability',
      channelType: _channelType,
      channelId: _channelId,
      isLocalUnreadCountEnabled: true,
      setUp: (tester) => tester.watch(modifyResponse: (_) => _livestreamChannelState()),
      body: (tester) async {
        expect(tester.channelState?.unreadCount, equals(0));

        final message = Message(
          id: 'message-1',
          text: 'Hello',
          user: User(id: 'other-user'),
          createdAt: DateTime.utc(2024),
        );

        await tester.emitEvent(
          createDefaultEvent(cid: tester.channel.cid, type: EventType.messageNew, message: message),
        );

        expect(tester.channelState?.unreadCount, equals(1));
      },
    );

    channelTest(
      'does not increment unreadCount when local unread count tracking is '
      'disabled',
      channelType: _channelType,
      channelId: _channelId,
      // Local unread count tracking stays at its default, disabled.
      isLocalUnreadCountEnabled: false,
      setUp: (tester) => tester.watch(modifyResponse: (_) => _livestreamChannelState()),
      body: (tester) async {
        final message = Message(
          id: 'message-1',
          text: 'Hello',
          user: User(id: 'other-user'),
          createdAt: DateTime.utc(2024),
        );

        await tester.emitEvent(
          createDefaultEvent(cid: tester.channel.cid, type: EventType.messageNew, message: message),
        );

        expect(tester.channelState?.unreadCount, equals(0));
      },
    );

    channelTest(
      'decrements unreadCount when a counted message is hard-deleted',
      channelType: _channelType,
      channelId: _channelId,
      isLocalUnreadCountEnabled: true,
      setUp: (tester) => tester.watch(
        modifyResponse: (_) => _livestreamChannelState(
          messages: [countedMessage],
          read: [
            createDefaultRead(lastRead: countedMessage.createdAt.subtract(const Duration(days: 1))),
          ],
        ),
      ),
      body: (tester) async {
        tester.channelState!.unreadCount = 1;
        expect(tester.channelState?.unreadCount, equals(1));

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageDeleted,
            message: countedMessage,
            hardDelete: true,
          ),
        );

        expect(tester.channelState?.unreadCount, equals(0));
      },
    );

    channelTest(
      'does not decrement unreadCount when a message is soft-deleted',
      channelType: _channelType,
      channelId: _channelId,
      isLocalUnreadCountEnabled: true,
      setUp: (tester) => tester.watch(
        modifyResponse: (_) => _livestreamChannelState(
          messages: [countedMessage],
          read: [
            createDefaultRead(lastRead: countedMessage.createdAt.subtract(const Duration(days: 1))),
          ],
        ),
      ),
      body: (tester) async {
        tester.channelState!.unreadCount = 1;

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageDeleted,
            message: countedMessage,
            hardDelete: false,
          ),
        );

        expect(tester.channelState?.unreadCount, equals(1));
      },
    );

    channelTest(
      'markRead resets unreadCount locally without making a network request',
      channelType: _channelType,
      channelId: _channelId,
      isLocalUnreadCountEnabled: true,
      setUp: (tester) => tester.watch(modifyResponse: (_) => _livestreamChannelState()),
      body: (tester) async {
        tester.channelState!.unreadCount = 3;
        expect(tester.channelState?.unreadCount, equals(3));

        await expectLater(tester.channel.markRead(), completes);

        expect(tester.channelState?.unreadCount, equals(0));
        tester.verifyNeverCalled(
          (api) => api.channel.markRead(any(), any(), messageId: any(named: 'messageId')),
        );
      },
    );

    // The three messages test 'markUnreadByTimestamp recomputes ...' seeds.
    final now = DateTime.utc(2024);
    final timestampedMessages = [
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

    channelTest(
      'markUnreadByTimestamp recomputes unreadCount locally without making a '
      'network request',
      channelType: _channelType,
      channelId: _channelId,
      isLocalUnreadCountEnabled: true,
      setUp: (tester) => tester.watch(
        modifyResponse: (_) => _livestreamChannelState(
          messages: timestampedMessages,
          read: [createDefaultRead(lastRead: now.add(const Duration(minutes: 5)))],
        ),
      ),
      body: (tester) async {
        expect(tester.channelState?.unreadCount, equals(0));

        await expectLater(
          tester.channel.markUnreadByTimestamp(now.add(const Duration(seconds: 30))),
          completes,
        );

        // Only m2 and m3 were created after the given timestamp.
        expect(tester.channelState?.unreadCount, equals(2));
        registerFallbackValue(DateTime.utc(2024));
        tester.verifyNeverCalled((api) => api.channel.markUnreadByTimestamp(any(), any(), any()));
      },
    );

    channelTest(
      'markUnread throws when the message is not locally known',
      channelType: _channelType,
      channelId: _channelId,
      isLocalUnreadCountEnabled: true,
      setUp: (tester) => tester.watch(modifyResponse: (_) => _livestreamChannelState()),
      body: (tester) async {
        await expectLater(
          tester.channel.markUnread('unknown-message-id'),
          throwsA(isA<StreamChatError>()),
        );
        tester.verifyNeverCalled((api) => api.channel.markUnread(any(), any(), any()));
      },
    );

    channelTest(
      'markRead reconciles pending delivery receipts',
      channelType: _channelType,
      channelId: _channelId,
      isLocalUnreadCountEnabled: true,
      // The delivery reporter is real in this harness, so the reconciliation
      // is observed through its effect: the pending receipt for the channel is
      // dropped and never reaches the API. A receipt only becomes pending on a
      // channel with the deliveryEvents capability and a read state older than
      // the incoming message.
      setUp: (tester) => tester.watch(
        modifyResponse: (_) => _livestreamChannelState(
          ownCapabilities: const [ChannelCapability.deliveryEvents],
          read: [createDefaultRead()],
        ),
      ),
      body: (tester) async {
        registerFallbackValue(<MessageDelivery>[]);
        tester.mockApi(
          (api) => api.channel.markChannelsDelivered(any()),
          result: createDefaultEmptyResponse(),
        );

        // A new message queues a delivery receipt behind the reporter's 1s
        // trailing throttle.
        final message = Message(
          id: 'message-1',
          text: 'Hello',
          user: User(id: 'other-user'),
          createdAt: DateTime.utc(2024),
        );
        await tester.emitEvent(
          createDefaultEvent(cid: tester.channel.cid, type: EventType.messageNew, message: message),
        );

        await expectLater(tester.channel.markRead(), completes);

        // Read supersedes delivered: once the throttle window elapses, the
        // reconciled receipt must not be reported.
        await Future.delayed(const Duration(milliseconds: 1100));
        tester.verifyNeverCalled((api) => api.channel.markChannelsDelivered(any()));
      },
    );

    group('local read boundary anchors', () {
      final start = DateTime.utc(2024);
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

      ChannelState seedAnchoredChannel(ChannelState _, {String cid = _channelCid}) {
        return _livestreamChannelState(
          cid: cid,
          messages: messages,
          read: [createDefaultRead(lastRead: start.add(const Duration(minutes: 5)))],
        );
      }

      channelTest(
        'markUnread is inclusive of the anchor and points lastReadMessageId at '
        'the previous message',
        channelType: _channelType,
        channelId: _channelId,
        isLocalUnreadCountEnabled: true,
        setUp: (tester) => tester.watch(modifyResponse: seedAnchoredChannel),
        body: (tester) async {
          await expectLater(tester.channel.markUnread('m2'), completes);

          // m2 (the anchor) and m3 are unread; m1 stays read.
          expect(tester.channelState?.unreadCount, equals(2));
          expect(tester.channelState?.currentUserRead?.lastReadMessageId, equals('m1'));
          tester.verifyNeverCalled((api) => api.channel.markUnread(any(), any(), any()));
        },
      );

      channelTest(
        'markUnread leaves lastReadMessageId null when the anchor is the oldest '
        'known message',
        channelType: _channelType,
        channelId: _channelId,
        isLocalUnreadCountEnabled: true,
        setUp: (tester) => tester.watch(modifyResponse: seedAnchoredChannel),
        body: (tester) async {
          await expectLater(tester.channel.markUnread('m1'), completes);

          expect(tester.channelState?.unreadCount, equals(3));
          expect(tester.channelState?.currentUserRead?.lastReadMessageId, isNull);
        },
      );

      channelTest(
        'markUnreadByTimestamp is exclusive of the boundary and points '
        'lastReadMessageId at the newest message at or before it',
        channelType: _channelType,
        channelId: _channelId,
        isLocalUnreadCountEnabled: true,
        setUp: (tester) => tester.watch(modifyResponse: seedAnchoredChannel),
        body: (tester) async {
          // Exactly m2's createdAt: m2 stays read, only m3 becomes unread.
          await expectLater(tester.channel.markUnreadByTimestamp(messages[1].createdAt), completes);

          expect(tester.channelState?.unreadCount, equals(1));
          expect(tester.channelState?.currentUserRead?.lastReadMessageId, equals('m2'));
          registerFallbackValue(DateTime.utc(2024));
          tester.verifyNeverCalled((api) => api.channel.markUnreadByTimestamp(any(), any(), any()));
        },
      );

      channelTest(
        'markUnread(id) and markUnreadByTimestamp(createdAt) intentionally '
        'differ by the anchor message',
        channelType: _channelType,
        channelId: _channelId,
        isLocalUnreadCountEnabled: true,
        setUp: (tester) => tester.watch(modifyResponse: seedAnchoredChannel),
        body: (tester) async {
          // The harness provides one channel per test; the second,
          // identically-seeded channel is watched by hand.
          const otherChannelId = 'other-channel-id';
          final byId = tester.channel;
          final byTimestamp = tester.client.channel(_channelType, id: otherChannelId);
          addTearDown(byTimestamp.dispose);

          tester.mockApi(
            (api) => api.channel.queryChannel(
              _channelType,
              channelId: otherChannelId,
              channelData: byTimestamp.extraData,
              state: true,
              watch: true,
              presence: false,
            ),
            result: seedAnchoredChannel(
              createDefaultChannelState(),
              cid: '$_channelType:$otherChannelId',
            ),
          );
          await byTimestamp.watch();

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

    channelTest(
      'server payloads do not clobber the locally-tracked read state',
      channelType: _channelType,
      channelId: _channelId,
      isLocalUnreadCountEnabled: true,
      setUp: (tester) => tester.watch(modifyResponse: (_) => _livestreamChannelState()),
      body: (tester) async {
        tester.channelState!.unreadCount = 5;

        final serverRead = Read(
          user: tester.currentUser!,
          lastRead: DateTime.utc(2024, 1, 2),
          unreadMessages: 0,
        );
        tester.channelState!.updateChannelStateFromServer(
          tester.channelState!.channelState.copyWith(read: [serverRead]),
        );

        expect(tester.channelState?.unreadCount, equals(5));
      },
    );

    channelTest(
      'local (non-remote) state updates are not affected by the server-merge '
      'guard',
      channelType: _channelType,
      channelId: _channelId,
      isLocalUnreadCountEnabled: true,
      setUp: (tester) => tester.watch(modifyResponse: (_) => _livestreamChannelState()),
      body: (tester) async {
        tester.channelState!.unreadCount = 5;

        // A plain local mutation (via updateChannelState, not
        // updateChannelStateFromServer) should still be able to change the
        // locally-tracked read state.
        await expectLater(tester.channel.markRead(), completes);

        expect(tester.channelState?.unreadCount, equals(0));
      },
    );
  });
}
