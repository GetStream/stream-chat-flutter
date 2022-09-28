import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/dialogs/message_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('MessageDialog shows default info', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: StreamChatTheme(
                  data: StreamChatThemeData.light(),
                  child: const MessageDialog(),
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
  });

  testWidgets('MessageDialog shows custom info', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: StreamChatTheme(
                  data: StreamChatThemeData.light(),
                  child: const MessageDialog(
                    titleText: 'Message',
                    messageText: 'Message body',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Message'), findsOneWidget);
    expect(find.text('Message body'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
  });

  testGoldens('golden test for default MessageDialog', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: StreamChatTheme(
                  data: StreamChatThemeData.light(),
                  child: const MessageDialog(),
                ),
              );
            },
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'message_dialog_0');
  });

  testGoldens('golden test for custom MessageDialog', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: StreamChatTheme(
                  data: StreamChatThemeData.light(),
                  child: const MessageDialog(
                    titleText: 'Message',
                    messageText: 'Message body',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'message_dialog_1');
  });

  testGoldens('golden test for custom MessageDialog with no body',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: StreamChatTheme(
                  data: StreamChatThemeData.light(),
                  child: const MessageDialog(
                    titleText: 'Message',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'message_dialog_2');
  });
}
