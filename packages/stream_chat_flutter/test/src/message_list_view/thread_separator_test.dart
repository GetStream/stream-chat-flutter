import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_list_view/thread_separator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('ThreadSeparator renders text and decoration', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ThreadSeparator(
              parentMessage: Message(replyCount: 3),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(DecoratedBox), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });
}
