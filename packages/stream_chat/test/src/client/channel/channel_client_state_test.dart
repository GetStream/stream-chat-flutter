// ignore_for_file: lines_longer_than_80_chars, cascade_invocations, deprecated_member_use_from_same_package, avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';
import 'channel_test_utils.dart';

void main() {
  group('Initialized Channel', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late Channel channel;

    setUpAll(() {
      // Fallback values
      registerFallbackValue(FakeMessage());
      registerFallbackValue(FakeAttachmentFile());
      registerFallbackValue(FakeEvent());

      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return createLogger(name);
      });

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);

      // fake clientState
      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      // client logger
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));

      // mock channel delivery reporter
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    // Setting up a initialized channel
    setUp(() {
      final channelState = generateChannelState(
        channelId,
        channelType,
        mockChannelConfig: true,
        ownCapabilities: [ChannelCapability.readEvents],
      );
      channel = Channel.fromState(client, channelState);
    });

    tearDown(() {
      channel.dispose();
      clearInteractions(client);
    });

    group('`ChannelClientState.updateMessage`', () {
      test('upsert: true (default) adds an unknown message', () async {
        final message = Message(
          id: 'unknown-message',
          user: client.state.currentUser,
          text: 'hello',
          createdAt: DateTime.utc(2026),
        );

        expect(channel.state!.messages, isEmpty);

        channel.state!.updateMessage(message);

        expect(channel.state!.messages.map((m) => m.id), ['unknown-message']);
      });

      test('upsert: false does NOT add an unknown message', () async {
        final message = Message(
          id: 'unknown-message',
          user: client.state.currentUser,
          text: 'hello',
          createdAt: DateTime.utc(2026),
        );

        expect(channel.state!.messages, isEmpty);

        channel.state!.updateMessage(message, upsert: false);

        expect(channel.state!.messages, isEmpty);
      });

      test('upsert: false updates a message already in the window', () async {
        const messageId = 'known-message';
        final seeded = Message(
          id: messageId,
          user: client.state.currentUser,
          text: 'old',
          createdAt: DateTime.utc(2026),
        );
        channel.state!.updateChannelState(
          channel.state!.channelState.copyWith(messages: [seeded]),
        );

        channel.state!.updateMessage(
          seeded.copyWith(text: 'new'),
          upsert: false,
        );

        final stored = channel.state!.messages.single;
        expect(stored.id, equals(messageId));
        expect(stored.text, equals('new'));
      });
    });

    group('stale error message cleanup', () {
      final channelState = generateChannelState(channelId, channelType);

      final errorMessage = Message(type: MessageType.error);
      final bouncedErrorMessage = Message(
        type: MessageType.error,
        moderation: const Moderation(
          action: ModerationAction.bounce,
          originalText: 'original text',
        ),
      );

      // Test case: sending a message cleans up stale error messages
      test('when sending a new message', () async {
        // Channel with 2 error messages
        final channel = Channel.fromState(
          client,
          channelState.copyWith(
            messages: [errorMessage, bouncedErrorMessage],
          ),
        );

        // Set up the mock response for sending message
        final newMessage = Message(text: 'New message');

        when(
          () => client.sendMessage(any(), channelId, channelType),
        ).thenAnswer((_) async => SendMessageResponse()..message = newMessage.copyWith(state: MessageState.sent));

        // Send a new message
        await channel.sendMessage(newMessage);
        final messages = channel.state!.messages;

        // Verify the cleanup
        expect(messages.length, 2);
        expect(messages.any((m) => m.id == errorMessage.id), false);
        expect(messages.any((m) => m.id == bouncedErrorMessage.id), true);
        expect(messages.any((m) => m.id == newMessage.id), true);

        verify(() => client.sendMessage(any(), channelId, channelType));
      });
    });

    group('`.state.pruneOldest`', () {
      List<Message> _generateMessages(int count) => List.generate(
        count,
        (i) => Message(
          id: 'msg-$i',
          text: 'Hello $i',
          createdAt: DateTime(2024).add(Duration(seconds: i)),
        ),
      );

      test('keeps only the [maxMessages] most recent messages', () {
        final initial = _generateMessages(10);
        channel.state!.updateChannelState(
          generateChannelState(channelId, channelType).copyWith(messages: initial),
        );
        expect(channel.state!.messages, hasLength(10));

        channel.state!.pruneOldest(4);

        final pruned = channel.state!.messages;
        expect(pruned, hasLength(4));
        expect(pruned.map((m) => m.id), ['msg-6', 'msg-7', 'msg-8', 'msg-9']);
      });

      test('emits the pruned list on `messagesStream`', () async {
        final initial = _generateMessages(6);
        channel.state!.updateChannelState(
          generateChannelState(channelId, channelType).copyWith(messages: initial),
        );

        final next = channel.state!.messagesStream.firstWhere((messages) => messages.length == 3);

        channel.state!.pruneOldest(3);

        final emitted = await next;
        expect(emitted.map((m) => m.id), ['msg-3', 'msg-4', 'msg-5']);
      });

      test('is a no-op when message count is within the limit', () {
        final initial = _generateMessages(3);
        channel.state!.updateChannelState(
          generateChannelState(channelId, channelType).copyWith(messages: initial),
        );

        channel.state!.pruneOldest(5);
        expect(channel.state!.messages, hasLength(3));

        channel.state!.pruneOldest(3);
        expect(channel.state!.messages, hasLength(3));
      });

      test('is a no-op when [maxMessages] is zero or negative', () {
        final initial = _generateMessages(5);
        channel.state!.updateChannelState(
          generateChannelState(channelId, channelType).copyWith(messages: initial),
        );

        channel.state!.pruneOldest(0);
        expect(channel.state!.messages, hasLength(5));

        channel.state!.pruneOldest(-1);
        expect(channel.state!.messages, hasLength(5));
      });

      test('is a no-op when `isUpToDate` is false', () {
        final initial = _generateMessages(10);
        channel.state!.updateChannelState(
          generateChannelState(channelId, channelType).copyWith(messages: initial),
        );

        channel.state!.isUpToDate = false;
        channel.state!.pruneOldest(3);
        expect(channel.state!.messages, hasLength(10));
      });

      test('only mutates `messages`; other channel state fields untouched', () {
        final initial = _generateMessages(10);
        final pinned = [
          Message(
            id: 'pinned-1',
            text: 'pinned message',
            createdAt: DateTime(2024),
          ),
        ];

        channel.state!.updateChannelState(
          generateChannelState(channelId, channelType).copyWith(
            messages: initial,
            pinnedMessages: pinned,
          ),
        );

        channel.state!.pruneOldest(3);

        expect(channel.state!.messages, hasLength(3));
        expect(channel.state!.pinnedMessages, equals(pinned));
      });

      test('does not emit on `messagesStream` for no-op calls', () async {
        final initial = _generateMessages(5);
        channel.state!.updateChannelState(
          generateChannelState(channelId, channelType).copyWith(messages: initial),
        );

        // Skip the seeded emission from updateChannelState.
        await pumpEventQueue();

        final emissions = <List<Message>>[];
        final sub = channel.state!.messagesStream.skip(1).listen(emissions.add);
        addTearDown(sub.cancel);

        channel.state!.pruneOldest(0); // non-positive guard
        channel.state!.pruneOldest(-1); // non-positive guard
        channel.state!.pruneOldest(10); // within limit guard
        channel.state!.isUpToDate = false;
        channel.state!.pruneOldest(2); // !isUpToDate guard

        await pumpEventQueue();
        expect(emissions, isEmpty);
      });
    });
  });

  group('WS events', () {
    late final client = MockStreamChatClient();

    setUpAll(() {
      // Fallback values
      registerFallbackValue(FakeMessage());
      registerFallbackValue(FakeAttachmentFile());
      registerFallbackValue(FakeEvent());

      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return createLogger(name);
      });

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);

      // fake clientState
      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      // client logger
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));

      // mock channel delivery reporter
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    group('Typing events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('${EventType.typingStart} from another user is added to typingEvents', () async {
        final otherUser = User(id: 'other-user');

        client.addEvent(
          Event(cid: channel.cid, type: EventType.typingStart, user: otherUser),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state!.typingEvents.keys.map((u) => u.id), ['other-user']);
        expect(channel.state!.typingEvents[otherUser]?.type, EventType.typingStart);
      });

      test('${EventType.typingStop} removes only the stopping user', () async {
        final user1 = User(id: 'other-user-1');
        final user2 = User(id: 'other-user-2');

        client.addEvent(Event(cid: channel.cid, type: EventType.typingStart, user: user1));
        client.addEvent(Event(cid: channel.cid, type: EventType.typingStart, user: user2));
        await Future.delayed(Duration.zero);
        expect(channel.state!.typingEvents, hasLength(2));

        client.addEvent(Event(cid: channel.cid, type: EventType.typingStop, user: user1));
        await Future.delayed(Duration.zero);

        expect(channel.state!.typingEvents.keys.map((u) => u.id), ['other-user-2']);
      });

      test('${EventType.typingStart} from the current user is ignored', () async {
        final currentUser = User(id: client.state.currentUser!.id);

        client.addEvent(Event(cid: channel.cid, type: EventType.typingStart, user: currentUser));
        await Future.delayed(Duration.zero);

        expect(channel.state!.typingEvents, isEmpty);
      });

      test('${EventType.typingStart} without a user is ignored', () async {
        client.addEvent(Event(cid: channel.cid, type: EventType.typingStart));
        await Future.delayed(Duration.zero);

        expect(channel.state!.typingEvents, isEmpty);
      });

      test('${EventType.typingStop} from the current user is ignored', () async {
        final currentUser = User(id: client.state.currentUser!.id);

        client.addEvent(Event(cid: channel.cid, type: EventType.typingStop, user: currentUser));
        await Future.delayed(Duration.zero);

        expect(channel.state!.typingEvents, isEmpty);
      });

      test('${EventType.typingStop} without a user is ignored', () async {
        client.addEvent(Event(cid: channel.cid, type: EventType.typingStop));
        await Future.delayed(Duration.zero);

        expect(channel.state!.typingEvents, isEmpty);
      });
    });

    group(
      '${EventType.messageNew} or ${EventType.notificationMessageNew}',
      () {
        final initialLastMessageAt = DateTime.now();
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        late Channel channel;

        setUp(() {
          final channelState = generateChannelState(
            channelId,
            channelType,
            mockChannelConfig: true,
            ownCapabilities: const [ChannelCapability.readEvents],
            lastMessageAt: initialLastMessageAt,
          );

          channel = Channel.fromState(client, channelState);
        });

        tearDown(() => channel.dispose());

        Event createNewMessageEvent(Message message) {
          return Event(
            cid: channel.cid,
            type: EventType.messageNew,
            message: message,
          );
        }

        test(
          "should update 'channel.lastMessageAt'",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              id: 'test-message-id',
              user: client.state.currentUser,
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, equals(message.createdAt));
            expect(channel.lastMessageAt, isNot(initialLastMessageAt));
          },
        );

        test(
          "should update 'channel.lastMessageAt' when Message has restricted visibility only for the current user",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              id: 'test-message-id',
              user: client.state.currentUser,
              // Message is visible to the current user.
              restrictedVisibility: [client.state.currentUser!.id],
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, equals(message.createdAt));
            expect(channel.lastMessageAt, isNot(initialLastMessageAt));
          },
        );

        test(
          "should not update 'channel.lastMessageAt' when 'message.createdAt' is older",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              id: 'test-message-id',
              user: client.state.currentUser,
              // Older than the current 'channel.lastMessageAt'.
              createdAt: initialLastMessageAt.subtract(const Duration(days: 1)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, isNot(message.createdAt));
            expect(channel.lastMessageAt, equals(initialLastMessageAt));
          },
        );

        test(
          "should not update 'channel.lastMessageAt' when Message is shadowed",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              id: 'test-message-id',
              user: client.state.currentUser,
              shadowed: true,
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, isNot(message.createdAt));
            expect(channel.lastMessageAt, equals(initialLastMessageAt));
          },
        );

        test(
          "should not update 'channel.lastMessageAt' when Message is ephemeral",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              type: MessageType.ephemeral,
              id: 'test-message-id',
              user: client.state.currentUser,
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, isNot(message.createdAt));
            expect(channel.lastMessageAt, equals(initialLastMessageAt));
          },
        );

        test(
          "should not update 'channel.lastMessageAt' when Message has restricted visibility but not for the current user",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              id: 'test-message-id',
              user: client.state.currentUser,
              // Message is only visible to user-1 not the current user.
              restrictedVisibility: const ['user-1'],
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, isNot(message.createdAt));
            expect(channel.lastMessageAt, equals(initialLastMessageAt));
          },
        );

        test(
          "should not update 'channel.lastMessageAt' when Message is system and skip is enabled",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            when(
              () => channel.config?.skipLastMsgUpdateForSystemMsgs,
            ).thenReturn(true);

            final message = Message(
              type: MessageType.system,
              id: 'test-message-id',
              user: client.state.currentUser,
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, isNot(message.createdAt));
            expect(channel.lastMessageAt, equals(initialLastMessageAt));
          },
        );

        test("should update 'unreadCount'", () async {
          expect(channel.state?.unreadCount, equals(0));

          final message = Message(
            id: 'test-message-id',
            user: User(id: 'other-user'),
            createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
          );

          final newMessageEvent = createNewMessageEvent(message);
          client.addEvent(newMessageEvent);

          // Wait for the event to get processed
          await Future.delayed(Duration.zero);

          expect(channel.state?.unreadCount, equals(1));

          final message2 = Message(
            id: 'test-message-id-2',
            user: User(id: 'other-user'),
            createdAt: message.createdAt.add(const Duration(seconds: 3)),
          );

          final newMessage2Event = createNewMessageEvent(message2);
          client.addEvent(newMessage2Event);

          // Wait for the event to get processed
          await Future.delayed(Duration.zero);

          expect(channel.state?.unreadCount, equals(2));
        });

        group("should not update 'unreadCount'", () {
          test(
            'when the message is silent',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                silent: true,
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message is shadowed',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                shadowed: true,
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message type is ephemeral',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                type: MessageType.ephemeral,
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message is a thread reply',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                parentId: 'test-parent-id',
                showInChannel: false,
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message is a thread reply',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                parentId: 'test-parent-id',
                showInChannel: false,
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message is from the current user',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                user: client.state.currentUser,
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message is not restricted for the current user',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
                restrictedVisibility: const ['other-user-2'],
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );
        });

        test(
          'should submit channel for delivery when message is received',
          () async {
            final message = Message(
              id: 'test-message-id',
              user: User(id: 'other-user'),
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            // Verify submitForDelivery was called
            verify(
              () => client.channelDeliveryReporter.submitForDelivery([channel]),
            ).called(1);
          },
        );

        test(
          'should not duplicate when server echoes back an optimistically '
          'inserted message with a later createdAt',
          () async {
            // Local message used as the input to `channel.sendMessage`.
            final localCreatedAt = initialLastMessageAt.add(const Duration(seconds: 3));
            final localMessage = Message(
              id: 'test-message-id',
              text: 'Hello world!',
              user: client.state.currentUser,
              createdAt: localCreatedAt,
            );

            // Mock the network send to return the message unchanged so the
            // optimistic insert + sent-state update both land on the same
            // `createdAt`. The bug fires later, on the WS echo.
            final sendMessageResponse = SendMessageResponse()
              ..message = localMessage.copyWith(state: MessageState.sent);
            when(() => client.sendMessage(any(), channelId, channelType)).thenAnswer((_) async => sendMessageResponse);

            await channel.sendMessage(localMessage);

            expect(channel.state!.messages, hasLength(1));

            // Server then broadcasts the same message via a `message.new`
            // event with a slightly later `createdAt` (server-assigned
            // timestamp).
            final serverMessage = localMessage.copyWith(
              createdAt: localCreatedAt.add(const Duration(milliseconds: 50)),
            );
            client.addEvent(createNewMessageEvent(serverMessage));

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            // The state should contain exactly one message with that id,
            // not a duplicate.
            final matching = channel.state!.messages.where((it) => it.id == localMessage.id);
            expect(matching, hasLength(1));
            expect(channel.state!.messages, hasLength(1));
          },
        );

        test(
          'should not duplicate when the locally-sent message is no longer '
          'the latest (retry-after-offline scenario)',
          () async {
            // Mirrors the offline-retry flow: a local message is sent, then
            // another message arrives via WS while the local one is still
            // pending. When the retry finally succeeds the server response's
            // `createdAt` is later than the intervening message, so the
            // locally-sent copy is no longer `messages.last`.
            final localCreatedAt = initialLastMessageAt.add(const Duration(seconds: 1));
            final localMessage = Message(
              id: 'local-message-id',
              text: 'Hello world!',
              user: client.state.currentUser,
              createdAt: localCreatedAt,
            );

            final sendMessageResponse = SendMessageResponse()
              ..message = localMessage.copyWith(state: MessageState.sent);
            when(() => client.sendMessage(any(), channelId, channelType)).thenAnswer((_) async => sendMessageResponse);

            await channel.sendMessage(localMessage);

            // Another message arrives via WS with a later `createdAt`,
            // pushing the locally-sent message off the tail.
            final otherMessage = Message(
              id: 'other-message-id',
              user: User(id: 'other-user'),
              createdAt: localCreatedAt.add(const Duration(seconds: 2)),
            );
            client.addEvent(createNewMessageEvent(otherMessage));
            await Future.delayed(Duration.zero);

            // Server then broadcasts the locally-sent message via
            // `message.new` with a `createdAt` that is later than the
            // intervening message — exactly the shape produced by a
            // successful retry after another message arrived in between.
            final serverEcho = localMessage.copyWith(
              createdAt: otherMessage.createdAt.add(const Duration(seconds: 1)),
            );
            client.addEvent(createNewMessageEvent(serverEcho));
            await Future.delayed(Duration.zero);

            final localMatches = channel.state!.messages.where((it) => it.id == localMessage.id);
            expect(localMatches, hasLength(1));
            expect(channel.state!.messages, hasLength(2));
          },
        );

        test(
          '${EventType.notificationMessageNew} adds the message and counts unread',
          () async {
            final message = Message(
              id: 'notified-message-id',
              user: User(id: 'other-user'),
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            client.addEvent(
              Event(
                cid: channel.cid,
                type: EventType.notificationMessageNew,
                message: message,
              ),
            );
            await Future.delayed(Duration.zero);

            expect(channel.state!.messages.map((m) => m.id), ['notified-message-id']);
            expect(channel.state!.unreadCount, 1);
          },
        );

        test(
          'a channel message is not appended while the channel is not up to date',
          () async {
            channel.state!.isUpToDate = false;

            final message = Message(
              id: 'below-window-message-id',
              user: User(id: 'other-user'),
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            client.addEvent(createNewMessageEvent(message));
            await Future.delayed(Duration.zero);

            expect(channel.state!.messages, isEmpty);
            expect(channel.state!.unreadCount, 1);
          },
        );

        test(
          'a thread-only reply is stored even while the channel is not up to date',
          () async {
            channel.state!.isUpToDate = false;

            final reply = Message(
              id: 'thread-reply-id',
              parentId: 'parent-message-id',
              user: User(id: 'other-user'),
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            client.addEvent(createNewMessageEvent(reply));
            await Future.delayed(Duration.zero);

            expect(channel.state!.messages, isEmpty);
            expect(channel.state!.threads['parent-message-id']?.map((m) => m.id), ['thread-reply-id']);
          },
        );

        test('an event without a message is ignored', () async {
          client.addEvent(Event(cid: channel.cid, type: EventType.messageNew));
          await Future.delayed(Duration.zero);

          expect(channel.state!.messages, isEmpty);
          expect(channel.lastMessageAt, initialLastMessageAt);
        });
      },
    );

    group(
      EventType.messageUpdated,
      () {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        late Channel channel;

        setUp(() {
          final channelState = generateChannelState(
            channelId,
            channelType,
            mockChannelConfig: true,
            ownCapabilities: const [ChannelCapability.readEvents],
          );

          channel = Channel.fromState(client, channelState);
        });

        tearDown(() => channel.dispose());

        Event createUpdateMessageEvent(Message message) {
          return Event(
            cid: channel.cid,
            type: EventType.messageUpdated,
            message: message,
          );
        }

        test(
          "should update 'channel.state.pinnedMessages' and should add message to pinned messages only once if updatedMessage.pinned is true",
          () async {
            const messageId = 'test-message-id';
            final message = Message(
              id: messageId,
              user: client.state.currentUser,
              pinned: true,
            );

            final newMessageEvent = createUpdateMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(1));
            expect(channel.state?.pinnedMessages.first.id, equals(messageId));
          },
        );

        test(
          'should update pinned message itself if updatedMessage.pinned is true and message is already pinned',
          () async {
            const messageId = 'test-message-id';
            const oldText = 'Old text';
            const newText = 'New text';
            final message = Message(
              id: messageId,
              user: client.state.currentUser,
              text: oldText,
              pinned: true,
            );

            final firstUpdateEvent = createUpdateMessageEvent(message);
            client.addEvent(firstUpdateEvent);

            // Wait for the first event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(1));
            expect(channel.state?.pinnedMessages.first.id, equals(messageId));
            expect(channel.state?.pinnedMessages.first.text, equals(oldText));

            final updatedMessage = message.copyWith(text: newText);
            final secondUpdateEvent = createUpdateMessageEvent(updatedMessage);
            client.addEvent(secondUpdateEvent);

            // Wait for the second event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(1));
            expect(channel.state?.pinnedMessages.first.id, equals(messageId));
            expect(channel.state?.pinnedMessages.first.text, equals(newText));
          },
        );

        test(
          "should update 'channel.state.pinnedMessages' and should add message to pinned messages "
          'and not unpin previous pinned message if updatedMessage.pinned is true and there is already another pinned message',
          () async {
            const firstMessageId = 'first-test-message-id';
            const secondMessageId = 'second-test-message-id';
            final firstMessage = Message(
              id: firstMessageId,
              user: client.state.currentUser,
              pinned: true,
            );
            final secondMessage = firstMessage.copyWith(id: secondMessageId);

            final firstUpdateEvent = createUpdateMessageEvent(firstMessage);
            client.addEvent(firstUpdateEvent);

            // Wait for the first event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(1));
            expect(
              channel.state?.pinnedMessages.first.id,
              equals(firstMessageId),
            );

            final secondUpdateEvent = createUpdateMessageEvent(secondMessage);
            client.addEvent(secondUpdateEvent);

            // Wait for the second event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(2));
            expect(
              channel.state?.pinnedMessages.first.id,
              equals(firstMessageId),
            );
            expect(
              channel.state?.pinnedMessages[1].id,
              equals(secondMessageId),
            );
          },
        );

        test(
          "should update 'channel.state.pinnedMessages' and should remove message from pinned messages if updatedMessage.pinned is false",
          () async {
            const messageId = 'test-message-id';
            final pinnedMessage = Message(
              id: messageId,
              user: client.state.currentUser,
              pinned: true,
            );

            final pinEvent = createUpdateMessageEvent(pinnedMessage);
            client.addEvent(pinEvent);

            // Wait for the pin event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(1));
            expect(channel.state?.pinnedMessages.first.id, equals(messageId));

            final unpinnedMessage = pinnedMessage.copyWith(pinned: false);
            final unpinEvent = createUpdateMessageEvent(unpinnedMessage);
            client.addEvent(unpinEvent);

            // Wait for the unpin event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages, isEmpty);
          },
        );

        // A `message.updated` event for a message outside the loaded window
        // would otherwise upsert into the sorted list — creating a phantom
        // entry with a gap. The guard is "id not in the loaded list", and
        // is independent of `isUpToDate` — even at the latest page we may
        // have paginated past older history and receive an event for a
        // message no longer in memory.
        group('when message is outside the loaded window', () {
          test(
            'should NOT insert unknown message into `messages` list',
            () async {
              // Simulate "we have the latest page but not older history":
              // seed the tail messages.
              final tail = List.generate(
                3,
                (i) => Message(
                  id: 'tail-$i',
                  user: client.state.currentUser,
                  text: 'tail $i',
                  createdAt: DateTime.utc(2026, 6, 1).add(Duration(seconds: i)),
                ),
              );
              channel.state!.updateChannelState(
                channel.state!.channelState.copyWith(messages: tail),
              );
              expect(channel.state!.messages, hasLength(3));

              // Event for a message on an older page we don't have loaded.
              final olderPageEdit = Message(
                id: 'older-page-msg',
                user: client.state.currentUser,
                text: 'edited on older page',
                createdAt: DateTime.utc(2025, 1, 1),
              );
              client.addEvent(createUpdateMessageEvent(olderPageEdit));
              await Future.delayed(Duration.zero);

              // Tail is unchanged, no phantom entry inserted at position 0.
              expect(channel.state!.messages.map((m) => m.id), ['tail-0', 'tail-1', 'tail-2']);
              expect(channel.state!.pinnedMessages, isEmpty);
            },
          );

          test(
            'should update message in place when it IS in the loaded window',
            () async {
              const messageId = 'known';
              final seeded = Message(
                id: messageId,
                user: client.state.currentUser,
                text: 'old',
                createdAt: DateTime.utc(2026),
              );
              channel.state!.updateChannelState(
                channel.state!.channelState.copyWith(messages: [seeded]),
              );
              channel.state!.isUpToDate = false;

              final edited = seeded.copyWith(text: 'new');
              client.addEvent(createUpdateMessageEvent(edited));
              await Future.delayed(Duration.zero);

              final stored = channel.state!.messages.singleWhere((m) => m.id == messageId);
              expect(stored.text, equals('new'));
            },
          );

          test(
            'should still add to pinnedMessages when pinned:true even if not in loaded window',
            () async {
              channel.state!.isUpToDate = false;
              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.pinnedMessages, isEmpty);

              const messageId = 'pin-me';
              final pinned = Message(
                id: messageId,
                user: client.state.currentUser,
                pinned: true,
              );
              client.addEvent(createUpdateMessageEvent(pinned));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.pinnedMessages.length, equals(1));
              expect(channel.state!.pinnedMessages.first.id, equals(messageId));
            },
          );

          test(
            'should NOT insert unknown reply into threads[parentId]',
            () async {
              const parentId = 'parent-1';
              final knownReply = Message(
                id: 'known-reply',
                parentId: parentId,
                user: client.state.currentUser,
                createdAt: DateTime.utc(2026),
              );
              // Populate threads[parentId] via addNewMessage's thread-only path.
              channel.state!.addNewMessage(knownReply);
              await Future.delayed(Duration.zero);
              expect(channel.state!.threads[parentId], hasLength(1));

              channel.state!.isUpToDate = false;

              final phantomReply = Message(
                id: 'other-reply',
                parentId: parentId,
                user: client.state.currentUser,
                text: 'edited',
                createdAt: DateTime.utc(2026, 1, 2),
              );
              client.addEvent(createUpdateMessageEvent(phantomReply));
              await Future.delayed(Duration.zero);

              expect(channel.state!.threads[parentId]!.map((m) => m.id), ['known-reply']);
            },
          );

          test(
            'should NOT create phantom threads[parentId] entry for unloaded thread',
            () async {
              const parentId = 'unloaded-parent';
              // The thread was never paged in, so there's no entry for it.
              expect(channel.state!.threads.containsKey(parentId), isFalse);

              channel.state!.isUpToDate = false;

              final phantomReply = Message(
                id: 'phantom-reply',
                parentId: parentId,
                user: client.state.currentUser,
                text: 'edited',
                createdAt: DateTime.utc(2026, 1, 2),
              );
              client.addEvent(createUpdateMessageEvent(phantomReply));
              await Future.delayed(Duration.zero);

              // The dropped reply must not leave behind an empty thread entry.
              expect(channel.state!.threads.containsKey(parentId), isFalse);
            },
          );

          test(
            'should still expire activeLiveLocations for out-of-window message',
            () async {
              final liveLocation = Location(
                channelCid: channel.cid,
                userId: 'user1',
                messageId: 'loc-msg',
                latitude: 40.7128,
                longitude: -74.0060,
                createdByDeviceId: 'device1',
                endAt: DateTime.now().add(const Duration(hours: 1)),
              );

              // Seed only activeLiveLocations, keeping `messages` empty —
              // the exact "message is outside the loaded window" scenario.
              channel.state!.updateChannelState(
                ChannelState(
                  channel: channel.state!.channelState.channel,
                  activeLiveLocations: [liveLocation],
                ),
              );
              channel.state!.isUpToDate = false;
              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.activeLiveLocations, hasLength(1));

              // A message.updated that expires the live location.
              final expiredMessage = Message(
                id: 'loc-msg',
                text: 'Live location shared',
                sharedLocation: liveLocation.copyWith(
                  endAt: DateTime.now().subtract(const Duration(minutes: 1)),
                ),
              );
              client.addEvent(createUpdateMessageEvent(expiredMessage));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.activeLiveLocations, isEmpty);
            },
          );
        });
      },
    );

    // A reply with `show_in_channel = true` is mirrored into both `messages`
    // and `threads[parentId]`. When the thread isn't loaded (fresh hydration,
    // user never opened the thread) the channel-level copy is the only place
    // locally-cached fields like `ownReactions`/`poll` survive — so reaction
    // and message-update events for such replies must still find it.
    group(
      'reply events with `show_in_channel = true` and unloaded thread',
      () {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        const replyId = 'mirrored-reply-id';
        const parentId = 'parent-message-id';
        // Pinned createdAt keeps oldIndex lookups stable in `updateMessage`.
        final createdAt = DateTime.utc(2026, 1, 1);
        late Channel channel;

        setUp(() {
          final channelState = generateChannelState(
            channelId,
            channelType,
            mockChannelConfig: true,
            ownCapabilities: const [ChannelCapability.readEvents],
          );
          channel = Channel.fromState(client, channelState);
        });

        tearDown(() => channel.dispose());

        // Seeds a single reply into the channel-level `messages` while leaving
        // `threads[parentId]` empty — the exact regression scenario.
        Message seedMirroredReply({
          List<Reaction> ownReactions = const [],
          Poll? poll,
        }) {
          final reply = Message(
            id: replyId,
            parentId: parentId,
            showInChannel: true,
            user: client.state.currentUser,
            createdAt: createdAt,
            ownReactions: ownReactions,
            poll: poll,
            pollId: poll?.id,
          );
          channel.state!.updateChannelState(
            channel.state!.channelState.copyWith(messages: [reply]),
          );
          return reply;
        }

        test(
          '`reaction.new` from another user preserves `ownReactions`',
          () async {
            final ownReaction = Reaction(
              type: 'like',
              messageId: replyId,
              user: client.state.currentUser,
            );
            seedMirroredReply(ownReactions: [ownReaction]);
            // Pre-condition: thread is not loaded.
            expect(channel.state!.threads, isEmpty);

            // Server reaction events don't echo back the recipient's own
            // reactions, so the listener must pull them from the cached copy.
            final otherUserReaction = Reaction(
              type: 'love',
              messageId: replyId,
              user: User(id: 'other-user'),
            );
            client.addEvent(
              Event(
                cid: channel.cid,
                type: EventType.reactionNew,
                reaction: otherUserReaction,
                message: Message(
                  id: replyId,
                  parentId: parentId,
                  showInChannel: true,
                  user: client.state.currentUser,
                  createdAt: createdAt,
                  latestReactions: [otherUserReaction],
                ),
              ),
            );

            await Future.delayed(Duration.zero);

            final stored = channel.state!.messages.firstWhere((it) => it.id == replyId);
            expect(stored.ownReactions, [ownReaction]);
          },
        );

        test(
          '`reaction.deleted` strips only the removed reaction',
          () async {
            final kept = Reaction(
              type: 'like',
              messageId: replyId,
              user: client.state.currentUser,
            );
            final removed = Reaction(
              type: 'love',
              messageId: replyId,
              user: client.state.currentUser,
            );
            seedMirroredReply(ownReactions: [kept, removed]);
            expect(channel.state!.threads, isEmpty);

            client.addEvent(
              Event(
                cid: channel.cid,
                type: EventType.reactionDeleted,
                reaction: removed,
                message: Message(
                  id: replyId,
                  parentId: parentId,
                  showInChannel: true,
                  user: client.state.currentUser,
                  createdAt: createdAt,
                ),
              ),
            );

            await Future.delayed(Duration.zero);

            final stored = channel.state!.messages.firstWhere((it) => it.id == replyId);
            expect(stored.ownReactions, [kept]);
          },
        );

        test(
          '`message.updated` preserves `poll`, `pollId`, and `ownReactions`',
          () async {
            final ownReaction = Reaction(
              type: 'like',
              messageId: replyId,
              user: client.state.currentUser,
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
            seedMirroredReply(ownReactions: [ownReaction], poll: poll);
            expect(channel.state!.threads, isEmpty);

            client.addEvent(
              Event(
                cid: channel.cid,
                type: EventType.messageUpdated,
                message: Message(
                  id: replyId,
                  parentId: parentId,
                  showInChannel: true,
                  user: client.state.currentUser,
                  createdAt: createdAt,
                  text: 'edited',
                ),
              ),
            );

            await Future.delayed(Duration.zero);

            final stored = channel.state!.messages.firstWhere((it) => it.id == replyId);
            expect(stored.ownReactions, [ownReaction]);
            expect(stored.poll?.id, poll.id);
            expect(stored.pollId, poll.id);
          },
        );
      },
    );

    group('Reaction events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const messageId = 'reaction-message-id';
      final createdAt = DateTime.now();
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      Message seedMessage({String? parentId, List<Reaction> ownReactions = const []}) {
        final message = Message(
          id: messageId,
          parentId: parentId,
          user: User(id: 'other-user'),
          text: 'react to me',
          createdAt: createdAt,
          ownReactions: ownReactions,
        );
        channel.state!.updateMessage(message);
        return message;
      }

      test('${EventType.reactionNew} from the current user is added to ownReactions', () async {
        seedMessage();

        final reaction = Reaction(
          type: 'like',
          messageId: messageId,
          user: client.state.currentUser,
        );
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.reactionNew,
            reaction: reaction,
            message: Message(
              id: messageId,
              user: User(id: 'other-user'),
              createdAt: createdAt,
              latestReactions: [reaction],
            ),
          ),
        );
        await Future.delayed(Duration.zero);

        final stored = channel.state!.messages.firstWhere((it) => it.id == messageId);
        expect(stored.ownReactions?.map((r) => r.type), ['like']);
      });

      test('${EventType.reactionNew} updates a thread message', () async {
        const parentId = 'reaction-parent-id';
        seedMessage(parentId: parentId);

        final reaction = Reaction(
          type: 'like',
          messageId: messageId,
          user: client.state.currentUser,
        );
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.reactionNew,
            reaction: reaction,
            message: Message(
              id: messageId,
              parentId: parentId,
              user: User(id: 'other-user'),
              createdAt: createdAt,
            ),
          ),
        );
        await Future.delayed(Duration.zero);

        final stored = channel.state!.threads[parentId]!.firstWhere((it) => it.id == messageId);
        expect(stored.ownReactions?.map((r) => r.type), ['like']);
      });

      test('${EventType.reactionUpdated} from the current user replaces ownReactions', () async {
        final existing = Reaction(
          type: 'love',
          messageId: messageId,
          user: client.state.currentUser,
        );
        seedMessage(ownReactions: [existing]);

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.reactionUpdated,
            reaction: Reaction(
              type: 'like',
              messageId: messageId,
              user: client.state.currentUser,
            ),
            message: Message(
              id: messageId,
              user: User(id: 'other-user'),
              createdAt: createdAt,
            ),
          ),
        );
        await Future.delayed(Duration.zero);

        final stored = channel.state!.messages.firstWhere((it) => it.id == messageId);
        expect(stored.ownReactions?.map((r) => r.type), ['like']);
      });

      test('${EventType.reactionDeleted} updates a thread message', () async {
        const parentId = 'reaction-parent-id';
        final removed = Reaction(
          type: 'love',
          messageId: messageId,
          user: client.state.currentUser,
        );
        seedMessage(parentId: parentId, ownReactions: [removed]);

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.reactionDeleted,
            reaction: removed,
            message: Message(
              id: messageId,
              parentId: parentId,
              user: User(id: 'other-user'),
              createdAt: createdAt,
            ),
          ),
        );
        await Future.delayed(Duration.zero);

        final stored = channel.state!.threads[parentId]!.firstWhere((it) => it.id == messageId);
        expect(stored.ownReactions, isEmpty);
      });
    });

    group('Poll events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      const pollMessageId = 'poll-message-id';
      const pollId = 'poll-id';
      final createdAt = DateTime.now();
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      Poll createPoll({
        String name = 'Favorite color?',
        List<PollVote> latestAnswers = const [],
        List<PollVote> ownVotesAndAnswers = const [],
      }) {
        return Poll(
          id: pollId,
          name: name,
          options: const [
            PollOption(id: 'option-a', text: 'A'),
            PollOption(id: 'option-b', text: 'B'),
          ],
          latestAnswers: latestAnswers,
          ownVotesAndAnswers: ownVotesAndAnswers,
        );
      }

      Message seedPollMessage({
        String? parentId,
        List<PollVote> latestAnswers = const [],
        List<PollVote> ownVotesAndAnswers = const [],
      }) {
        final message = Message(
          id: pollMessageId,
          parentId: parentId,
          user: User(id: 'other-user'),
          createdAt: createdAt,
          poll: createPoll(
            latestAnswers: latestAnswers,
            ownVotesAndAnswers: ownVotesAndAnswers,
          ),
        );
        channel.state!.updateMessage(message);
        return message;
      }

      Message storedPollMessage() {
        return channel.state!.messages.firstWhere((it) => it.id == pollMessageId);
      }

      test('${EventType.pollCreated} adds the poll message', () async {
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollCreated,
            message: Message(
              id: pollMessageId,
              user: User(id: 'other-user'),
              createdAt: createdAt,
              poll: createPoll(),
            ),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(storedPollMessage().poll?.id, pollId);
      });

      test('${EventType.pollCreated} without a poll is ignored', () async {
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollCreated,
            message: Message(
              id: pollMessageId,
              user: User(id: 'other-user'),
              createdAt: createdAt,
            ),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state!.messages, isEmpty);
      });

      test('${EventType.pollUpdated} updates the poll but preserves own votes', () async {
        final ownVote = PollVote(
          id: 'own-vote-id',
          optionId: 'option-a',
          userId: client.state.currentUser!.id,
        );
        seedPollMessage(ownVotesAndAnswers: [ownVote]);

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollUpdated,
            poll: createPoll(name: 'Renamed'),
          ),
        );
        await Future.delayed(Duration.zero);

        final stored = storedPollMessage();
        expect(stored.poll?.name, 'Renamed');
        expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-vote-id']);
      });

      test('${EventType.pollUpdated} for an unknown poll is ignored', () async {
        seedPollMessage();

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollUpdated,
            poll: Poll(
              id: 'unknown-poll-id',
              name: 'Renamed',
              options: const [PollOption(text: 'A')],
            ),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(storedPollMessage().poll?.name, 'Favorite color?');
      });

      test('${EventType.pollUpdated} without a poll is ignored', () async {
        seedPollMessage();

        client.addEvent(Event(cid: channel.cid, type: EventType.pollUpdated));
        await Future.delayed(Duration.zero);

        expect(storedPollMessage().poll?.name, 'Favorite color?');
      });

      test('${EventType.pollUpdated} updates a poll on a thread message', () async {
        const parentId = 'poll-parent-id';
        seedPollMessage(parentId: parentId);

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollUpdated,
            poll: createPoll(name: 'Renamed'),
          ),
        );
        await Future.delayed(Duration.zero);

        final stored = channel.state!.threads[parentId]!.firstWhere((it) => it.id == pollMessageId);
        expect(stored.poll?.name, 'Renamed');
      });

      test('${EventType.pollClosed} closes the poll and keeps the cached data', () async {
        seedPollMessage();

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollClosed,
            poll: createPoll(name: 'Renamed'),
          ),
        );
        await Future.delayed(Duration.zero);

        final stored = storedPollMessage();
        expect(stored.poll?.isClosed, isTrue);
        expect(stored.poll?.name, 'Favorite color?');
      });

      test('${EventType.pollAnswerCasted} adds own answers only for the current user', () async {
        seedPollMessage();

        final ownAnswer = PollVote(
          id: 'own-answer-id',
          answerText: 'my answer',
          userId: client.state.currentUser!.id,
        );
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollAnswerCasted,
            poll: createPoll(),
            pollVote: ownAnswer,
          ),
        );
        await Future.delayed(Duration.zero);

        var stored = storedPollMessage();
        expect(stored.poll?.latestAnswers.map((v) => v.id), ['own-answer-id']);
        expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-answer-id']);

        final otherAnswer = PollVote(
          id: 'other-answer-id',
          answerText: 'their answer',
          userId: 'other-user',
        );
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollAnswerCasted,
            poll: createPoll(),
            pollVote: otherAnswer,
          ),
        );
        await Future.delayed(Duration.zero);

        stored = storedPollMessage();
        expect(stored.poll?.latestAnswers.map((v) => v.id), contains('other-answer-id'));
        expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-answer-id']);
      });

      test('${EventType.pollVoteCasted} adds own votes only for the current user', () async {
        seedPollMessage();

        final ownVote = PollVote(
          id: 'own-vote-id',
          optionId: 'option-a',
          userId: client.state.currentUser!.id,
        );
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollVoteCasted,
            poll: createPoll(),
            pollVote: ownVote,
          ),
        );
        await Future.delayed(Duration.zero);

        var stored = storedPollMessage();
        expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-vote-id']);

        final otherVote = PollVote(
          id: 'other-vote-id',
          optionId: 'option-b',
          userId: 'other-user',
        );
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollVoteCasted,
            poll: createPoll(),
            pollVote: otherVote,
          ),
        );
        await Future.delayed(Duration.zero);

        stored = storedPollMessage();
        expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-vote-id']);
      });

      test('${EventType.pollVoteChanged} upserts the current user vote', () async {
        seedPollMessage();

        final changedVote = PollVote(
          id: 'changed-vote-id',
          optionId: 'option-b',
          userId: client.state.currentUser!.id,
        );
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollVoteChanged,
            poll: createPoll(),
            pollVote: changedVote,
          ),
        );
        await Future.delayed(Duration.zero);

        expect(
          storedPollMessage().poll?.ownVotesAndAnswers.map((v) => v.id),
          contains('changed-vote-id'),
        );
      });

      test('${EventType.pollAnswerRemoved} removes the answer from both lists', () async {
        final answer = PollVote(
          id: 'answer-id',
          answerText: 'my answer',
          userId: client.state.currentUser!.id,
        );
        seedPollMessage(latestAnswers: [answer], ownVotesAndAnswers: [answer]);

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollAnswerRemoved,
            poll: createPoll(),
            pollVote: answer,
          ),
        );
        await Future.delayed(Duration.zero);

        final stored = storedPollMessage();
        expect(stored.poll?.latestAnswers, isEmpty);
        expect(stored.poll?.ownVotesAndAnswers, isEmpty);
      });

      test('${EventType.pollVoteRemoved} removes the vote from own votes', () async {
        final vote = PollVote(
          id: 'vote-id',
          optionId: 'option-a',
          userId: client.state.currentUser!.id,
        );
        seedPollMessage(ownVotesAndAnswers: [vote]);

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.pollVoteRemoved,
            poll: createPoll(),
            pollVote: vote,
          ),
        );
        await Future.delayed(Duration.zero);

        expect(storedPollMessage().poll?.ownVotesAndAnswers, isEmpty);
      });
    });

    // A `message.deleted` event for a message outside the loaded window
    // must not upsert a "deleted" record into the sorted list — that would
    // create a phantom entry with a gap. Pinned + live-location
    // side-effects must still fire.
    group(
      EventType.messageDeleted,
      () {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        late Channel channel;

        setUp(() {
          final channelState = generateChannelState(
            channelId,
            channelType,
            mockChannelConfig: true,
            ownCapabilities: const [ChannelCapability.readEvents],
          );
          channel = Channel.fromState(client, channelState);
        });

        tearDown(() => channel.dispose());

        Event createDeleteMessageEvent(Message message, {bool hardDelete = false}) {
          return Event(
            cid: channel.cid,
            type: EventType.messageDeleted,
            message: message.copyWith(
              type: MessageType.deleted,
              deletedAt: DateTime.timestamp(),
            ),
            hardDelete: hardDelete,
          );
        }

        // Same design as the `messageUpdated` guards: the check is
        // "message-in-loaded-window" and is independent of `isUpToDate` —
        // an event for a message on an older, unloaded page must not be
        // turned into a phantom "deleted" record inserted into the sorted
        // list.
        group('when message is outside the loaded window', () {
          test(
            'soft delete does NOT insert phantom "deleted" record into messages',
            () async {
              final tail = List.generate(
                3,
                (i) => Message(
                  id: 'tail-$i',
                  user: client.state.currentUser,
                  text: 'tail $i',
                  createdAt: DateTime.utc(2026, 6, 1).add(Duration(seconds: i)),
                ),
              );
              channel.state!.updateChannelState(
                channel.state!.channelState.copyWith(messages: tail),
              );
              expect(channel.state!.messages, hasLength(3));

              final olderPage = Message(
                id: 'older-page-msg',
                user: client.state.currentUser,
                text: 'gone',
                createdAt: DateTime.utc(2025, 1, 1),
              );
              client.addEvent(createDeleteMessageEvent(olderPage));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages.map((m) => m.id), ['tail-0', 'tail-1', 'tail-2']);
            },
          );

          test(
            'soft delete marks message as deleted when it IS in the loaded window',
            () async {
              const messageId = 'known';
              final seeded = Message(
                id: messageId,
                user: client.state.currentUser,
                text: 'hi',
                createdAt: DateTime.utc(2026),
              );
              channel.state!.updateChannelState(
                channel.state!.channelState.copyWith(messages: [seeded]),
              );
              channel.state!.isUpToDate = false;

              client.addEvent(createDeleteMessageEvent(seeded));
              await Future.delayed(Duration.zero);

              final stored = channel.state!.messages.singleWhere((m) => m.id == messageId);
              expect(stored.type, equals(MessageType.deleted));
              expect(stored.deletedAt, isNotNull);
            },
          );

          test(
            'soft delete unpins a pinned-but-not-in-window message via _pinIsValid',
            () async {
              const messageId = 'pinned-msg';
              final pinned = Message(
                id: messageId,
                user: client.state.currentUser,
                pinned: true,
                createdAt: DateTime.utc(2026),
              );
              // Seed only the pinnedMessages list — message absent from
              // the main `messages` window.
              channel.state!.updateChannelState(
                channel.state!.channelState.copyWith(pinnedMessages: [pinned]),
              );
              channel.state!.isUpToDate = false;
              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.pinnedMessages, hasLength(1));

              client.addEvent(createDeleteMessageEvent(pinned));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.pinnedMessages, isEmpty);
            },
          );

          test(
            'soft delete still clears activeLiveLocations even when message not in window',
            () async {
              final liveLocation = Location(
                channelCid: channel.cid,
                userId: 'user1',
                messageId: 'loc-msg',
                latitude: 40.7128,
                longitude: -74.0060,
                createdByDeviceId: 'device1',
                endAt: DateTime.now().add(const Duration(hours: 1)),
              );

              // Seed only activeLiveLocations, keeping `messages` empty.
              channel.state!.updateChannelState(
                ChannelState(
                  channel: channel.state!.channelState.channel,
                  activeLiveLocations: [liveLocation],
                ),
              );
              channel.state!.isUpToDate = false;
              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.activeLiveLocations, hasLength(1));

              final locationMessage = Message(
                id: 'loc-msg',
                text: 'Live location shared',
                sharedLocation: liveLocation,
              );
              client.addEvent(createDeleteMessageEvent(locationMessage));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.activeLiveLocations, isEmpty);
            },
          );

          test(
            'hard delete is a no-op when message is not in the loaded window',
            () async {
              channel.state!.isUpToDate = false;
              expect(channel.state!.messages, isEmpty);

              final phantom = Message(
                id: 'phantom',
                user: client.state.currentUser,
                text: 'gone',
                createdAt: DateTime.utc(2026),
              );
              client.addEvent(createDeleteMessageEvent(phantom, hardDelete: true));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.pinnedMessages, isEmpty);
            },
          );
        });

        test('an in-window hard delete removes the message', () async {
          final message = Message(
            id: 'doomed-message-id',
            user: User(id: 'other-user'),
            createdAt: DateTime.now(),
          );
          channel.state!.updateMessage(message);
          expect(channel.state!.messages, hasLength(1));

          client.addEvent(createDeleteMessageEvent(message, hardDelete: true));
          await Future.delayed(Duration.zero);

          expect(channel.state!.messages, isEmpty);
        });

        test('deletedForMe is propagated to the stored message', () async {
          final message = Message(
            id: 'deleted-for-me-message-id',
            user: User(id: 'other-user'),
            createdAt: DateTime.now(),
          );
          channel.state!.updateMessage(message);

          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.messageDeleted,
              deletedForMe: true,
              message: message.copyWith(
                type: MessageType.deleted,
                deletedAt: DateTime.timestamp(),
              ),
            ),
          );
          await Future.delayed(Duration.zero);

          final stored = channel.state!.messages.single;
          expect(stored.deletedForMe, isTrue);
          expect(stored.type, MessageType.deleted);
        });
      },
    );

    group('Channel updated events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('merges the event channel into the current channel model', () async {
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.channelUpdated,
            channel: ChannelModel(
              id: channelId,
              type: channelType,
              memberCount: 42,
              extraData: const {'name': 'updated-name'},
            ),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(channel.memberCount, 42);
        expect(channel.extraData['name'], 'updated-name');
      });

      test('replaces the member list with the event members', () async {
        channel.state!.updateChannelState(
          channel.state!.channelState.copyWith(
            members: [
              Member(userId: 'member-1'),
              Member(userId: 'member-2'),
            ],
          ),
        );

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.channelUpdated,
            channel: ChannelModel(
              id: channelId,
              type: channelType,
              members: [Member(userId: 'member-3')],
            ),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state!.channelState.members?.map((m) => m.userId), ['member-3']);
      });
    });

    group('Channel truncated events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;
      late MockPersistenceClient persistenceClient;

      setUp(() {
        persistenceClient = MockPersistenceClient();
        when(() => client.chatPersistenceClient).thenReturn(persistenceClient);
        when(() => persistenceClient.deleteMessageByCid(any())).thenAnswer((_) async {});
        when(() => persistenceClient.getChannelThreads(any())).thenAnswer((_) async => {});

        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
        // Reset so the remaining groups run without a persistence layer.
        when(() => client.chatPersistenceClient).thenReturn(null);
      });

      Message seedMessage(String id) {
        final message = Message(
          id: id,
          user: User(id: 'other-user'),
          text: 'to be truncated',
          createdAt: DateTime.now(),
        );
        channel.state!.updateMessage(message);
        return message;
      }

      test('${EventType.channelTruncated} clears messages and wipes persistence', () async {
        seedMessage('truncated-message-1');
        seedMessage('truncated-message-2');
        expect(channel.state!.messages, hasLength(2));

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.channelTruncated,
            channel: ChannelModel(id: channelId, type: channelType),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state!.messages, isEmpty);
        verify(() => persistenceClient.deleteMessageByCid(channel.cid!)).called(1);
      });

      test('${EventType.notificationChannelTruncated} keeps the event system message', () async {
        seedMessage('truncated-message-1');

        final systemMessage = Message(
          id: 'system-message-id',
          type: MessageType.system,
          text: 'Channel truncated',
          createdAt: DateTime.now(),
        );
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.notificationChannelTruncated,
            channel: ChannelModel(id: channelId, type: channelType),
            message: systemMessage,
          ),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state!.messages.map((m) => m.id), ['system-message-id']);
      });
    });

    group('Member Events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test(
        'should update membership when member is updated and is current user',
        () async {
          final currentUser = client.state.currentUser;
          final currentMember = Member(user: currentUser);
          final now = DateTime.now();

          // Setup initial membership
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              members: [currentMember],
              membership: currentMember,
            ),
          );

          // Verify initial state
          expect(channel.membership, isNotNull);
          expect(channel.membership?.channelRole, isNull);
          expect(channel.membership?.isModerator, false);
          expect(channel.isPinned, isFalse);
          expect(channel.isArchived, isFalse);

          // Create updated member with same userId but updated properties
          final updatedMember = currentMember.copyWith(
            channelRole: 'moderator',
            isModerator: true,
            pinnedAt: now,
            archivedAt: now,
          );

          // Create member updated event
          final memberUpdatedEvent = Event(
            cid: channel.cid,
            type: EventType.memberUpdated,
            user: currentUser,
            member: updatedMember,
          );

          // Dispatch event
          client.addEvent(memberUpdatedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify membership is updated with new properties
          expect(channel.membership, isNotNull);
          expect(channel.membership?.userId, equals(currentUser?.id));
          expect(channel.membership?.channelRole, equals('moderator'));
          expect(channel.membership?.isModerator, isTrue);
          expect(channel.isPinned, isTrue);
          expect(channel.isArchived, isTrue);
        },
      );

      test(
        'should update membership user when any event containing user is updated',
        () async {
          final currentUser = client.state.currentUser;
          final currentMember = Member(user: currentUser);

          // Setup initial membership
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              members: [currentMember],
              membership: currentMember,
            ),
          );

          // Verify initial state
          expect(channel.membership, isNotNull);
          expect(channel.membership?.user?.id, equals(currentUser?.id));
          expect(channel.membership?.user?.role, equals(currentUser?.role));

          // Create updated user with same userId but updated properties
          final updatedUser = currentUser?.copyWith(role: 'moderator');

          // Create any event with same updated user as membership.
          final anyEvent = Event(
            cid: channel.cid,
            type: EventType.any,
            user: updatedUser,
          );

          // Dispatch event
          client.addEvent(anyEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify membership is updated with new properties
          expect(channel.membership, isNotNull);
          expect(channel.membership?.user?.id, equals(updatedUser?.id));
          expect(channel.membership?.user?.role, equals(updatedUser?.role));
        },
      );

      test('${EventType.memberAdded} appends the member', () async {
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.memberAdded,
            member: Member(userId: 'new-member'),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state!.channelState.members?.map((m) => m.userId), ['new-member']);
      });

      test('${EventType.memberRemoved} removes the member', () async {
        channel.state!.updateChannelState(
          channel.state!.channelState.copyWith(
            members: [
              Member(userId: 'member-1'),
              Member(userId: 'member-2'),
            ],
          ),
        );

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.memberRemoved,
            user: User(id: 'member-1'),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state!.channelState.members?.map((m) => m.userId), ['member-2']);
      });

      test('${EventType.memberUpdated} replaces the member entry', () async {
        channel.state!.updateChannelState(
          channel.state!.channelState.copyWith(
            members: [Member(userId: 'member-1', channelRole: 'channel_member')],
          ),
        );

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.memberUpdated,
            member: Member(userId: 'member-1', channelRole: 'channel_moderator'),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state!.channelState.members?.single.channelRole, 'channel_moderator');
      });

      test('an event user that is not a member is ignored', () async {
        channel.state!.updateChannelState(
          channel.state!.channelState.copyWith(
            members: [
              Member(
                userId: 'member-1',
                user: User(id: 'member-1', name: 'old-name'),
              ),
            ],
          ),
        );

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.userUpdated,
            user: User(id: 'stranger', name: 'new-name'),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state!.channelState.members?.single.user?.name, 'old-name');
      });

      group('user banned/unbanned events', () {
        setUp(() {
          clearInteractions(client);

          channel.state!.updateChannelState(
            channel.state!.channelState.copyWith(
              members: [
                Member(
                  userId: 'bad-user',
                  user: User(id: 'bad-user'),
                  channelRole: 'channel_member',
                ),
              ],
            ),
          );

          when(
            () => client.queryMembers(
              channelType,
              channelId: channelId,
              filter: Filter.equal('id', 'bad-user'),
              members: any(named: 'members'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenAnswer(
            (_) async => QueryMembersResponse()..members = [Member(userId: 'bad-user', channelRole: 'channel_banned')],
          );
        });

        test('${EventType.userBanned} refreshes the member from the server', () async {
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.userBanned,
              user: User(id: 'bad-user'),
            ),
          );
          await Future.delayed(Duration.zero);
          await Future.delayed(Duration.zero);

          expect(channel.state!.channelState.members?.single.channelRole, 'channel_banned');
        });

        test('${EventType.userUnbanned} refreshes the member from the server', () async {
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.userUnbanned,
              user: User(id: 'bad-user'),
            ),
          );
          await Future.delayed(Duration.zero);
          await Future.delayed(Duration.zero);

          expect(channel.state!.channelState.members?.single.channelRole, 'channel_banned');
        });

        test('an app-level ban without a cid is ignored', () async {
          client.addEvent(
            Event(
              type: EventType.userBanned,
              user: User(id: 'bad-user'),
            ),
          );
          await Future.delayed(Duration.zero);
          await Future.delayed(Duration.zero);

          expect(channel.state!.channelState.members?.single.channelRole, 'channel_member');
          verifyNever(
            () => client.queryMembers(
              any(),
              channelId: any(named: 'channelId'),
              filter: any(named: 'filter'),
              members: any(named: 'members'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          );
        });
      });
    });

    group('Watching Events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(
          channelId,
          channelType,
          mockChannelConfig: true,
          ownCapabilities: const [ChannelCapability.readEvents],
        );
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() => channel.dispose());

      test(
        '${EventType.userWatchingStart} adds the watcher and updates watcherCount',
        () async {
          final watcher = User(id: 'watcher-1');

          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.userWatchingStart,
              user: watcher,
              watcherCount: 3,
            ),
          );

          // Wait for the event to get processed
          await Future.delayed(Duration.zero);

          expect(channel.state!.watcherCount, 3);
          expect(
            channel.state!.channelState.watchers?.map((it) => it.id),
            contains('watcher-1'),
          );
        },
      );

      test(
        '${EventType.userWatchingStop} removes the watcher and updates watcherCount',
        () async {
          final watcher = User(id: 'watcher-1');

          // The watcher starts watching first (count = 2).
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.userWatchingStart,
              user: watcher,
              watcherCount: 2,
            ),
          );
          await Future.delayed(Duration.zero);
          expect(channel.state!.watcherCount, 2);
          expect(
            channel.state!.channelState.watchers?.map((it) => it.id),
            contains('watcher-1'),
          );

          // Then stops watching (count = 1).
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.userWatchingStop,
              user: watcher,
              watcherCount: 1,
            ),
          );
          await Future.delayed(Duration.zero);

          expect(channel.state!.watcherCount, 1);
          expect(
            channel.state!.channelState.watchers?.map((it) => it.id),
            isNot(contains('watcher-1')),
          );
        },
      );

      test(
        'watching event without watcherCount preserves the existing count',
        () async {
          // Seed an initial watcher count.
          channel.state!.updateChannelState(
            channel.state!.channelState.copyWith(watcherCount: 5),
          );
          expect(channel.state!.watcherCount, 5);

          // A watching event that omits watcher_count must not wipe the count.
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.userWatchingStart,
              user: User(id: 'watcher-2'),
            ),
          );
          await Future.delayed(Duration.zero);

          expect(channel.state!.watcherCount, 5);
          expect(
            channel.state!.channelState.watchers?.map((it) => it.id),
            contains('watcher-2'),
          );
        },
      );

      test(
        '${EventType.messageNew} updates watcherCount from the event',
        () async {
          expect(channel.state!.watcherCount, isNull);

          final message = Message(
            id: 'test-message-id',
            user: client.state.currentUser,
            createdAt: DateTime.now(),
          );

          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.messageNew,
              message: message,
              watcherCount: 7,
            ),
          );
          await Future.delayed(Duration.zero);

          expect(channel.state!.watcherCount, 7);
        },
      );

      test(
        '${EventType.messageNew} without watcherCount preserves the existing count',
        () async {
          // Seed an initial watcher count.
          channel.state!.updateChannelState(
            channel.state!.channelState.copyWith(watcherCount: 4),
          );
          expect(channel.state!.watcherCount, 4);

          // A local/optimistic message.new without watcher_count must not
          // reset the count.
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.messageNew,
              message: Message(
                id: 'test-message-id-2',
                user: client.state.currentUser,
                createdAt: DateTime.now(),
              ),
            ),
          );
          await Future.delayed(Duration.zero);

          expect(channel.state!.watcherCount, 4);
        },
      );

      test(
        '${EventType.notificationMessageNew} does not overwrite watcherCount',
        () async {
          // Seed a known watcher count.
          channel.state!.updateChannelState(
            channel.state!.channelState.copyWith(watcherCount: 5),
          );
          expect(channel.state!.watcherCount, 5);

          // notification.message_new is delivered to non-watchers and reports
          // watcher_count: 0; it must not clobber the real count.
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.notificationMessageNew,
              message: Message(
                id: 'notif-message-id',
                user: User(id: 'other-user'),
                createdAt: DateTime.now(),
              ),
              watcherCount: 0,
            ),
          );
          await Future.delayed(Duration.zero);

          expect(channel.state!.watcherCount, 5);
        },
      );

      test('${EventType.userWatchingStop} without a watcher count preserves the count', () async {
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.userWatchingStart,
            user: User(id: 'watcher-1'),
            watcherCount: 5,
          ),
        );
        await Future.delayed(Duration.zero);
        expect(channel.state!.watcherCount, 5);

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.userWatchingStop,
            user: User(id: 'watcher-1'),
          ),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state!.channelState.watchers, isEmpty);
        expect(channel.state!.watcherCount, 5);
      });
    });

    group('Read Events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(
          channelId,
          channelType,
          mockChannelConfig: true,
        );

        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should update read state on message read event', () async {
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime(2020),
          unreadMessages: 10,
        );

        // Setup initial read state
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = channel.state?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.unreadMessages, 10);
        expect(read?.lastReadMessageId, isNull);
        expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);

        // Create message read event
        final messageReadEvent = Event(
          cid: channel.cid,
          type: EventType.messageRead,
          user: currentUser,
          createdAt: DateTime(2022),
          unreadMessages: 0,
          lastReadMessageId: 'message-123',
        );

        // Dispatch event
        client.addEvent(messageReadEvent);

        // Wait for event to be processed
        await Future.delayed(Duration.zero);

        // Verify read state is updated
        final updatedRead = channel.state?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.unreadMessages, 0);
        expect(updatedRead?.lastReadMessageId, 'message-123');
        expect(updatedRead?.lastRead.isAtSameMomentAs(DateTime(2022)), isTrue);
      });

      test(
        'should add a new read state if not exist on message read event',
        () async {
          // Create the current read state
          final currentUser = User(id: 'test-user');

          // Verify initial state
          final read = channel.state?.read;
          expect(read, isEmpty);

          // Create mark read notification event
          final markReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          client.addEvent(markReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read list has not changed
          final updated = channel.state?.read;
          expect(updated?.length, 1);
          expect(updated?.any((r) => r.user.id == currentUser.id), isTrue);
        },
      );

      test(
        'should not update channel read state on thread message read event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastReadMessageId: 'channel-msg-1',
          );

          // Setup initial channel read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = channel.state?.read.first;
          expect(read?.unreadMessages, 10);
          expect(read?.lastReadMessageId, 'channel-msg-1');
          expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);

          // Create a thread-scoped message.read event (thread != null)
          final threadMessageReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            lastReadMessageId: 'thread-reply-99',
            thread: Thread(
              channelCid: channel.cid!,
              parentMessageId: 'parent-msg-1',
              createdByUserId: currentUser.id,
              replyCount: 3,
              participantCount: 2,
            ),
          );

          // Dispatch event
          client.addEvent(threadMessageReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Channel read state must be untouched — thread reads
          // must not clobber the channel-level Read.
          final after = channel.state?.read.first;
          expect(after?.unreadMessages, 10);
          expect(after?.lastReadMessageId, 'channel-msg-1');
          expect(after?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);
        },
      );

      test('should update read state on notification mark unread event', () async {
        // Create the current read state
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime(2020),
          unreadMessages: 10,
        );

        // Setup initial read state
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = channel.state?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.unreadMessages, 10);
        expect(read?.lastReadMessageId, isNull);
        expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);

        // Create mark unread notification event
        final markUnreadEvent = Event(
          cid: channel.cid,
          type: EventType.notificationMarkUnread,
          user: currentUser,
          lastReadAt: DateTime(2019),
          unreadMessages: 15,
          lastReadMessageId: 'message-100',
        );

        // Dispatch event
        client.addEvent(markUnreadEvent);

        // Wait for event to be processed
        await Future.delayed(Duration.zero);

        // Verify read state is updated
        final updatedRead = channel.state?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.unreadMessages, 15);
        expect(updatedRead?.lastReadMessageId, 'message-100');
        expect(updatedRead?.lastRead.isAtSameMomentAs(DateTime(2019)), isTrue);
      });

      test(
        'should add a new read state if not exist on notification mark unread',
        () async {
          // Verify initial state
          final read = channel.state?.read;
          expect(read, isEmpty);

          // Create event for non-existing user
          final markUnreadEvent = Event(
            cid: channel.cid,
            type: EventType.notificationMarkUnread,
            user: User(id: 'non-existing-user'),
            lastReadAt: DateTime(2019),
            unreadMessages: 15,
            lastReadMessageId: 'message-100',
          );

          // Dispatch event
          client.addEvent(markUnreadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read list has not changed
          final updated = channel.state?.read;
          expect(updated?.length, 1);
          expect(updated?.any((r) => r.user.id == 'non-existing-user'), isTrue);
        },
      );

      test(
        'should preserve delivery info on message read event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastDeliveredAt: DateTime(2021),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Setup initial read state with delivery info
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = channel.state?.read.first;
          expect(read?.lastDeliveredAt, isNotNull);
          expect(
            read?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2021)),
            isTrue,
          );
          expect(read?.lastDeliveredMessageId, 'delivered-msg-456');

          // Create message read event (doesn't include delivery info)
          final messageReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          client.addEvent(messageReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read state is updated but delivery info is preserved
          final updatedRead = channel.state?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(updatedRead?.unreadMessages, 0);
          expect(updatedRead?.lastReadMessageId, 'message-123');
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime(2022)),
            isTrue,
          );
          // Delivery info should be preserved
          expect(updatedRead?.lastDeliveredAt, isNotNull);
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2021)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
        },
      );

      test(
        'should reconcile delivery when message read event is from current user',
        () async {
          final currentUser = client.state.currentUser;
          final updatedUser = currentUser?.copyWith(id: 'current-user-id');

          client.state.updateUser(updatedUser);
          addTearDown(() => client.state.updateUser(currentUser));

          when(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).thenAnswer((_) => Future.value());

          // Create message read event from current user
          final messageReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          client.addEvent(messageReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify reconcileDelivery was called
          verify(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).called(1);
        },
      );

      test(
        'should reset unread count on notification mark read event',
        () async {
          final currentUser = client.state.currentUser!;
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
          );

          // Setup initial read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          when(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).thenAnswer((_) => Future.value());

          // Verify initial state
          expect(channel.state?.unreadCount, 10);

          // notification.mark_read is delivered on the reading user's own
          // connection, so it reaches non-watched channels as well.
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime(2022),
              lastReadMessageId: 'message-123',
            ),
          );

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read state is updated
          final updatedRead = channel.state?.read.first;
          expect(updatedRead?.user.id, currentUser.id);
          expect(channel.state?.unreadCount, 0);
          expect(updatedRead?.lastReadMessageId, 'message-123');
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime(2022)),
            isTrue,
          );
        },
      );

      test(
        'should preserve delivery info on notification mark read event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastDeliveredAt: DateTime(2021),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Setup initial read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime(2022),
              lastReadMessageId: 'message-123',
            ),
          );

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read state is updated but delivery info is preserved
          final updatedRead = channel.state?.read.first;
          expect(updatedRead?.unreadMessages, 0);
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2021)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
        },
      );

      test(
        'should not update channel read state on thread notification mark '
        'read event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastReadMessageId: 'channel-msg-1',
          );

          // Setup initial read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime(2022),
              lastReadMessageId: 'thread-reply-99',
              thread: Thread(
                channelCid: channel.cid!,
                parentMessageId: 'parent-msg-1',
                createdByUserId: currentUser.id,
                replyCount: 3,
                participantCount: 2,
              ),
            ),
          );

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Channel read state must be untouched — thread reads
          // must not clobber the channel-level Read.
          final after = channel.state?.read.first;
          expect(after?.unreadMessages, 10);
          expect(after?.lastReadMessageId, 'channel-msg-1');
          expect(after?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);
        },
      );

      test(
        'should reconcile delivery when notification mark read event is from '
        'current user',
        () async {
          final currentUser = client.state.currentUser;

          when(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).thenAnswer((_) => Future.value());

          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime(2022),
              lastReadMessageId: 'message-123',
            ),
          );

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify reconcileDelivery was called
          verify(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).called(1);
        },
      );

      test('should update read state on message delivered event', () async {
        final currentUser = User(id: 'test-user');
        final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
        final currentRead = Read(
          user: currentUser,
          lastRead: distantPast,
          unreadMessages: 5,
        );

        // Setup initial read state
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state has no delivery info
        final read = channel.state?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.lastDeliveredAt, isNull);
        expect(read?.lastDeliveredMessageId, isNull);

        // Create message delivered event
        final messageDeliveredEvent = Event(
          cid: channel.cid,
          type: EventType.messageDelivered,
          user: currentUser,
          lastDeliveredAt: DateTime(2022),
          lastDeliveredMessageId: 'message-456',
        );

        // Dispatch event
        client.addEvent(messageDeliveredEvent);

        // Wait for event to be processed
        await Future.delayed(Duration.zero);

        // Verify delivery state is updated
        final updatedRead = channel.state?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.lastDeliveredAt, isNotNull);
        expect(
          updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2022)),
          isTrue,
        );
        expect(updatedRead?.lastDeliveredMessageId, 'message-456');
      });

      test(
        'should add a new read state if not exist on message delivered event',
        () async {
          final newUser = User(id: 'new-user');
          final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

          // Verify initial state
          final read = channel.state?.read;
          expect(read, isEmpty);

          // Create message delivered event for new user
          final messageDeliveredEvent = Event(
            cid: channel.cid,
            type: EventType.messageDelivered,
            user: newUser,
            lastDeliveredAt: DateTime(2022),
            lastDeliveredMessageId: 'message-789',
          );

          // Dispatch event
          client.addEvent(messageDeliveredEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read state was created with delivery info
          final updated = channel.state?.read;
          expect(updated?.length, 1);
          final newRead = updated?.first;
          expect(newRead?.user.id, 'new-user');
          expect(newRead?.lastDeliveredAt, isNotNull);
          expect(
            newRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2022)),
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

      test(
        'should preserve read info on message delivered event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastReadMessageId: 'read-msg-123',
          );

          // Setup initial read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = channel.state?.read.first;
          expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);
          expect(read?.unreadMessages, 10);
          expect(read?.lastReadMessageId, 'read-msg-123');

          // Create message delivered event (doesn't include read info)
          final messageDeliveredEvent = Event(
            cid: channel.cid,
            type: EventType.messageDelivered,
            user: currentUser,
            lastDeliveredAt: DateTime(2022),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Dispatch event
          client.addEvent(messageDeliveredEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify delivery state is updated but read info is preserved
          final updatedRead = channel.state?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2022)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
          // Read info should be preserved
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime(2020)),
            isTrue,
          );
          expect(updatedRead?.unreadMessages, 10);
          expect(updatedRead?.lastReadMessageId, 'read-msg-123');
        },
      );

      test(
        'should reconcile delivery when message delivered event is from current user',
        () async {
          final currentUser = client.state.currentUser;
          final updatedUser = currentUser?.copyWith(id: 'current-user-id');

          client.state.updateUser(updatedUser);
          addTearDown(() => client.state.updateUser(currentUser));

          when(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).thenAnswer((_) => Future.value());

          // Create message delivered event from current user
          final messageDeliveredEvent = Event(
            cid: channel.cid,
            type: EventType.messageDelivered,
            user: currentUser,
            lastDeliveredAt: DateTime(2022),
            lastDeliveredMessageId: 'message-456',
          );

          // Dispatch event
          client.addEvent(messageDeliveredEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify reconcileDelivery was called
          verify(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).called(1);
        },
      );
    });

    group('Draft events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle draft.updated event for channel drafts', () async {
        // Verify initial state
        expect(channel.state?.draft, isNull);

        // Create Draft
        final draft = Draft(
          channelCid: channel.cid!,
          createdAt: DateTime.now(),
          message: DraftMessage(text: 'test message'),
        );

        // Create draft.updated event
        final draftUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.draftUpdated,
          draft: draft,
        );

        // Dispatch event
        client.addEvent(draftUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel draft was updated
        expect(channel.state?.draft, isNotNull);
        expect(channel.state?.draft?.message.text, 'test message');
      });

      test('should handle draft.updated event for thread drafts', () async {
        const threadParentMessageId = 'thread-parent-id';

        // Setup initial state with a regular message
        channel.state?.updateMessage(
          Message(
            id: threadParentMessageId,
            user: client.state.currentUser,
          ),
        );

        // Verify initial state
        expect(channel.state?.threadDraft(threadParentMessageId), isNull);

        // Create thread Draft
        final draft = Draft(
          channelCid: channel.cid!,
          createdAt: DateTime.now(),
          parentId: threadParentMessageId,
          message: DraftMessage(text: 'thread reply'),
        );

        // Create draft.updated event
        final draftUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.draftUpdated,
          draft: draft,
        );

        // Dispatch event
        client.addEvent(draftUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread draft was updated
        final threadDraft = channel.state?.threadDraft(threadParentMessageId);
        expect(threadDraft, isNotNull);
        expect(threadDraft?.message.text, 'thread reply');
      });

      test('should handle draft.deleted event for channel drafts', () async {
        // Setup initial state with a draft
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            draft: Draft(
              channelCid: channel.cid!,
              createdAt: DateTime.now(),
              message: DraftMessage(text: 'test message'),
            ),
          ),
        );

        // Verify initial state
        final draft = channel.state?.draft;
        expect(draft, isNotNull);
        expect(draft?.message.text, 'test message');

        // Create draft.deleted event
        final draftUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.draftDeleted,
          draft: draft,
        );

        // Dispatch event
        client.addEvent(draftUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel draft was updated
        expect(channel.state?.draft, isNull);
      });

      test('should handle draft.deleted event for thread drafts', () async {
        const threadParentMessageId = 'thread-parent-id';

        // Setup initial state with a thread draft
        channel.state?.updateMessage(
          Message(
            id: threadParentMessageId,
            user: client.state.currentUser,
            draft: Draft(
              channelCid: channel.cid!,
              createdAt: DateTime.now(),
              parentId: threadParentMessageId,
              message: DraftMessage(text: 'thread reply'),
            ),
          ),
        );

        // Verify initial state
        final threadDraft = channel.state?.threadDraft(threadParentMessageId);
        expect(threadDraft, isNotNull);
        expect(threadDraft?.message.text, 'thread reply');

        // Create draft.deleted event
        final draftDeletedEvent = Event(
          cid: channel.cid,
          type: EventType.draftDeleted,
          draft: threadDraft,
        );

        // Dispatch event
        client.addEvent(draftDeletedEvent);

        // Allow event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread draft was removed
        expect(channel.state?.threadDraft(threadParentMessageId), isNull);
      });

      test(
        'should update current channel draft if draft.updated event is emitted',
        () async {
          // Setup initial state with a draft
          final initialDraft = Draft(
            channelCid: channel.cid!,
            createdAt: DateTime.now(),
            message: DraftMessage(text: 'test message'),
          );

          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              draft: initialDraft,
            ),
          );

          // Verify initial state
          expect(channel.state?.draft, isNotNull);
          expect(channel.state?.draft?.message.text, 'test message');

          // Create Draft
          final updatedDraft = initialDraft.copyWith(
            message: DraftMessage(text: 'updated message'),
          );

          // Create draft.updated event
          final draftUpdatedEvent = Event(
            cid: channel.cid,
            type: EventType.draftUpdated,
            draft: updatedDraft,
          );

          // Dispatch event
          client.addEvent(draftUpdatedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify channel draft was updated
          expect(channel.state?.draft, isNotNull);
          expect(channel.state?.draft?.message.text, 'updated message');
        },
      );

      test(
        'should update current thread draft if draft.updated event is emitted',
        () async {
          const threadParentMessageId = 'thread-parent-id';

          // Setup initial state with a thread draft
          final initialDraft = Draft(
            channelCid: channel.cid!,
            createdAt: DateTime.now(),
            parentId: threadParentMessageId,
            message: DraftMessage(text: 'thread reply'),
          );

          channel.state?.updateMessage(
            Message(
              id: threadParentMessageId,
              user: client.state.currentUser,
              draft: initialDraft,
            ),
          );

          // Verify initial state
          final draft = channel.state?.threadDraft(threadParentMessageId);
          expect(draft, isNotNull);
          expect(draft?.message.text, 'thread reply');

          // Create Draft
          final updatedDraft = initialDraft.copyWith(
            message: DraftMessage(text: 'updated thread reply'),
          );

          // Create draft.updated event
          final draftUpdatedEvent = Event(
            cid: channel.cid,
            type: EventType.draftUpdated,
            draft: updatedDraft,
          );

          // Dispatch event
          client.addEvent(draftUpdatedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify thread draft was updated
          final threadDraft = channel.state?.threadDraft(threadParentMessageId);
          expect(threadDraft, isNotNull);
          expect(threadDraft?.message.text, 'updated thread reply');
        },
      );

      test('an event without a draft is ignored', () async {
        client.addEvent(Event(cid: channel.cid, type: EventType.draftUpdated));
        await Future.delayed(Duration.zero);

        expect(channel.state?.draft, isNull);
      });
    });

    group('Reminder events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle reminder.created event', () async {
        const messageId = 'test-message-id';

        // Setup initial state with a message without reminder
        final message = Message(
          id: messageId,
          user: client.state.currentUser,
          text: 'Test message',
        );

        channel.state?.updateMessage(message);

        // Verify initial state - no reminder
        final initialMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNull);

        // Create reminder
        final reminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: DateTime.now().add(const Duration(days: 30)),
        );

        // Create reminder.created event
        final reminderCreatedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderCreated,
          reminder: reminder,
        );

        // Dispatch event
        client.addEvent(reminderCreatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify message reminder was added
        final updatedMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, reminder.remindAt);
      });

      test('should handle reminder.updated event', () async {
        const messageId = 'test-message-id';

        // Setup initial state with a message with existing reminder
        final remindAt = DateTime.now().add(const Duration(days: 30));
        final initialReminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final message = Message(
          id: messageId,
          user: client.state.currentUser,
          text: 'Test message',
          reminder: initialReminder,
        );

        channel.state?.updateMessage(message);

        // Verify initial state
        final initialMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);
        expect(initialMessage?.reminder?.remindAt, remindAt);

        // Create updated reminder
        final updatedRemindAt = remindAt.add(const Duration(days: 15));
        final updatedReminder = initialReminder.copyWith(
          remindAt: updatedRemindAt,
          updatedAt: DateTime.now(),
        );

        // Create reminder.updated event
        final reminderUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderUpdated,
          reminder: updatedReminder,
        );

        // Dispatch event
        client.addEvent(reminderUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify message reminder was updated
        final updatedMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, updatedRemindAt);
      });

      test('should handle reminder.deleted event', () async {
        const messageId = 'test-message-id';

        // Setup initial state with a message with existing reminder
        final remindAt = DateTime.now().add(const Duration(days: 30));
        final initialReminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final message = Message(
          id: messageId,
          user: client.state.currentUser,
          text: 'Test message',
          reminder: initialReminder,
        );

        channel.state?.updateMessage(message);

        // Verify initial state
        final initialMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);

        // Create reminder.deleted event
        final reminderDeletedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderDeleted,
          reminder: initialReminder,
        );

        // Dispatch event
        client.addEvent(reminderDeletedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify message reminder was removed
        final updatedMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNull);
      });

      test('should handle reminder.created event for thread messages', () async {
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';

        // Setup initial state with a thread message without reminder
        final threadMessage = Message(
          id: messageId,
          parentId: parentId,
          user: client.state.currentUser,
          text: 'Thread message',
          // `Message.createdAt` falls back to `DateTime.now()` per call when
          // not provided, which breaks merge/sort keyed on createdAt.
          createdAt: DateTime.now(),
        );

        channel.state?.updateMessage(threadMessage);

        // Verify initial state - no reminder
        final initialMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNull);

        // Create reminder
        final remindAt = DateTime.now().add(const Duration(days: 30));
        final reminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        // Create reminder.created event
        final reminderCreatedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderCreated,
          reminder: reminder,
        );

        // Dispatch event
        client.addEvent(reminderCreatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread message reminder was added
        final updatedMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, reminder.remindAt);
      });

      test('should handle reminder.updated event for thread messages', () async {
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';

        // Setup initial state with a thread message with existing reminder
        final remindAt = DateTime.now().add(const Duration(days: 30));
        final initialReminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final threadMessage = Message(
          id: messageId,
          parentId: parentId,
          user: client.state.currentUser,
          text: 'Thread message',
          reminder: initialReminder,
          // `Message.createdAt` falls back to `DateTime.now()` per call when
          // not provided, which breaks merge/sort keyed on createdAt.
          createdAt: DateTime.now(),
        );

        channel.state?.updateMessage(threadMessage);

        // Verify initial state
        final initialMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);
        expect(initialMessage?.reminder?.remindAt, remindAt);

        // Create updated reminder
        final updatedRemindAt = remindAt.add(const Duration(days: 15));
        final updatedReminder = initialReminder.copyWith(
          remindAt: updatedRemindAt,
          updatedAt: DateTime.now(),
        );

        // Create reminder.updated event
        final reminderUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderUpdated,
          reminder: updatedReminder,
        );

        // Dispatch event
        client.addEvent(reminderUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread message reminder was updated
        final updatedMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, updatedRemindAt);
      });

      test('should handle reminder.deleted event for thread messages', () async {
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';

        // Setup initial state with a thread message with existing reminder
        final remindAt = DateTime.now().add(const Duration(days: 30));
        final initialReminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final threadMessage = Message(
          id: messageId,
          parentId: parentId,
          user: client.state.currentUser,
          text: 'Thread message',
          reminder: initialReminder,
          // Explicit `createdAt` so `Message.createdAt` is deterministic
          // across reads — without one it falls back to `DateTime.now()`
          // on every call, which breaks any sort/merge keyed on createdAt.
          createdAt: DateTime.now(),
        );

        channel.state?.updateMessage(threadMessage);

        // Verify initial state
        final initialMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);

        // Create reminder.deleted event
        final reminderDeletedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderDeleted,
          reminder: initialReminder,
        );

        // Dispatch event
        client.addEvent(reminderDeletedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread message reminder was removed
        final updatedMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNull);
      });

      test('an event without a reminder is ignored', () async {
        const messageId = 'test-message-id';

        final message = Message(
          id: messageId,
          user: client.state.currentUser,
          text: 'Test message',
        );
        channel.state?.updateMessage(message);

        client.addEvent(Event(cid: channel.cid, type: EventType.reminderCreated));
        await Future.delayed(Duration.zero);

        final storedMessage = channel.state?.messages.firstWhere((m) => m.id == messageId);
        expect(storedMessage?.reminder, isNull);
      });
    });

    group('Location events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle location.shared event', () async {
        // Verify initial state
        expect(channel.state?.activeLiveLocations, isEmpty);

        // Create live location
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Create location.shared event
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: locationMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was added
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message, isNotNull);

        // Check if active live location was updated
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('msg1'));
      });

      test('should handle location.updated event', () async {
        // Setup initial state with location message
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial message
        channel.state?.addNewMessage(locationMessage);

        // Create updated location
        final updatedLocation = liveLocation.copyWith(
          latitude: 40.7500, // Updated latitude
          longitude: -74.1000, // Updated longitude
        );

        final updatedMessage = locationMessage.copyWith(
          sharedLocation: updatedLocation,
        );

        // Create location.updated event
        final locationUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.locationUpdated,
          message: updatedMessage,
        );

        // Dispatch event
        client.addEvent(locationUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was updated
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation?.latitude, equals(40.7500));
        expect(message?.sharedLocation?.longitude, equals(-74.1000));

        // Check if active live location was updated
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
        expect(activeLiveLocations?.first.longitude, equals(-74.1000));
      });

      test('should handle location.expired event', () async {
        // Setup initial state with location message
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial message
        channel.state?.addNewMessage(locationMessage);
        expect(channel.state?.activeLiveLocations, hasLength(1));

        // Create expired location
        final expiredLocation = liveLocation.copyWith(
          endAt: DateTime.now().subtract(const Duration(hours: 1)),
        );

        final expiredMessage = locationMessage.copyWith(
          sharedLocation: expiredLocation,
        );

        // Create location.expired event
        final locationExpiredEvent = Event(
          cid: channel.cid,
          type: EventType.locationExpired,
          message: expiredMessage,
        );

        // Dispatch event
        client.addEvent(locationExpiredEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was updated
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation?.isExpired, isTrue);

        // Check if active live location was removed
        expect(channel.state?.activeLiveLocations, isEmpty);
      });

      test('should not add static location to active locations', () async {
        final staticLocation = Location(
          channelCid: channel.cid,
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

        // Create location.shared event
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: staticMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was added
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation, isNotNull);

        // Check if active live location was NOT updated (should remain empty)
        expect(channel.state?.activeLiveLocations, isEmpty);
      });

      test(
        'should update active locations when location message is deleted',
        () async {
          final liveLocation = Location(
            channelCid: channel.cid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Verify initial state
          channel.state?.addNewMessage(locationMessage);
          expect(channel.state?.activeLiveLocations, hasLength(1));

          final messageDeletedEvent = Event(
            type: EventType.messageDeleted,
            cid: channel.cid,
            message: locationMessage.copyWith(
              type: MessageType.deleted,
              deletedAt: DateTime.timestamp(),
            ),
          );

          // Dispatch event
          client.addEvent(messageDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify active locations are updated
          expect(channel.state?.activeLiveLocations, isEmpty);
        },
      );

      test('should merge locations with same key', () async {
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial location for setup
        channel.state?.addNewMessage(locationMessage);
        expect(channel.state?.activeLiveLocations, hasLength(1));

        // Create new location with same user, channel, and device
        final newLocation = Location(
          channelCid: channel.cid,
          userId: 'user1', // Same user
          messageId: 'msg2', // Different message
          latitude: 40.7500,
          longitude: -74.1000,
          createdByDeviceId: 'device1', // Same device
          endAt: DateTime.now().add(const Duration(hours: 2)),
        );

        final newMessage = Message(
          id: 'msg2',
          text: 'Updated location',
          sharedLocation: newLocation,
        );

        // Create location.shared event for the new message
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: newMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Should still have only one active location (merged)
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('msg2'));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
      });

      test(
        'should handle multiple active locations from different devices',
        () async {
          final liveLocation = Location(
            channelCid: channel.cid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Add first location for setup
          channel.state?.addNewMessage(locationMessage);
          expect(channel.state?.activeLiveLocations, hasLength(1));

          // Create location from different device
          final location2 = Location(
            channelCid: channel.cid,
            userId: 'user1', // Same user
            messageId: 'msg2',
            latitude: 34.0522,
            longitude: -118.2437,
            createdByDeviceId: 'device2', // Different device
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final message2 = Message(
            id: 'msg2',
            text: 'Location from device 2',
            sharedLocation: location2,
          );

          // Create location.shared event for the second message
          final locationSharedEvent = Event(
            cid: channel.cid,
            type: EventType.locationShared,
            message: message2,
          );

          // Dispatch event
          client.addEvent(locationSharedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Should have two active locations
          expect(channel.state?.activeLiveLocations, hasLength(2));
        },
      );

      test('should handle location messages in threads', () async {
        final parentMessage = Message(
          id: 'parent1',
          text: 'Thread parent',
        );

        // Add parent message first for setup
        channel.state?.addNewMessage(parentMessage);

        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'thread-msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final threadLocationMessage = Message(
          id: 'thread-msg1',
          text: 'Live location in thread',
          parentId: 'parent1',
          sharedLocation: liveLocation,
        );

        // Create location.shared event for the thread message
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: threadLocationMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if thread message was added
        final thread = channel.state?.threads['parent1'];
        expect(thread, contains(threadLocationMessage));

        // Check if location was added to active locations
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('thread-msg1'));
      });

      test('should update thread location messages', () async {
        final parentMessage = Message(
          id: 'parent1',
          text: 'Thread parent',
        );

        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'thread-msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final threadLocationMessage = Message(
          id: 'thread-msg1',
          text: 'Live location in thread',
          parentId: 'parent1',
          sharedLocation: liveLocation,
        );

        // Add messages
        channel.state?.addNewMessage(parentMessage);
        channel.state?.addNewMessage(threadLocationMessage);

        // Update the location
        final updatedLocation = liveLocation.copyWith(
          latitude: 40.7500,
          longitude: -74.1000,
        );

        final updatedThreadMessage = threadLocationMessage.copyWith(
          sharedLocation: updatedLocation,
        );

        // Create location.updated event for the thread message
        final locationUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.locationUpdated,
          message: updatedThreadMessage,
        );

        // Dispatch event
        client.addEvent(locationUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if thread message was updated
        final thread = channel.state?.threads['parent1'];
        final threadMessage = thread?.firstWhere((m) => m.id == 'thread-msg1');
        expect(threadMessage?.sharedLocation?.latitude, equals(40.7500));
        expect(threadMessage?.sharedLocation?.longitude, equals(-74.1000));

        // Check if active location was updated
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
        expect(activeLiveLocations?.first.longitude, equals(-74.1000));
      });
    });

    group('Channel push preference events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle channel.push_preference.updated event', () async {
        // Verify initial state
        expect(channel.state?.channelState.pushPreferences, isNull);

        // Create channel push preference
        final channelPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.mentions,
          disabledUntil: DateTime.now().add(const Duration(hours: 1)),
        );

        // Create channel.push_preference.updated event
        final channelPushPreferenceUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.channelPushPreferenceUpdated,
          channelPushPreference: channelPushPreference,
        );

        // Dispatch event
        client.addEvent(channelPushPreferenceUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel push preferences were updated
        final updatedPreferences = channel.state?.channelState.pushPreferences;
        expect(updatedPreferences, isNotNull);
        expect(updatedPreferences?.chatLevel, ChatLevel.mentions);
        expect(
          updatedPreferences?.disabledUntil,
          channelPushPreference.disabledUntil,
        );
      });

      test('should update existing channel push preferences', () async {
        // Set initial push preferences
        const initialPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.all,
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            pushPreferences: initialPushPreference,
          ),
        );

        // Verify initial state
        final pushPreferences = channel.state?.channelState.pushPreferences;
        expect(pushPreferences?.chatLevel, ChatLevel.all);
        expect(pushPreferences?.disabledUntil, isNull);

        // Create updated channel push preference
        final updatedPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.none,
          disabledUntil: DateTime.now().add(const Duration(hours: 2)),
        );

        // Create channel.push_preference.updated event
        final channelPushPreferenceUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.channelPushPreferenceUpdated,
          channelPushPreference: updatedPushPreference,
        );

        // Dispatch event
        client.addEvent(channelPushPreferenceUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel push preferences were updated
        final updatedPreferences = channel.state?.channelState.pushPreferences;
        expect(updatedPreferences?.chatLevel, ChatLevel.none);
        expect(
          updatedPreferences?.disabledUntil,
          updatedPushPreference.disabledUntil,
        );
      });

      test('an event without a push preference is ignored', () async {
        client.addEvent(Event(cid: channel.cid, type: EventType.channelPushPreferenceUpdated));
        await Future.delayed(Duration.zero);

        expect(channel.state?.channelState.pushPreferences, isNull);
      });
    });

    group('User messages deleted event', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;
      late MockPersistenceClient persistenceClient;

      setUp(() {
        persistenceClient = MockPersistenceClient();
        when(() => client.chatPersistenceClient).thenReturn(persistenceClient);
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
        when(() => persistenceClient.getChannelThreads(any())).thenAnswer((_) async => <String, List<Message>>{});

        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test(
        'should soft delete all messages from user when hardDelete is false',
        () async {
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

          channel.state?.addNewMessage(message1);
          channel.state?.addNewMessage(message2);
          channel.state?.addNewMessage(message3);

          // Verify initial state
          expect(channel.state?.messages.length, equals(3));
          expect(
            channel.state?.messages.where((m) => m.user?.id == 'user-1').length,
            equals(2),
          );
          expect(
            channel.state?.messages.where((m) => m.user?.id == 'user-2').length,
            equals(1),
          );

          // Create user.messages.deleted event (soft delete)
          final deletedAt = DateTime.now();
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
            createdAt: deletedAt,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify user1's messages are soft deleted
          expect(channel.state?.messages.length, equals(3));
          final deletedMessages = channel.state?.messages.where((m) => m.user?.id == 'user-1').toList();
          expect(deletedMessages?.length, equals(2));
          for (final message in deletedMessages!) {
            expect(message.type, equals(MessageType.deleted));
            expect(message.deletedAt, isNotNull);
            expect(message.state.isDeleted, isTrue);
          }

          // Verify user2's message is unaffected
          final user2Message = channel.state?.messages.firstWhere((m) => m.id == 'msg-3');
          expect(user2Message?.type, isNot(MessageType.deleted));
          expect(user2Message?.deletedAt, isNull);
        },
      );

      test(
        'should hard delete all messages from user when hardDelete is true',
        () async {
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

          channel.state?.addNewMessage(message1);
          channel.state?.addNewMessage(message2);
          channel.state?.addNewMessage(message3);

          // Verify initial state
          expect(channel.state?.messages.length, equals(3));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify user1's messages are removed
          expect(channel.state?.messages.length, equals(1));
          expect(
            channel.state?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          // Verify user2's message still exists
          final user2Message = channel.state?.messages.firstWhere((m) => m.id == 'msg-3');
          expect(user2Message, isNotNull);
          expect(user2Message?.user?.id, equals('user-2'));
        },
      );

      test(
        'should handle thread messages from user',
        () async {
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

          channel.state?.addNewMessage(parentMessage);
          channel.state?.addNewMessage(threadMessage1);
          channel.state?.addNewMessage(threadMessage2);

          // Verify initial state
          expect(channel.state?.messages.length, equals(1));
          expect(channel.state?.threads['parent-msg']?.length, equals(2));

          // Create user.messages.deleted event (soft delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify thread messages are soft deleted
          final threadMessages = channel.state?.threads['parent-msg'];
          expect(threadMessages?.length, equals(2));
          for (final message in threadMessages!) {
            expect(message.type, equals(MessageType.deleted));
            expect(message.state.isDeleted, isTrue);
          }

          // Verify parent message is unaffected
          final parent = channel.state?.messages.first;
          expect(parent?.type, isNot(MessageType.deleted));
        },
      );

      test(
        'should do nothing when user is null',
        () async {
          // Setup: Add messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );

          channel.state?.addNewMessage(message1);

          // Verify initial state
          expect(channel.state?.messages.length, equals(1));

          // Create user.messages.deleted event without user
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            hardDelete: false,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify messages are unaffected
          expect(channel.state?.messages.length, equals(1));
          expect(
            channel.state?.messages.first.type,
            isNot(MessageType.deleted),
          );
        },
      );

      test(
        'should handle empty message list',
        () async {
          // Setup: Empty channel
          expect(channel.state?.messages.length, equals(0));

          // Create user.messages.deleted event
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: User(id: 'user-1'),
            hardDelete: false,
          );

          // Dispatch event - should not throw
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify state is still empty
          expect(channel.state?.messages.length, equals(0));
        },
      );

      test(
        'should delete messages from persistence when hardDelete is true',
        () async {
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

          channel.state?.addNewMessage(message1);
          channel.state?.addNewMessage(message2);
          channel.state?.addNewMessage(message3);

          // Verify initial state
          expect(channel.state?.messages.length, equals(3));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify messages are removed from persistence
          verify(
            () => persistenceClient.deleteMessageByIds(['msg-1', 'msg-2']),
          ).called(1);
          verify(
            () => persistenceClient.deletePinnedMessageByIds(['msg-1', 'msg-2']),
          ).called(1);

          // Verify user1's messages are removed from state
          expect(channel.state?.messages.length, equals(1));
          expect(
            channel.state?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );
        },
      );

      test(
        'should not delete from persistence when hardDelete is false',
        () async {
          // Setup: Add messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );

          channel.state?.addNewMessage(message1);

          // Create user.messages.deleted event (soft delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify persistence deletion methods were NOT called
          verifyNever(() => persistenceClient.deleteMessageByIds(any()));
          verifyNever(() => persistenceClient.deletePinnedMessageByIds(any()));

          // Verify message is soft deleted (still in state)
          expect(channel.state?.messages.length, equals(1));
          expect(channel.state?.messages.first.type, equals(MessageType.deleted));
        },
      );

      test(
        'should delete all user messages including those only in storage',
        () async {
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
          channel.state?.addNewMessage(stateMessage1);
          channel.state?.addNewMessage(stateMessage2);
          channel.state?.addNewMessage(stateThreadMessage1);
          channel.state?.addNewMessage(stateThreadMessage2);

          // Verify initial state has only 2 messages and 1 thread with 2 replies
          expect(channel.state?.messages.length, equals(2));
          expect(channel.state?.threads['msg-1']?.length, equals(2));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify user1's messages are removed from state
          expect(channel.state?.messages.length, equals(1));
          expect(channel.state?.threads['msg-1']?.length, equals(1));

          expect(
            channel.state?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          expect(
            channel.state?.threads['msg-1']?.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          // Verify persistence delete was called - this handles ALL messages
          // in storage (both those in state AND those only in storage)
          verify(
            () => persistenceClient.deleteMessagesFromUser(
              cid: channel.cid,
              userId: user1.id,
              hardDelete: true,
              deletedAt: any(named: 'deletedAt'),
            ),
          ).called(1);

          // Verify in-state messages were also removed from state's persistence
          final capturedIds =
              verify(
                    () => persistenceClient.deleteMessageByIds(captureAny()),
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

      test(
        'should delete every authored message across threads without '
        'cross-thread leakage (regression: _updateThreadMessages)',
        () async {
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

          channel.state?.addNewMessage(parentA);
          channel.state?.addNewMessage(parentB);
          channel.state?.addNewMessage(topLevelFromUser1);
          channel.state?.addNewMessage(replyA);
          channel.state?.addNewMessage(replyB);

          // Initial state: each thread has exactly its own reply.
          expect(
            channel.state?.threads['parent-A']?.map((m) => m.id),
            equals(['reply-A']),
          );
          expect(
            channel.state?.threads['parent-B']?.map((m) => m.id),
            equals(['reply-B']),
          );

          // Trigger the multi-thread batch via user.messages.deleted.
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );
          client.addEvent(userMessagesDeletedEvent);
          await Future.delayed(Duration.zero);

          // 1) Thread membership is preserved — no cross-thread leakage.
          //    Without the fix, replyB would leak into thread A and v.v.
          expect(
            channel.state?.threads['parent-A']?.map((m) => m.id),
            equals(['reply-A']),
            reason: 'thread A must not contain replies from thread B',
          );
          expect(
            channel.state?.threads['parent-B']?.map((m) => m.id),
            equals(['reply-B']),
            reason: 'thread B must not contain replies from thread A',
          );

          // 2) Every message authored by user-1 is soft-deleted — top-level
          //    AND in both threads. The fix must not narrow this scope.
          expect(
            channel.state?.messages.firstWhere((m) => m.id == 'top-1').type,
            equals(MessageType.deleted),
            reason: 'top-level user-1 message must be deleted',
          );
          expect(
            channel.state?.threads['parent-A']?.first.type,
            equals(MessageType.deleted),
            reason: 'thread A reply from user-1 must be deleted',
          );
          expect(
            channel.state?.threads['parent-B']?.first.type,
            equals(MessageType.deleted),
            reason: 'thread B reply from user-1 must be deleted',
          );

          // 3) Other users' messages are unaffected.
          expect(
            channel.state?.messages.firstWhere((m) => m.id == 'parent-A').type,
            isNot(MessageType.deleted),
          );
          expect(
            channel.state?.messages.firstWhere((m) => m.id == 'parent-B').type,
            isNot(MessageType.deleted),
          );
        },
      );
    });
  });

  group('Channel State Validation and Cooldown', () {
    late final client = MockStreamChatClient();

    setUpAll(() {
      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return createLogger(name);
      });

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);

      // fake clientState
      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      // client logger
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));

      // mock channel delivery reporter
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    group('Channel message count events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test(
        'should update channel messageCount when event contains channelMessageCount',
        () async {
          // Verify initial state - no messageCount
          expect(channel.messageCount, isNull);

          // Create event with channelMessageCount
          final messageCountEvent = Event(
            cid: channel.cid,
            type: EventType.messageNew,
            channelMessageCount: 42,
          );

          // Dispatch event
          client.addEvent(messageCountEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify channel messageCount was updated
          expect(channel.messageCount, equals(42));
        },
      );

      test(
        'should update channel messageCount from message.new and message.deleted events',
        () async {
          // Test with message.new event - count increases
          final messageNewEvent = Event(
            cid: channel.cid,
            type: EventType.messageNew,
            message: Message(
              id: 'new-message-1',
              text: 'Hello world!',
              user: User(id: 'user-1'),
            ),
            channelMessageCount: 1,
          );

          client.addEvent(messageNewEvent);
          await Future.delayed(Duration.zero);
          expect(channel.messageCount, equals(1));

          // Test with another message.new event - count increases
          final messageNewEvent2 = Event(
            cid: channel.cid,
            type: EventType.messageNew,
            message: Message(
              id: 'new-message-2',
              text: 'Second message',
              user: User(id: 'user-2'),
            ),
            channelMessageCount: 2,
          );

          client.addEvent(messageNewEvent2);
          await Future.delayed(Duration.zero);
          expect(channel.messageCount, equals(2));

          // Test with message.deleted event - count decreases
          final messageDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.messageDeleted,
            message: Message(
              id: 'new-message-1',
              text: 'Hello world!',
              user: User(id: 'user-1'),
            ),
            channelMessageCount: 1,
          );

          client.addEvent(messageDeletedEvent);
          await Future.delayed(Duration.zero);
          expect(channel.messageCount, equals(1));
        },
      );

      test(
        'should preserve other channel properties when updating messageCount',
        () async {
          // Set initial channel state with some properties
          final initialChannel = channel.state?.channelState.channel?.copyWith(
            extraData: {'name': 'Test Channel'},
            memberCount: 5,
            frozen: true,
          );

          if (initialChannel != null) {
            channel.state?.updateChannelState(
              channel.state!.channelState.copyWith(channel: initialChannel),
            );
          }

          // Verify initial state
          expect(channel.name, 'Test Channel');
          expect(channel.memberCount, equals(5));
          expect(channel.frozen, equals(true));
          expect(channel.messageCount, isNull);

          // Update messageCount via event
          final messageCountEvent = Event(
            cid: channel.cid,
            type: EventType.messageNew,
            channelMessageCount: 100,
          );

          client.addEvent(messageCountEvent);
          await Future.delayed(Duration.zero);

          // Verify messageCount was updated while preserving other properties
          expect(channel.messageCount, equals(100));
          expect(channel.name, 'Test Channel');
          expect(channel.memberCount, equals(5));
          expect(channel.frozen, equals(true));
        },
      );

      test(
        'should provide messageCountStream for reactive updates',
        () async {
          expectLater(
            channel.messageCountStream.distinct(),
            emitsInOrder([null, 1, 5, 10]),
          );

          // Update messageCount multiple times
          final counts = [1, 5, 10];
          for (final count in counts) {
            final event = Event(
              cid: channel.cid,
              type: EventType.messageNew,
              message: Message(
                id: 'msg-$count',
                text: 'Message $count',
                user: User(id: 'user-1'),
              ),
              channelMessageCount: count,
            );

            client.addEvent(event);
            await Future.delayed(Duration.zero);
          }
        },
      );
    });
  });

  group('Local unread count', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    final currentUser = OwnUser(id: 'current-user-id');

    late final client = MockStreamChatClient();

    setUpAll(() {
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(shouldRetry: (_, __, ___) => false, delayFactor: Duration.zero),
      );
      when(() => client.state).thenReturn(FakeClientState(currentUser: currentUser));
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));
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
          return createLogger(name);
        });
        when(() => disabledClient.retryPolicy).thenReturn(
          RetryPolicy(shouldRetry: (_, __, ___) => false),
        );
        when(() => disabledClient.state).thenReturn(FakeClientState(currentUser: currentUser));
        when(() => disabledClient.logger).thenReturn(createLogger('mock-client-logger'));
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
        return createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(
          shouldRetry: (_, __, ___) => false,
          delayFactor: Duration.zero,
        ),
      );
      when(() => client.state).thenReturn(FakeClientState());
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    Channel _seededChannel() {
      final base = generateChannelState(channelId, channelType);
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
        return createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(
          shouldRetry: (_, __, ___) => false,
          delayFactor: Duration.zero,
        ),
      );
      when(() => client.state).thenReturn(FakeClientState());
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    Channel _seededChannel({required List<Message> messages}) {
      final base = generateChannelState(channelId, channelType);
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
        return createLogger(name);
      });

      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));

      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);
    });

    setUp(() {
      final channelState = generateChannelState(channelId, channelType);
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
