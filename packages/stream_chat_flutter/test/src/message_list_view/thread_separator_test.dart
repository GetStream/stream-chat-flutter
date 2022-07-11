import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_list_view/thread_separator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('ThreadSeparator', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: ThreadSeparator(
                parentMessage: Message(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(DecoratedBox), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });
}
