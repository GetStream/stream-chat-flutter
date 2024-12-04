import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/ai_assistant/streaming_message_view.dart';

void main() {
  group('StreamingMessageView Tests', () {
    testWidgets(
      'displays initial text',
      (WidgetTester tester) async {
        const testText = 'Hello, world!';

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StreamingMessageView(text: testText),
            ),
          ),
        );

        expect(find.text(testText), findsOneWidget);
      },
    );

    testWidgets(
      'updates text progressively like a typewriter',
      (WidgetTester tester) async {
        const testText = 'Hello, world!';
        const typingSpeed = Duration(milliseconds: 20);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StreamingMessageView(
                text: testText,
                typingSpeed: typingSpeed,
              ),
            ),
          ),
        );

        expect(find.text(testText), findsOneWidget);

        const updatedText = 'Hello, world! How are you?';
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: StreamingMessageView(
                text: updatedText,
                typingSpeed: typingSpeed,
              ),
            ),
          ),
        );

        await tester.pump(typingSpeed * updatedText.length);

        expect(find.text(updatedText), findsOneWidget);
      },
    );

    testWidgets(
      'handles links correctly',
      (WidgetTester tester) async {
        const testText = '[Click me](https://example.com)';
        const typingSpeed = Duration(milliseconds: 20);
        String? tappedLink;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StreamingMessageView(
                text: testText,
                typingSpeed: typingSpeed,
                onTapLink: (String link, String? href, String title) {
                  tappedLink = href;
                },
              ),
            ),
          ),
        );

        await tester.pump(typingSpeed * testText.length);

        final linkFinder = find.text('Click me');
        expect(linkFinder, findsOneWidget);
        await tester.tap(linkFinder);

        expect(tappedLink, equals('https://example.com'));
      },
    );
  });
}
