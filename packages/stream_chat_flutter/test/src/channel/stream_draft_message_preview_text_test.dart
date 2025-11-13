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
            streamChatConfigData: configData,
            streamChatThemeData: StreamChatThemeData.light(),
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

// Custom formatter for testing draft message overrides
class _CustomMessagePreviewFormatter extends StreamMessagePreviewFormatter {
  const _CustomMessagePreviewFormatter();

  @override
  String getDraftPrefix(BuildContext context) {
    return '✏️'; // Use "✏️" instead of "Draft:"
  }
}
