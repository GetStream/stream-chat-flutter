import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';

void main() {
  testWidgets('AttachmentButton onPressed works', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AttachmentButton(
              color: Colors.red,
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

  testWidgets('AttachmentButton should accept icon', (tester) async {
    const icon = Icon(Icons.attachment);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AttachmentButton(
              icon: icon,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.attachment), findsOneWidget);
  });

  testWidgets('AttachmentButton should accept color', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AttachmentButton(
              color: Colors.red,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    final buttonFinder = find.byType(AttachmentButton);
    expect(buttonFinder, findsOneWidget);

    final button = tester.widget<AttachmentButton>(buttonFinder);
    expect(button.color, Colors.red);
  });

  goldenTest(
    'golden test for AttachmentButton',
    fileName: 'attachment_button_0',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: Scaffold(
        body: Center(
          child: AttachmentButton(
            color: StreamChatThemeData.light()
                .messageInputTheme
                .actionButtonIdleColor,
            onPressed: () {},
          ),
        ),
      ),
    ),
  );
}
