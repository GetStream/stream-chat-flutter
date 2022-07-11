import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_widget/username.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('Username', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Username(
              message: Message(),
              messageTheme: StreamChatThemeData.light().ownMessageTheme,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Text), findsOneWidget);
  });
}
