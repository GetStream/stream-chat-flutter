// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

  final messageActions = <StreamMessageAction>[
    StreamMessageAction(
      title: const Text('Send Anyway'),
      leading: const StreamSvgIcon(icon: StreamSvgIcons.send),
      action: ResendMessage(message: message),
    ),
    StreamMessageAction(
      title: const Text('Edit Message'),
      leading: const StreamSvgIcon(icon: StreamSvgIcons.edit),
      action: EditMessage(message: message),
    ),
    StreamMessageAction(
      isDestructive: true,
      title: const Text('Delete Message'),
      leading: const StreamSvgIcon(icon: StreamSvgIcons.delete),
      action: HardDeleteMessage(message: message),
    ),
  ];

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
      MessageAction? messageAction;

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          ModeratedMessageActionsModal(
            message: message,
            messageActions: messageActions,
            onActionTap: (action) => messageAction = action,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Send Anyway button
      await tester.tap(find.text('Send Anyway'));
      await tester.pumpAndSettle();
      expect(messageAction, isA<ResendMessage>());

      // Tap on Edit Message button
      await tester.tap(find.text('Edit Message'));
      await tester.pumpAndSettle();
      expect(messageAction, isA<EditMessage>());

      // Tap on Delete Message button
      await tester.tap(find.text('Delete Message'));
      await tester.pumpAndSettle();
      expect(messageAction, isA<HardDeleteMessage>());
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
