import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

final _initialLastMessageAt = DateTime.utc(2021, 3);

ChannelState Function(ChannelState) _seedChannel({
  List<ChannelCapability> ownCapabilities = const [ChannelCapability.readEvents],
  ChannelConfig? config,
}) {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: config ?? createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: ownCapabilities,
      lastMessageAt: _initialLastMessageAt,
    ),
  );
}

Event _newMessageEvent(Message message) => createDefaultEvent(
  type: EventType.messageNew,
  cid: _channelCid,
  message: message,
);

void main() {
  group('${EventType.messageNew} or ${EventType.notificationMessageNew}', () {
    channelTest(
      "should update 'channel.lastMessageAt'",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));

        final message = Message(
          id: 'test-message-id',
          user: tester.currentUser,
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(message));

        expect(tester.channel.lastMessageAt, equals(message.createdAt));
        expect(tester.channel.lastMessageAt, isNot(_initialLastMessageAt));
      },
    );

    channelTest(
      "should update 'channel.lastMessageAt' when Message has restricted visibility only for the current user",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));

        final message = Message(
          id: 'test-message-id',
          user: tester.currentUser,
          // Message is visible to the current user.
          restrictedVisibility: [tester.currentUser!.id],
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(message));

        expect(tester.channel.lastMessageAt, equals(message.createdAt));
        expect(tester.channel.lastMessageAt, isNot(_initialLastMessageAt));
      },
    );

    channelTest(
      "should not update 'channel.lastMessageAt' when 'message.createdAt' is older",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));

        final message = Message(
          id: 'test-message-id',
          user: tester.currentUser,
          // Older than the current 'channel.lastMessageAt'.
          createdAt: _initialLastMessageAt.subtract(const Duration(days: 1)),
        );

        await tester.emitEvent(_newMessageEvent(message));

        expect(tester.channel.lastMessageAt, isNot(message.createdAt));
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));
      },
    );

    channelTest(
      "should not update 'channel.lastMessageAt' when Message is shadowed",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));

        final message = Message(
          id: 'test-message-id',
          user: tester.currentUser,
          shadowed: true,
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(message));

        expect(tester.channel.lastMessageAt, isNot(message.createdAt));
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));
      },
    );

    channelTest(
      "should not update 'channel.lastMessageAt' when Message is ephemeral",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));

        final message = Message(
          type: MessageType.ephemeral,
          id: 'test-message-id',
          user: tester.currentUser,
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(message));

        expect(tester.channel.lastMessageAt, isNot(message.createdAt));
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));
      },
    );

    channelTest(
      "should not update 'channel.lastMessageAt' when Message has restricted visibility but not for the current user",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));

        final message = Message(
          id: 'test-message-id',
          user: tester.currentUser,
          // Message is only visible to user-1 not the current user.
          restrictedVisibility: const ['user-1'],
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(message));

        expect(tester.channel.lastMessageAt, isNot(message.createdAt));
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));
      },
    );

    channelTest(
      "should not update 'channel.lastMessageAt' when Message is system and skip is enabled",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          config: createDefaultChannelConfig(
            readEvents: true,
            typingEvents: true,
            skipLastMsgUpdateForSystemMsgs: true,
          ),
        ),
      ),
      body: (tester) async {
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));

        final message = Message(
          type: MessageType.system,
          id: 'test-message-id',
          user: tester.currentUser,
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(message));

        expect(tester.channel.lastMessageAt, isNot(message.createdAt));
        expect(tester.channel.lastMessageAt, equals(_initialLastMessageAt));
      },
    );

    channelTest(
      "should update 'unreadCount'",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        expect(tester.channelState?.unreadCount, equals(0));

        final message = Message(
          id: 'test-message-id',
          user: User(id: 'other-user'),
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(message));

        expect(tester.channelState?.unreadCount, equals(1));

        final message2 = Message(
          id: 'test-message-id-2',
          user: User(id: 'other-user'),
          createdAt: message.createdAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(message2));

        expect(tester.channelState?.unreadCount, equals(2));
      },
    );

    group("should not update 'unreadCount'", () {
      channelTest(
        'when the message is silent',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channelState?.unreadCount, equals(0));

          final message = Message(
            id: 'test-message-id',
            silent: true,
            user: User(id: 'other-user'),
            createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
          );

          await tester.emitEvent(_newMessageEvent(message));

          expect(tester.channelState?.unreadCount, equals(0));
        },
      );

      channelTest(
        'when the message is shadowed',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channelState?.unreadCount, equals(0));

          final message = Message(
            id: 'test-message-id',
            shadowed: true,
            user: User(id: 'other-user'),
            createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
          );

          await tester.emitEvent(_newMessageEvent(message));

          expect(tester.channelState?.unreadCount, equals(0));
        },
      );

      channelTest(
        'when the message type is ephemeral',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channelState?.unreadCount, equals(0));

          final message = Message(
            id: 'test-message-id',
            type: MessageType.ephemeral,
            user: User(id: 'other-user'),
            createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
          );

          await tester.emitEvent(_newMessageEvent(message));

          expect(tester.channelState?.unreadCount, equals(0));
        },
      );

      channelTest(
        'when the message is a thread reply',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channelState?.unreadCount, equals(0));

          final message = Message(
            id: 'test-message-id',
            parentId: 'test-parent-id',
            showInChannel: false,
            user: User(id: 'other-user'),
            createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
          );

          await tester.emitEvent(_newMessageEvent(message));

          expect(tester.channelState?.unreadCount, equals(0));
        },
      );

      channelTest(
        'when the message is a thread reply',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channelState?.unreadCount, equals(0));

          final message = Message(
            id: 'test-message-id',
            parentId: 'test-parent-id',
            showInChannel: false,
            user: User(id: 'other-user'),
            createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
          );

          await tester.emitEvent(_newMessageEvent(message));

          expect(tester.channelState?.unreadCount, equals(0));
        },
      );

      channelTest(
        'when the message is from the current user',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channelState?.unreadCount, equals(0));

          final message = Message(
            id: 'test-message-id',
            user: tester.currentUser,
            createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
          );

          await tester.emitEvent(_newMessageEvent(message));

          expect(tester.channelState?.unreadCount, equals(0));
        },
      );

      channelTest(
        'when the message is not restricted for the current user',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channelState?.unreadCount, equals(0));

          final message = Message(
            id: 'test-message-id',
            user: User(id: 'other-user'),
            createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
            restrictedVisibility: const ['other-user-2'],
          );

          await tester.emitEvent(_newMessageEvent(message));

          expect(tester.channelState?.unreadCount, equals(0));
        },
      );
    });

    channelTest(
      'should submit channel for delivery when message is received',
      channelType: _channelType,
      channelId: _channelId,
      // A real watch response carries the member's read state; without it the
      // first unread increment synthesizes one anchored at the incoming
      // message, which suppresses the delivery receipt.
      setUp: (tester) => tester.watch(
        modifyResponse: (state) => _seedChannel(
          ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
        )(state).copyWith(read: [createDefaultRead()]),
      ),
      body: (tester) async {
        registerFallbackValue(<MessageDelivery>[]);
        tester.mockApi(
          (api) => api.channel.markChannelsDelivered(any()),
          result: createDefaultEmptyResponse(),
        );

        final message = Message(
          id: 'test-message-id',
          user: User(id: 'other-user'),
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(message));

        // The delivery reporter batches receipts behind a 1s trailing throttle.
        await Future.delayed(const Duration(milliseconds: 1100));

        final captured = tester.captureApi(
          (api) => api.channel.markChannelsDelivered(captureAny()),
        );
        final deliveries = captured.single! as List<MessageDelivery>;
        expect(deliveries.single.channelCid, _channelCid);
        expect(deliveries.single.messageId, 'test-message-id');
      },
    );

    channelTest(
      'should not duplicate when server echoes back an optimistically '
      'inserted message with a later createdAt',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Local message used as the input to `channel.sendMessage`.
        final localCreatedAt = _initialLastMessageAt.add(const Duration(seconds: 3));
        final localMessage = Message(
          id: 'test-message-id',
          text: 'Hello world!',
          user: tester.currentUser,
          createdAt: localCreatedAt,
        );

        // Mock the network send to return the message unchanged so the
        // optimistic insert + sent-state update both land on the same
        // `createdAt`. The bug fires later, on the WS echo.
        tester.mockApi(
          (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(localMessage))),
          result: createDefaultSendMessageResponse(message: localMessage.copyWith(state: MessageState.sent)),
        );

        await tester.channel.sendMessage(localMessage);

        expect(tester.channelState!.messages, hasLength(1));

        // Server then broadcasts the same message via a `message.new`
        // event with a slightly later `createdAt` (server-assigned
        // timestamp).
        final serverMessage = localMessage.copyWith(
          createdAt: localCreatedAt.add(const Duration(milliseconds: 50)),
        );
        await tester.emitEvent(_newMessageEvent(serverMessage));

        // The state should contain exactly one message with that id,
        // not a duplicate.
        final matching = tester.channelState!.messages.where((it) => it.id == localMessage.id);
        expect(matching, hasLength(1));
        expect(tester.channelState!.messages, hasLength(1));
      },
    );

    channelTest(
      'should not duplicate when the locally-sent message is no longer '
      'the latest (retry-after-offline scenario)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Mirrors the offline-retry flow: a local message is sent, then
        // another message arrives via WS while the local one is still
        // pending. When the retry finally succeeds the server response's
        // `createdAt` is later than the intervening message, so the
        // locally-sent copy is no longer `messages.last`.
        final localCreatedAt = _initialLastMessageAt.add(const Duration(seconds: 1));
        final localMessage = Message(
          id: 'local-message-id',
          text: 'Hello world!',
          user: tester.currentUser,
          createdAt: localCreatedAt,
        );

        tester.mockApi(
          (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(localMessage))),
          result: createDefaultSendMessageResponse(message: localMessage.copyWith(state: MessageState.sent)),
        );

        await tester.channel.sendMessage(localMessage);

        // Another message arrives via WS with a later `createdAt`,
        // pushing the locally-sent message off the tail.
        final otherMessage = Message(
          id: 'other-message-id',
          user: User(id: 'other-user'),
          createdAt: localCreatedAt.add(const Duration(seconds: 2)),
        );
        await tester.emitEvent(_newMessageEvent(otherMessage));

        // Server then broadcasts the locally-sent message via
        // `message.new` with a `createdAt` that is later than the
        // intervening message — exactly the shape produced by a
        // successful retry after another message arrived in between.
        final serverEcho = localMessage.copyWith(
          createdAt: otherMessage.createdAt.add(const Duration(seconds: 1)),
        );
        await tester.emitEvent(_newMessageEvent(serverEcho));

        final localMatches = tester.channelState!.messages.where((it) => it.id == localMessage.id);
        expect(localMatches, hasLength(1));
        expect(tester.channelState!.messages, hasLength(2));
      },
    );

    channelTest(
      '${EventType.notificationMessageNew} adds the message and counts unread',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'notified-message-id',
          user: User(id: 'other-user'),
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(
          createDefaultEvent(
            cid: _channelCid,
            type: EventType.notificationMessageNew,
            message: message,
          ),
        );

        expect(tester.channelState!.messages.map((m) => m.id), ['notified-message-id']);
        expect(tester.channelState!.unreadCount, 1);
      },
    );

    channelTest(
      'a channel message is not appended while the channel is not up to date',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        tester.channelState!.isUpToDate = false;

        final message = Message(
          id: 'below-window-message-id',
          user: User(id: 'other-user'),
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(message));

        expect(tester.channelState!.messages, isEmpty);
        expect(tester.channelState!.unreadCount, 1);
      },
    );

    channelTest(
      'a thread-only reply is stored even while the channel is not up to date',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        tester.channelState!.isUpToDate = false;

        final reply = Message(
          id: 'thread-reply-id',
          parentId: 'parent-message-id',
          user: User(id: 'other-user'),
          createdAt: _initialLastMessageAt.add(const Duration(seconds: 3)),
        );

        await tester.emitEvent(_newMessageEvent(reply));

        expect(tester.channelState!.messages, isEmpty);
        expect(tester.channelState!.threads['parent-message-id']?.map((m) => m.id), ['thread-reply-id']);
      },
    );

    channelTest(
      'an event without a message is ignored',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        await tester.emitEvent(createDefaultEvent(cid: _channelCid, type: EventType.messageNew));

        expect(tester.channelState!.messages, isEmpty);
        expect(tester.channel.lastMessageAt, _initialLastMessageAt);
      },
    );
  });
}
