import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  Future<void> pumpLeading(
    WidgetTester tester, {
    required Message message,
    VoidCallback? onTap,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData(),
          child: Scaffold(
            body: Center(
              child: StreamMessageLeading(
                message: message,
                onTap: onTap,
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'invokes onTap when the avatar is tapped',
    (tester) async {
      var tapCount = 0;
      final message = Message(
        text: 'hello',
        user: User(id: 'u1', name: 'Alice'),
      );

      await pumpLeading(
        tester,
        message: message,
        onTap: () => tapCount++,
      );

      await tester.tap(find.byType(StreamUserAvatar));
      expect(tapCount, 1);
    },
  );

  testWidgets(
    'does nothing when onTap is null',
    (tester) async {
      final message = Message(
        text: 'hello',
        user: User(id: 'u1', name: 'Alice'),
      );

      await pumpLeading(tester, message: message);

      await tester.tap(find.byType(StreamUserAvatar));
      // No GestureDetector should be wrapping the avatar when onTap is null.
      expect(
        find.descendant(
          of: find.byType(StreamMessageLeading),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    },
  );
}
