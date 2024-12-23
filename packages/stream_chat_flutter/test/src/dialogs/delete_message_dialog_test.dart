import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:stream_chat_flutter/src/dialogs/delete_message_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';

void main() {
  group('DeleteMessageDialog tests', () {
    testWidgets('renders with correct title and actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: StreamChatTheme(
                    data: StreamChatThemeData.light(),
                    child: const DeleteMessageDialog(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Delete Message'), findsOneWidget);
      expect(find.text('DELETE'), findsOneWidget);
    });

    goldenTest(
      'golden test for DeleteMessageDialog',
      fileName: 'delete_message_dialog_0',
      constraints: const BoxConstraints.tightFor(width: 400, height: 300),
      builder: () => MaterialAppWrapper(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: StreamChatTheme(
                  data: StreamChatThemeData.light(),
                  child: const DeleteMessageDialog(),
                ),
              );
            },
          ),
        ),
      ),
    );
  });
}
