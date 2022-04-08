import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/message_input/send_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('SendButton onPressed works', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SendButton(
              assetName: 'Icon_circle_up.svg',
              color: StreamChatThemeData.light()
                  .messageInputTheme
                  .sendButtonColor!,
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

  testGoldens('golden test for SendButton', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SendButton(
              assetName: 'Icon_circle_up.svg',
              color: StreamChatThemeData.light()
                  .messageInputTheme
                  .sendButtonColor!,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'send_button_0');
  });
}
