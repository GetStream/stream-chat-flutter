// ignore_for_file: avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

void main() {
  group('MessageRules', () {
    late StreamChatClient client;

    setUp(() {
      final currentUser = OwnUser(id: 'current-user-id');
      client = _createMockClient(currentUser: currentUser);
    });

    group('canUpload', () {
      test('should return true for message with text', () {
        final message = Message(text: 'Hello');

        expect(MessageRules.canUpload(message), isTrue);
      });

      test('should return false for message with empty text', () {
        final message = Message(text: '');

        expect(MessageRules.canUpload(message), isFalse);
      });

      test('should return false for message with whitespace only', () {
        final message = Message(text: '   ');

        expect(MessageRules.canUpload(message), isFalse);
      });

      test('should return true for message with attachments', () {
        final message = Message(
          attachments: [
            Attachment(type: 'image'),
          ],
        );

        expect(MessageRules.canUpload(message), isTrue);
      });

      test('should return true for message with quoted message', () {
        final message = Message(quotedMessageId: 'quoted-message-id');

        expect(MessageRules.canUpload(message), isTrue);
      });

      test('should return true for message with poll', () {
        final message = Message(pollId: 'poll-id');

        expect(MessageRules.canUpload(message), isTrue);
      });

      test('should return true for message with shared location', () {
        final message = Message(
          sharedLocation: Location(latitude: 1, longitude: 2),
        );

        expect(MessageRules.canUpload(message), isTrue);
      });

      test('should return false for empty message', () {
        final message = Message();

        expect(MessageRules.canUpload(message), isFalse);
      });

      test('should return true for message with multiple valid fields', () {
        final message = Message(
          text: 'Hello',
          attachments: [Attachment(type: 'image')],
        );

        expect(MessageRules.canUpload(message), isTrue);
      });
    });

    group('canUpdateChannelLastMessageAt', () {
      late Channel channel;

      setUp(() {
        channel = _createChannel(client);
      });

      test('should return true for valid message', () {
        final message = _createMessage();

        expect(
          MessageRules.canUpdateChannelLastMessageAt(message, channel),
          isTrue,
        );
      });

      test('should return false for error messages', () {
        final message = _createMessage(
          (m) => m.copyWith(type: MessageType.error),
        );

        expect(
          MessageRules.canUpdateChannelLastMessageAt(message, channel),
          isFalse,
        );
      });

      test('should return false for shadowed messages', () {
        final message = _createMessage(
          (m) => m.copyWith(shadowed: true),
        );

        expect(
          MessageRules.canUpdateChannelLastMessageAt(message, channel),
          isFalse,
        );
      });

      test('should return false for ephemeral messages', () {
        final message = _createMessage(
          (m) => m.copyWith(type: MessageType.ephemeral),
        );

        expect(
          MessageRules.canUpdateChannelLastMessageAt(message, channel),
          isFalse,
        );
      });

      test(
        'should return false for system messages when config skips them',
        () {
          final channel = _createChannel(
            client,
            skipLastMsgUpdateForSystemMsgs: true,
          );

          final message = _createMessage(
            (m) => m.copyWith(type: MessageType.system),
          );

          expect(
            MessageRules.canUpdateChannelLastMessageAt(message, channel),
            isFalse,
          );
        },
      );

      test(
        'should return true for system messages when config allows them',
        () {
          final channel = _createChannel(
            client,
            skipLastMsgUpdateForSystemMsgs: false,
          );

          final message = _createMessage(
            (m) => m.copyWith(type: MessageType.system),
          );

          expect(
            MessageRules.canUpdateChannelLastMessageAt(message, channel),
            isTrue,
          );
        },
      );

      test('should return false for restricted messages', () {
        final message = _createMessage(
          (m) => m.copyWith(
            restrictedVisibility: [
              'other-user-id', // Not visible to current user
            ],
          ),
        );

        expect(
          MessageRules.canUpdateChannelLastMessageAt(message, channel),
          isFalse,
        );
      });

      test('should return true for message visible to current user', () {
        final currentUserId = client.state.currentUser!.id;

        final message = _createMessage(
          (m) => m.copyWith(
            restrictedVisibility: [
              currentUserId, // Visible to current user
              'other-user-id',
            ],
          ),
        );

        expect(
          MessageRules.canUpdateChannelLastMessageAt(message, channel),
          isTrue,
        );
      });
    });

    group('canCountAsUnread', () {
      late Channel channel;

      setUp(() {
        channel = _createChannel(client, hasReadEvents: true);
      });

      test('should return true for valid unread message', () {
        final message = _createMessage();

        expect(MessageRules.canCountAsUnread(message, channel), isTrue);
      });

      test('should return false when user disabled read receipts', () {
        final message = _createMessage();
        final originalUser = client.state.currentUser;

        final userWithDisabledReceipts = originalUser?.copyWith(
          privacySettings: const PrivacySettings(
            readReceipts: ReadReceipts(enabled: false),
          ),
        );

        client.state.updateUser(userWithDisabledReceipts);
        addTearDown(() => client.state.updateUser(originalUser));

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return false when channel lacks read capability', () {
        final message = _createMessage();
        final channel = _createChannel(client, hasReadEvents: false);

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return false when channel is muted', () {
        final message = _createMessage();
        final originalUser = client.state.currentUser;

        final userWithMutedChannel = originalUser?.copyWith(
          channelMutes: [
            ChannelMute(
              user: client.state.currentUser!,
              channel: ChannelModel(cid: channel.cid),
              createdAt: DateTime(2023, 1, 1),
              updatedAt: DateTime(2023, 1, 1),
            ),
          ],
        );

        client.state.updateUser(userWithMutedChannel);
        addTearDown(() => client.state.updateUser(originalUser));

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return false for silent messages', () {
        final message = _createMessage((m) => m.copyWith(silent: true));

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return false for shadowed messages', () {
        final message = _createMessage((m) => m.copyWith(shadowed: true));

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return false for ephemeral messages', () {
        final message = _createMessage(
          (m) => m.copyWith(type: MessageType.ephemeral),
        );

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return false for thread-only messages', () {
        final message = _createMessage(
          (m) => m.copyWith(
            parentId: 'parent-id',
            showInChannel: false,
          ),
        );

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return true for thread messages shown in channel', () {
        final message = _createMessage(
          (m) => m.copyWith(
            parentId: 'parent-id',
            showInChannel: true,
          ),
        );

        expect(MessageRules.canCountAsUnread(message, channel), isTrue);
      });

      test('should return false when message has no sender', () {
        final messageWithoutUser = Message(
          id: 'message-id',
          text: 'Test message',
          user: null,
          createdAt: DateTime(2023, 1, 1),
        );

        expect(
          MessageRules.canCountAsUnread(messageWithoutUser, channel),
          isFalse,
        );
      });

      test('should return false for current user own messages', () {
        final currentUserId = client.state.currentUser!.id;

        final message = _createMessage(
          (m) => m.copyWith(
            user: User(id: currentUserId), // Message from current user
          ),
        );

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return false for restricted messages', () {
        final message = _createMessage(
          (m) => m.copyWith(
            restrictedVisibility: [
              'other-user-id', // Not visible to current user
            ],
          ),
        );

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return false for messages from muted users', () {
        final mutedUser = User(id: 'muted-user-id');
        final originalUser = client.state.currentUser;

        final userWithMutedUser = originalUser?.copyWith(
          mutes: [
            Mute(
              user: originalUser, // Current user did the muting
              target: mutedUser, // This is the user who was muted
              createdAt: DateTime(2023, 1, 1),
              updatedAt: DateTime(2023, 1, 1),
            ),
          ],
        );

        client.state.updateUser(userWithMutedUser);
        addTearDown(() => client.state.updateUser(originalUser));

        final message = _createMessage(
          (m) => m.copyWith(
            user: mutedUser, // Message from muted user
          ),
        );

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return true when no read state exists', () {
        final message = _createMessage();

        expect(MessageRules.canCountAsUnread(message, channel), isTrue);
      });

      test('should return false when message is already read', () {
        final message = _createMessage();
        final channel = _createChannel(
          client,
          hasReadEvents: true,
          reads: [
            Read(
              user: client.state.currentUser!,
              // After message
              lastRead: message.createdAt.add(const Duration(days: 1)),
              lastReadMessageId: 'other-message-id',
            ),
          ],
        );

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return false when message is the last read message', () {
        final message = _createMessage();
        final channel = _createChannel(
          client,
          hasReadEvents: true,
          reads: [
            Read(
              user: client.state.currentUser!,
              lastRead: message.createdAt, // Same as message
              lastReadMessageId: message.id,
            ),
          ],
        );

        expect(MessageRules.canCountAsUnread(message, channel), isFalse);
      });

      test('should return true for message after last read', () {
        final message = _createMessage();
        final channel = _createChannel(
          client,
          hasReadEvents: true,
          reads: [
            Read(
              user: client.state.currentUser!,
              // Before message
              lastRead: message.createdAt.subtract(const Duration(days: 1)),
              lastReadMessageId: 'other-message-id',
            ),
          ],
        );

        expect(MessageRules.canCountAsUnread(message, channel), isTrue);
      });
    });

    group('canMarkAsDelivered', () {
      late Channel channel;

      setUp(() {
        channel = _createChannel(client, hasDeliveryEvents: true);
      });

      test('should return true for valid deliverable message', () {
        final message = _createMessage();

        expect(MessageRules.canMarkAsDelivered(message, channel), isTrue);
      });

      test('should return false when user disabled delivery receipts', () {
        final message = _createMessage();
        final originalUser = client.state.currentUser;

        final userWithDisabledReceipts = originalUser?.copyWith(
          privacySettings: const PrivacySettings(
            deliveryReceipts: DeliveryReceipts(enabled: false),
          ),
        );

        client.state.updateUser(userWithDisabledReceipts);
        addTearDown(() => client.state.updateUser(originalUser));

        expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
      });

      test('should return false when channel lacks delivery capability', () {
        final message = _createMessage();
        final channel = _createChannel(client, hasDeliveryEvents: false);

        expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
      });

      test('should return false when channel is muted', () {
        final message = _createMessage();
        final originalUser = client.state.currentUser;

        final userWithMutedChannel = originalUser?.copyWith(
          channelMutes: [
            ChannelMute(
              user: client.state.currentUser!,
              channel: ChannelModel(cid: 'test:channel-1'),
              createdAt: DateTime(2023, 1, 1),
              updatedAt: DateTime(2023, 1, 1),
            ),
          ],
        );

        client.state.updateUser(userWithMutedChannel);
        addTearDown(() => client.state.updateUser(originalUser));

        expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
      });

      test('should return false for ephemeral messages', () {
        final message = _createMessage(
          (m) => m.copyWith(type: MessageType.ephemeral),
        );

        expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
      });

      test('should return false for thread-only messages', () {
        final message = _createMessage(
          (m) => m.copyWith(parentId: 'parent-id', showInChannel: false),
        );

        expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
      });

      test('should return true for thread messages shown in channel', () {
        final message = _createMessage(
          (m) => m.copyWith(parentId: 'parent-id', showInChannel: true),
        );

        expect(MessageRules.canMarkAsDelivered(message, channel), isTrue);
      });

      test('should return false when message has no sender', () {
        final messageWithoutUser = Message(
          id: 'message-id',
          text: 'Test message',
          user: null,
          createdAt: DateTime(2023, 1, 1),
        );

        expect(
          MessageRules.canMarkAsDelivered(messageWithoutUser, channel),
          isFalse,
        );
      });

      test('should return false for current user own messages', () {
        final currentUserId = client.state.currentUser!.id;

        final message = _createMessage(
          (m) => m.copyWith(
            user: User(id: currentUserId), // Message from current user
          ),
        );

        expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
      });

      test('should return false for restricted messages', () {
        final message = _createMessage(
          (m) => m.copyWith(
            restrictedVisibility: [
              'other-user-id', // Not visible to current user
            ],
          ),
        );

        expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
      });

      test('should return true when no read state exists', () {
        final message = _createMessage();

        expect(MessageRules.canMarkAsDelivered(message, channel), isTrue);
      });

      test('should return false when message is already read', () {
        final message = _createMessage();
        final channel = _createChannel(
          client,
          hasDeliveryEvents: true,
          reads: [
            Read(
              user: client.state.currentUser!,
              // After message
              lastRead: message.createdAt.add(const Duration(days: 1)),
              lastReadMessageId: 'other-message-id',
            ),
          ],
        );

        expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
      });

      test('should return false when message is the last read message', () {
        final message = _createMessage();
        final channel = _createChannel(
          client,
          hasDeliveryEvents: true,
          reads: [
            Read(
              user: client.state.currentUser!,
              lastRead: message.createdAt, // Same as message
              lastReadMessageId: message.id,
            ),
          ],
        );

        expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
      });

      test('should return false when message is already delivered', () {
        final message = _createMessage();
        final channel = _createChannel(
          client,
          hasDeliveryEvents: true,
          reads: [
            Read(
              user: client.state.currentUser!,
              lastRead: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
              // After message
              lastDeliveredAt: message.createdAt.add(const Duration(days: 1)),
              lastDeliveredMessageId: 'other-message-id',
            ),
          ],
        );

        expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
      });

      test(
        'should return false when message is the last delivered message',
        () {
          final message = _createMessage();
          final channel = _createChannel(
            client,
            hasDeliveryEvents: true,
            reads: [
              Read(
                user: client.state.currentUser!,
                lastRead: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
                lastDeliveredAt: message.createdAt, // Same as message
                lastDeliveredMessageId: message.id,
              ),
            ],
          );

          expect(MessageRules.canMarkAsDelivered(message, channel), isFalse);
        },
      );

      test(
        'should return true for message between last delivered and last read',
        () {
          final message = _createMessage();
          final channel = _createChannel(
            client,
            hasDeliveryEvents: true,
            reads: [
              Read(
                user: client.state.currentUser!,
                // Before message
                lastRead: message.createdAt.subtract(const Duration(days: 1)),
                // Before message and lastRead
                lastDeliveredAt: message.createdAt.subtract(
                  const Duration(days: 2),
                ),
              ),
            ],
          );

          expect(MessageRules.canMarkAsDelivered(message, channel), isTrue);
        },
      );
    });
  });
}

// region Test Helpers

Logger _createLogger(String name) {
  final logger = Logger.detached(name)..level = Level.ALL;
  logger.onRecord.listen(print);
  return logger;
}

StreamChatClient _createMockClient({OwnUser? currentUser}) {
  final client = MockStreamChatClient();
  final clientState = FakeClientState(currentUser: currentUser);

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
    id: 'message-id',
    text: 'Test message',
    user: User(id: 'other-user-id'),
    createdAt: DateTime(2023, 1, 1),
  );

  return builder?.call(baseMessage) ?? baseMessage;
}

Channel _createChannel(
  StreamChatClient client, {
  String cid = 'test:channel-1',
  Message? lastMessage,
  bool hasReadEvents = false,
  bool hasDeliveryEvents = false,
  bool skipLastMsgUpdateForSystemMsgs = false,
  List<ChannelCapability>? capabilities,
  List<Read>? reads,
}) {
  final channelState = ChannelState(
    channel: ChannelModel(
      cid: cid,
      config: ChannelConfig(
        readEvents: hasReadEvents,
        deliveryEvents: hasDeliveryEvents,
        skipLastMsgUpdateForSystemMsgs: skipLastMsgUpdateForSystemMsgs,
      ),
      ownCapabilities: [
        ...?capabilities,
        if (hasReadEvents) ChannelCapability.readEvents,
        if (hasDeliveryEvents) ChannelCapability.deliveryEvents,
      ],
    ),
    messages: [if (lastMessage != null) lastMessage],
    read: [...?reads],
  );

  return Channel.fromState(client, channelState);
}

// endregion
