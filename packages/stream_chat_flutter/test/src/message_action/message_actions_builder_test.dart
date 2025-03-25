// ignore_for_file: cascade_invocations, avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_action/message_actions_builder.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

/// Creates a test message with customizable properties.
Message createTestMessage({
  String id = 'test-message',
  String text = 'Test message',
  String userId = 'test-user',
  bool pinned = false,
  String? parentId,
  Poll? poll,
  bool isDeleted = false,
  int? replyCount,
}) {
  return Message(
    id: id,
    text: text,
    user: User(id: userId),
    pinned: pinned,
    parentId: parentId,
    poll: poll,
    type: isDeleted ? MessageType.deleted : MessageType.regular,
    deletedAt: isDeleted ? DateTime.now() : null,
    replyCount: replyCount,
  );
}

const allChannelCapabilities = [
  ChannelCapability.sendMessage,
  ChannelCapability.sendReply,
  ChannelCapability.pinMessage,
  ChannelCapability.readEvents,
  ChannelCapability.deleteOwnMessage,
  ChannelCapability.deleteAnyMessage,
  ChannelCapability.updateOwnMessage,
  ChannelCapability.updateAnyMessage,
  ChannelCapability.quoteMessage,
];

void main() {
  final message = createTestMessage();
  final currentUser = OwnUser(id: 'current-user');

  setUpAll(() {
    registerFallbackValue(Message());
    registerFallbackValue(const StreamMessageActionType('any'));
  });

  MockChannel _getChannelWithCapabilities(
    List<ChannelCapability> capabilities, {
    bool enableMutes = true,
  }) {
    final customChannel = MockChannel(ownCapabilities: capabilities);
    final channelConfig = ChannelConfig(mutes: enableMutes);
    when(() => customChannel.config).thenReturn(channelConfig);
    return customChannel;
  }

  Future<BuildContext> _getContext(WidgetTester tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: Builder(builder: (ctx) {
          context = ctx;
          return const SizedBox.shrink();
        }),
      ),
    );
    return context;
  }

  testWidgets('builds default message actions', (tester) async {
    final context = await _getContext(tester);

    final channel = _getChannelWithCapabilities(allChannelCapabilities);
    final actions = StreamMessageActionsBuilder.buildActions(
      context: context,
      message: message,
      channel: channel,
      currentUser: currentUser,
    );

    // Verify default actions
    actions.expects(StreamMessageActionType.quotedReply);
    actions.expects(StreamMessageActionType.threadReply);
    actions.expects(StreamMessageActionType.markUnread);
    actions.expects(StreamMessageActionType.copyMessage);
    actions.expects(StreamMessageActionType.editMessage);
    actions.expects(StreamMessageActionType.pinMessage);
    actions.expects(StreamMessageActionType.deleteMessage);
    actions.expects(StreamMessageActionType.flagMessage);
    actions.expects(StreamMessageActionType.muteUser);
  });

  testWidgets('handles onActionTap callback for actions', (tester) async {
    final context = await _getContext(tester);
    StreamMessageActionType? tappedActionType;
    Message? tappedMessage;

    final channel = _getChannelWithCapabilities(allChannelCapabilities);
    final actions = StreamMessageActionsBuilder.buildActions(
      context: context,
      message: message,
      channel: channel,
      currentUser: currentUser,
      onActionTap: (msg, actionType) {
        tappedMessage = msg;
        tappedActionType = actionType;
      },
    );

    actions.expects(StreamMessageActionType.quotedReply);
    final quotedReplyAction = actions.firstWhere(
      (action) => action.type == StreamMessageActionType.quotedReply,
    );

    quotedReplyAction.onTap?.call(message);

    expect(tappedActionType, StreamMessageActionType.quotedReply);
    expect(tappedMessage, message);
  });

  testWidgets('returns empty set for deleted messages', (tester) async {
    final context = await _getContext(tester);
    final deletedMessage = createTestMessage(isDeleted: true);

    final channel = _getChannelWithCapabilities(allChannelCapabilities);
    final actions = StreamMessageActionsBuilder.buildActions(
      context: context,
      message: deletedMessage,
      channel: channel,
      currentUser: currentUser,
    );

    expect(actions.isEmpty, isTrue);
  });

  testWidgets('includes custom actions', (tester) async {
    final context = await _getContext(tester);
    const customAction = StreamMessageAction(
      type: StreamMessageActionType('custom-action'),
      title: Text('Custom'),
      leading: Icon(Icons.star),
    );

    final channel = _getChannelWithCapabilities(allChannelCapabilities);
    final actions = StreamMessageActionsBuilder.buildActions(
      context: context,
      message: message,
      channel: channel,
      currentUser: currentUser,
      customActions: [customAction],
    );

    actions.expects(
      const StreamMessageActionType('custom-action'),
      reason: 'Custom action should be included',
    );
  });

  group('permission-based actions', () {
    testWidgets(
      'includes/excludes edit action based on authorship',
      (tester) async {
        final context = await _getContext(tester);

        // Own message test
        final channel = _getChannelWithCapabilities(allChannelCapabilities);
        final ownMessage = createTestMessage(userId: currentUser.id);
        final ownActions = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: ownMessage,
          channel: channel,
          currentUser: currentUser,
        );

        ownActions.expects(
          StreamMessageActionType.editMessage,
          reason: 'Edit action should be available for own messages',
        );

        // Other user's message test
        final otherUserActions = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: message,
          channel: channel,
          currentUser: currentUser,
        );

        otherUserActions.expects(
          StreamMessageActionType.editMessage,
          reason: 'Edit action should be available for others messages',
        );
      },
    );

    testWidgets('excludes edit action for messages with polls', (tester) async {
      final context = await _getContext(tester);

      final pollMessage = createTestMessage(
        userId: currentUser.id,
        poll: Poll(
          id: 'poll-id',
          name: 'What is your favorite color?',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          options: const [
            PollOption(text: 'Option 1'),
            PollOption(text: 'Option 2'),
          ],
        ),
      );

      final channel = _getChannelWithCapabilities(allChannelCapabilities);
      final actions = StreamMessageActionsBuilder.buildActions(
        context: context,
        message: pollMessage,
        channel: channel,
        currentUser: currentUser,
      );

      actions.notExpects(
        StreamMessageActionType.editMessage,
        reason: 'Edit action should not be available for poll messages',
      );
    });

    testWidgets(
      'includes/excludes delete action based on permission',
      (tester) async {
        final context = await _getContext(tester);

        // With delete permission
        final channel = _getChannelWithCapabilities([
          ChannelCapability.sendMessage,
          ChannelCapability.updateOwnMessage,
          ChannelCapability.deleteOwnMessage,
        ]);

        final ownMessage = createTestMessage(userId: currentUser.id);
        final actionsWithPerm = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: ownMessage,
          channel: channel,
          currentUser: currentUser,
        );

        actionsWithPerm.expects(
          StreamMessageActionType.deleteMessage,
          reason: 'Delete action should be available with permission',
        );

        // Without delete permission
        final channelWithoutDeletePerm = _getChannelWithCapabilities([
          ChannelCapability.sendMessage,
          ChannelCapability.updateOwnMessage,
        ]);

        final actionsWithoutPerm = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: message,
          channel: channelWithoutDeletePerm,
          currentUser: currentUser,
        );

        actionsWithoutPerm.notExpects(
          StreamMessageActionType.deleteMessage,
          reason: 'Delete action should not be available without permission',
        );
      },
    );

    testWidgets(
      'includes/excludes pin action based on permission',
      (tester) async {
        final context = await _getContext(tester);

        // With pin permission
        final channel = _getChannelWithCapabilities([
          ChannelCapability.sendMessage,
          ChannelCapability.sendReply,
          ChannelCapability.pinMessage,
        ]);

        final actionsWithPerm = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: message,
          channel: channel,
          currentUser: currentUser,
        );

        actionsWithPerm.expects(
          StreamMessageActionType.pinMessage,
          reason: 'Pin action should be available with pin permission',
        );

        // Without pin permission
        final channelWithoutPinPerm = _getChannelWithCapabilities([
          ChannelCapability.sendMessage,
          ChannelCapability.sendReply,
        ]);

        final actionsWithoutPerm = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: message,
          channel: channelWithoutPinPerm,
          currentUser: currentUser,
        );

        actionsWithoutPerm.notExpects(
          StreamMessageActionType.pinMessage,
          reason: 'Pin action should not be available without permission',
        );
      },
    );

    testWidgets('shows unpin action for pinned messages', (tester) async {
      final context = await _getContext(tester);

      final channel = _getChannelWithCapabilities(allChannelCapabilities);
      final pinnedMessage = createTestMessage(pinned: true);
      final actions = StreamMessageActionsBuilder.buildActions(
        context: context,
        message: pinnedMessage,
        channel: channel,
        currentUser: currentUser,
      );

      actions.expects(
        StreamMessageActionType.unpinMessage,
        reason: 'Unpin action should be available for pinned messages',
      );
    });

    testWidgets(
      'includes/excludes flag action based on authorship',
      (tester) async {
        final context = await _getContext(tester);

        // Other user's message
        final channel = _getChannelWithCapabilities(allChannelCapabilities);
        final actionsOtherUser = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: message,
          channel: channel,
          currentUser: currentUser,
        );

        actionsOtherUser.expects(
          StreamMessageActionType.flagMessage,
          reason: "Flag action should be available for others' messages",
        );

        // Own message
        final ownMessage = createTestMessage(userId: currentUser.id);
        final actionsOwnMessage = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: ownMessage,
          channel: channel,
          currentUser: currentUser,
        );

        actionsOwnMessage.notExpects(
          StreamMessageActionType.flagMessage,
          reason: 'Flag action should not be available for own messages',
        );
      },
    );

    testWidgets(
      'handles mute action correctly based on user and config',
      (tester) async {
        final context = await _getContext(tester);

        // User with no mutes
        final channel = _getChannelWithCapabilities(allChannelCapabilities);
        final userWithNoMutes = OwnUser(id: 'current-user', mutes: const []);
        final actionsForNoMutes = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: message,
          channel: channel,
          currentUser: userWithNoMutes,
        );

        actionsForNoMutes.expects(
          StreamMessageActionType.muteUser,
          reason: 'Mute action should be available for users with no mutes',
        );

        // User with mutes
        final userWithMutes = OwnUser(
          id: 'current-user',
          mutes: [
            Mute(
              user: User(id: 'test-user'),
              target: User(id: 'test-user'),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ],
        );

        final actionsForMutedUser = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: message,
          channel: channel,
          currentUser: userWithMutes,
        );

        actionsForMutedUser.expects(
          StreamMessageActionType.muteUser,
          reason: 'Mute action should be available for already muted users',
        );

        // Own message
        final ownMessage = createTestMessage(userId: currentUser.id);
        final actionsForOwnMessage = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: ownMessage,
          channel: channel,
          currentUser: currentUser,
        );

        actionsForOwnMessage.notExpects(
          StreamMessageActionType.muteUser,
          reason: 'Mute action should not be available for own messages',
        );

        // Channel without mutes enabled
        final channelWithoutMutes = _getChannelWithCapabilities(
          allChannelCapabilities,
          enableMutes: false,
        );

        final muteDisabledActions = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: message,
          channel: channelWithoutMutes,
          currentUser: currentUser,
        );

        muteDisabledActions.notExpects(
          StreamMessageActionType.muteUser,
          reason: 'Mute action unavailable when channel mutes are disabled',
        );
      },
    );

    testWidgets(
      'handles thread and quote reply actions correctly',
      (tester) async {
        final context = await _getContext(tester);

        // Thread message
        final channel = _getChannelWithCapabilities(allChannelCapabilities);
        final threadMessage = createTestMessage(parentId: 'parent-message-id');
        final actionsForThreadMessage =
            StreamMessageActionsBuilder.buildActions(
          context: context,
          message: threadMessage,
          channel: channel,
          currentUser: currentUser,
        );

        actionsForThreadMessage.notExpects(
          StreamMessageActionType.threadReply,
          reason: 'Thread reply unavailable for thread messages',
        );

        // Channel without quote permission
        final channelWithoutQuote = _getChannelWithCapabilities([
          ChannelCapability.sendMessage,
          ChannelCapability.sendReply,
        ]);

        final actionsWithoutQuote = StreamMessageActionsBuilder.buildActions(
          context: context,
          message: message,
          channel: channelWithoutQuote,
          currentUser: currentUser,
        );

        actionsWithoutQuote.notExpects(
          StreamMessageActionType.quotedReply,
          reason: 'Quote reply unavailable without quote permission',
        );
      },
    );

    testWidgets('handles mark unread action correctly', (tester) async {
      final context = await _getContext(tester);

      // With read events capability
      final parentMessage = createTestMessage(
        id: 'parent-message',
        text: 'Parent message',
        replyCount: 5,
      );

      final channelWithReadEvents = _getChannelWithCapabilities([
        ChannelCapability.sendMessage,
        ChannelCapability.sendReply,
        ChannelCapability.readEvents,
      ]);

      final actionsWithReadEvents = StreamMessageActionsBuilder.buildActions(
        context: context,
        message: parentMessage,
        channel: channelWithReadEvents,
        currentUser: currentUser,
      );

      actionsWithReadEvents.expects(
        StreamMessageActionType.markUnread,
        reason: 'Mark unread available with read events capability',
      );

      // Without read events capability
      final channelWithoutReadEvents = _getChannelWithCapabilities([
        ChannelCapability.sendMessage,
        ChannelCapability.sendReply,
      ]);

      final actionsWithoutReadEvents = StreamMessageActionsBuilder.buildActions(
        context: context,
        message: message,
        channel: channelWithoutReadEvents,
        currentUser: currentUser,
      );

      actionsWithoutReadEvents.notExpects(
        StreamMessageActionType.markUnread,
        reason: 'Mark unread unavailable without read events capability',
      );
    });
  });
}

/// Extension on Set<StreamMessageAction> to simplify action type checks.
extension StreamMessageActionSetExtension on Set<StreamMessageAction> {
  void expects(StreamMessageActionType type, {String? reason}) {
    final containsActionType = where((it) => it.type == type).isNotEmpty;
    return expect(containsActionType, isTrue, reason: reason);
  }

  void notExpects(StreamMessageActionType type, {String? reason}) {
    final containsActionType = where((it) => it.type == type).isNotEmpty;
    return expect(containsActionType, isFalse, reason: reason);
  }
}
