import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

void main() {
  group('WS events', () {
    group('Typing events', () {
      channelTest(
        '${EventType.typingStart} from another user is added to typingEvents',
        channelType: 'test-channel-type',
        channelId: 'test-channel-id',
        setUp: (tester) => tester.watch(),
        body: (tester) async {
          final otherUser = User(id: 'other-user');

          await tester.emitEvent(
            createDefaultEvent(type: EventType.typingStart, cid: tester.channel.cid, user: otherUser),
          );

          final typingEvents = tester.channelState!.typingEvents;
          expect(typingEvents.keys.map((u) => u.id), ['other-user']);
          expect(typingEvents.values.single.type, EventType.typingStart);
        },
      );

      channelTest(
        '${EventType.typingStop} removes only the stopping user',
        channelType: 'test-channel-type',
        channelId: 'test-channel-id',
        setUp: (tester) => tester.watch(),
        body: (tester) async {
          final user1 = User(id: 'other-user-1');
          final user2 = User(id: 'other-user-2');

          await tester.emitEvent(createDefaultEvent(type: EventType.typingStart, cid: tester.channel.cid, user: user1));
          await tester.emitEvent(createDefaultEvent(type: EventType.typingStart, cid: tester.channel.cid, user: user2));
          expect(tester.channelState!.typingEvents, hasLength(2));

          await tester.emitEvent(createDefaultEvent(type: EventType.typingStop, cid: tester.channel.cid, user: user1));

          expect(tester.channelState!.typingEvents.keys.map((u) => u.id), ['other-user-2']);
        },
      );

      channelTest(
        '${EventType.typingStart} from the current user is ignored',
        channelType: 'test-channel-type',
        channelId: 'test-channel-id',
        setUp: (tester) => tester.watch(),
        body: (tester) async {
          final currentUser = User(id: tester.currentUser!.id);

          await tester.emitEvent(
            createDefaultEvent(type: EventType.typingStart, cid: tester.channel.cid, user: currentUser),
          );

          expect(tester.channelState!.typingEvents, isEmpty);
        },
      );

      channelTest(
        '${EventType.typingStart} without a user is ignored',
        channelType: 'test-channel-type',
        channelId: 'test-channel-id',
        setUp: (tester) => tester.watch(),
        body: (tester) async {
          await tester.emitEvent(createDefaultEvent(type: EventType.typingStart, cid: tester.channel.cid));

          expect(tester.channelState!.typingEvents, isEmpty);
        },
      );

      channelTest(
        '${EventType.typingStop} from the current user is ignored',
        channelType: 'test-channel-type',
        channelId: 'test-channel-id',
        setUp: (tester) => tester.watch(),
        body: (tester) async {
          final currentUser = User(id: tester.currentUser!.id);

          await tester.emitEvent(
            createDefaultEvent(type: EventType.typingStop, cid: tester.channel.cid, user: currentUser),
          );

          expect(tester.channelState!.typingEvents, isEmpty);
        },
      );

      channelTest(
        '${EventType.typingStop} without a user is ignored',
        channelType: 'test-channel-type',
        channelId: 'test-channel-id',
        setUp: (tester) => tester.watch(),
        body: (tester) async {
          await tester.emitEvent(createDefaultEvent(type: EventType.typingStop, cid: tester.channel.cid));

          expect(tester.channelState!.typingEvents, isEmpty);
        },
      );
    });

    group('${EventType.messageNew} or ${EventType.notificationMessageNew}', () {
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

    group(EventType.messageUpdated, () {
      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: const [ChannelCapability.readEvents],
          ),
        );
      }

      Event _updateMessageEvent(Message message) => createDefaultEvent(
        type: EventType.messageUpdated,
        cid: _channelCid,
        message: message,
      );

      // A `message.updated` event for a message outside the loaded window
      // would otherwise upsert into the sorted list — creating a phantom
      // entry with a gap. The guard is "id not in the loaded list", and
      // is independent of `isUpToDate` — even at the latest page we may
      // have paginated past older history and receive an event for a
      // message no longer in memory.

      channelTest(
        "should update 'channel.state.pinnedMessages' and should add message to pinned messages only once if updatedMessage.pinned is true",
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const messageId = 'test-message-id';
          final message = Message(
            id: messageId,
            user: tester.currentUser,
            pinned: true,
          );

          await tester.emitEvent(_updateMessageEvent(message));

          expect(tester.channelState?.pinnedMessages.length, equals(1));
          expect(tester.channelState?.pinnedMessages.first.id, equals(messageId));
        },
      );

      channelTest(
        'should update pinned message itself if updatedMessage.pinned is true and message is already pinned',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const messageId = 'test-message-id';
          const oldText = 'Old text';
          const newText = 'New text';
          final message = Message(
            id: messageId,
            user: tester.currentUser,
            text: oldText,
            pinned: true,
          );

          await tester.emitEvent(_updateMessageEvent(message));

          expect(tester.channelState?.pinnedMessages.length, equals(1));
          expect(tester.channelState?.pinnedMessages.first.id, equals(messageId));
          expect(tester.channelState?.pinnedMessages.first.text, equals(oldText));

          final updatedMessage = message.copyWith(text: newText);
          await tester.emitEvent(_updateMessageEvent(updatedMessage));

          expect(tester.channelState?.pinnedMessages.length, equals(1));
          expect(tester.channelState?.pinnedMessages.first.id, equals(messageId));
          expect(tester.channelState?.pinnedMessages.first.text, equals(newText));
        },
      );

      channelTest(
        "should update 'channel.state.pinnedMessages' and should add message to pinned messages "
        'and not unpin previous pinned message if updatedMessage.pinned is true and there is already another pinned message',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const firstMessageId = 'first-test-message-id';
          const secondMessageId = 'second-test-message-id';
          final firstMessage = Message(
            id: firstMessageId,
            user: tester.currentUser,
            pinned: true,
          );
          final secondMessage = firstMessage.copyWith(id: secondMessageId);

          await tester.emitEvent(_updateMessageEvent(firstMessage));

          expect(tester.channelState?.pinnedMessages.length, equals(1));
          expect(
            tester.channelState?.pinnedMessages.first.id,
            equals(firstMessageId),
          );

          await tester.emitEvent(_updateMessageEvent(secondMessage));

          expect(tester.channelState?.pinnedMessages.length, equals(2));
          expect(
            tester.channelState?.pinnedMessages.first.id,
            equals(firstMessageId),
          );
          expect(
            tester.channelState?.pinnedMessages[1].id,
            equals(secondMessageId),
          );
        },
      );

      channelTest(
        "should update 'channel.state.pinnedMessages' and should remove message from pinned messages if updatedMessage.pinned is false",
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const messageId = 'test-message-id';
          final pinnedMessage = Message(
            id: messageId,
            user: tester.currentUser,
            pinned: true,
          );

          await tester.emitEvent(_updateMessageEvent(pinnedMessage));

          expect(tester.channelState?.pinnedMessages.length, equals(1));
          expect(tester.channelState?.pinnedMessages.first.id, equals(messageId));

          final unpinnedMessage = pinnedMessage.copyWith(pinned: false);
          await tester.emitEvent(_updateMessageEvent(unpinnedMessage));

          expect(tester.channelState?.pinnedMessages, isEmpty);
        },
      );

      group('when message is outside the loaded window', () {
        channelTest(
          'should NOT insert unknown message into `messages` list',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            // Simulate "we have the latest page but not older history":
            // seed the tail messages.
            final tail = List.generate(
              3,
              (i) => Message(
                id: 'tail-$i',
                user: tester.currentUser,
                text: 'tail $i',
                createdAt: DateTime.utc(2026, 6, 1).add(Duration(seconds: i)),
              ),
            );
            tester.channelState!.updateChannelState(
              tester.channelState!.channelState.copyWith(messages: tail),
            );
            expect(tester.channelState!.messages, hasLength(3));

            // Event for a message on an older page we don't have loaded.
            final olderPageEdit = Message(
              id: 'older-page-msg',
              user: tester.currentUser,
              text: 'edited on older page',
              createdAt: DateTime.utc(2025, 1, 1),
            );
            await tester.emitEvent(_updateMessageEvent(olderPageEdit));

            // Tail is unchanged, no phantom entry inserted at position 0.
            expect(tester.channelState!.messages.map((m) => m.id), ['tail-0', 'tail-1', 'tail-2']);
            expect(tester.channelState!.pinnedMessages, isEmpty);
          },
        );

        channelTest(
          'should update message in place when it IS in the loaded window',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            const messageId = 'known';
            final seeded = Message(
              id: messageId,
              user: tester.currentUser,
              text: 'old',
              createdAt: DateTime.utc(2026),
            );
            tester.channelState!.updateChannelState(
              tester.channelState!.channelState.copyWith(messages: [seeded]),
            );
            tester.channelState!.isUpToDate = false;

            final edited = seeded.copyWith(text: 'new');
            await tester.emitEvent(_updateMessageEvent(edited));

            final stored = tester.channelState!.messages.singleWhere((m) => m.id == messageId);
            expect(stored.text, equals('new'));
          },
        );

        channelTest(
          'should still add to pinnedMessages when pinned:true even if not in loaded window',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            tester.channelState!.isUpToDate = false;
            expect(tester.channelState!.messages, isEmpty);
            expect(tester.channelState!.pinnedMessages, isEmpty);

            const messageId = 'pin-me';
            final pinned = Message(
              id: messageId,
              user: tester.currentUser,
              pinned: true,
            );
            await tester.emitEvent(_updateMessageEvent(pinned));

            expect(tester.channelState!.messages, isEmpty);
            expect(tester.channelState!.pinnedMessages.length, equals(1));
            expect(tester.channelState!.pinnedMessages.first.id, equals(messageId));
          },
        );

        channelTest(
          'should NOT insert unknown reply into threads[parentId]',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            const parentId = 'parent-1';
            final knownReply = Message(
              id: 'known-reply',
              parentId: parentId,
              user: tester.currentUser,
              createdAt: DateTime.utc(2026),
            );
            // Populate threads[parentId] via addNewMessage's thread-only path.
            tester.channelState!.addNewMessage(knownReply);
            await Future.delayed(Duration.zero);
            expect(tester.channelState!.threads[parentId], hasLength(1));

            tester.channelState!.isUpToDate = false;

            final phantomReply = Message(
              id: 'other-reply',
              parentId: parentId,
              user: tester.currentUser,
              text: 'edited',
              createdAt: DateTime.utc(2026, 1, 2),
            );
            await tester.emitEvent(_updateMessageEvent(phantomReply));

            expect(tester.channelState!.threads[parentId]!.map((m) => m.id), ['known-reply']);
          },
        );

        channelTest(
          'should NOT create phantom threads[parentId] entry for unloaded thread',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            const parentId = 'unloaded-parent';
            // The thread was never paged in, so there's no entry for it.
            expect(tester.channelState!.threads.containsKey(parentId), isFalse);

            tester.channelState!.isUpToDate = false;

            final phantomReply = Message(
              id: 'phantom-reply',
              parentId: parentId,
              user: tester.currentUser,
              text: 'edited',
              createdAt: DateTime.utc(2026, 1, 2),
            );
            await tester.emitEvent(_updateMessageEvent(phantomReply));

            // The dropped reply must not leave behind an empty thread entry.
            expect(tester.channelState!.threads.containsKey(parentId), isFalse);
          },
        );

        channelTest(
          'should still expire activeLiveLocations for out-of-window message',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            final liveLocation = Location(
              channelCid: tester.channel.cid,
              userId: 'user1',
              messageId: 'loc-msg',
              latitude: 40.7128,
              longitude: -74.0060,
              createdByDeviceId: 'device1',
              endAt: DateTime.now().add(const Duration(hours: 1)),
            );

            // Seed only activeLiveLocations, keeping `messages` empty —
            // the exact "message is outside the loaded window" scenario.
            tester.channelState!.updateChannelState(
              ChannelState(
                channel: tester.channelState!.channelState.channel,
                activeLiveLocations: [liveLocation],
              ),
            );
            tester.channelState!.isUpToDate = false;
            expect(tester.channelState!.messages, isEmpty);
            expect(tester.channelState!.activeLiveLocations, hasLength(1));

            // A message.updated that expires the live location.
            final expiredMessage = Message(
              id: 'loc-msg',
              text: 'Live location shared',
              sharedLocation: liveLocation.copyWith(
                endAt: DateTime.now().subtract(const Duration(minutes: 1)),
              ),
            );
            // Applied directly, the way the `message.updated` listener would:
            // a WS `message.updated` carrying an expired live location is
            // rerouted by `locationExpiredResolver` to `location.expired` before
            // channel state sees it, and that handler no-ops when the message is
            // not loaded. This keeps the state-layer guard itself pinned.
            tester.channelState!.updateMessage(expiredMessage, upsert: false);
            await Future.delayed(Duration.zero);

            expect(tester.channelState!.messages, isEmpty);
            expect(tester.channelState!.activeLiveLocations, isEmpty);
          },
        );
      });
    });

    group('reply events with `show_in_channel = true` and unloaded thread', () {
      const _replyId = 'mirrored-reply-id';

      const _parentId = 'parent-message-id';

      // Pinned createdAt keeps oldIndex lookups stable in `updateMessage`.
      final _createdAt = DateTime.utc(2026);

      ChannelState _seedChannel(ChannelState _) {
        return createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: const [ChannelCapability.readEvents],
          ),
        );
      }

      // Seeds a single reply into the channel-level `messages` while leaving
      // `threads[parentId]` empty — the exact regression scenario.
      Message _seedMirroredReply(
        ChannelTester tester, {
        List<Reaction> ownReactions = const [],
        Poll? poll,
      }) {
        final reply = Message(
          id: _replyId,
          parentId: _parentId,
          showInChannel: true,
          user: tester.currentUser,
          createdAt: _createdAt,
          ownReactions: ownReactions,
          poll: poll,
          pollId: poll?.id,
        );
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(messages: [reply]),
        );
        return reply;
      }

      // A reply with `show_in_channel = true` is mirrored into both `messages`
      // and `threads[parentId]`. When the thread isn't loaded (fresh hydration,
      // user never opened the thread) the channel-level copy is the only place
      // locally-cached fields like `ownReactions`/`poll` survive — so reaction
      // and message-update events for such replies must still find it.

      channelTest(
        '`reaction.new` from another user preserves `ownReactions`',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final ownReaction = Reaction(
            type: 'like',
            messageId: _replyId,
            user: tester.currentUser,
          );
          _seedMirroredReply(tester, ownReactions: [ownReaction]);
          // Pre-condition: thread is not loaded.
          expect(tester.channelState!.threads, isEmpty);

          // Server reaction events don't echo back the recipient's own
          // reactions, so the listener must pull them from the cached copy.
          final otherUserReaction = Reaction(
            type: 'love',
            messageId: _replyId,
            user: User(id: 'other-user'),
          );
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reactionNew,
              reaction: otherUserReaction,
              message: Message(
                id: _replyId,
                parentId: _parentId,
                showInChannel: true,
                user: tester.currentUser,
                createdAt: _createdAt,
                latestReactions: [otherUserReaction],
              ),
            ),
          );

          final stored = tester.channelState!.messages.firstWhere((it) => it.id == _replyId);
          expect(stored.ownReactions, [ownReaction]);
        },
      );

      channelTest(
        '`reaction.deleted` strips only the removed reaction',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final kept = Reaction(
            type: 'like',
            messageId: _replyId,
            user: tester.currentUser,
          );
          final removed = Reaction(
            type: 'love',
            messageId: _replyId,
            user: tester.currentUser,
          );
          _seedMirroredReply(tester, ownReactions: [kept, removed]);
          expect(tester.channelState!.threads, isEmpty);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reactionDeleted,
              reaction: removed,
              message: Message(
                id: _replyId,
                parentId: _parentId,
                showInChannel: true,
                user: tester.currentUser,
                createdAt: _createdAt,
              ),
            ),
          );

          final stored = tester.channelState!.messages.firstWhere((it) => it.id == _replyId);
          expect(stored.ownReactions, [kept]);
        },
      );

      channelTest(
        '`message.updated` preserves `poll`, `pollId`, and `ownReactions`',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final ownReaction = Reaction(
            type: 'like',
            messageId: _replyId,
            user: tester.currentUser,
          );
          // Partial server updates can omit poll/pollId/ownReactions; the
          // cached copy is what backfills them.
          final poll = Poll(
            id: 'poll-1',
            name: 'Pick one',
            options: const [
              PollOption(text: 'A'),
              PollOption(text: 'B'),
            ],
          );
          _seedMirroredReply(tester, ownReactions: [ownReaction], poll: poll);
          expect(tester.channelState!.threads, isEmpty);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.messageUpdated,
              message: Message(
                id: _replyId,
                parentId: _parentId,
                showInChannel: true,
                user: tester.currentUser,
                createdAt: _createdAt,
                text: 'edited',
              ),
            ),
          );

          final stored = tester.channelState!.messages.firstWhere((it) => it.id == _replyId);
          expect(stored.ownReactions, [ownReaction]);
          expect(stored.poll?.id, poll.id);
          expect(stored.pollId, poll.id);
        },
      );
    });

    group('Reaction events', () {
      const _messageId = 'reaction-message-id';

      // Pinned createdAt keeps message index lookups stable in `updateMessage`.
      final _createdAt = DateTime.utc(2021, 3);

      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid),
        );
      }

      Message _seedMessage(ChannelTester tester, {String? parentId, List<Reaction> ownReactions = const []}) {
        final message = Message(
          id: _messageId,
          parentId: parentId,
          user: User(id: 'other-user'),
          text: 'react to me',
          createdAt: _createdAt,
          ownReactions: ownReactions,
        );
        tester.channelState!.updateMessage(message);
        return message;
      }

      channelTest(
        '${EventType.reactionNew} from the current user is added to ownReactions',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          _seedMessage(tester);

          final reaction = Reaction(
            type: 'like',
            messageId: _messageId,
            user: tester.currentUser,
          );
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reactionNew,
              reaction: reaction,
              message: Message(
                id: _messageId,
                user: User(id: 'other-user'),
                createdAt: _createdAt,
                latestReactions: [reaction],
              ),
            ),
          );

          final stored = tester.channelState!.messages.firstWhere((it) => it.id == _messageId);
          expect(stored.ownReactions?.map((r) => r.type), ['like']);
        },
      );

      channelTest(
        '${EventType.reactionNew} updates a thread message',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const parentId = 'reaction-parent-id';
          _seedMessage(tester, parentId: parentId);

          final reaction = Reaction(
            type: 'like',
            messageId: _messageId,
            user: tester.currentUser,
          );
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reactionNew,
              reaction: reaction,
              message: Message(
                id: _messageId,
                parentId: parentId,
                user: User(id: 'other-user'),
                createdAt: _createdAt,
              ),
            ),
          );

          final stored = tester.channelState!.threads[parentId]!.firstWhere((it) => it.id == _messageId);
          expect(stored.ownReactions?.map((r) => r.type), ['like']);
        },
      );

      channelTest(
        '${EventType.reactionUpdated} from the current user replaces ownReactions',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final existing = Reaction(
            type: 'love',
            messageId: _messageId,
            user: tester.currentUser,
          );
          _seedMessage(tester, ownReactions: [existing]);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reactionUpdated,
              reaction: Reaction(
                type: 'like',
                messageId: _messageId,
                user: tester.currentUser,
              ),
              message: Message(
                id: _messageId,
                user: User(id: 'other-user'),
                createdAt: _createdAt,
              ),
            ),
          );

          final stored = tester.channelState!.messages.firstWhere((it) => it.id == _messageId);
          expect(stored.ownReactions?.map((r) => r.type), ['like']);
        },
      );

      channelTest(
        '${EventType.reactionDeleted} updates a thread message',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const parentId = 'reaction-parent-id';
          final removed = Reaction(
            type: 'love',
            messageId: _messageId,
            user: tester.currentUser,
          );
          _seedMessage(tester, parentId: parentId, ownReactions: [removed]);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reactionDeleted,
              reaction: removed,
              message: Message(
                id: _messageId,
                parentId: parentId,
                user: User(id: 'other-user'),
                createdAt: _createdAt,
              ),
            ),
          );

          final stored = tester.channelState!.threads[parentId]!.firstWhere((it) => it.id == _messageId);
          expect(stored.ownReactions, isEmpty);
        },
      );
    });

    group('Poll events', () {
      const _pollMessageId = 'poll-message-id';

      const _pollId = 'poll-id';

      final _createdAt = DateTime.utc(2021, 3);

      ChannelState _seedChannel(ChannelState _) =>
          createDefaultChannelState(channel: createDefaultChannelModel(cid: _channelCid));

      Poll _createPoll({
        String name = 'Favorite color?',
        List<PollVote> latestAnswers = const [],
        List<PollVote> ownVotesAndAnswers = const [],
      }) {
        return Poll(
          id: _pollId,
          name: name,
          options: const [
            PollOption(id: 'option-a', text: 'A'),
            PollOption(id: 'option-b', text: 'B'),
          ],
          latestAnswers: latestAnswers,
          ownVotesAndAnswers: ownVotesAndAnswers,
        );
      }

      Message _seedPollMessage(
        ChannelTester tester, {
        String? parentId,
        List<PollVote> latestAnswers = const [],
        List<PollVote> ownVotesAndAnswers = const [],
      }) {
        final message = Message(
          id: _pollMessageId,
          parentId: parentId,
          user: User(id: 'other-user'),
          createdAt: _createdAt,
          poll: _createPoll(
            latestAnswers: latestAnswers,
            ownVotesAndAnswers: ownVotesAndAnswers,
          ),
        );
        tester.channelState!.updateMessage(message);
        return message;
      }

      Message _storedPollMessage(ChannelTester tester) {
        return tester.channelState!.messages.firstWhere((it) => it.id == _pollMessageId);
      }

      channelTest(
        '${EventType.pollCreated} adds the poll message',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollCreated,
              message: Message(
                id: _pollMessageId,
                user: User(id: 'other-user'),
                createdAt: _createdAt,
                poll: _createPoll(),
              ),
            ),
          );

          expect(_storedPollMessage(tester).poll?.id, _pollId);
        },
      );

      channelTest(
        '${EventType.pollCreated} without a poll is ignored',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollCreated,
              message: Message(
                id: _pollMessageId,
                user: User(id: 'other-user'),
                createdAt: _createdAt,
              ),
            ),
          );

          expect(tester.channelState!.messages, isEmpty);
        },
      );

      channelTest(
        '${EventType.pollUpdated} updates the poll but preserves own votes',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final ownVote = PollVote(
            id: 'own-vote-id',
            optionId: 'option-a',
            userId: tester.currentUser!.id,
          );
          _seedPollMessage(tester, ownVotesAndAnswers: [ownVote]);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollUpdated,
              poll: _createPoll(name: 'Renamed'),
            ),
          );

          final stored = _storedPollMessage(tester);
          expect(stored.poll?.name, 'Renamed');
          expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-vote-id']);
        },
      );

      channelTest(
        '${EventType.pollUpdated} for an unknown poll is ignored',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          _seedPollMessage(tester);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollUpdated,
              poll: Poll(
                id: 'unknown-poll-id',
                name: 'Renamed',
                options: const [PollOption(text: 'A')],
              ),
            ),
          );

          expect(_storedPollMessage(tester).poll?.name, 'Favorite color?');
        },
      );

      channelTest(
        '${EventType.pollUpdated} without a poll is ignored',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          _seedPollMessage(tester);

          await tester.emitEvent(createDefaultEvent(cid: tester.channel.cid, type: EventType.pollUpdated));

          expect(_storedPollMessage(tester).poll?.name, 'Favorite color?');
        },
      );

      channelTest(
        '${EventType.pollUpdated} updates a poll on a thread message',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const parentId = 'poll-parent-id';
          _seedPollMessage(tester, parentId: parentId);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollUpdated,
              poll: _createPoll(name: 'Renamed'),
            ),
          );

          final stored = tester.channelState!.threads[parentId]!.firstWhere((it) => it.id == _pollMessageId);
          expect(stored.poll?.name, 'Renamed');
        },
      );

      channelTest(
        '${EventType.pollClosed} closes the poll and keeps the cached data',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          _seedPollMessage(tester);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollClosed,
              poll: _createPoll(name: 'Renamed'),
            ),
          );

          final stored = _storedPollMessage(tester);
          expect(stored.poll?.isClosed, isTrue);
          expect(stored.poll?.name, 'Favorite color?');
        },
      );

      channelTest(
        '${EventType.pollAnswerCasted} adds own answers only for the current user',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          _seedPollMessage(tester);

          final ownAnswer = PollVote(
            id: 'own-answer-id',
            answerText: 'my answer',
            userId: tester.currentUser!.id,
          );
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollAnswerCasted,
              poll: _createPoll(),
              pollVote: ownAnswer,
            ),
          );

          var stored = _storedPollMessage(tester);
          expect(stored.poll?.latestAnswers.map((v) => v.id), ['own-answer-id']);
          expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-answer-id']);

          final otherAnswer = PollVote(
            id: 'other-answer-id',
            answerText: 'their answer',
            userId: 'other-user',
          );
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollAnswerCasted,
              poll: _createPoll(),
              pollVote: otherAnswer,
            ),
          );

          stored = _storedPollMessage(tester);
          expect(stored.poll?.latestAnswers.map((v) => v.id), contains('other-answer-id'));
          expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-answer-id']);
        },
      );

      channelTest(
        '${EventType.pollVoteCasted} adds own votes only for the current user',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          _seedPollMessage(tester);

          final ownVote = PollVote(
            id: 'own-vote-id',
            optionId: 'option-a',
            userId: tester.currentUser!.id,
          );
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollVoteCasted,
              poll: _createPoll(),
              pollVote: ownVote,
            ),
          );

          var stored = _storedPollMessage(tester);
          expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-vote-id']);

          final otherVote = PollVote(
            id: 'other-vote-id',
            optionId: 'option-b',
            userId: 'other-user',
          );
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollVoteCasted,
              poll: _createPoll(),
              pollVote: otherVote,
            ),
          );

          stored = _storedPollMessage(tester);
          expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-vote-id']);
        },
      );

      channelTest(
        '${EventType.pollVoteChanged} upserts the current user vote',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          _seedPollMessage(tester);

          final changedVote = PollVote(
            id: 'changed-vote-id',
            optionId: 'option-b',
            userId: tester.currentUser!.id,
          );
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollVoteChanged,
              poll: _createPoll(),
              pollVote: changedVote,
            ),
          );

          expect(
            _storedPollMessage(tester).poll?.ownVotesAndAnswers.map((v) => v.id),
            contains('changed-vote-id'),
          );
        },
      );

      channelTest(
        '${EventType.pollAnswerRemoved} removes the answer from both lists',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final answer = PollVote(
            id: 'answer-id',
            answerText: 'my answer',
            userId: tester.currentUser!.id,
          );
          _seedPollMessage(tester, latestAnswers: [answer], ownVotesAndAnswers: [answer]);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollAnswerRemoved,
              poll: _createPoll(),
              pollVote: answer,
            ),
          );

          final stored = _storedPollMessage(tester);
          expect(stored.poll?.latestAnswers, isEmpty);
          expect(stored.poll?.ownVotesAndAnswers, isEmpty);
        },
      );

      channelTest(
        '${EventType.pollVoteRemoved} removes the vote from own votes',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final vote = PollVote(
            id: 'vote-id',
            optionId: 'option-a',
            userId: tester.currentUser!.id,
          );
          _seedPollMessage(tester, ownVotesAndAnswers: [vote]);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.pollVoteRemoved,
              poll: _createPoll(),
              pollVote: vote,
            ),
          );

          expect(_storedPollMessage(tester).poll?.ownVotesAndAnswers, isEmpty);
        },
      );
    });

    group(EventType.messageDeleted, () {
      final _deletedAt = DateTime.utc(2026, 7);

      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: const [ChannelCapability.readEvents],
          ),
        );
      }

      Event _deleteMessageEvent(Message message, {bool hardDelete = false}) {
        return createDefaultEvent(
          cid: _channelCid,
          type: EventType.messageDeleted,
          message: message.copyWith(
            type: MessageType.deleted,
            deletedAt: _deletedAt,
          ),
          hardDelete: hardDelete,
        );
      }

      // A `message.deleted` event for a message outside the loaded window
      // must not upsert a "deleted" record into the sorted list — that would
      // create a phantom entry with a gap. Pinned + live-location
      // side-effects must still fire.

      // Same design as the `messageUpdated` guards: the check is
      // "message-in-loaded-window" and is independent of `isUpToDate` —
      // an event for a message on an older, unloaded page must not be
      // turned into a phantom "deleted" record inserted into the sorted
      // list.

      group('when message is outside the loaded window', () {
        channelTest(
          'soft delete does NOT insert phantom "deleted" record into messages',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            final tail = List.generate(
              3,
              (i) => Message(
                id: 'tail-$i',
                user: tester.currentUser,
                text: 'tail $i',
                createdAt: DateTime.utc(2026, 6, 1).add(Duration(seconds: i)),
              ),
            );
            tester.channelState!.updateChannelState(
              tester.channelState!.channelState.copyWith(messages: tail),
            );
            expect(tester.channelState!.messages, hasLength(3));

            final olderPage = Message(
              id: 'older-page-msg',
              user: tester.currentUser,
              text: 'gone',
              createdAt: DateTime.utc(2025, 1, 1),
            );
            await tester.emitEvent(_deleteMessageEvent(olderPage));

            expect(tester.channelState!.messages.map((m) => m.id), ['tail-0', 'tail-1', 'tail-2']);
          },
        );

        channelTest(
          'soft delete marks message as deleted when it IS in the loaded window',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            const messageId = 'known';
            final seeded = Message(
              id: messageId,
              user: tester.currentUser,
              text: 'hi',
              createdAt: DateTime.utc(2026),
            );
            tester.channelState!.updateChannelState(
              tester.channelState!.channelState.copyWith(messages: [seeded]),
            );
            tester.channelState!.isUpToDate = false;

            await tester.emitEvent(_deleteMessageEvent(seeded));

            final stored = tester.channelState!.messages.singleWhere((m) => m.id == messageId);
            expect(stored.type, equals(MessageType.deleted));
            expect(stored.deletedAt, isNotNull);
          },
        );

        channelTest(
          'soft delete unpins a pinned-but-not-in-window message via _pinIsValid',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            const messageId = 'pinned-msg';
            final pinned = Message(
              id: messageId,
              user: tester.currentUser,
              pinned: true,
              createdAt: DateTime.utc(2026),
            );
            // Seed only the pinnedMessages list — message absent from
            // the main `messages` window.
            tester.channelState!.updateChannelState(
              tester.channelState!.channelState.copyWith(pinnedMessages: [pinned]),
            );
            tester.channelState!.isUpToDate = false;
            expect(tester.channelState!.messages, isEmpty);
            expect(tester.channelState!.pinnedMessages, hasLength(1));

            await tester.emitEvent(_deleteMessageEvent(pinned));

            expect(tester.channelState!.messages, isEmpty);
            expect(tester.channelState!.pinnedMessages, isEmpty);
          },
        );

        channelTest(
          'soft delete still clears activeLiveLocations even when message not in window',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            final liveLocation = Location(
              channelCid: tester.channel.cid,
              userId: 'user1',
              messageId: 'loc-msg',
              latitude: 40.7128,
              longitude: -74.0060,
              createdByDeviceId: 'device1',
              endAt: DateTime.timestamp().add(const Duration(hours: 1)),
            );

            // Seed only activeLiveLocations, keeping `messages` empty.
            tester.channelState!.updateChannelState(
              ChannelState(
                channel: tester.channelState!.channelState.channel,
                activeLiveLocations: [liveLocation],
              ),
            );
            tester.channelState!.isUpToDate = false;
            expect(tester.channelState!.messages, isEmpty);
            expect(tester.channelState!.activeLiveLocations, hasLength(1));

            final locationMessage = Message(
              id: 'loc-msg',
              text: 'Live location shared',
              sharedLocation: liveLocation,
            );
            await tester.emitEvent(_deleteMessageEvent(locationMessage));

            expect(tester.channelState!.messages, isEmpty);
            expect(tester.channelState!.activeLiveLocations, isEmpty);
          },
        );

        channelTest(
          'hard delete is a no-op when message is not in the loaded window',
          channelType: _channelType,
          channelId: _channelId,
          setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
          body: (tester) async {
            tester.channelState!.isUpToDate = false;
            expect(tester.channelState!.messages, isEmpty);

            final phantom = Message(
              id: 'phantom',
              user: tester.currentUser,
              text: 'gone',
              createdAt: DateTime.utc(2026),
            );
            await tester.emitEvent(_deleteMessageEvent(phantom, hardDelete: true));

            expect(tester.channelState!.messages, isEmpty);
            expect(tester.channelState!.pinnedMessages, isEmpty);
          },
        );
      });

      channelTest(
        'an in-window hard delete removes the message',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'doomed-message-id',
            user: User(id: 'other-user'),
            createdAt: DateTime.utc(2026),
          );
          tester.channelState!.updateMessage(message);
          expect(tester.channelState!.messages, hasLength(1));

          await tester.emitEvent(_deleteMessageEvent(message, hardDelete: true));

          expect(tester.channelState!.messages, isEmpty);
        },
      );

      channelTest(
        'deletedForMe is propagated to the stored message',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final message = Message(
            id: 'deleted-for-me-message-id',
            user: User(id: 'other-user'),
            createdAt: DateTime.utc(2026),
          );
          tester.channelState!.updateMessage(message);

          await tester.emitEvent(
            createDefaultEvent(
              cid: _channelCid,
              type: EventType.messageDeleted,
              deletedForMe: true,
              message: message.copyWith(
                type: MessageType.deleted,
                deletedAt: _deletedAt,
              ),
            ),
          );

          final stored = tester.channelState!.messages.single;
          expect(stored.deletedForMe, isTrue);
          expect(stored.type, MessageType.deleted);
        },
      );
    });

    group('Channel updated events', () {
      ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
      );

      channelTest(
        'merges the event channel into the current channel model',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.channelUpdated,
              channel: createDefaultChannelModel(
                cid: _channelCid,
                memberCount: 42,
                extraData: const {'name': 'updated-name'},
              ),
            ),
          );

          expect(tester.channel.memberCount, 42);
          expect(tester.channel.extraData['name'], 'updated-name');
        },
      );

      channelTest(
        'replaces the member list with the event members',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(
              members: [
                Member(userId: 'member-1'),
                Member(userId: 'member-2'),
              ],
            ),
          );

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.channelUpdated,
              channel: createDefaultChannelModel(
                cid: _channelCid,
                members: [Member(userId: 'member-3')],
              ),
            ),
          );

          expect(tester.channelState!.channelState.members?.map((m) => m.userId), ['member-3']);
        },
      );
    });

    group('Channel truncated events', () {
      final _seededCreatedAt = DateTime.utc(2021, 3);

      ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
      );

      // Stubs every persistence call the harness makes on the way to a truncation:
      // `updateConnectionInfo` on connect, `getChannelThreads` when the channel
      // state initializes, and `deleteMessageByCid` from the truncation handler.
      MockPersistenceClient _createPersistenceClient() {
        registerFallbackValue(createDefaultEvent());
        final persistenceClient = MockPersistenceClient();
        when(() => persistenceClient.updateConnectionInfo(any())).thenAnswer((_) async {});
        when(() => persistenceClient.getChannelThreads(_channelCid)).thenAnswer((_) async => {});
        when(() => persistenceClient.deleteMessageByCid(_channelCid)).thenAnswer((_) async {});
        return persistenceClient;
      }

      Message _seedMessage(ChannelTester tester, String id, {DateTime? createdAt}) {
        final message = Message(
          id: id,
          user: User(id: 'other-user'),
          text: 'to be truncated',
          createdAt: createdAt ?? _seededCreatedAt,
        );
        tester.channelState!.updateMessage(message);
        return message;
      }

      final truncatedPersistence = _createPersistenceClient();

      final notifiedPersistence = _createPersistenceClient();

      channelTest(
        '${EventType.channelTruncated} clears messages and wipes persistence',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: truncatedPersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          _seedMessage(tester, 'truncated-message-1');
          _seedMessage(tester, 'truncated-message-2', createdAt: _seededCreatedAt.add(const Duration(seconds: 1)));
          expect(tester.channelState!.messages, hasLength(2));

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.channelTruncated,
              channel: createDefaultChannelModel(cid: _channelCid),
            ),
          );

          expect(tester.channelState!.messages, isEmpty);
          verify(() => truncatedPersistence.deleteMessageByCid(tester.channel.cid!)).called(1);
        },
      );

      channelTest(
        '${EventType.notificationChannelTruncated} keeps the event system message',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: notifiedPersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          _seedMessage(tester, 'truncated-message-1');

          final systemMessage = Message(
            id: 'system-message-id',
            type: MessageType.system,
            text: 'Channel truncated',
            createdAt: _seededCreatedAt.add(const Duration(seconds: 1)),
          );
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.notificationChannelTruncated,
              channel: createDefaultChannelModel(cid: _channelCid),
              message: systemMessage,
            ),
          );

          expect(tester.channelState!.messages.map((m) => m.id), ['system-message-id']);
        },
      );
    });

    group('Member Events', () {
      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid),
        );
      }

      channelTest(
        'should update membership when member is updated and is current user',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final currentUser = tester.currentUser;
          final currentMember = Member(user: currentUser);
          final now = DateTime.utc(2021, 3);

          // Setup initial membership
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              members: [currentMember],
              membership: currentMember,
            ),
          );

          // Verify initial state
          expect(tester.channel.membership, isNotNull);
          expect(tester.channel.membership?.channelRole, isNull);
          expect(tester.channel.membership?.isModerator, false);
          expect(tester.channel.isPinned, isFalse);
          expect(tester.channel.isArchived, isFalse);

          // Create updated member with same userId but updated properties
          final updatedMember = currentMember.copyWith(
            channelRole: 'moderator',
            isModerator: true,
            pinnedAt: now,
            archivedAt: now,
          );

          // Create member updated event
          final memberUpdatedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.memberUpdated,
            user: currentUser,
            member: updatedMember,
          );

          // Dispatch event
          await tester.emitEvent(memberUpdatedEvent);

          // Verify membership is updated with new properties
          expect(tester.channel.membership, isNotNull);
          expect(tester.channel.membership?.userId, equals(currentUser?.id));
          expect(tester.channel.membership?.channelRole, equals('moderator'));
          expect(tester.channel.membership?.isModerator, isTrue);
          expect(tester.channel.isPinned, isTrue);
          expect(tester.channel.isArchived, isTrue);
        },
      );

      channelTest(
        'should update membership user when any event containing user is updated',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final currentUser = tester.currentUser;
          final currentMember = Member(user: currentUser);

          // Setup initial membership
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              members: [currentMember],
              membership: currentMember,
            ),
          );

          // Verify initial state
          expect(tester.channel.membership, isNotNull);
          expect(tester.channel.membership?.user?.id, equals(currentUser?.id));
          expect(tester.channel.membership?.user?.role, equals(currentUser?.role));

          // Create updated user with same userId but updated properties
          final updatedUser = currentUser?.copyWith(role: 'moderator');

          // Create any event with same updated user as membership.
          final anyEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.any,
            user: updatedUser,
          );

          // Dispatch event
          await tester.emitEvent(anyEvent);

          // Verify membership is updated with new properties
          expect(tester.channel.membership, isNotNull);
          expect(tester.channel.membership?.user?.id, equals(updatedUser?.id));
          expect(tester.channel.membership?.user?.role, equals(updatedUser?.role));
        },
      );

      channelTest(
        '${EventType.memberAdded} appends the member',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.memberAdded,
              member: Member(userId: 'new-member'),
            ),
          );

          expect(tester.channelState!.channelState.members?.map((m) => m.userId), ['new-member']);
        },
      );

      channelTest(
        '${EventType.memberRemoved} removes the member and its read state',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(
              members: [
                Member(userId: 'member-1'),
                Member(userId: 'member-2'),
              ],
              read: [
                Read(
                  user: User(id: 'member-1'),
                  lastRead: DateTime.utc(2020),
                ),
                Read(
                  user: User(id: 'member-2'),
                  lastRead: DateTime.utc(2020),
                ),
              ],
            ),
          );

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.memberRemoved,
              user: User(id: 'member-1'),
            ),
          );

          expect(tester.channelState!.channelState.members?.map((m) => m.userId), ['member-2']);
          expect(tester.channelState!.channelState.read?.map((r) => r.user.id), ['member-2']);
        },
      );

      channelTest(
        '${EventType.memberRemoved} clears the read state of the only member',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(
              members: [Member(userId: 'member-1')],
              read: [
                Read(
                  user: User(id: 'member-1'),
                  lastRead: DateTime.utc(2020),
                ),
              ],
            ),
          );

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.memberRemoved,
              user: User(id: 'member-1'),
            ),
          );

          expect(tester.channelState!.channelState.members, isEmpty);
          expect(tester.channelState!.channelState.read, isEmpty);
        },
      );

      channelTest(
        '${EventType.memberUpdated} replaces the member entry',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(
              members: [Member(userId: 'member-1', channelRole: 'channel_member')],
            ),
          );

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.memberUpdated,
              member: Member(userId: 'member-1', channelRole: 'channel_moderator'),
            ),
          );

          expect(tester.channelState!.channelState.members?.single.channelRole, 'channel_moderator');
        },
      );

      channelTest(
        'an event user that is not a member is ignored',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(
              members: [
                Member(
                  userId: 'member-1',
                  user: User(id: 'member-1', name: 'old-name'),
                ),
              ],
            ),
          );

          // The merge runs unfiltered on every event carrying a user, so a
          // non-member must not write state at all — an equal-but-new state
          // would still notify every listener.
          final before = tester.channelState!.channelState;

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.userUpdated,
              user: User(id: 'stranger', name: 'new-name'),
            ),
          );

          expect(tester.channelState!.channelState.members?.single.user?.name, 'old-name');
          expect(identical(before, tester.channelState!.channelState), isTrue);
        },
      );

      group('user banned/unbanned events', () {
        Future<void> setUpBannedMember(ChannelTester tester) async {
          await tester.watch(modifyResponse: _seedChannel());

          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(
              members: [
                Member(
                  userId: 'bad-user',
                  user: User(id: 'bad-user'),
                  channelRole: 'channel_member',
                ),
              ],
            ),
          );

          tester.mockApi(
            (api) => api.general.queryMembers(
              _channelType,
              channelId: _channelId,
              filter: any(
                named: 'filter',
                that: isSameFilterAs(
                  MemberFilter.equal(MemberFilterField.userId, 'bad-user'),
                ),
              ),
              members: any(named: 'members'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
            result: QueryMembersResponse()..members = [Member(userId: 'bad-user', channelRole: 'channel_banned')],
          );
        }

        channelTest(
          '${EventType.userBanned} refreshes the member from the server',
          channelType: _channelType,
          channelId: _channelId,
          setUp: setUpBannedMember,
          body: (tester) async {
            await tester.emitEvent(
              createDefaultEvent(
                cid: tester.channel.cid,
                type: EventType.userBanned,
                user: User(id: 'bad-user'),
              ),
            );

            expect(tester.channelState!.channelState.members?.single.channelRole, 'channel_banned');
          },
        );

        channelTest(
          '${EventType.userUnbanned} refreshes the member from the server',
          channelType: _channelType,
          channelId: _channelId,
          setUp: setUpBannedMember,
          body: (tester) async {
            await tester.emitEvent(
              createDefaultEvent(
                cid: tester.channel.cid,
                type: EventType.userUnbanned,
                user: User(id: 'bad-user'),
              ),
            );

            expect(tester.channelState!.channelState.members?.single.channelRole, 'channel_banned');
          },
        );

        channelTest(
          'an app-level ban without a cid is ignored',
          channelType: _channelType,
          channelId: _channelId,
          setUp: setUpBannedMember,
          body: (tester) async {
            await tester.emitEvent(
              createDefaultEvent(
                type: EventType.userBanned,
                user: User(id: 'bad-user'),
              ),
            );

            expect(tester.channelState!.channelState.members?.single.channelRole, 'channel_member');
            tester.verifyNeverCalled(
              (api) => api.general.queryMembers(
                any(),
                channelId: any(named: 'channelId'),
                filter: any(named: 'filter'),
                members: any(named: 'members'),
                sort: any(named: 'sort'),
                pagination: any(named: 'pagination'),
              ),
            );
          },
        );
      });
    });

    group('Watching Events', () {
      final _messageCreatedAt = DateTime.utc(2021, 3);

      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: const [ChannelCapability.readEvents],
          ),
        );
      }

      channelTest(
        '${EventType.userWatchingStart} adds the watcher and updates watcherCount',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final watcher = User(id: 'watcher-1');

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.userWatchingStart,
              user: watcher,
              watcherCount: 3,
            ),
          );

          expect(tester.channelState!.watcherCount, 3);
          expect(
            tester.channelState!.channelState.watchers?.map((it) => it.id),
            contains('watcher-1'),
          );
        },
      );

      channelTest(
        '${EventType.userWatchingStop} removes the watcher and updates watcherCount',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final watcher = User(id: 'watcher-1');

          // The watcher starts watching first (count = 2).
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.userWatchingStart,
              user: watcher,
              watcherCount: 2,
            ),
          );
          expect(tester.channelState!.watcherCount, 2);
          expect(
            tester.channelState!.channelState.watchers?.map((it) => it.id),
            contains('watcher-1'),
          );

          // Then stops watching (count = 1).
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.userWatchingStop,
              user: watcher,
              watcherCount: 1,
            ),
          );

          expect(tester.channelState!.watcherCount, 1);
          expect(
            tester.channelState!.channelState.watchers?.map((it) => it.id),
            isNot(contains('watcher-1')),
          );
        },
      );

      channelTest(
        'watching event without watcherCount preserves the existing count',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          // Seed an initial watcher count.
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(watcherCount: 5),
          );
          expect(tester.channelState!.watcherCount, 5);

          // A watching event that omits watcher_count must not wipe the count.
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.userWatchingStart,
              user: User(id: 'watcher-2'),
            ),
          );

          expect(tester.channelState!.watcherCount, 5);
          expect(
            tester.channelState!.channelState.watchers?.map((it) => it.id),
            contains('watcher-2'),
          );
        },
      );

      channelTest(
        '${EventType.messageNew} updates watcherCount from the event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channelState!.watcherCount, isNull);

          final message = Message(
            id: 'test-message-id',
            user: tester.currentUser,
            createdAt: _messageCreatedAt,
          );

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.messageNew,
              message: message,
              watcherCount: 7,
            ),
          );

          expect(tester.channelState!.watcherCount, 7);
        },
      );

      channelTest(
        '${EventType.messageNew} without watcherCount preserves the existing count',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          // Seed an initial watcher count.
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(watcherCount: 4),
          );
          expect(tester.channelState!.watcherCount, 4);

          // A local/optimistic message.new without watcher_count must not
          // reset the count.
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.messageNew,
              message: Message(
                id: 'test-message-id-2',
                user: tester.currentUser,
                createdAt: _messageCreatedAt,
              ),
            ),
          );

          expect(tester.channelState!.watcherCount, 4);
        },
      );

      channelTest(
        '${EventType.notificationMessageNew} does not overwrite watcherCount',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          // Seed a known watcher count.
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(watcherCount: 5),
          );
          expect(tester.channelState!.watcherCount, 5);

          // notification.message_new is delivered to non-watchers and reports
          // watcher_count: 0; it must not clobber the real count.
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.notificationMessageNew,
              message: Message(
                id: 'notif-message-id',
                user: User(id: 'other-user'),
                createdAt: _messageCreatedAt,
              ),
              watcherCount: 0,
            ),
          );

          expect(tester.channelState!.watcherCount, 5);
        },
      );

      channelTest(
        '${EventType.userWatchingStop} without a watcher count preserves the count',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.userWatchingStart,
              user: User(id: 'watcher-1'),
              watcherCount: 5,
            ),
          );
          expect(tester.channelState!.watcherCount, 5);

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.userWatchingStop,
              user: User(id: 'watcher-1'),
            ),
          );

          expect(tester.channelState!.channelState.watchers, isEmpty);
          expect(tester.channelState!.watcherCount, 5);
        },
      );
    });

    group('Read Events', () {
      ChannelState Function(ChannelState) _seedChannel({
        List<ChannelCapability>? ownCapabilities,
        List<Read> read = const [],
      }) {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(
            cid: _channelCid,
            config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
            ownCapabilities: ownCapabilities,
          ),
          read: read,
        );
      }

      channelTest(
        'should update read state on message read event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime.utc(2020),
            unreadMessages: 10,
          );

          // Setup initial read state
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = tester.channelState?.read.first;
          expect(read?.user.id, 'test-user');
          expect(read?.unreadMessages, 10);
          expect(read?.lastReadMessageId, isNull);
          expect(read?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);

          // Create message read event
          final messageReadEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime.utc(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          await tester.emitEvent(messageReadEvent);

          // Verify read state is updated
          final updatedRead = tester.channelState?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(updatedRead?.unreadMessages, 0);
          expect(updatedRead?.lastReadMessageId, 'message-123');
          expect(updatedRead?.lastRead.isAtSameMomentAs(DateTime.utc(2022)), isTrue);
        },
      );

      channelTest(
        'should add a new read state if not exist on message read event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          // Create the current read state
          final currentUser = User(id: 'test-user');

          // Verify initial state
          final read = tester.channelState?.read;
          expect(read, isEmpty);

          // Create mark read notification event
          final markReadEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime.utc(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          await tester.emitEvent(markReadEvent);

          // Verify read list has not changed
          final updated = tester.channelState?.read;
          expect(updated?.length, 1);
          expect(updated?.any((r) => r.user.id == currentUser.id), isTrue);
        },
      );

      channelTest(
        'should not update channel read state on thread message read event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime.utc(2020),
            unreadMessages: 10,
            lastReadMessageId: 'channel-msg-1',
          );

          // Setup initial channel read state
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = tester.channelState?.read.first;
          expect(read?.unreadMessages, 10);
          expect(read?.lastReadMessageId, 'channel-msg-1');
          expect(read?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);

          // Create a thread-scoped message.read event (thread != null)
          final threadMessageReadEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime.utc(2022),
            lastReadMessageId: 'thread-reply-99',
            thread: Thread(
              channelCid: tester.channel.cid!,
              parentMessageId: 'parent-msg-1',
              createdByUserId: currentUser.id,
              replyCount: 3,
              participantCount: 2,
            ),
          );

          // Dispatch event
          await tester.emitEvent(threadMessageReadEvent);

          // Channel read state must be untouched — thread reads
          // must not clobber the channel-level Read.
          final after = tester.channelState?.read.first;
          expect(after?.unreadMessages, 10);
          expect(after?.lastReadMessageId, 'channel-msg-1');
          expect(after?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);
        },
      );

      channelTest(
        'should update read state on notification mark unread event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          // Create the current read state
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime.utc(2020),
            unreadMessages: 10,
          );

          // Setup initial read state
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = tester.channelState?.read.first;
          expect(read?.user.id, 'test-user');
          expect(read?.unreadMessages, 10);
          expect(read?.lastReadMessageId, isNull);
          expect(read?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);

          // Create mark unread notification event
          final markUnreadEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.notificationMarkUnread,
            user: currentUser,
            lastReadAt: DateTime.utc(2019),
            unreadMessages: 15,
            lastReadMessageId: 'message-100',
          );

          // Dispatch event
          await tester.emitEvent(markUnreadEvent);

          // Verify read state is updated
          final updatedRead = tester.channelState?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(updatedRead?.unreadMessages, 15);
          expect(updatedRead?.lastReadMessageId, 'message-100');
          expect(updatedRead?.lastRead.isAtSameMomentAs(DateTime.utc(2019)), isTrue);
        },
      );

      channelTest(
        'should add a new read state if not exist on notification mark unread',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          // Verify initial state
          final read = tester.channelState?.read;
          expect(read, isEmpty);

          // Create event for non-existing user
          final markUnreadEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.notificationMarkUnread,
            user: User(id: 'non-existing-user'),
            lastReadAt: DateTime.utc(2019),
            unreadMessages: 15,
            lastReadMessageId: 'message-100',
          );

          // Dispatch event
          await tester.emitEvent(markUnreadEvent);

          // Verify read list has not changed
          final updated = tester.channelState?.read;
          expect(updated?.length, 1);
          expect(updated?.any((r) => r.user.id == 'non-existing-user'), isTrue);
        },
      );

      channelTest(
        'should preserve delivery info on message read event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime.utc(2020),
            unreadMessages: 10,
            lastDeliveredAt: DateTime.utc(2021),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Setup initial read state with delivery info
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = tester.channelState?.read.first;
          expect(read?.lastDeliveredAt, isNotNull);
          expect(
            read?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2021)),
            isTrue,
          );
          expect(read?.lastDeliveredMessageId, 'delivered-msg-456');

          // Create message read event (doesn't include delivery info)
          final messageReadEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime.utc(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          await tester.emitEvent(messageReadEvent);

          // Verify read state is updated but delivery info is preserved
          final updatedRead = tester.channelState?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(updatedRead?.unreadMessages, 0);
          expect(updatedRead?.lastReadMessageId, 'message-123');
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime.utc(2022)),
            isTrue,
          );
          // Delivery info should be preserved
          expect(updatedRead?.lastDeliveredAt, isNotNull);
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2021)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
        },
      );

      channelTest(
        'should reconcile delivery when message read event is from current user',
        channelType: _channelType,
        channelId: _channelId,
        // The delivery reporter is real here, so the reconciliation is observed
        // through its effect: a pending delivery receipt — armed by an incoming
        // message on a delivery-capable channel with a stale read — is dropped
        // once the current user's read supersedes it.
        setUp: (tester) => tester.watch(
          modifyResponse: _seedChannel(
            ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
            read: [createDefaultRead()],
          ),
        ),
        body: (tester) async {
          registerFallbackValue(<MessageDelivery>[]);
          tester.mockApi(
            (api) => api.channel.markChannelsDelivered(any()),
            result: createDefaultEmptyResponse(),
          );

          // An incoming message from another user arms a pending delivery
          // receipt for this channel.
          final message = Message(
            id: 'message-123',
            user: User(id: 'other-user'),
            createdAt: DateTime.utc(2021, 2),
          );
          await tester.emitEvent(
            createDefaultEvent(cid: tester.channel.cid, type: EventType.messageNew, message: message),
          );

          // Create message read event from current user
          final messageReadEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageRead,
            user: tester.currentUser,
            createdAt: DateTime.utc(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          await tester.emitEvent(messageReadEvent);

          // The delivery reporter batches receipts behind a 1s trailing
          // throttle; by then reconciliation must have dropped the receipt.
          await Future.delayed(const Duration(milliseconds: 1100));

          // Verify the reconciled receipt was never sent
          tester.verifyNeverCalled((api) => api.channel.markChannelsDelivered(any()));
        },
      );

      channelTest(
        'should reset unread count on notification mark read event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final currentUser = tester.currentUser!;
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime.utc(2020),
            unreadMessages: 10,
          );

          // Setup initial read state
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          expect(tester.channelState?.unreadCount, 10);

          // notification.mark_read is delivered on the reading user's own
          // connection, so it reaches non-watched channels as well.
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime.utc(2022),
              lastReadMessageId: 'message-123',
            ),
          );

          // Verify read state is updated
          final updatedRead = tester.channelState?.read.first;
          expect(updatedRead?.user.id, currentUser.id);
          expect(tester.channelState?.unreadCount, 0);
          expect(updatedRead?.lastReadMessageId, 'message-123');
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime.utc(2022)),
            isTrue,
          );
        },
      );

      channelTest(
        'should preserve delivery info on notification mark read event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime.utc(2020),
            unreadMessages: 10,
            lastDeliveredAt: DateTime.utc(2021),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Setup initial read state
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime.utc(2022),
              lastReadMessageId: 'message-123',
            ),
          );

          // Verify read state is updated but delivery info is preserved
          final updatedRead = tester.channelState?.read.first;
          expect(updatedRead?.unreadMessages, 0);
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2021)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
        },
      );

      channelTest(
        'should not update channel read state on thread notification mark '
        'read event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime.utc(2020),
            unreadMessages: 10,
            lastReadMessageId: 'channel-msg-1',
          );

          // Setup initial read state
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime.utc(2022),
              lastReadMessageId: 'thread-reply-99',
              thread: Thread(
                channelCid: tester.channel.cid!,
                parentMessageId: 'parent-msg-1',
                createdByUserId: currentUser.id,
                replyCount: 3,
                participantCount: 2,
              ),
            ),
          );

          // Channel read state must be untouched — thread reads
          // must not clobber the channel-level Read.
          final after = tester.channelState?.read.first;
          expect(after?.unreadMessages, 10);
          expect(after?.lastReadMessageId, 'channel-msg-1');
          expect(after?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);
        },
      );

      channelTest(
        'should reconcile delivery when notification mark read event is from '
        'current user',
        channelType: _channelType,
        channelId: _channelId,
        // The delivery reporter is real here, so the reconciliation is observed
        // through its effect: a pending delivery receipt — armed by an incoming
        // message on a delivery-capable channel with a stale read — is dropped
        // once the current user's read supersedes it.
        setUp: (tester) => tester.watch(
          modifyResponse: _seedChannel(
            ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
            read: [createDefaultRead()],
          ),
        ),
        body: (tester) async {
          registerFallbackValue(<MessageDelivery>[]);
          tester.mockApi(
            (api) => api.channel.markChannelsDelivered(any()),
            result: createDefaultEmptyResponse(),
          );

          // An incoming message from another user arms a pending delivery
          // receipt for this channel.
          final message = Message(
            id: 'message-123',
            user: User(id: 'other-user'),
            createdAt: DateTime.utc(2021, 2),
          );
          await tester.emitEvent(
            createDefaultEvent(cid: tester.channel.cid, type: EventType.messageNew, message: message),
          );

          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.notificationMarkRead,
              user: tester.currentUser,
              createdAt: DateTime.utc(2022),
              lastReadMessageId: 'message-123',
            ),
          );

          // The delivery reporter batches receipts behind a 1s trailing
          // throttle; by then reconciliation must have dropped the receipt.
          await Future.delayed(const Duration(milliseconds: 1100));

          // Verify the reconciled receipt was never sent
          tester.verifyNeverCalled((api) => api.channel.markChannelsDelivered(any()));
        },
      );

      channelTest(
        'should update read state on message delivered event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final currentUser = User(id: 'test-user');
          final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
          final currentRead = Read(
            user: currentUser,
            lastRead: distantPast,
            unreadMessages: 5,
          );

          // Setup initial read state
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state has no delivery info
          final read = tester.channelState?.read.first;
          expect(read?.user.id, 'test-user');
          expect(read?.lastDeliveredAt, isNull);
          expect(read?.lastDeliveredMessageId, isNull);

          // Create message delivered event
          final messageDeliveredEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageDelivered,
            user: currentUser,
            lastDeliveredAt: DateTime.utc(2022),
            lastDeliveredMessageId: 'message-456',
          );

          // Dispatch event
          await tester.emitEvent(messageDeliveredEvent);

          // Verify delivery state is updated
          final updatedRead = tester.channelState?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(updatedRead?.lastDeliveredAt, isNotNull);
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2022)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'message-456');
        },
      );

      channelTest(
        'should add a new read state if not exist on message delivered event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final newUser = User(id: 'new-user');
          final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

          // Verify initial state
          final read = tester.channelState?.read;
          expect(read, isEmpty);

          // Create message delivered event for new user
          final messageDeliveredEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageDelivered,
            user: newUser,
            lastDeliveredAt: DateTime.utc(2022),
            lastDeliveredMessageId: 'message-789',
          );

          // Dispatch event
          await tester.emitEvent(messageDeliveredEvent);

          // Verify read state was created with delivery info
          final updated = tester.channelState?.read;
          expect(updated?.length, 1);
          final newRead = updated?.first;
          expect(newRead?.user.id, 'new-user');
          expect(newRead?.lastDeliveredAt, isNotNull);
          expect(
            newRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2022)),
            isTrue,
          );
          expect(newRead?.lastDeliveredMessageId, 'message-789');
          // lastRead should default to distantPast
          expect(
            newRead?.lastRead.isAtSameMomentAs(distantPast),
            isTrue,
          );
        },
      );

      channelTest(
        'should preserve read info on message delivered event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime.utc(2020),
            unreadMessages: 10,
            lastReadMessageId: 'read-msg-123',
          );

          // Setup initial read state
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = tester.channelState?.read.first;
          expect(read?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);
          expect(read?.unreadMessages, 10);
          expect(read?.lastReadMessageId, 'read-msg-123');

          // Create message delivered event (doesn't include read info)
          final messageDeliveredEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageDelivered,
            user: currentUser,
            lastDeliveredAt: DateTime.utc(2022),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Dispatch event
          await tester.emitEvent(messageDeliveredEvent);

          // Verify delivery state is updated but read info is preserved
          final updatedRead = tester.channelState?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2022)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
          // Read info should be preserved
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime.utc(2020)),
            isTrue,
          );
          expect(updatedRead?.unreadMessages, 10);
          expect(updatedRead?.lastReadMessageId, 'read-msg-123');
        },
      );

      channelTest(
        'should reconcile delivery when message delivered event is from current user',
        channelType: _channelType,
        channelId: _channelId,
        // The delivery reporter is real here, so the reconciliation is observed
        // through its effect: a pending delivery receipt — armed by an incoming
        // message on a delivery-capable channel with a stale read — is dropped
        // once the current user's delivery marker supersedes it.
        setUp: (tester) => tester.watch(
          modifyResponse: _seedChannel(
            ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
            read: [createDefaultRead()],
          ),
        ),
        body: (tester) async {
          registerFallbackValue(<MessageDelivery>[]);
          tester.mockApi(
            (api) => api.channel.markChannelsDelivered(any()),
            result: createDefaultEmptyResponse(),
          );

          // An incoming message from another user arms a pending delivery
          // receipt for this channel.
          final message = Message(
            id: 'message-456',
            user: User(id: 'other-user'),
            createdAt: DateTime.utc(2021, 2),
          );
          await tester.emitEvent(
            createDefaultEvent(cid: tester.channel.cid, type: EventType.messageNew, message: message),
          );

          // Create message delivered event from current user
          final messageDeliveredEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageDelivered,
            user: tester.currentUser,
            lastDeliveredAt: DateTime.utc(2022),
            lastDeliveredMessageId: 'message-456',
          );

          // Dispatch event
          await tester.emitEvent(messageDeliveredEvent);

          // The delivery reporter batches receipts behind a 1s trailing
          // throttle; by then reconciliation must have dropped the receipt.
          await Future.delayed(const Duration(milliseconds: 1100));

          // Verify the reconciled receipt was never sent
          tester.verifyNeverCalled((api) => api.channel.markChannelsDelivered(any()));
        },
      );
    });

    group('Draft events', () {
      final _draftCreatedAt = DateTime.utc(2021, 3);

      ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
      );

      channelTest(
        'should handle draft.updated event for channel drafts',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Verify initial state
          expect(tester.channelState?.draft, isNull);

          // Create Draft
          final draft = Draft(
            channelCid: tester.channel.cid!,
            createdAt: _draftCreatedAt,
            message: DraftMessage(text: 'test message'),
          );

          // Create and dispatch draft.updated event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.draftUpdated,
              draft: draft,
            ),
          );

          // Verify channel draft was updated
          expect(tester.channelState?.draft, isNotNull);
          expect(tester.channelState?.draft?.message.text, 'test message');
        },
      );

      channelTest(
        'should handle draft.updated event for thread drafts',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const threadParentMessageId = 'thread-parent-id';

          // Setup initial state with a regular message
          tester.channelState?.updateMessage(
            Message(
              id: threadParentMessageId,
              user: tester.currentUser,
            ),
          );

          // Verify initial state
          expect(tester.channelState?.threadDraft(threadParentMessageId), isNull);

          // Create thread Draft
          final draft = Draft(
            channelCid: tester.channel.cid!,
            createdAt: _draftCreatedAt,
            parentId: threadParentMessageId,
            message: DraftMessage(text: 'thread reply'),
          );

          // Create and dispatch draft.updated event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.draftUpdated,
              draft: draft,
            ),
          );

          // Verify thread draft was updated
          final threadDraft = tester.channelState?.threadDraft(threadParentMessageId);
          expect(threadDraft, isNotNull);
          expect(threadDraft?.message.text, 'thread reply');
        },
      );

      channelTest(
        'should handle draft.deleted event for channel drafts',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup initial state with a draft
          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              draft: Draft(
                channelCid: tester.channel.cid!,
                createdAt: _draftCreatedAt,
                message: DraftMessage(text: 'test message'),
              ),
            ),
          );

          // Verify initial state
          final draft = tester.channelState?.draft;
          expect(draft, isNotNull);
          expect(draft?.message.text, 'test message');

          // Create and dispatch draft.deleted event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.draftDeleted,
              draft: draft,
            ),
          );

          // Verify channel draft was updated
          expect(tester.channelState?.draft, isNull);
        },
      );

      channelTest(
        'should handle draft.deleted event for thread drafts',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const threadParentMessageId = 'thread-parent-id';

          // Setup initial state with a thread draft
          tester.channelState?.updateMessage(
            Message(
              id: threadParentMessageId,
              user: tester.currentUser,
              draft: Draft(
                channelCid: tester.channel.cid!,
                createdAt: _draftCreatedAt,
                parentId: threadParentMessageId,
                message: DraftMessage(text: 'thread reply'),
              ),
            ),
          );

          // Verify initial state
          final threadDraft = tester.channelState?.threadDraft(threadParentMessageId);
          expect(threadDraft, isNotNull);
          expect(threadDraft?.message.text, 'thread reply');

          // Create and dispatch draft.deleted event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.draftDeleted,
              draft: threadDraft,
            ),
          );

          // Verify thread draft was removed
          expect(tester.channelState?.threadDraft(threadParentMessageId), isNull);
        },
      );

      channelTest(
        'should update current channel draft if draft.updated event is emitted',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup initial state with a draft
          final initialDraft = Draft(
            channelCid: tester.channel.cid!,
            createdAt: _draftCreatedAt,
            message: DraftMessage(text: 'test message'),
          );

          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              draft: initialDraft,
            ),
          );

          // Verify initial state
          expect(tester.channelState?.draft, isNotNull);
          expect(tester.channelState?.draft?.message.text, 'test message');

          // Create Draft
          final updatedDraft = initialDraft.copyWith(
            message: DraftMessage(text: 'updated message'),
          );

          // Create and dispatch draft.updated event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.draftUpdated,
              draft: updatedDraft,
            ),
          );

          // Verify channel draft was updated
          expect(tester.channelState?.draft, isNotNull);
          expect(tester.channelState?.draft?.message.text, 'updated message');
        },
      );

      channelTest(
        'should update current thread draft if draft.updated event is emitted',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const threadParentMessageId = 'thread-parent-id';

          // Setup initial state with a thread draft
          final initialDraft = Draft(
            channelCid: tester.channel.cid!,
            createdAt: _draftCreatedAt,
            parentId: threadParentMessageId,
            message: DraftMessage(text: 'thread reply'),
          );

          tester.channelState?.updateMessage(
            Message(
              id: threadParentMessageId,
              user: tester.currentUser,
              draft: initialDraft,
            ),
          );

          // Verify initial state
          final draft = tester.channelState?.threadDraft(threadParentMessageId);
          expect(draft, isNotNull);
          expect(draft?.message.text, 'thread reply');

          // Create Draft
          final updatedDraft = initialDraft.copyWith(
            message: DraftMessage(text: 'updated thread reply'),
          );

          // Create and dispatch draft.updated event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.draftUpdated,
              draft: updatedDraft,
            ),
          );

          // Verify thread draft was updated
          final threadDraft = tester.channelState?.threadDraft(threadParentMessageId);
          expect(threadDraft, isNotNull);
          expect(threadDraft?.message.text, 'updated thread reply');
        },
      );

      channelTest(
        'an event without a draft is ignored',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          await tester.emitEvent(createDefaultEvent(cid: tester.channel.cid, type: EventType.draftUpdated));

          expect(tester.channelState?.draft, isNull);
        },
      );
    });

    group('Reminder events', () {
      // Deterministic stand-in for `DateTime.now()`: emitted reminders round-trip
      // through JSON, and only UTC values survive that round-trip unchanged.
      final _now = DateTime.utc(2021, 3);

      ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
      );

      channelTest(
        'should handle reminder.created event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const messageId = 'test-message-id';

          // Setup initial state with a message without reminder
          final message = Message(
            id: messageId,
            user: tester.currentUser,
            text: 'Test message',
          );

          tester.channelState?.updateMessage(message);

          // Verify initial state - no reminder
          final initialMessage = tester.channelState?.messages.firstWhere(
            (m) => m.id == messageId,
          );
          expect(initialMessage?.reminder, isNull);

          // Create reminder
          final reminder = createDefaultMessageReminder(
            messageId: messageId,
            channelCid: tester.channel.cid!,
            userId: 'test-user-id',
            remindAt: _now.add(const Duration(days: 30)),
          );

          // Emit reminder.created event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reminderCreated,
              reminder: reminder,
            ),
          );

          // Verify message reminder was added
          final updatedMessage = tester.channelState?.messages.firstWhere(
            (m) => m.id == messageId,
          );
          expect(updatedMessage?.reminder, isNotNull);
          expect(updatedMessage?.reminder?.messageId, messageId);
          expect(updatedMessage?.reminder?.remindAt, reminder.remindAt);
        },
      );

      channelTest(
        'should handle reminder.updated event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const messageId = 'test-message-id';

          // Setup initial state with a message with existing reminder
          final remindAt = _now.add(const Duration(days: 30));
          final initialReminder = createDefaultMessageReminder(
            messageId: messageId,
            channelCid: tester.channel.cid!,
            userId: 'test-user-id',
            remindAt: remindAt,
          );

          final message = Message(
            id: messageId,
            user: tester.currentUser,
            text: 'Test message',
            reminder: initialReminder,
          );

          tester.channelState?.updateMessage(message);

          // Verify initial state
          final initialMessage = tester.channelState?.messages.firstWhere(
            (m) => m.id == messageId,
          );
          expect(initialMessage?.reminder, isNotNull);
          expect(initialMessage?.reminder?.remindAt, remindAt);

          // Create updated reminder
          final updatedRemindAt = remindAt.add(const Duration(days: 15));
          final updatedReminder = initialReminder.copyWith(
            remindAt: updatedRemindAt,
            updatedAt: _now,
          );

          // Emit reminder.updated event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reminderUpdated,
              reminder: updatedReminder,
            ),
          );

          // Verify message reminder was updated
          final updatedMessage = tester.channelState?.messages.firstWhere(
            (m) => m.id == messageId,
          );
          expect(updatedMessage?.reminder, isNotNull);
          expect(updatedMessage?.reminder?.messageId, messageId);
          expect(updatedMessage?.reminder?.remindAt, updatedRemindAt);
        },
      );

      channelTest(
        'should handle reminder.deleted event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const messageId = 'test-message-id';

          // Setup initial state with a message with existing reminder
          final remindAt = _now.add(const Duration(days: 30));
          final initialReminder = createDefaultMessageReminder(
            messageId: messageId,
            channelCid: tester.channel.cid!,
            userId: 'test-user-id',
            remindAt: remindAt,
          );

          final message = Message(
            id: messageId,
            user: tester.currentUser,
            text: 'Test message',
            reminder: initialReminder,
          );

          tester.channelState?.updateMessage(message);

          // Verify initial state
          final initialMessage = tester.channelState?.messages.firstWhere(
            (m) => m.id == messageId,
          );
          expect(initialMessage?.reminder, isNotNull);

          // Emit reminder.deleted event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reminderDeleted,
              reminder: initialReminder,
            ),
          );

          // Verify message reminder was removed
          final updatedMessage = tester.channelState?.messages.firstWhere(
            (m) => m.id == messageId,
          );
          expect(updatedMessage?.reminder, isNull);
        },
      );

      channelTest(
        'should handle reminder.created event for thread messages',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const messageId = 'test-message-id';
          const parentId = 'test-parent-id';

          // Setup initial state with a thread message without reminder
          final threadMessage = Message(
            id: messageId,
            parentId: parentId,
            user: tester.currentUser,
            text: 'Thread message',
            // `Message.createdAt` falls back to `DateTime.now()` per call when
            // not provided, which breaks merge/sort keyed on createdAt.
            createdAt: _now,
          );

          tester.channelState?.updateMessage(threadMessage);

          // Verify initial state - no reminder
          final initialMessage = tester.channelState?.threads[parentId]?.firstWhere(
            (m) => m.id == messageId,
          );
          expect(initialMessage?.reminder, isNull);

          // Create reminder
          final remindAt = _now.add(const Duration(days: 30));
          final reminder = createDefaultMessageReminder(
            messageId: messageId,
            channelCid: tester.channel.cid!,
            userId: 'test-user-id',
            remindAt: remindAt,
          );

          // Emit reminder.created event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reminderCreated,
              reminder: reminder,
            ),
          );

          // Verify thread message reminder was added
          final updatedMessage = tester.channelState?.threads[parentId]?.firstWhere(
            (m) => m.id == messageId,
          );
          expect(updatedMessage?.reminder, isNotNull);
          expect(updatedMessage?.reminder?.messageId, messageId);
          expect(updatedMessage?.reminder?.remindAt, reminder.remindAt);
        },
      );

      channelTest(
        'should handle reminder.updated event for thread messages',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const messageId = 'test-message-id';
          const parentId = 'test-parent-id';

          // Setup initial state with a thread message with existing reminder
          final remindAt = _now.add(const Duration(days: 30));
          final initialReminder = createDefaultMessageReminder(
            messageId: messageId,
            channelCid: tester.channel.cid!,
            userId: 'test-user-id',
            remindAt: remindAt,
          );

          final threadMessage = Message(
            id: messageId,
            parentId: parentId,
            user: tester.currentUser,
            text: 'Thread message',
            reminder: initialReminder,
            // `Message.createdAt` falls back to `DateTime.now()` per call when
            // not provided, which breaks merge/sort keyed on createdAt.
            createdAt: _now,
          );

          tester.channelState?.updateMessage(threadMessage);

          // Verify initial state
          final initialMessage = tester.channelState?.threads[parentId]?.firstWhere(
            (m) => m.id == messageId,
          );
          expect(initialMessage?.reminder, isNotNull);
          expect(initialMessage?.reminder?.remindAt, remindAt);

          // Create updated reminder
          final updatedRemindAt = remindAt.add(const Duration(days: 15));
          final updatedReminder = initialReminder.copyWith(
            remindAt: updatedRemindAt,
            updatedAt: _now,
          );

          // Emit reminder.updated event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reminderUpdated,
              reminder: updatedReminder,
            ),
          );

          // Verify thread message reminder was updated
          final updatedMessage = tester.channelState?.threads[parentId]?.firstWhere(
            (m) => m.id == messageId,
          );
          expect(updatedMessage?.reminder, isNotNull);
          expect(updatedMessage?.reminder?.messageId, messageId);
          expect(updatedMessage?.reminder?.remindAt, updatedRemindAt);
        },
      );

      channelTest(
        'should handle reminder.deleted event for thread messages',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const messageId = 'test-message-id';
          const parentId = 'test-parent-id';

          // Setup initial state with a thread message with existing reminder
          final remindAt = _now.add(const Duration(days: 30));
          final initialReminder = createDefaultMessageReminder(
            messageId: messageId,
            channelCid: tester.channel.cid!,
            userId: 'test-user-id',
            remindAt: remindAt,
          );

          final threadMessage = Message(
            id: messageId,
            parentId: parentId,
            user: tester.currentUser,
            text: 'Thread message',
            reminder: initialReminder,
            // Explicit `createdAt` so `Message.createdAt` is deterministic
            // across reads — without one it falls back to `DateTime.now()`
            // on every call, which breaks any sort/merge keyed on createdAt.
            createdAt: _now,
          );

          tester.channelState?.updateMessage(threadMessage);

          // Verify initial state
          final initialMessage = tester.channelState?.threads[parentId]?.firstWhere(
            (m) => m.id == messageId,
          );
          expect(initialMessage?.reminder, isNotNull);

          // Emit reminder.deleted event
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.reminderDeleted,
              reminder: initialReminder,
            ),
          );

          // Verify thread message reminder was removed
          final updatedMessage = tester.channelState?.threads[parentId]?.firstWhere(
            (m) => m.id == messageId,
          );
          expect(updatedMessage?.reminder, isNull);
        },
      );

      channelTest(
        'an event without a reminder is ignored',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          const messageId = 'test-message-id';

          final message = Message(
            id: messageId,
            user: tester.currentUser,
            text: 'Test message',
          );
          tester.channelState?.updateMessage(message);

          await tester.emitEvent(createDefaultEvent(cid: tester.channel.cid, type: EventType.reminderCreated));

          final storedMessage = tester.channelState?.messages.firstWhere((m) => m.id == messageId);
          expect(storedMessage?.reminder, isNull);
        },
      );
    });

    group('Location events', () {
      ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
      );

      channelTest(
        'should handle location.shared event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Verify initial state
          expect(tester.channelState?.activeLiveLocations, isEmpty);

          // Create live location
          final liveLocation = Location(
            channelCid: _channelCid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Dispatch location.shared event
          await tester.emitEvent(
            createDefaultEvent(
              cid: _channelCid,
              type: EventType.locationShared,
              message: locationMessage,
            ),
          );

          // Check if message was added
          final messages = tester.channelState?.messages;
          final message = messages?.firstWhere((m) => m.id == 'msg1');
          expect(message, isNotNull);

          // Check if active live location was updated
          final activeLiveLocations = tester.channelState?.activeLiveLocations;
          expect(activeLiveLocations, hasLength(1));
          expect(activeLiveLocations?.first.messageId, equals('msg1'));
        },
      );

      channelTest(
        'should handle location.updated event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup initial state with location message
          final liveLocation = Location(
            channelCid: _channelCid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Add initial message
          tester.channelState?.addNewMessage(locationMessage);

          // Create updated location
          final updatedLocation = liveLocation.copyWith(
            latitude: 40.7500, // Updated latitude
            longitude: -74.1000, // Updated longitude
          );

          final updatedMessage = locationMessage.copyWith(
            sharedLocation: updatedLocation,
          );

          // Dispatch location.updated event
          await tester.emitEvent(
            createDefaultEvent(
              cid: _channelCid,
              type: EventType.locationUpdated,
              message: updatedMessage,
            ),
          );

          // Check if message was updated
          final messages = tester.channelState?.messages;
          final message = messages?.firstWhere((m) => m.id == 'msg1');
          expect(message?.sharedLocation?.latitude, equals(40.7500));
          expect(message?.sharedLocation?.longitude, equals(-74.1000));

          // Check if active live location was updated
          final activeLiveLocations = tester.channelState?.activeLiveLocations;
          expect(activeLiveLocations, hasLength(1));
          expect(activeLiveLocations?.first.latitude, equals(40.7500));
          expect(activeLiveLocations?.first.longitude, equals(-74.1000));
        },
      );

      channelTest(
        'should handle location.expired event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup initial state with location message
          final liveLocation = Location(
            channelCid: _channelCid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Add initial message
          tester.channelState?.addNewMessage(locationMessage);
          expect(tester.channelState?.activeLiveLocations, hasLength(1));

          // Create expired location
          final expiredLocation = liveLocation.copyWith(
            endAt: DateTime.timestamp().subtract(const Duration(hours: 1)),
          );

          final expiredMessage = locationMessage.copyWith(
            sharedLocation: expiredLocation,
          );

          // Dispatch location.expired event
          await tester.emitEvent(
            createDefaultEvent(
              cid: _channelCid,
              type: EventType.locationExpired,
              message: expiredMessage,
            ),
          );

          // Check if message was updated
          final messages = tester.channelState?.messages;
          final message = messages?.firstWhere((m) => m.id == 'msg1');
          expect(message?.sharedLocation?.isExpired, isTrue);

          // Check if active live location was removed
          expect(tester.channelState?.activeLiveLocations, isEmpty);
        },
      );

      channelTest(
        "should auto-expire another user's live location once at endAt",
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final liveLocation = Location(
            channelCid: _channelCid,
            userId: 'user1', // Another user.
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().add(const Duration(milliseconds: 800)),
          );

          // The real client processes every event it handles, so collect the
          // handled events the way the old mock captured `client.handleEvent`.
          final captured = <Event>[];
          final subscription = tester.client.on().listen(captured.add);

          tester.channelState?.addNewMessage(
            Message(id: 'msg1', sharedLocation: liveLocation),
          );
          expect(tester.channelState?.activeLiveLocations, hasLength(1));

          // Before endAt no expiry event is emitted.
          await Future.delayed(const Duration(milliseconds: 200));
          expect(captured, isEmpty);

          // After endAt the scheduler emits exactly one location.expired event.
          await Future.delayed(const Duration(milliseconds: 900));
          expect(captured, hasLength(1));
          final event = captured.single;
          expect(event.type, EventType.locationExpired);
          expect(event.message?.id, 'msg1');

          await subscription.cancel();
        },
      );

      channelTest(
        "should not auto-expire the current user's own live location",
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final ownLocation = Location(
            channelCid: _channelCid,
            userId: tester.currentUser!.id, // The current user (handled by the client).
            messageId: 'msg-own',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().add(const Duration(milliseconds: 150)),
          );

          final captured = <Event>[];
          final subscription = tester.client.on().listen(captured.add);

          tester.channelState?.addNewMessage(
            Message(id: 'msg-own', sharedLocation: ownLocation),
          );
          expect(tester.channelState?.activeLiveLocations, hasLength(1));

          // The channel scheduler skips the current user's own locations, so no
          // expiry event is emitted even after endAt passes.
          await Future.delayed(const Duration(milliseconds: 300));
          expect(captured, isEmpty);

          await subscription.cancel();
        },
      );

      channelTest(
        "should auto-expire another user's location that arrives expired",
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final expiredLocation = Location(
            channelCid: _channelCid,
            userId: 'user1', // Another user.
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().subtract(const Duration(minutes: 5)),
          );

          final captured = <Event>[];
          final subscription = tester.client.on().listen(captured.add);

          // Mirrors a query/watch response whose live location is already past
          // endAt by the local clock, e.g. when the device clock runs ahead of
          // the server or endAt passed while the response was in flight.
          tester.channelState?.updateChannelState(
            ChannelState(messages: const [], activeLiveLocations: [expiredLocation]),
          );
          expect(tester.channelState?.activeLiveLocations, hasLength(1));

          // The scheduler fires straight away and emits exactly one event.
          await Future.delayed(const Duration(milliseconds: 100));
          expect(captured, hasLength(1));
          final event = captured.single;
          expect(event.type, EventType.locationExpired);
          expect(event.message?.id, 'msg1');

          await subscription.cancel();
        },
      );

      channelTest(
        'should not add static location to active locations',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final staticLocation = Location(
            channelCid: _channelCid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            // No endAt - static location
          );

          final staticMessage = Message(
            id: 'msg1',
            text: 'Static location shared',
            sharedLocation: staticLocation,
          );

          // Dispatch location.shared event
          await tester.emitEvent(
            createDefaultEvent(
              cid: _channelCid,
              type: EventType.locationShared,
              message: staticMessage,
            ),
          );

          // Check if message was added
          final messages = tester.channelState?.messages;
          final message = messages?.firstWhere((m) => m.id == 'msg1');
          expect(message?.sharedLocation, isNotNull);

          // Check if active live location was NOT updated (should remain empty)
          expect(tester.channelState?.activeLiveLocations, isEmpty);
        },
      );

      channelTest(
        'should update active locations when location message is deleted',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final liveLocation = Location(
            channelCid: _channelCid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Verify initial state
          tester.channelState?.addNewMessage(locationMessage);
          expect(tester.channelState?.activeLiveLocations, hasLength(1));

          // Dispatch message.deleted event
          await tester.emitEvent(
            createDefaultEvent(
              type: EventType.messageDeleted,
              cid: _channelCid,
              message: locationMessage.copyWith(
                type: MessageType.deleted,
                deletedAt: DateTime.timestamp(),
              ),
            ),
          );

          // Verify active locations are updated
          expect(tester.channelState?.activeLiveLocations, isEmpty);
        },
      );

      channelTest(
        'should merge locations with same key',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final liveLocation = Location(
            channelCid: _channelCid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Add initial location for setup
          tester.channelState?.addNewMessage(locationMessage);
          expect(tester.channelState?.activeLiveLocations, hasLength(1));

          // Create new location with same user, channel, and device
          final newLocation = Location(
            channelCid: _channelCid,
            userId: 'user1', // Same user
            messageId: 'msg2', // Different message
            latitude: 40.7500,
            longitude: -74.1000,
            createdByDeviceId: 'device1', // Same device
            endAt: DateTime.timestamp().add(const Duration(hours: 2)),
          );

          final newMessage = Message(
            id: 'msg2',
            text: 'Updated location',
            sharedLocation: newLocation,
          );

          // Dispatch location.shared event for the new message
          await tester.emitEvent(
            createDefaultEvent(
              cid: _channelCid,
              type: EventType.locationShared,
              message: newMessage,
            ),
          );

          // Should still have only one active location (merged)
          final activeLiveLocations = tester.channelState?.activeLiveLocations;
          expect(activeLiveLocations, hasLength(1));
          expect(activeLiveLocations?.first.messageId, equals('msg2'));
          expect(activeLiveLocations?.first.latitude, equals(40.7500));
        },
      );

      channelTest(
        'should handle multiple active locations from different devices',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final liveLocation = Location(
            channelCid: _channelCid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Add first location for setup
          tester.channelState?.addNewMessage(locationMessage);
          expect(tester.channelState?.activeLiveLocations, hasLength(1));

          // Create location from different device
          final location2 = Location(
            channelCid: _channelCid,
            userId: 'user1', // Same user
            messageId: 'msg2',
            latitude: 34.0522,
            longitude: -118.2437,
            createdByDeviceId: 'device2', // Different device
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final message2 = Message(
            id: 'msg2',
            text: 'Location from device 2',
            sharedLocation: location2,
          );

          // Dispatch location.shared event for the second message
          await tester.emitEvent(
            createDefaultEvent(
              cid: _channelCid,
              type: EventType.locationShared,
              message: message2,
            ),
          );

          // Should have two active locations
          expect(tester.channelState?.activeLiveLocations, hasLength(2));
        },
      );

      channelTest(
        'should handle location messages in threads',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final parentMessage = Message(
            id: 'parent1',
            text: 'Thread parent',
          );

          // Add parent message first for setup
          tester.channelState?.addNewMessage(parentMessage);

          final liveLocation = Location(
            channelCid: _channelCid,
            userId: 'user1',
            messageId: 'thread-msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final threadLocationMessage = Message(
            id: 'thread-msg1',
            text: 'Live location in thread',
            parentId: 'parent1',
            sharedLocation: liveLocation,
          );

          // Dispatch location.shared event for the thread message
          await tester.emitEvent(
            createDefaultEvent(
              cid: _channelCid,
              type: EventType.locationShared,
              message: threadLocationMessage,
            ),
          );

          // Check if thread message was added. The wire round-trip rewrites the
          // local-only message fields (state, local timestamps), so match on id
          // and the location payload instead of whole-message equality.
          final thread = tester.channelState?.threads['parent1'];
          final threadMessage = thread?.firstWhere((m) => m.id == 'thread-msg1');
          expect(threadMessage, isNotNull);
          expect(threadMessage?.sharedLocation, equals(liveLocation));

          // Check if location was added to active locations
          final activeLiveLocations = tester.channelState?.activeLiveLocations;
          expect(activeLiveLocations, hasLength(1));
          expect(activeLiveLocations?.first.messageId, equals('thread-msg1'));
        },
      );

      channelTest(
        'should update thread location messages',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final parentMessage = Message(
            id: 'parent1',
            text: 'Thread parent',
          );

          final liveLocation = Location(
            channelCid: _channelCid,
            userId: 'user1',
            messageId: 'thread-msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          final threadLocationMessage = Message(
            id: 'thread-msg1',
            text: 'Live location in thread',
            parentId: 'parent1',
            sharedLocation: liveLocation,
          );

          // Add messages
          tester.channelState?.addNewMessage(parentMessage);
          tester.channelState?.addNewMessage(threadLocationMessage);

          // Update the location
          final updatedLocation = liveLocation.copyWith(
            latitude: 40.7500,
            longitude: -74.1000,
          );

          final updatedThreadMessage = threadLocationMessage.copyWith(
            sharedLocation: updatedLocation,
          );

          // Dispatch location.updated event for the thread message
          await tester.emitEvent(
            createDefaultEvent(
              cid: _channelCid,
              type: EventType.locationUpdated,
              message: updatedThreadMessage,
            ),
          );

          // Check if thread message was updated
          final thread = tester.channelState?.threads['parent1'];
          final threadMessage = thread?.firstWhere((m) => m.id == 'thread-msg1');
          expect(threadMessage?.sharedLocation?.latitude, equals(40.7500));
          expect(threadMessage?.sharedLocation?.longitude, equals(-74.1000));

          // Check if active location was updated
          final activeLiveLocations = tester.channelState?.activeLiveLocations;
          expect(activeLiveLocations, hasLength(1));
          expect(activeLiveLocations?.first.latitude, equals(40.7500));
          expect(activeLiveLocations?.first.longitude, equals(-74.1000));
        },
      );
    });

    group('Channel push preference events', () {
      ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
      );

      channelTest(
        'should handle channel.push_preference.updated event',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Verify initial state
          expect(tester.channelState?.channelState.pushPreferences, isNull);

          // Create channel push preference
          final channelPushPreference = ChannelPushPreference(
            chatLevel: ChatLevel.mentions,
            disabledUntil: DateTime.utc(2021, 3),
          );

          // Dispatch channel.push_preference.updated event
          await tester.emitEvent(
            createDefaultEvent(
              type: EventType.channelPushPreferenceUpdated,
              cid: tester.channel.cid,
              channelPushPreference: channelPushPreference,
            ),
          );

          // Verify channel push preferences were updated
          final updatedPreferences = tester.channelState?.channelState.pushPreferences;
          expect(updatedPreferences, isNotNull);
          expect(updatedPreferences?.chatLevel, ChatLevel.mentions);
          expect(
            updatedPreferences?.disabledUntil,
            channelPushPreference.disabledUntil,
          );
        },
      );

      channelTest(
        'should update existing channel push preferences',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Set initial push preferences
          const initialPushPreference = ChannelPushPreference(
            chatLevel: ChatLevel.all,
          );

          tester.channelState?.updateChannelState(
            tester.channelState!.channelState.copyWith(
              pushPreferences: initialPushPreference,
            ),
          );

          // Verify initial state
          final pushPreferences = tester.channelState?.channelState.pushPreferences;
          expect(pushPreferences?.chatLevel, ChatLevel.all);
          expect(pushPreferences?.disabledUntil, isNull);

          // Create updated channel push preference
          final updatedPushPreference = ChannelPushPreference(
            chatLevel: ChatLevel.none,
            disabledUntil: DateTime.utc(2021, 4),
          );

          // Dispatch channel.push_preference.updated event
          await tester.emitEvent(
            createDefaultEvent(
              type: EventType.channelPushPreferenceUpdated,
              cid: tester.channel.cid,
              channelPushPreference: updatedPushPreference,
            ),
          );

          // Verify channel push preferences were updated
          final updatedPreferences = tester.channelState?.channelState.pushPreferences;
          expect(updatedPreferences?.chatLevel, ChatLevel.none);
          expect(
            updatedPreferences?.disabledUntil,
            updatedPushPreference.disabledUntil,
          );
        },
      );

      channelTest(
        'an event without a push preference is ignored',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          await tester.emitEvent(
            createDefaultEvent(type: EventType.channelPushPreferenceUpdated, cid: tester.channel.cid),
          );

          expect(tester.channelState?.channelState.pushPreferences, isNull);
        },
      );
    });

    group('User messages deleted event', () {
      ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
      );

      // Stubs every persistence call the harness makes on the way to a user-level
      // deletion: `updateConnectionInfo` on connect, `getChannelThreads` when the
      // channel state initializes, the debounced channel-state/threads writes (they
      // only fire when a run is slow enough for the 1s debounce to elapse
      // mid-test), and the three calls the `user.messages.deleted` handler makes.
      MockPersistenceClient _createPersistenceClient() {
        registerFallbackValue(createDefaultEvent());
        registerFallbackValue(createDefaultChannelState());
        final persistenceClient = MockPersistenceClient();
        when(() => persistenceClient.updateConnectionInfo(any())).thenAnswer((_) async {});
        when(() => persistenceClient.getChannelThreads(_channelCid)).thenAnswer((_) async => {});
        when(() => persistenceClient.updateChannelState(any())).thenAnswer((_) async {});
        when(() => persistenceClient.updateChannelThreads(any(), any())).thenAnswer((_) async {});
        when(
          () => persistenceClient.deleteMessagesFromUser(
            cid: any(named: 'cid'),
            userId: any(named: 'userId'),
            hardDelete: any(named: 'hardDelete'),
            deletedAt: any(named: 'deletedAt'),
          ),
        ).thenAnswer((_) async {});
        when(() => persistenceClient.deleteMessageByIds(any())).thenAnswer((_) async {});
        when(() => persistenceClient.deletePinnedMessageByIds(any())).thenAnswer((_) async {});
        return persistenceClient;
      }

      final softDeletePersistence = _createPersistenceClient();

      final hardDeletePersistence = _createPersistenceClient();

      final threadMessagesPersistence = _createPersistenceClient();

      final nullUserPersistence = _createPersistenceClient();

      final emptyChannelPersistence = _createPersistenceClient();

      final hardDeleteStoragePersistence = _createPersistenceClient();

      final softDeleteStoragePersistence = _createPersistenceClient();

      final storageWidePersistence = _createPersistenceClient();

      final crossThreadPersistence = _createPersistenceClient();

      channelTest(
        'should soft delete all messages from user when hardDelete is false',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: softDeletePersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup: Add messages from different users
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Another message from user 1',
            user: user1,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Message from user 2',
            user: user2,
          );

          tester.channelState?.addNewMessage(message1);
          tester.channelState?.addNewMessage(message2);
          tester.channelState?.addNewMessage(message3);

          // Verify initial state
          expect(tester.channelState?.messages.length, equals(3));
          expect(
            tester.channelState?.messages.where((m) => m.user?.id == 'user-1').length,
            equals(2),
          );
          expect(
            tester.channelState?.messages.where((m) => m.user?.id == 'user-2').length,
            equals(1),
          );

          // Create user.messages.deleted event (soft delete)
          final deletedAt = DateTime.utc(2021, 3);
          final userMessagesDeletedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
            createdAt: deletedAt,
          );

          // Dispatch event and wait for it to be processed
          await tester.emitEvent(userMessagesDeletedEvent);

          // Verify user1's messages are soft deleted
          expect(tester.channelState?.messages.length, equals(3));
          final deletedMessages = tester.channelState?.messages.where((m) => m.user?.id == 'user-1').toList();
          expect(deletedMessages?.length, equals(2));
          for (final message in deletedMessages!) {
            expect(message.type, equals(MessageType.deleted));
            expect(message.deletedAt, isNotNull);
            expect(message.state.isDeleted, isTrue);
          }

          // Verify user2's message is unaffected
          final user2Message = tester.channelState?.messages.firstWhere((m) => m.id == 'msg-3');
          expect(user2Message?.type, isNot(MessageType.deleted));
          expect(user2Message?.deletedAt, isNull);
        },
      );

      channelTest(
        'should hard delete all messages from user when hardDelete is true',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: hardDeletePersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup: Add messages from different users
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Another message from user 1',
            user: user1,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Message from user 2',
            user: user2,
          );

          tester.channelState?.addNewMessage(message1);
          tester.channelState?.addNewMessage(message2);
          tester.channelState?.addNewMessage(message3);

          // Verify initial state
          expect(tester.channelState?.messages.length, equals(3));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event and wait for it to be processed
          await tester.emitEvent(userMessagesDeletedEvent);

          // Verify user1's messages are removed
          expect(tester.channelState?.messages.length, equals(1));
          expect(
            tester.channelState?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          // Verify user2's message still exists
          final user2Message = tester.channelState?.messages.firstWhere((m) => m.id == 'msg-3');
          expect(user2Message, isNotNull);
          expect(user2Message?.user?.id, equals('user-2'));
        },
      );

      channelTest(
        'should handle thread messages from user',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: threadMessagesPersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup: Add parent and thread messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final parentMessage = Message(
            id: 'parent-msg',
            text: 'Parent message',
            user: user2,
          );
          final threadMessage1 = Message(
            id: 'thread-msg-1',
            text: 'Thread message from user 1',
            user: user1,
            parentId: 'parent-msg',
          );
          final threadMessage2 = Message(
            id: 'thread-msg-2',
            text: 'Another thread message from user 1',
            user: user1,
            parentId: 'parent-msg',
          );

          tester.channelState?.addNewMessage(parentMessage);
          tester.channelState?.addNewMessage(threadMessage1);
          tester.channelState?.addNewMessage(threadMessage2);

          // Verify initial state
          expect(tester.channelState?.messages.length, equals(1));
          expect(tester.channelState?.threads['parent-msg']?.length, equals(2));

          // Create user.messages.deleted event (soft delete)
          final userMessagesDeletedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );

          // Dispatch event and wait for it to be processed
          await tester.emitEvent(userMessagesDeletedEvent);

          // Verify thread messages are soft deleted
          final threadMessages = tester.channelState?.threads['parent-msg'];
          expect(threadMessages?.length, equals(2));
          for (final message in threadMessages!) {
            expect(message.type, equals(MessageType.deleted));
            expect(message.state.isDeleted, isTrue);
          }

          // Verify parent message is unaffected
          final parent = tester.channelState?.messages.first;
          expect(parent?.type, isNot(MessageType.deleted));
        },
      );

      channelTest(
        'should do nothing when user is null',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: nullUserPersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup: Add messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );

          tester.channelState?.addNewMessage(message1);

          // Verify initial state
          expect(tester.channelState?.messages.length, equals(1));

          // Create user.messages.deleted event without user
          final userMessagesDeletedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userMessagesDeleted,
            hardDelete: false,
          );

          // Dispatch event and wait for it to be processed
          await tester.emitEvent(userMessagesDeletedEvent);

          // Verify messages are unaffected
          expect(tester.channelState?.messages.length, equals(1));
          expect(
            tester.channelState?.messages.first.type,
            isNot(MessageType.deleted),
          );
        },
      );

      channelTest(
        'should handle empty message list',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: emptyChannelPersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup: Empty channel
          expect(tester.channelState?.messages.length, equals(0));

          // Create user.messages.deleted event
          final userMessagesDeletedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userMessagesDeleted,
            user: User(id: 'user-1'),
            hardDelete: false,
          );

          // Dispatch event - should not throw
          await tester.emitEvent(userMessagesDeletedEvent);

          // Verify state is still empty
          expect(tester.channelState?.messages.length, equals(0));
        },
      );

      channelTest(
        'should delete messages from persistence when hardDelete is true',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: hardDeleteStoragePersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup: Add messages from different users
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Another message from user 1',
            user: user1,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Message from user 2',
            user: user2,
          );

          tester.channelState?.addNewMessage(message1);
          tester.channelState?.addNewMessage(message2);
          tester.channelState?.addNewMessage(message3);

          // Verify initial state
          expect(tester.channelState?.messages.length, equals(3));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event and wait for it to be processed
          await tester.emitEvent(userMessagesDeletedEvent);

          // Verify messages are removed from persistence
          verify(
            () => hardDeleteStoragePersistence.deleteMessageByIds(['msg-1', 'msg-2']),
          ).called(1);
          verify(
            () => hardDeleteStoragePersistence.deletePinnedMessageByIds(['msg-1', 'msg-2']),
          ).called(1);

          // Verify user1's messages are removed from state
          expect(tester.channelState?.messages.length, equals(1));
          expect(
            tester.channelState?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );
        },
      );

      channelTest(
        'should not delete from persistence when hardDelete is false',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: softDeleteStoragePersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // Setup: Add messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );

          tester.channelState?.addNewMessage(message1);

          // Create user.messages.deleted event (soft delete)
          final userMessagesDeletedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );

          // Dispatch event and wait for it to be processed
          await tester.emitEvent(userMessagesDeletedEvent);

          // Verify persistence deletion methods were NOT called
          verifyNever(() => softDeleteStoragePersistence.deleteMessageByIds(any()));
          verifyNever(() => softDeleteStoragePersistence.deletePinnedMessageByIds(any()));

          // Verify message is soft deleted (still in state)
          expect(tester.channelState?.messages.length, equals(1));
          expect(tester.channelState?.messages.first.type, equals(MessageType.deleted));
        },
      );

      channelTest(
        'should delete all user messages including those only in storage',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: storageWidePersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final stateMessage1 = Message(
            id: 'msg-1',
            text: 'Message from user 1 in state',
            user: user1,
            pinned: true,
          );
          final stateMessage2 = Message(
            id: 'msg-2',
            text: 'Message from user 2 in state',
            user: user2,
          );
          final stateThreadMessage1 = Message(
            id: 'thread-msg-1',
            text: 'Thread message from user 1 in state',
            user: user1,
            parentId: 'msg-1',
          );
          final stateThreadMessage2 = Message(
            id: 'thread-msg-2',
            text: 'Another thread message from user 2 in state',
            user: user2,
            parentId: 'msg-1',
          );

          // Load the state with only 2 messages and 1 thread with 2 replies.
          // Note: In reality, storage may contain many more user1 messages
          // (e.g., older messages not loaded into state yet), but the delete
          // operation should remove ALL of them from storage.
          tester.channelState?.addNewMessage(stateMessage1);
          tester.channelState?.addNewMessage(stateMessage2);
          tester.channelState?.addNewMessage(stateThreadMessage1);
          tester.channelState?.addNewMessage(stateThreadMessage2);

          // Verify initial state has only 2 messages and 1 thread with 2 replies
          expect(tester.channelState?.messages.length, equals(2));
          expect(tester.channelState?.threads['msg-1']?.length, equals(2));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event and wait for it to be processed
          await tester.emitEvent(userMessagesDeletedEvent);

          // Verify user1's messages are removed from state
          expect(tester.channelState?.messages.length, equals(1));
          expect(tester.channelState?.threads['msg-1']?.length, equals(1));

          expect(
            tester.channelState?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          expect(
            tester.channelState?.threads['msg-1']?.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          // Verify persistence delete was called - this handles ALL messages
          // in storage (both those in state AND those only in storage)
          verify(
            () => storageWidePersistence.deleteMessagesFromUser(
              cid: tester.channel.cid,
              userId: user1.id,
              hardDelete: true,
              deletedAt: any(named: 'deletedAt'),
            ),
          ).called(1);

          // Verify in-state messages were also removed from state's persistence
          final capturedIds =
              verify(
                    () => storageWidePersistence.deleteMessageByIds(captureAny()),
                  ).captured.first
                  as List<String>;

          expect(
            capturedIds,
            containsAll([
              'msg-1', // state message
              'thread-msg-1', // state thread message
            ]),
          );
        },
      );

      channelTest(
        'should delete every authored message across threads without '
        'cross-thread leakage (regression: _updateThreadMessages)',
        channelType: _channelType,
        channelId: _channelId,
        chatPersistenceClient: crossThreadPersistence,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
        body: (tester) async {
          // user-1 authors a top-level message AND replies in two different
          // threads (owned by user-2). The user.messages.deleted flow
          // collects everything from user-1 across channel + threads and
          // routes it through a single _updateMessages batch — historically
          // this batch was passed unfiltered to every affected thread's
          // merge, so replies to thread A leaked into thread B and v.v.
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final parentA = Message(id: 'parent-A', text: 'Thread A', user: user2);
          final parentB = Message(id: 'parent-B', text: 'Thread B', user: user2);

          final topLevelFromUser1 = Message(
            id: 'top-1',
            text: 'user-1 top-level message',
            user: user1,
          );
          final replyA = Message(
            id: 'reply-A',
            text: 'user-1 reply in thread A',
            user: user1,
            parentId: 'parent-A',
          );
          final replyB = Message(
            id: 'reply-B',
            text: 'user-1 reply in thread B',
            user: user1,
            parentId: 'parent-B',
          );

          tester.channelState?.addNewMessage(parentA);
          tester.channelState?.addNewMessage(parentB);
          tester.channelState?.addNewMessage(topLevelFromUser1);
          tester.channelState?.addNewMessage(replyA);
          tester.channelState?.addNewMessage(replyB);

          // Initial state: each thread has exactly its own reply.
          expect(
            tester.channelState?.threads['parent-A']?.map((m) => m.id),
            equals(['reply-A']),
          );
          expect(
            tester.channelState?.threads['parent-B']?.map((m) => m.id),
            equals(['reply-B']),
          );

          // Trigger the multi-thread batch via user.messages.deleted.
          final userMessagesDeletedEvent = createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );
          await tester.emitEvent(userMessagesDeletedEvent);

          // 1) Thread membership is preserved — no cross-thread leakage.
          //    Without the fix, replyB would leak into thread A and v.v.
          expect(
            tester.channelState?.threads['parent-A']?.map((m) => m.id),
            equals(['reply-A']),
            reason: 'thread A must not contain replies from thread B',
          );
          expect(
            tester.channelState?.threads['parent-B']?.map((m) => m.id),
            equals(['reply-B']),
            reason: 'thread B must not contain replies from thread A',
          );

          // 2) Every message authored by user-1 is soft-deleted — top-level
          //    AND in both threads. The fix must not narrow this scope.
          expect(
            tester.channelState?.messages.firstWhere((m) => m.id == 'top-1').type,
            equals(MessageType.deleted),
            reason: 'top-level user-1 message must be deleted',
          );
          expect(
            tester.channelState?.threads['parent-A']?.first.type,
            equals(MessageType.deleted),
            reason: 'thread A reply from user-1 must be deleted',
          );
          expect(
            tester.channelState?.threads['parent-B']?.first.type,
            equals(MessageType.deleted),
            reason: 'thread B reply from user-1 must be deleted',
          );

          // 3) Other users' messages are unaffected.
          expect(
            tester.channelState?.messages.firstWhere((m) => m.id == 'parent-A').type,
            isNot(MessageType.deleted),
          );
          expect(
            tester.channelState?.messages.firstWhere((m) => m.id == 'parent-B').type,
            isNot(MessageType.deleted),
          );
        },
      );
    });

    group('Dispatch error isolation', () {
      // A bare channel state (no config, no capabilities).
      ChannelState Function(ChannelState) _seedChannel() {
        return (_) => createDefaultChannelState(
          channel: createDefaultChannelModel(cid: _channelCid),
        );
      }

      channelTest(
        'a throwing handler still lets the later stages apply',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          expect(tester.channel.memberCount, equals(0));

          // A message.deleted without a message throws on `event.message!` in
          // the first dispatch stage. The unfiltered count refresh that runs
          // after it must still apply.
          await tester.emitEvent(
            createDefaultEvent(
              cid: tester.channel.cid,
              type: EventType.messageDeleted,
              channelMemberCount: 9,
            ),
          );

          expect(tester.channel.memberCount, equals(9));
        },
      );
    });
  });

  group('Local unread count', () {
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

    // A message from another user that counts as unread once seeded together
    // with a read state older than the message.
    final countedMessage = Message(
      id: 'message-1',
      text: 'Hello',
      user: User(id: 'other-user'),
      createdAt: DateTime.utc(2024),
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
          throwsA(isA<StreamClientException>()),
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

  group('updateChannelState identity guard', () {
    // Pinned base timestamp for the seeded messages (m1, m2 +1s, m3 +2s).
    final _baseCreatedAt = DateTime.utc(2021, 3);

    ChannelState Function(ChannelState) _seedChannel() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
        messages: [
          Message(id: 'm1', text: '1', createdAt: _baseCreatedAt),
          Message(id: 'm2', text: '2', createdAt: _baseCreatedAt.add(const Duration(seconds: 1))),
          Message(id: 'm3', text: '3', createdAt: _baseCreatedAt.add(const Duration(seconds: 2))),
        ],
      );
    }

    channelTest(
      'preserves messages reference when updatedState.messages is null',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final before = tester.channelState!.messages;
        tester.channelState!.updateChannelState(
          ChannelState(channel: tester.channelState!.channelState.channel),
        );
        final after = tester.channelState!.messages;

        expect(identical(before, after), isTrue);
      },
    );

    channelTest(
      'preserves messages reference when updatedState.messages is identical',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final before = tester.channelState!.messages;
        // copyWith without messages keeps the same `messages` reference, so
        // updateChannelState should hit the identity-guard fast path.
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [
              Read(
                user: User(id: 'me'),
                lastRead: DateTime.utc(2021, 3, 2),
                unreadMessages: 1,
              ),
            ],
          ),
        );
        final after = tester.channelState!.messages;

        expect(identical(before, after), isTrue);
      },
    );

    channelTest(
      'still merges messages when updatedState.messages is a different list',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final newMessage = Message(
          id: 'm4',
          text: '4',
          createdAt: _baseCreatedAt.add(const Duration(seconds: 10)),
        );
        tester.channelState!.updateChannelState(
          ChannelState(
            channel: tester.channelState!.channelState.channel,
            messages: [newMessage],
          ),
        );

        expect(
          tester.channelState!.messages.map((m) => m.id),
          ['m1', 'm2', 'm3', 'm4'],
        );
      },
    );

    channelTest(
      'cold-path merge interleaves new messages in sorted order',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final base = tester.channelState!.messages.first.createdAt;
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
        tester.channelState!.updateChannelState(
          ChannelState(
            channel: tester.channelState!.channelState.channel,
            messages: incoming,
          ),
        );

        expect(
          tester.channelState!.messages.map((m) => m.id),
          ['m1', 'm1.5', 'm2', 'm2.5', 'm3'],
        );
      },
    );

    channelTest(
      'cold-path merge runs syncWith on overlapping ids',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final localStamp = DateTime.utc(2021, 3, 5);
        // Seed m2 with a localCreatedAt that the incoming version doesn't
        // carry, so we can verify syncWith fired during the merge.
        tester.channelState!.updateMessage(
          Message(
            id: 'm2',
            text: '2',
            createdAt: tester.channelState!.messages.firstWhere((m) => m.id == 'm2').createdAt,
          ).copyWith(localCreatedAt: localStamp),
        );

        final incoming = [
          Message(
            id: 'm2',
            text: '2 (server)',
            createdAt: tester.channelState!.messages.firstWhere((m) => m.id == 'm2').createdAt,
          ),
        ];
        tester.channelState!.updateChannelState(
          ChannelState(
            channel: tester.channelState!.channelState.channel,
            messages: incoming,
          ),
        );

        final m2 = tester.channelState!.messages.firstWhere((m) => m.id == 'm2');
        expect(m2.text, '2 (server)');
        // Local-only field carried over by syncWith during the merge.
        expect(m2.localCreatedAt, localStamp);
      },
    );
  });

  group('updateMessage quoted-rewrite', () {
    ChannelState Function(ChannelState) _seedChannel({required List<Message> messages}) {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
        messages: messages,
      );
    }

    channelTest(
      'rewrites quotedMessage on every quoter when target is deleted',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final now = DateTime.utc(2021, 3);
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

        await tester.watch(
          modifyResponse: _seedChannel(messages: [target, quoter1, unrelated, quoter2]),
        );

        final unrelatedBefore = tester.channelState!.messages.firstWhere((m) => m.id == 'u1');

        final deleted = target.copyWith(
          type: MessageType.deleted,
          deletedAt: now.add(const Duration(seconds: 5)),
        );
        tester.channelState!.updateMessage(deleted);

        final after = tester.channelState!.messages;
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

    channelTest(
      'preserves messages reference when no message quotes the deleted one',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final now = DateTime.utc(2021, 3);
        final target = Message(id: 'target', text: 'hi', createdAt: now);
        final unrelated = Message(
          id: 'u1',
          text: 'other',
          createdAt: now.add(const Duration(seconds: 1)),
        );

        await tester.watch(modifyResponse: _seedChannel(messages: [target, unrelated]));

        final deleted = target.copyWith(
          type: MessageType.deleted,
          deletedAt: now.add(const Duration(seconds: 5)),
        );
        tester.channelState!.updateMessage(deleted);

        // No message quotes `target`, so `updateWhere` short-circuits and the
        // remaining messages keep their identities (only `target` itself was
        // replaced by `sortedUpsert`).
        final unrelatedAfter = tester.channelState!.messages.firstWhere((m) => m.id == 'u1');
        expect(identical(unrelatedAfter, unrelated), isTrue);
      },
    );

    channelTest(
      'does not rewrite quotes when an existing quoted target is updated '
      'without being deleted',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final now = DateTime.utc(2021, 3);
        final target = Message(id: 'target', text: 'original', createdAt: now);
        final quoter = Message(
          id: 'q1',
          text: 'reply',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 1)),
        );

        await tester.watch(modifyResponse: _seedChannel(messages: [target, quoter]));

        final quoterBefore = tester.channelState!.messages.firstWhere((m) => m.id == 'q1');

        // Plain text update — not a deletion.
        tester.channelState!.updateMessage(target.copyWith(text: 'edited'));

        final quoterAfter = tester.channelState!.messages.firstWhere((m) => m.id == 'q1');
        // `updateWhere` is gated on `message.isDeleted`, so the quoter must keep
        // its identity (no allocation, no quoted-message overwrite).
        expect(identical(quoterAfter, quoterBefore), isTrue);
      },
    );
  });

  group('Message enrichment preservation on merge', () {
    ChannelState Function(ChannelState) _seedChannel() {
      return (_) => createDefaultChannelState(
        channel: createDefaultChannelModel(cid: _channelCid),
      );
    }

    Event _updateMessageEvent(Message message) => createDefaultEvent(
      type: EventType.messageUpdated,
      cid: _channelCid,
      message: message,
    );

    channelTest(
      'preserves the `poll` on a quotedMessage when the server omits it during '
      're-sync (regression: poll quote disappears after foregrounding)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
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

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [reSyncedReply],
          ),
        );

        final mergedReply = tester.channelState?.messages.firstWhere((it) => it.id == replyToPoll.id);

        expect(mergedReply, isNotNull);
        expect(mergedReply!.quotedMessage, isNotNull);
        expect(mergedReply.quotedMessage!.id, pollMessage.id);
        expect(mergedReply.quotedMessage!.poll, isNotNull);
        expect(mergedReply.quotedMessage!.poll!.id, poll.id);
        expect(mergedReply.quotedMessage!.poll!.name, poll.name);
      },
    );

    channelTest(
      'preserves a nested quotedMessage (poll) two levels deep when the '
      'server omits it during re-sync (regression: quote-of-quote of a poll '
      'disappears completely after foregrounding)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
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

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [pollMessage, reSyncedReplyA, reSyncedReplyB],
          ),
        );

        final mergedReplyA = tester.channelState?.messages.firstWhere((it) => it.id == replyToPoll.id);
        final mergedReplyB = tester.channelState?.messages.firstWhere((it) => it.id == replyToReply.id);

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

    channelTest(
      'still preserves quotedMessage when the updated payload has no '
      'quoted_message at all (existing behavior should not regress)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
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

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [reSyncedReply],
          ),
        );

        final mergedReply = tester.channelState?.messages.firstWhere((it) => it.id == replyToPoll.id);

        expect(mergedReply, isNotNull);
        expect(mergedReply!.text, 'Definitely beach (edited)');
        expect(mergedReply.quotedMessage, isNotNull);
        expect(mergedReply.quotedMessage!.poll?.id, poll.id);
      },
    );

    channelTest(
      'preserves the top-level `poll` when the server emits a `message.updated`'
      ' that omits the `poll` object (regression: poll disappears from the '
      'parent message after a thread reply is added)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
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

        await tester.emitEvent(_updateMessageEvent(strippedParentUpdate));

        final merged = tester.channelState?.messages.firstWhere((it) => it.id == pollMessage.id);

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

    channelTest(
      'still uses the updated `poll` when the server includes one in '
      '`message.updated` (poll edits should not be reverted to the locally '
      'cached version)',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            messages: [pollMessage],
          ),
        );

        final updatedPoll = poll.copyWith(name: 'Edited name');
        final updatedParent = pollMessage.copyWith(poll: updatedPoll, updatedAt: DateTime.utc(2026, 4, 29, 12));

        await tester.emitEvent(_updateMessageEvent(updatedParent));

        final merged = tester.channelState?.messages.firstWhere((it) => it.id == pollMessage.id);

        // Server-echoed poll must override the locally cached one — poll edits
        // should not be reverted by the local-fallback merge.
        expect(merged?.poll, isNotNull);
        expect(merged?.poll?.name, 'Edited name');
      },
    );
  });
}
