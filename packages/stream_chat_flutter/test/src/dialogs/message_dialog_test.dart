import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:stream_chat_flutter/src/dialogs/message_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';

void main() {
  group('MessageDialog tests', () {
    testWidgets('shows default info', (tester) async {
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

    testWidgets('shows custom info', (tester) async {
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

    goldenTest(
      'golden test for default MessageDialog',
      fileName: 'message_dialog_0',
      constraints: const BoxConstraints.tightFor(width: 400, height: 300),
      builder: () => MaterialAppWrapper(
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

    goldenTest(
      'golden test for custom MessageDialog',
      fileName: 'message_dialog_1',
      constraints: const BoxConstraints.tightFor(width: 400, height: 300),
      builder: () => MaterialAppWrapper(
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

    goldenTest(
      'golden test for custom MessageDialog with no body',
      fileName: 'message_dialog_2',
      constraints: const BoxConstraints.tightFor(width: 400, height: 300),
      builder: () => MaterialAppWrapper(
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
  });
}
