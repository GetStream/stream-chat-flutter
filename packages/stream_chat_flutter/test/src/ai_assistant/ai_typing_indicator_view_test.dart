import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/ai_assistant/ai_typing_indicator_view.dart';

void main() {
  group('AITypingIndicatorView', () {
    testWidgets('displays the provided text', (WidgetTester tester) async {
      const dotCount = 5;
      const testText = 'AI is thinking';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AITypingIndicatorView(
              text: testText,
              dotCount: dotCount,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200 * dotCount));

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('applies the provided textStyle', (WidgetTester tester) async {
      const dotCount = 5;
      const testText = 'AI is thinking';
      const textStyle = TextStyle(fontSize: 20, color: Colors.blue);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AITypingIndicatorView(
              text: testText,
              textStyle: textStyle,
              dotCount: dotCount,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200 * dotCount));

      final textWidget = tester.widget<Text>(find.text(testText));
      expect(textWidget.style?.fontSize, equals(20));
      expect(textWidget.style?.color, equals(Colors.blue));
    });
  });
}
