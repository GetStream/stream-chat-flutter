// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_modal/moderated_message_actions_modal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final message = Message(
    id: 'test-message',
    type: MessageType.error,
    text: 'This is a test message',
    createdAt: DateTime.now(),
    user: User(id: 'test-user', name: 'Test User'),
    moderation: const Moderation(
      action: ModerationAction.bounce,
      originalText: 'This is a test message with flagged content',
    ),
  );

  final messageActions = <StreamMessageAction>{
    const StreamMessageAction(
      type: StreamMessageActionType.resendMessage,
      title: Text('Send Anyway'),
      leading: StreamSvgIcon(icon: StreamSvgIcons.send),
    ),
    const StreamMessageAction(
      type: StreamMessageActionType.editMessage,
      title: Text('Edit Message'),
      leading: StreamSvgIcon(icon: StreamSvgIcons.edit),
    ),
    const StreamMessageAction(
      isDestructive: true,
      type: StreamMessageActionType.hardDeleteMessage,
      title: Text('Delete Message'),
      leading: StreamSvgIcon(icon: StreamSvgIcons.delete),
    ),
  };

  group('ModeratedMessageActionsModal', () {
    testWidgets('renders title, content and actions correctly', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          ModeratedMessageActionsModal(
            message: message,
            messageActions: messageActions,
          ),
        ),
      );

      // Use a longer timeout to ensure everything is rendered
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Check for icon, title and content
      expect(find.byType(StreamSvgIcon), findsWidgets);
      expect(find.byType(Text), findsWidgets);

      // Check for actions
      expect(find.text('Send Anyway'), findsOneWidget);
      expect(find.text('Edit Message'), findsOneWidget);
      expect(find.text('Delete Message'), findsOneWidget);
    });

    testWidgets('action buttons call the correct callbacks', (tester) async {
      var sendAnywayTapped = false;
      var editMessageTapped = false;
      var deleteMessageTapped = false;

      final callbackActions = <StreamMessageAction>{
        StreamMessageAction(
          type: StreamMessageActionType.resendMessage,
          title: const Text('Send Anyway'),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.send),
          onTap: (_) => sendAnywayTapped = true,
        ),
        StreamMessageAction(
          type: StreamMessageActionType.editMessage,
          title: const Text('Edit Message'),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.edit),
          onTap: (_) => editMessageTapped = true,
        ),
        StreamMessageAction(
          isDestructive: true,
          type: StreamMessageActionType.hardDeleteMessage,
          title: const Text('Delete Message'),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.delete),
          onTap: (_) => deleteMessageTapped = true,
        ),
      };

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          ModeratedMessageActionsModal(
            message: message,
            messageActions: callbackActions,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Send Anyway button
      await tester.tap(find.text('Send Anyway'));
      await tester.pumpAndSettle();
      expect(sendAnywayTapped, isTrue);

      // Tap on Edit Message button
      await tester.tap(find.text('Edit Message'));
      await tester.pumpAndSettle();
      expect(editMessageTapped, isTrue);

      // Tap on Delete Message button
      await tester.tap(find.text('Delete Message'));
      await tester.pumpAndSettle();
      expect(deleteMessageTapped, isTrue);
    });
  });

  group('ModeratedMessageActionsModal Golden Tests', () {
    for (final brightness in Brightness.values) {
      final theme = brightness.name;

      goldenTest(
        'ModeratedMessageActionsModal in $theme theme',
        fileName: 'moderated_message_actions_modal_$theme',
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 350),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          ModeratedMessageActionsModal(
            message: message,
            messageActions: messageActions,
          ),
        ),
      );

      // Test with different moderation actions
      goldenTest(
        'ModeratedMessageActionsModal with bounce action in $theme theme',
        fileName: 'moderated_message_actions_modal_bounce_$theme',
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 350),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          ModeratedMessageActionsModal(
            message: Message(
              id: 'test-message',
              type: MessageType.error,
              text: 'This is a test message',
              createdAt: DateTime.now(),
              user: User(id: 'test-user', name: 'Test User'),
              moderation: const Moderation(
                action: ModerationAction.bounce,
                originalText: 'This is a test message with bounced content',
              ),
            ),
            messageActions: messageActions,
          ),
        ),
      );
    }
  });
}

Widget _wrapWithMaterialApp(
  Widget child, {
  Brightness? brightness,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamChatTheme(
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
  );
}
