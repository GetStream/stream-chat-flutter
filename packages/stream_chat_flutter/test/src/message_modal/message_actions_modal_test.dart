// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' show StreamIconData;

void main() {
  final message = Message(
    id: 'test-message',
    text: 'This is a test message',
    createdAt: DateTime.now(),
    user: User(id: 'test-user', name: 'Test User'),
  );

  final messageActions = <StreamContextMenuAction<MessageAction>>[
    StreamContextMenuAction<MessageAction>(
      label: const Text('Reply'),
      leading: const Icon(StreamIconData.reply),
      value: QuotedReply(message: message),
    ),
    StreamContextMenuAction<MessageAction>(
      label: const Text('Thread Reply'),
      leading: const Icon(StreamIconData.thread),
      value: ThreadReply(message: message),
    ),
    StreamContextMenuAction<MessageAction>(
      label: const Text('Copy Message'),
      leading: const Icon(StreamIconData.copy),
      value: CopyMessage(message: message),
    ),
    StreamContextMenuAction<MessageAction>.destructive(
      label: const Text('Delete Message'),
      leading: const Icon(StreamIconData.delete),
      value: DeleteMessage(message: message),
    ),
  ];

  group('StreamMessageActionsModal', () {
    testWidgets('renders message widget and actions correctly', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageActionsModal(
            message: message,
            messageActions: messageActions,
            messageWidget: const Text('Message Widget'),
            alignment: AlignmentDirectional.centerStart,
          ),
        ),
      );

      // Use a longer timeout to ensure everything is rendered
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Message Widget'), findsOneWidget);
      expect(find.text('Reply'), findsOneWidget);
      expect(find.text('Thread Reply'), findsOneWidget);
      expect(find.text('Copy Message'), findsOneWidget);
      expect(find.text('Delete Message'), findsOneWidget);
    });

    testWidgets('renders with reaction picker when enabled', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageActionsModal(
            message: message,
            messageActions: messageActions,
            messageWidget: const Text('Message Widget'),
            alignment: AlignmentDirectional.centerStart,
            showReactionPicker: true,
          ),
        ),
      );

      // Use a longer timeout to ensure everything is rendered
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(StreamMessageReactionPicker), findsOneWidget);
    });

    testWidgets(
      'pops with SelectReaction when reaction is selected',
      (tester) async {
        MessageAction? messageAction;

        // Define custom reaction icons via resolver for testing.
        const testReactionResolver = _TestReactionIconResolver(
          defaultReactionTypes: {'like', 'love'},
        );

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            reactionIconResolver: testReactionResolver,
            Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  messageAction = await showStreamDialog(
                    context: context,
                    builder: (_) => StreamMessageActionsModal(
                      message: message,
                      messageActions: messageActions,
                      messageWidget: const Text('Message Widget'),
                      alignment: AlignmentDirectional.centerStart,
                      showReactionPicker: true,
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open Dialog'));

        // Use a longer timeout to ensure everything is rendered
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Verify reaction picker is shown
        expect(find.byType(StreamMessageReactionPicker), findsOneWidget);

        // Reactions are rendered as StreamEmojiButton widgets. The resolver
        // maps 'like' → 👍 and 'love' → ❤️. Find and tap the 'like' emoji.
        final likeEmoji = find.text('👍');
        expect(likeEmoji, findsOneWidget);
        await tester.tap(likeEmoji);
        await tester.pumpAndSettle();

        expect(messageAction, isA<SelectReaction>());
        // Verify the popped value has correct reaction type
        expect((messageAction! as SelectReaction).reaction.type, 'like');

        // Open dialog again and tap the second reaction (love)
        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        final loveEmoji = find.text('❤️');
        expect(loveEmoji, findsOneWidget);
        await tester.tap(loveEmoji);
        await tester.pumpAndSettle();

        expect(messageAction, isA<SelectReaction>());
        // Verify the popped value has correct reaction type
        expect((messageAction! as SelectReaction).reaction.type, 'love');
      },
    );
  });

  group('StreamMessageActionsModal Golden Tests', () {
    Widget buildMessageWidget({bool reverse = false}) {
      return Builder(
        builder: (context) {
          final colorScheme = context.streamColorScheme;
          final backgroundColor = reverse ? colorScheme.brand.shade100 : colorScheme.backgroundSurface;
          final textColor = reverse ? colorScheme.brand.shade900 : colorScheme.textPrimary;

          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: backgroundColor,
            ),
            child: Text(
              message.text ?? '',
              style: TextStyle(color: textColor),
            ),
          );
        },
      );
    }

    for (final brightness in Brightness.values) {
      final theme = brightness.name;

      goldenTest(
        'StreamMessageActionsModal in $theme theme',
        fileName: 'stream_message_actions_modal_$theme',
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          StreamMessageActionsModal(
            message: message,
            messageActions: messageActions,
            messageWidget: buildMessageWidget(),
            alignment: AlignmentDirectional.centerStart,
          ),
        ),
      );

      goldenTest(
        'StreamMessageActionsModal with reaction picker in $theme theme',
        fileName: 'stream_message_actions_modal_with_reactions_$theme',
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          StreamMessageActionsModal(
            message: message,
            messageActions: messageActions,
            messageWidget: buildMessageWidget(),
            alignment: AlignmentDirectional.centerStart,
            showReactionPicker: true,
          ),
        ),
      );

      goldenTest(
        'StreamMessageActionsModal reversed in $theme theme',
        fileName: 'stream_message_actions_modal_reversed_$theme',
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          StreamMessageActionsModal(
            message: message,
            messageActions: messageActions,
            messageWidget: buildMessageWidget(reverse: true),
            alignment: AlignmentDirectional.centerEnd,
          ),
        ),
      );

      goldenTest(
        'StreamMessageActionsModal reversed with reaction picker in $theme theme',
        fileName: 'stream_message_actions_modal_reversed_with_reactions_$theme',
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          StreamMessageActionsModal(
            message: message,
            messageActions: messageActions,
            messageWidget: buildMessageWidget(reverse: true),
            alignment: AlignmentDirectional.centerEnd,
            showReactionPicker: true,
          ),
        ),
      );
    }
  });
}

Widget _wrapWithMaterialApp(
  Widget child, {
  Brightness brightness = Brightness.light,
  ReactionIconResolver? reactionIconResolver,
}) {
  return Portal(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: brightness),
      builder: (context, child) => StreamChatConfiguration(
        data: StreamChatConfigurationData(
          reactionIconResolver: reactionIconResolver ?? const _TestReactionIconResolver(),
        ),
        child: StreamChatTheme(
          data: StreamChatThemeData(),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
      home: Builder(
        builder: (context) {
          final colorScheme = context.streamColorScheme;
          return Scaffold(
            backgroundColor: colorScheme.backgroundApp,
            body: ColoredBox(
              color: colorScheme.backgroundOverlayLight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: child,
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _TestReactionIconResolver extends ReactionIconResolver {
  const _TestReactionIconResolver({
    this.defaultReactionTypes = const {'like', 'love', 'haha', 'wow', 'sad'},
  });

  final Set<String> defaultReactionTypes;

  @override
  Set<String> get defaultReactions => defaultReactionTypes;

  @override
  Set<String> get supportedReactions => defaultReactionTypes;

  @override
  String? emojiCode(String type) => streamSupportedEmojis[type]?.emoji;

  @override
  StreamEmojiContent resolve(String type) {
    if (emojiCode(type) case final emoji?) return StreamUnicodeEmoji(emoji);
    return const StreamUnicodeEmoji('❓');
  }
}
