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

    test('clear resets text, selectedChatOption, and attachments', () {
      final controller = AiComposerController(initialText: 'some text')
        ..selectChatOption(const ChatOption(id: 'a', text: 'Option A'))
        ..addAttachments([XFile('a.png')])
        ..clear();
      expect(controller.text, isEmpty);
      expect(controller.selectedChatOption, isNull);
      expect(controller.attachments, isEmpty);
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

    test('addAttachments appends files and notifies listeners', () {
      final controller = AiComposerController();
      var notified = false;
      controller
        ..addListener(() => notified = true)
        ..addAttachments([XFile('a.png'), XFile('b.png')]);

      expect(notified, isTrue);
      expect(controller.attachments, hasLength(2));
      controller.dispose();
    });

    test('addAttachments makes hasContent true even with no text', () {
      final controller = AiComposerController();
      expect(controller.hasContent, isFalse);

      controller.addAttachments([XFile('a.png')]);

      expect(controller.hasContent, isTrue);
      expect(controller.hasText, isFalse);
      controller.dispose();
    });

    test('removeAttachment removes a single file and notifies listeners', () {
      final fileA = XFile('a.png');
      final fileB = XFile('b.png');
      final controller = AiComposerController()..addAttachments([fileA, fileB]);
      var notified = false;
      controller
        ..addListener(() => notified = true)
        ..removeAttachment(fileA);

      expect(notified, isTrue);
      expect(controller.attachments, equals([fileB]));
      controller.dispose();
    });
  });

  group('StreamAIComposer', () {
    testWidgets('renders hint text in empty text field', (tester) async {
      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            hintText: 'Ask anything…',
            onSendPressed: (_, __, ___) {},
          ),
        ),
      );
      expect(find.text('Ask anything…'), findsOneWidget);
    });

    testWidgets('displays send button when text is not empty', (tester) async {
      final controller = AiComposerController(initialText: 'Hello');
      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            controller: controller,
            onSendPressed: (_, __, ___) {},
          ),
        ),
      );
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
      controller.dispose();
    });

    testWidgets('displays stop button when isGenerating is true', (tester) async {
      final controller = AiComposerController()..isGenerating = true;
      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            controller: controller,
            onSendPressed: (_, __, ___) {},
            onStopPressed: () {},
          ),
        ),
      );
      expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
      controller.dispose();
    });

    testWidgets('does not render a chip row even when chatOptions is non-empty', (tester) async {
      // Regression test: chat options used to render as an always-visible
      // chip row above the input. That row was removed in favor of listing
      // them inside `ComposerAttachmentSheet` (opened from the "+" button) —
      // see the "ComposerAttachmentSheet" group below.
      final controller = AiComposerController(
        chatOptions: [const ChatOption(id: '1', text: 'Summarize')],
      );
      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            controller: controller,
            onSendPressed: (_, __, ___) {},
          ),
        ),
      );
      expect(find.text('Summarize'), findsNothing);
      expect(find.byType(ActionChip), findsNothing);
      controller.dispose();
    });

    testWidgets('send callback receives text, selected option, and attachments', (tester) async {
      String? capturedText;
      ChatOption? capturedOption;
      List<XFile>? capturedAttachments;
      const option = ChatOption(id: 'summarize', text: 'Summarize');
      final controller = AiComposerController(chatOptions: [option])
        ..selectChatOption(option)
        ..addAttachments([XFile('a.png')]);

      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            controller: controller,
            onSendPressed: (text, selectedOption, attachments) {
              capturedText = text;
              capturedOption = selectedOption;
              capturedAttachments = attachments;
            },
          ),
        ),
      );

      // Type a message.
      await tester.enterText(find.byType(TextField), 'Hello AI');
      await tester.pump();

      // Tap send.
      await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
      await tester.pump();

      expect(capturedText, equals('Hello AI'));
      expect(capturedOption, equals(option));
      expect(capturedAttachments, hasLength(1));
      controller.dispose();
    });

    testWidgets('onStopPressed is called when stop button is tapped', (tester) async {
      var stopped = false;
      final controller = AiComposerController()..isGenerating = true;

      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            controller: controller,
            onSendPressed: (_, __, ___) {},
            onStopPressed: () => stopped = true,
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.stop_rounded));
      await tester.pump();
      expect(stopped, isTrue);
      controller.dispose();
    });

    testWidgets('trailing control shows mic when empty and speech is enabled', (tester) async {
      final controller = AiComposerController();
      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            controller: controller,
            enableSpeechToText: true,
            onSendPressed: (_, __, ___) {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.arrow_upward_rounded), findsNothing);
      controller.dispose();
    });

    testWidgets('trailing control morphs from mic to send once text is entered', (tester) async {
      final controller = AiComposerController();
      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            controller: controller,
            enableSpeechToText: true,
            onSendPressed: (_, __, ___) {},
          ),
        ),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Hi');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
      controller.dispose();
    });

    testWidgets('renders attachment thumbnails and removes them on tap', (tester) async {
      final controller = AiComposerController()..addAttachments([XFile('a.png')]);
      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            controller: controller,
            onSendPressed: (_, __, ___) {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.close), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(controller.attachments, isEmpty);
      controller.dispose();
    });

    testWidgets('default leading slot renders an attachment button', (tester) async {
      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            onSendPressed: (_, __, ___) {},
          ),
        ),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('does not reserve a spacer for the absent trailing factory slot', (tester) async {
      // Regression test: `buildTrailing` defaults to `null` (no widget), and
      // the composer must only insert its 8px gap next to a slot that
      // actually renders something. Previously this was decided by comparing
      // the built widget against a `SizedBox.shrink()` sentinel, which is
      // *not* `identical`/`==` to another separately-constructed
      // `SizedBox.shrink()` in this Flutter version — so the gap was always
      // inserted, doubling the composer's right-hand margin.
      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(
            onSendPressed: (_, __, ___) {},
          ),
        ),
      );

      final gapSpacers = find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.width == 8 && widget.height == null,
      );
      expect(gapSpacers, findsOneWidget);
    });
  });

  group('ComposerAttachmentSheet', () {
    testWidgets('tapping "+" opens the sheet with chat options listed', (tester) async {
      const option = ChatOption(
        id: 'research',
        text: 'Deep research',
        description: 'Get a detailed report',
      );
      final controller = AiComposerController(chatOptions: [option]);

      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(controller: controller, onSendPressed: (_, __, ___) {}),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      // Not `pumpAndSettle` — the sheet shows an indeterminate
      // `CircularProgressIndicator` while its (unmocked, platform-channel-based)
      // photo permission/gallery check is in flight, which never "settles" on
      // its own. A bounded pump is enough to open the sheet; none of these
      // assertions depend on that photo section finishing loading.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Deep research'), findsOneWidget);
      expect(find.text('Get a detailed report'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('selecting a chat option updates the controller and closes the sheet', (tester) async {
      const option = ChatOption(id: 'research', text: 'Deep research');
      final controller = AiComposerController(chatOptions: [option]);

      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(controller: controller, onSendPressed: (_, __, ___) {}),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      // Not `pumpAndSettle` — the sheet shows an indeterminate
      // `CircularProgressIndicator` while its (unmocked, platform-channel-based)
      // photo permission/gallery check is in flight, which never "settles" on
      // its own. A bounded pump is enough to open the sheet; none of these
      // assertions depend on that photo section finishing loading.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Deep research'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(controller.selectedChatOption, equals(option));
      // The sheet's own option row is gone (it closed); the one remaining
      // "Deep research" is the composer's inline selected-option chip.
      expect(find.byType(ListTile), findsNothing);
      expect(find.text('Deep research'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('does not render a chat-options section when chatOptions is empty', (tester) async {
      final controller = AiComposerController();

      await tester.pumpWidget(
        _wrap(
          StreamAIComposer(controller: controller, onSendPressed: (_, __, ___) {}),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      // Not `pumpAndSettle` — the sheet shows an indeterminate
      // `CircularProgressIndicator` while its (unmocked, platform-channel-based)
      // photo permission/gallery check is in flight, which never "settles" on
      // its own. A bounded pump is enough to open the sheet; none of these
      // assertions depend on that photo section finishing loading.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ListTile), findsNothing);
      controller.dispose();
    });
  });
}
