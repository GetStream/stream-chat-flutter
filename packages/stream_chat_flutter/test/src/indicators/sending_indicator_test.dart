import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('SendingIndicator shows a StreamSvgIcon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: SendingIndicator(
                message: Message(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(StreamSvgIcon), findsOneWidget);
  });

  testWidgets('SendingIndicator shows an Icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: SendingIndicator(
                message: Message(
                  status: MessageSendingStatus.sending,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Icon), findsOneWidget);
  });

  testGoldens('golden test for SendingIndicator with StreamSvgIcon.checkAll',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: SendingIndicator(
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

  testGoldens('golden test for SendingIndicator with StreamSvgIcon.check',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: SendingIndicator(
                message: Message(),
              ),
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'sending_indicator_1');
  });

  testGoldens('golden test for SendingIndicator with Icon(Icons.access_time)',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: SendingIndicator(
                message: Message(
                  status: MessageSendingStatus.sending,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'sending_indicator_2');
  });
}
