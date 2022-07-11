import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('KeyboardShortcutRunner onEnterKeypress works', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: KeyboardShortcutRunner(
              onEnterKeypress: () {
                count++;
              },
              onEscapeKeypress: () {},
              child: const TextField(),
            ),
          ),
        ),
      ),
    );

    final textField = find.byType(TextField);
    await tester.tap(textField);
    await tester.enterText(textField, 'Test');
    await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(count, 1);
  });

  testWidgets('KeyboardShortcutRunner onEscapeKeypress works', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: KeyboardShortcutRunner(
              onEnterKeypress: () {},
              onEscapeKeypress: controller.clear,
              child: TextField(
                controller: controller,
              ),
            ),
          ),
        ),
      ),
    );

    final textField = find.byType(TextField);
    await tester.tap(textField);
    await tester.enterText(textField, 'Test');
    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(controller.text, '');
  });
}
