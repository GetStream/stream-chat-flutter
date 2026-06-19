import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_ai/stream_chat_flutter_ai.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('AiComposerController', () {
    test('hasContent is false when text is empty', () {
      final controller = AiComposerController();
      expect(controller.hasContent, isFalse);
      controller.dispose();
    });

    test('hasContent is true when text is non-empty', () {
      final controller = AiComposerController(initialText: 'hello');
      expect(controller.hasContent, isTrue);
      controller.dispose();
    });

    test('selectChatOption updates selectedChatOption', () {
      final controller = AiComposerController();
      const option = ChatOption(id: 'a', text: 'Option A');
      controller.selectChatOption(option);
      expect(controller.selectedChatOption, equals(option));
      controller.dispose();
    });

    test('clearSelectedChatOption removes the selection', () {
      final controller = AiComposerController()
        ..selectChatOption(const ChatOption(id: 'a', text: 'Option A'))
        ..clearSelectedChatOption();
      expect(controller.selectedChatOption, isNull);
      controller.dispose();
    });

    test('clear resets text and selectedChatOption', () {
      final controller = AiComposerController(initialText: 'some text')
        ..selectChatOption(const ChatOption(id: 'a', text: 'Option A'))
        ..clear();
      expect(controller.text, isEmpty);
      expect(controller.selectedChatOption, isNull);
      controller.dispose();
    });

    test('isGenerating setter notifies listeners', () {
      final controller = AiComposerController();
      var notified = false;
      controller
        ..addListener(() => notified = true)
        ..isGenerating = true;
      expect(notified, isTrue);
      expect(controller.isGenerating, isTrue);
      controller.dispose();
    });
  });

  group('StreamAIComposer', () {
    testWidgets('renders hint text in empty text field', (tester) async {
      await tester.pumpWidget(_wrap(
        StreamAIComposer(
          hintText: 'Ask anything…',
          onSendPressed: (_, __) {},
        ),
      ));
      expect(find.text('Ask anything…'), findsOneWidget);
    });

    testWidgets('displays send button when text is not empty', (tester) async {
      final controller = AiComposerController(initialText: 'Hello');
      await tester.pumpWidget(_wrap(
        StreamAIComposer(
          controller: controller,
          onSendPressed: (_, __) {},
        ),
      ));
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
      controller.dispose();
    });

    testWidgets('displays stop button when isGenerating is true', (tester) async {
      final controller = AiComposerController()..isGenerating = true;
      await tester.pumpWidget(_wrap(
        StreamAIComposer(
          controller: controller,
          onSendPressed: (_, __) {},
          onStopPressed: () {},
        ),
      ));
      expect(find.byIcon(Icons.stop_circle_outlined), findsOneWidget);
      controller.dispose();
    });

    testWidgets('shows chat option chips when chatOptions is non-empty', (tester) async {
      final controller = AiComposerController(
        chatOptions: [
          const ChatOption(id: '1', text: 'Summarize'),
          const ChatOption(id: '2', text: 'Write an email'),
        ],
      );
      await tester.pumpWidget(_wrap(
        StreamAIComposer(
          controller: controller,
          onSendPressed: (_, __) {},
        ),
      ));
      expect(find.text('Summarize'), findsOneWidget);
      expect(find.text('Write an email'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('tapping a chip selects the option and hides the chip row', (tester) async {
      final controller = AiComposerController(
        chatOptions: [const ChatOption(id: '1', text: 'Summarize')],
      );
      await tester.pumpWidget(_wrap(
        StreamAIComposer(
          controller: controller,
          onSendPressed: (_, __) {},
        ),
      ));
      await tester.tap(find.text('Summarize'));
      await tester.pump();
      expect(controller.selectedChatOption?.id, equals('1'));
      // Chip row should no longer be visible (option is selected)
      expect(find.byType(ActionChip), findsNothing);
      controller.dispose();
    });

    testWidgets('send callback receives text and selected option', (tester) async {
      String? capturedText;
      ChatOption? capturedOption;
      const option = ChatOption(id: 'summarize', text: 'Summarize');
      final controller = AiComposerController(chatOptions: [option]);

      await tester.pumpWidget(_wrap(
        StreamAIComposer(
          controller: controller,
          onSendPressed: (text, selectedOption) {
            capturedText = text;
            capturedOption = selectedOption;
          },
        ),
      ));

      // Select an option.
      await tester.tap(find.text('Summarize'));
      await tester.pump();

      // Type a message.
      await tester.enterText(find.byType(TextField), 'Hello AI');
      await tester.pump();

      // Tap send.
      await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
      await tester.pump();

      expect(capturedText, equals('Hello AI'));
      expect(capturedOption, equals(option));
      controller.dispose();
    });

    testWidgets('onStopPressed is called when stop button is tapped', (tester) async {
      var stopped = false;
      final controller = AiComposerController()..isGenerating = true;

      await tester.pumpWidget(_wrap(
        StreamAIComposer(
          controller: controller,
          onSendPressed: (_, __) {},
          onStopPressed: () => stopped = true,
        ),
      ));
      await tester.tap(find.byIcon(Icons.stop_circle_outlined));
      await tester.pump();
      expect(stopped, isTrue);
      controller.dispose();
    });
  });
}
