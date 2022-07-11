import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/dialogs/delete_message_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('DeleteMessageDialog', (tester) async {
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

  testGoldens('golden test for DeleteMessageDialog', (tester) async {
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

    await screenMatchesGolden(tester, 'delete_message_dialog_0');
  });
}
