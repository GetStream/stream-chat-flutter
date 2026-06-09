// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

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

  final messageActions = <StreamContextMenuAction<MessageAction>>[
    StreamContextMenuAction<MessageAction>(
      label: const Text('Send Anyway'),
      leading: const Icon(StreamIconData.send),
      value: ResendMessage(message: message),
    ),
    StreamContextMenuAction<MessageAction>(
      label: const Text('Edit Message'),
      leading: const Icon(StreamIconData.edit),
      value: EditMessage(message: message),
    ),
    StreamContextMenuAction<MessageAction>.destructive(
      label: const Text('Delete Message'),
      leading: const Icon(StreamIconData.delete),
      value: HardDeleteMessage(message: message),
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
      expect(find.byType(Icon), findsWidgets);
      expect(find.byType(Text), findsWidgets);

      // Check for actions
      expect(find.text('Send Anyway'), findsOneWidget);
      expect(find.text('Edit Message'), findsOneWidget);
      expect(find.text('Delete Message'), findsOneWidget);
    });

    testWidgets('action buttons pop with the correct value', (tester) async {
      MessageAction? messageAction;

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                messageAction = await showStreamDialog(
                  context: context,
                  builder: (_) => ModeratedMessageActionsModal(
                    message: message,
                    messageActions: messageActions,
                  ),
                );
              },
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      );

      // Open dialog and tap Send Anyway
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Tap on Send Anyway button
      await tester.tap(find.text('Send Anyway'));
      await tester.pumpAndSettle();
      expect(messageAction, isA<ResendMessage>());

      // Open dialog and tap Edit Message
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit Message'));
      await tester.pumpAndSettle();
      expect(messageAction, isA<EditMessage>());

      // Open dialog and tap Delete Message
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();
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
  Brightness brightness = Brightness.light,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: brightness),
    builder: (context, child) => StreamChatConfiguration(
      data: StreamChatConfigurationData(),
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
  );
}
