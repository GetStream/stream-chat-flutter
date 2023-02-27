import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/message_input/on_press_button.dart';

void main() {
  testWidgets('CommandButton onPressed works', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: OnPressButton.command(
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
    await tester.tap(button);
    expect(count, 1);
  });

  testGoldens('golden test for CommandButton', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: OnPressButton.command(
              color: Colors.red,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'command_button_0');
  });
}
