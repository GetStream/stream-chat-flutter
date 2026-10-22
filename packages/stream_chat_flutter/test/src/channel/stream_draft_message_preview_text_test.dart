import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  // Helper to pump the draft message preview widget
  Future<void> pumpDraftMessagePreview(
    WidgetTester tester,
    DraftMessage draftMessage, {
    TextStyle? textStyle,
    StreamChatConfigurationData? configData,
    StreamChatThemeData? themeData,
  }) async {
    final client = MockClient();
    final clientState = MockClientState();
    final currentUser = OwnUser(id: 'test-user-id', name: 'Test User');

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(currentUser);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StreamChat(
            client: client,
            configData: configData,
            themeData: themeData ?? StreamChatThemeData(),
            child: Center(
              child: StreamDraftMessagePreviewText(
                textStyle: textStyle,
                draftMessage: draftMessage,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('StreamDraftMessagePreviewText', () {
    testWidgets('renders draft message', (tester) async {
      final draftMessage = DraftMessage(
        text: 'This is a draft message',
      );

      await pumpDraftMessagePreview(tester, draftMessage);

      expect(find.text('Draft: This is a draft message'), findsOneWidget);
    });

    testWidgets('renders the draft label bold in the accent color', (tester) async {
      await pumpDraftMessagePreview(tester, DraftMessage(text: 'This is a draft message'));

      final accentPrimary = tester.element(find.byType(StreamDraftMessagePreviewText)).streamColorScheme.accentPrimary;
      final style = _draftLabelStyle(tester);
      expect(style?.color, accentPrimary);
      expect(style?.fontWeight, FontWeight.bold);
    });

    testWidgets('renders the draft label in the themed draft label style', (tester) async {
      await pumpDraftMessagePreview(
        tester,
        DraftMessage(text: 'This is a draft message'),
        themeData: StreamChatThemeData(
          messagePreviewTextTheme: const StreamMessagePreviewTextThemeData(
            draftLabelStyle: TextStyle(color: Colors.purple),
          ),
        ),
      );

      expect(_draftLabelStyle(tester)?.color, Colors.purple);
    });

    testWidgets('renders attachment icons in the text color', (tester) async {
      await pumpDraftMessagePreview(
        tester,
        DraftMessage(attachments: [Attachment(type: AttachmentType.image)]),
        textStyle: const TextStyle(color: Colors.teal),
      );

      final finder = find.descendant(of: find.byType(StreamDraftMessagePreviewText), matching: find.byType(Icon));
      final iconColor = tester.widget<Icon>(finder).color ?? IconTheme.of(tester.element(finder)).color;
      expect(iconColor, Colors.teal);
    });
  });

  group('Accessibility label (formatDraftMessageSemanticsLabel)', () {
    testWidgets('text draft — "Draft, {body}"', (tester) async {
      final handle = tester.ensureSemantics();
      final draftMessage = DraftMessage(text: 'Reply in progress');

      await pumpDraftMessagePreview(tester, draftMessage);

      expect(find.bySemanticsLabel('Draft\nReply in progress'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('attachment draft — "Draft, {type}, {caption}"', (tester) async {
      final handle = tester.ensureSemantics();
      final draftMessage = DraftMessage(
        text: 'Beach day',
        attachments: [Attachment(type: AttachmentType.image)],
      );

      await pumpDraftMessagePreview(tester, draftMessage);

      expect(find.bySemanticsLabel('Draft\nPhoto\nBeach day'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('multi-attachment draft — "Draft, {count} {type}, {caption}"', (tester) async {
      final handle = tester.ensureSemantics();
      final draftMessage = DraftMessage(
        text: 'Beach day',
        attachments: [
          Attachment(type: AttachmentType.image),
          Attachment(type: AttachmentType.image),
        ],
      );

      await pumpDraftMessagePreview(tester, draftMessage);

      expect(find.bySemanticsLabel('Draft\n2 photos\nBeach day'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('poll draft — "Draft, Poll, {name}"', (tester) async {
      final handle = tester.ensureSemantics();
      final draftMessage = DraftMessage(
        poll: Poll(id: 'p1', name: "What's for lunch?", options: const []),
      );

      await pumpDraftMessagePreview(tester, draftMessage);

      expect(find.bySemanticsLabel("Draft\nPoll\nWhat's for lunch?"), findsOneWidget);
      handle.dispose();
    });
  });

  group('Custom MessagePreviewFormatter', () {
    const customFormatter = _CustomMessagePreviewFormatter();

    testWidgets('can override getDraftPrefix', (tester) async {
      final draftMessage = DraftMessage(
        text: 'This is a draft message',
      );

      await pumpDraftMessagePreview(
        tester,
        draftMessage,
        configData: StreamChatConfigurationData(
          messagePreviewFormatter: customFormatter,
        ),
      );

      // Custom formatter uses "✏️" instead of "Draft:"
      expect(find.text('✏️ This is a draft message'), findsOneWidget);
      expect(find.text('Draft: This is a draft message'), findsNothing);
    });
  });
}

// The style the "Draft:" label paints with, after every ancestor span's style
// is applied.
TextStyle? _draftLabelStyle(WidgetTester tester) {
  final text = tester.widget<RichText>(
    find.descendant(of: find.byType(StreamDraftMessagePreviewText), matching: find.byType(RichText)),
  );

  TextStyle? result;
  void visit(InlineSpan span, TextStyle? inherited) {
    if (span is! TextSpan) return;
    final style = inherited?.merge(span.style) ?? span.style;
    if (span.text == 'Draft:') result = style;
    for (final child in span.children ?? const <InlineSpan>[]) {
      visit(child, style);
    }
  }

  visit(text.text, null);
  return result;
}

// Custom formatter for testing draft message overrides
class _CustomMessagePreviewFormatter extends StreamMessagePreviewFormatter {
  const _CustomMessagePreviewFormatter();

  @override
  String getDraftPrefix(BuildContext context) {
    return '✏️'; // Use "✏️" instead of "Draft:"
  }
}
