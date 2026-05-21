import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

final _sender = noahSmith;

/// Custom reaction resolver that maps 'celebrate' to 🎉, demonstrating the
/// [ReactionIconResolver] API.
class _CelebrationReactionResolver extends DefaultReactionIconResolver {
  const _CelebrationReactionResolver();

  @override
  String? emojiCode(String type) {
    if (type == 'celebrate') return '🎉';
    return super.emojiCode(type);
  }
}

Widget _buildMessageScaffold({
  required MockClient client,
  required MockChannel channel,
  required Widget child,
  StreamChatConfigurationData? configData,
}) {
  return MaterialApp(
    theme: docsScreenshotsTheme(),
    debugShowCheckedModeBanner: false,
    home: StreamChat(
      client: client,
      streamChatConfigData: configData,
      connectivityStream: Stream.value([ConnectivityResult.mobile]),
      child: StreamChannel(
        showLoading: false,
        channel: channel,
        child: Scaffold(body: child),
      ),
    ),
  );
}

void _setupBasicChannel(
  MockClient client,
  MockClientState clientState,
  MockChannel channel,
  MockChannelState channelState,
) {
  setupMockChannel(
    client: client,
    clientState: clientState,
    channel: channel,
    channelState: channelState,
    channelName: 'General',
  );
  when(() => clientState.currentUser).thenReturn(ownUser);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'message widget actions',
    fileName: 'message_widget_actions',
    constraints: const BoxConstraints.tightFor(width: 375, height: 620),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(
        type: 'messaging',
        id: 'general',
        ownCapabilities: const [
          ChannelCapability.sendMessage,
          ChannelCapability.sendReply,
          ChannelCapability.pinMessage,
          ChannelCapability.quoteMessage,
          ChannelCapability.readEvents,
          ChannelCapability.updateAnyMessage,
          ChannelCapability.updateOwnMessage,
          ChannelCapability.deleteAnyMessage,
          ChannelCapability.deleteOwnMessage,
        ],
      );
      final channelState = MockChannelState();
      _setupBasicChannel(client, clientState, channel, channelState);

      final message = Message(
        id: 'msg-1',
        text: 'Hello! This message has actions.',
        user: _sender,
        createdAt: DateTime(2024, 6, 1, 10, 0),
        reactionGroups: {
          'love': ReactionGroup(
            count: 3,
            sumScores: 3,
            firstReactionAt: DateTime(2024, 6, 1, 10, 1),
            lastReactionAt: DateTime(2024, 6, 1, 10, 2),
          ),
        },
      );

      return _buildMessageScaffold(
        client: client,
        channel: channel,
        child: Builder(
          builder: (context) {
            const effectiveAvatarSize = StreamAvatarSize.md;
            final effectiveSpacing = context.streamSpacing.md + context.streamSpacing.xs;
            final leadingInset = effectiveAvatarSize.value + effectiveSpacing;

            return StreamMessageActionsModal(
              message: message,
              showReactionPicker: true,
              leadingInset: leadingInset,
              messageWidget: StreamMessageItem(message: message),
              messageActions: StreamContextMenuAction.partitioned(
                items: StreamMessageActionsBuilder.buildActions(
                  context: context,
                  message: message,
                  channel: channel,
                  currentUser: ownUser,
                ),
              ),
            );
          },
        ),
      );
    },
  );

  docsGoldenTest(
    'message theming',
    fileName: 'message_theming',
    constraints: const BoxConstraints.tightFor(width: 375, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      _setupBasicChannel(client, clientState, channel, channelState);
      stubMockClientCurrentUser(client, ownUser);

      final message = Message(
        id: 'msg-2',
        text: 'This message uses a custom theme!',
        user: ownUser,
        createdAt: DateTime(2024, 6, 1, 10, 0),
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Center(
                child: core.StreamMessageLayout(
                  data: const core.StreamMessageLayoutData(
                    alignment: core.StreamMessageAlignment.end,
                  ),
                  child: core.StreamMessageItemTheme(
                    data: core.StreamMessageItemThemeData(
                      bubble: core.StreamMessageBubbleStyle.from(
                        backgroundColor: Colors.amber.shade300,
                      ),
                      text: core.StreamMessageTextStyle.from(
                        textColor: Colors.brown,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    child: StreamMessageItem(message: message),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'message reaction theming',
    fileName: 'message_reaction_theming',
    constraints: const BoxConstraints.tightFor(width: 375, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      _setupBasicChannel(client, clientState, channel, channelState);

      final message = Message(
        id: 'msg-3',
        text: 'Check out these reactions!',
        user: _sender,
        createdAt: DateTime(2024, 6, 1, 10, 0),
        reactionGroups: {
          'celebrate': ReactionGroup(
            count: 3,
            sumScores: 3,
            firstReactionAt: DateTime(2024, 6, 1),
            lastReactionAt: DateTime(2024, 6, 1),
          ),
          'love': ReactionGroup(
            count: 2,
            sumScores: 2,
            firstReactionAt: DateTime(2024, 6, 1),
            lastReactionAt: DateTime(2024, 6, 1),
          ),
        },
      );

      return _buildMessageScaffold(
        client: client,
        channel: channel,
        configData: StreamChatConfigurationData(
          reactionIconResolver: const _CelebrationReactionResolver(),
        ),
        child: Center(child: StreamMessageItem(message: message)),
      );
    },
  );

  docsGoldenTest(
    'message with rounded avatar',
    fileName: 'message_rounded_avatar',
    constraints: const BoxConstraints.tightFor(width: 375, height: 120),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      _setupBasicChannel(client, clientState, channel, channelState);

      final message = Message(
        id: 'msg-4',
        text: 'Message with user avatar shown.',
        user: _sender,
        createdAt: DateTime(2024, 6, 1, 10, 0),
      );

      return _buildMessageScaffold(
        client: client,
        channel: channel,
        child: Center(child: StreamMessageItem(message: message)),
      );
    },
  );

  docsGoldenTest(
    'message styles',
    fileName: 'message_styles',
    constraints: const BoxConstraints.tightFor(width: 375, height: 300),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      _setupBasicChannel(client, clientState, channel, channelState);
      stubMockClientCurrentUser(client, ownUser);

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  core.StreamMessageItemTheme(
                    data: core.StreamMessageItemThemeData(
                      text: core.StreamMessageTextStyle.from(
                        textColor: Colors.deepPurple,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    child: StreamMessageItem(
                      message: Message(
                        id: 'msg-from-other',
                        text: 'This is a message from ${_sender.name}.',
                        user: _sender,
                        createdAt: DateTime(2024, 6, 1, 10, 0),
                      ),
                    ),
                  ),
                  core.StreamMessageLayout(
                    data: const core.StreamMessageLayoutData(
                      alignment: core.StreamMessageAlignment.end,
                    ),
                    child: core.StreamMessageItemTheme(
                      data: core.StreamMessageItemThemeData(
                        text: core.StreamMessageTextStyle.from(
                          textColor: Colors.indigo,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      child: StreamMessageItem(
                        message: Message(
                          id: 'msg-from-me',
                          text: 'And this is my reply!',
                          user: ownUser,
                          createdAt: DateTime(2024, 6, 1, 10, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

