import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/message_input/clear_input_item_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('ClearInputItemButton onPressed works', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: ClearInputItemButton(
                onTap: () {
                  count++;
                },
              ),
            ),
          ),
        ),
      ),
    );

    final button = find.byType(RawMaterialButton);
    expect(button, findsOneWidget);
    expect(find.byType(StreamSvgIcon), findsOneWidget);
    await tester.tap(button);
    expect(count, 1);
  });

  testGoldens('golden test for ClearInputItemButton', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: ClearInputItemButton(
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'clear_input_item_0');
  });
}
