// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_modal/message_actions_modal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final message = Message(
    id: 'test-message',
    text: 'This is a test message',
    createdAt: DateTime.now(),
    user: User(id: 'test-user', name: 'Test User'),
  );

  final messageActions = <StreamMessageAction>{
    const StreamMessageAction(
      type: StreamMessageActionType.quotedReply,
      title: Text('Reply'),
      leading: StreamSvgIcon(icon: StreamSvgIcons.reply),
    ),
    const StreamMessageAction(
      type: StreamMessageActionType.threadReply,
      title: Text('Thread Reply'),
      leading: StreamSvgIcon(icon: StreamSvgIcons.threadReply),
    ),
    const StreamMessageAction(
      type: StreamMessageActionType.copyMessage,
      title: Text('Copy Message'),
      leading: StreamSvgIcon(icon: StreamSvgIcons.copy),
    ),
    const StreamMessageAction(
      isDestructive: true,
      type: StreamMessageActionType.deleteMessage,
      title: Text('Delete Message'),
      leading: StreamSvgIcon(icon: StreamSvgIcons.delete),
    ),
  };

  group('StreamMessageActionsModal', () {
    testWidgets('renders message widget and actions correctly', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageActionsModal(
            message: message,
            messageActions: messageActions,
            messageWidget: const Text('Message Widget'),
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
            showReactionPicker: true,
          ),
        ),
      );

      // Use a longer timeout to ensure everything is rendered
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byType(StreamReactionPicker), findsOneWidget);
    });

    testWidgets(
      'calls onReactionPicked when reaction is selected',
      (tester) async {
        String? selectedReactionType;

        // Define custom reaction icons for testing
        final testReactionIcons = [
          StreamReactionIcon(
            type: 'like',
            builder: (context, isActive, size) => const Icon(Icons.thumb_up),
          ),
          StreamReactionIcon(
            type: 'love',
            builder: (context, isActive, size) => const Icon(Icons.favorite),
          ),
        ];

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            StreamMessageActionsModal(
              message: message,
              messageActions: messageActions,
              messageWidget: const Text('Message Widget'),
              showReactionPicker: true,
              onReactionPicked: (reaction) {
                selectedReactionType = reaction.type;
              },
            ),
            reactionIcons: testReactionIcons,
          ),
        );

        // Use a longer timeout to ensure everything is rendered
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Verify reaction picker is shown
        expect(find.byType(StreamReactionPicker), findsOneWidget);

        // Find and tap the first reaction (like)
        final reactionIconFinder = find.byIcon(Icons.thumb_up);
        expect(reactionIconFinder, findsOneWidget);
        await tester.tap(reactionIconFinder);
        await tester.pumpAndSettle();

        // Verify callback was called with correct reaction type
        expect(selectedReactionType, 'like');

        // Reset selected reaction
        selectedReactionType = null;

        // Find and tap the second reaction (love)
        final loveIconFinder = find.byIcon(Icons.favorite);
        expect(loveIconFinder, findsOneWidget);
        await tester.tap(loveIconFinder);
        await tester.pumpAndSettle();

        // Verify callback was called with correct reaction type
        expect(selectedReactionType, 'love');
      },
    );
  });

  group('StreamMessageActionsModal Golden Tests', () {
    Widget buildMessageWidget({bool reverse = false}) {
      return Builder(
        builder: (context) {
          final theme = StreamChatTheme.of(context);
          final messageTheme = theme.getMessageTheme(reverse: reverse);

          return Align(
            alignment: reverse ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: messageTheme.messageBackgroundColor,
              ),
              child: Text(
                message.text ?? '',
                style: messageTheme.messageTextStyle,
              ),
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
            reverse: true,
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
            showReactionPicker: true,
            reverse: true,
          ),
        ),
      );
    }
  });
}

Widget _wrapWithMaterialApp(
  Widget child, {
  Brightness? brightness,
  List<StreamReactionIcon>? reactionIcons,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamChatConfiguration(
      data: StreamChatConfigurationData(reactionIcons: reactionIcons),
      child: StreamChatTheme(
        data: StreamChatThemeData(brightness: brightness),
        child: Builder(builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.appBg,
            body: ColoredBox(
              color: theme.colorTheme.overlay,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: child,
              ),
            ),
          );
        }),
      ),
    ),
  );
}
