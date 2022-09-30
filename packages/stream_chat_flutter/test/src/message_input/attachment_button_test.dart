import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('SendButton onPressed works', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AttachmentButton(
              color: StreamChatThemeData.light()
                  .messageInputTheme
                  .actionButtonIdleColor!,
              onPressed: () {
                count++;
              },
            ),
          ),
        ),
      ),
    );

    final button = find.byType(IconButton);
    expect(button, findsOneWidget);
    expect(find.byType(StreamSvgIcon), findsOneWidget);
    await tester.tap(button);
    expect(count, 1);
  });

  testGoldens('golden test for AttachmentButton', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AttachmentButton(
              color: StreamChatThemeData.light()
                  .messageInputTheme
                  .actionButtonIdleColor!,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'attachment_button_0');
  });
}
