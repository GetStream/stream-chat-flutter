import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('StreamSendingIndicator shows an Icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: StreamSendingIndicator(
                message: Message(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Icon), findsOneWidget);
  });

  testGoldens(
      'golden test for StreamSendingIndicator with StreamSvgIcon.checkAll',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: StreamSendingIndicator(
                isMessageRead: true,
                message: Message(),
              ),
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'sending_indicator_0');
  });

  testGoldens('golden test for StreamSendingIndicator with StreamSvgIcon.check',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: StreamSendingIndicator(
                message: Message(),
              ),
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'sending_indicator_1');
  });

  testGoldens(
      'golden test for StreamSendingIndicator with Icon(Icons.access_time)',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: StreamSendingIndicator(
                message: Message(),
              ),
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'sending_indicator_2');
  });
}
