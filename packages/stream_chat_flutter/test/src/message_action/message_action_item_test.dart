import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_action/message_action_item.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final message = Message(
    id: 'test-message',
    text: 'Hello, world!',
    user: User(id: 'test-user'),
  );

  testWidgets('renders with title and icon', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamMessageActionItem(
          message: message,
          action: const StreamMessageAction(
            type: StreamMessageActionType.reply,
            title: Text('Reply'),
            leading: Icon(Icons.reply),
          ),
        ),
      ),
    );

    expect(find.text('Reply'), findsOneWidget);
    expect(find.byIcon(Icons.reply), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    Message? tappedMessage;

    final actionWithTap = StreamMessageAction(
      type: StreamMessageActionType.reply,
      title: const Text('Reply'),
      leading: const Icon(Icons.reply),
      onTap: (msg) {
        tappedMessage = msg;
      },
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamMessageActionItem(
          message: message,
          action: actionWithTap,
        ),
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(tappedMessage, message);
  });

  testWidgets('renders custom child when provided', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamMessageActionItem.custom(
          message: message,
          action: const StreamMessageAction(
            type: StreamMessageActionType('custom-child'),
          ),
          child: const Text('Custom Child'),
        ),
      ),
    );

    expect(find.text('Custom Child'), findsOneWidget);
  });

  testWidgets(
    'applies destructive styling when isDestructive is true',
    (tester) async {
      const destructiveAction = StreamMessageAction(
        type: StreamMessageActionType.deleteMessage,
        title: Text('Delete'),
        leading: Icon(Icons.delete),
        isDestructive: true,
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageActionItem(
            message: message,
            action: destructiveAction,
          ),
        ),
      );

      expect(find.text('Delete'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);

      // The icon and text should have the error color
      final theme = StreamChatTheme.of(tester.element(find.text('Delete')));
      final iconTheme = IconTheme.of(tester.element(find.byIcon(Icons.delete)));

      expect(iconTheme.color, theme.colorTheme.accentError);
    },
  );

  group('StreamMessageActionItem Golden Tests', () {
    for (final brightness in Brightness.values) {
      final theme = brightness.name;

      // Test standard action
      goldenTest(
        'StreamMessageActionItem (Reply) in $theme theme',
        fileName: 'stream_message_action_item_reply_$theme',
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 60),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          StreamMessageActionItem(
            message: message,
            action: const StreamMessageAction(
              type: StreamMessageActionType.quotedReply,
              title: Text('Reply'),
              leading: Icon(Icons.reply),
            ),
          ),
        ),
      );

      // Test destructive action (like delete)
      goldenTest(
        'StreamMessageActionItem (Delete) in $theme theme',
        fileName: 'stream_message_action_item_delete_$theme',
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 60),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          StreamMessageActionItem(
            message: message,
            action: const StreamMessageAction(
              type: StreamMessageActionType.deleteMessage,
              title: Text('Delete Message'),
              isDestructive: true,
              leading: Icon(Icons.delete),
            ),
          ),
        ),
      );

      // Test with custom styling
      goldenTest(
        'StreamMessageActionItem with custom styling in $theme theme',
        fileName: 'stream_message_action_item_custom_styling_$theme',
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 60),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          StreamMessageActionItem(
            message: message,
            action: StreamMessageAction(
              type: const StreamMessageActionType('styled'),
              title: const Text('Styled Action'),
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.purple[700],
              ),
              leading: const Icon(Icons.favorite),
              iconColor: Colors.pink[400],
              backgroundColor: Colors.amber[100],
            ),
          ),
        ),
      );

      // Test custom child action item
      goldenTest(
        'StreamMessageActionItem.custom in $theme theme',
        fileName: 'stream_message_action_item_custom_child_$theme',
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 60),
        builder: () => _wrapWithMaterialApp(
          brightness: brightness,
          StreamMessageActionItem.custom(
            message: message,
            action: const StreamMessageAction(
              type: StreamMessageActionType('custom-child'),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_emotions, color: Colors.amber[600]),
                const SizedBox(width: 16),
                const Expanded(child: Text('Custom Child')),
                const SizedBox(width: 8),
                const Badge(label: Text('New')),
              ],
            ),
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
          body: Center(
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
