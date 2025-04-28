import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/channel/stream_draft_message_preview_text.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';


void main() {
  // Helper to pump the draft message preview widget
  Future<void> pumpDraftMessagePreview(
    WidgetTester tester,
    DraftMessage draftMessage, {
    TextStyle? textStyle,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StreamChatTheme(
            data: StreamChatThemeData.light(),
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
  });
}
