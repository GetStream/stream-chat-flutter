import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show CustomSemanticsAction;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  final hanSolo = User(id: 'han-solo', name: 'Han Solo');

  // On mobile the message text renders non-selectable, letting the item's
  // MergeSemantics flatten the whole message into one node — the behavior
  // these tests assert. (On desktop/web the selectable text keeps its own
  // text-field node for selection support.)
  setUp(() => CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android);
  tearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

  Future<void> pumpItem(
    WidgetTester tester, {
    required Message message,
    StreamMessageAlignment alignment = StreamMessageAlignment.start,
    StreamChatConfigurationData? configData,
  }) async {
    final client = MockClient();
    final clientState = MockClientState();
    final currentUser = OwnUser(id: 'current-user', name: 'Current User');

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(currentUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          themeData: StreamChatThemeData(),
          configData: configData,
          child: StreamMessageLayout(
            data: StreamMessageLayoutData(alignment: alignment),
            child: Scaffold(
              // A generous maxWidth — the wide Ahem test font overflows the
              // deleted-message row at the default bubble width.
              body: Center(child: StreamMessageItem(message: message, maxWidth: 500)),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('StreamMessageItem a11y', () {
    testWidgets('merges the whole item into a single message summary', (tester) async {
      final handle = tester.ensureSemantics();
      final message = Message(
        text: 'Are we still meeting tomorrow?',
        user: hanSolo,
        createdAt: DateTime.now(),
        replyCount: 3,
      );

      await pumpItem(tester, message: message);
      await tester.pumpAndSettle();

      // One swipe stop carries the sender prefix, the message text, the
      // thread replies count, and the footer's timestamp — in that order.
      final summary = tester.getSemantics(
        find.bySemanticsLabel(
          RegExp(
            'Han Solo said.*Are we still meeting tomorrow.*3 replies.*Just now',
            dotAll: true,
          ),
        ),
      );

      // The sender name is announced once — the footer username is excluded.
      expect('Han Solo'.allMatches(summary.label).length, 1);

      handle.dispose();
    });

    testWidgets('exposes the message-options custom action on the summary', (tester) async {
      final handle = tester.ensureSemantics();
      final message = Message(text: 'Hello', user: hanSolo, createdAt: DateTime.now());

      await pumpItem(tester, message: message);
      await tester.pumpAndSettle();

      final summary = tester.getSemantics(find.bySemanticsLabel(RegExp('Han Solo said')));
      expect(
        summary,
        isSemantics(
          customActions: [const CustomSemanticsAction(label: 'Show message options')],
        ),
      );
      handle.dispose();
    });

    testWidgets('keeps interactive content operable by skipping the merge', (tester) async {
      final handle = tester.ensureSemantics();
      final message = Message(
        user: hanSolo,
        createdAt: DateTime.now(),
        attachments: [
          Attachment(
            type: AttachmentType.voiceRecording,
            assetUrl: 'https://example.com/x.m4a',
            uploadState: const UploadState.success(),
          ),
        ],
      );

      await pumpItem(
        tester,
        message: message,
        configData: StreamChatConfigurationData(
          // Stands in for the real voice player, whose controls must stay
          // individually reachable.
          attachmentBuilders: const [_PlayButtonAttachmentBuilder()],
        ),
      );

      // Both controls remain independently operable nodes instead of being
      // flattened into the message summary.
      final play = tester.getSemantics(find.bySemanticsLabel('PLAY-SENTINEL'));
      final speed = tester.getSemantics(find.bySemanticsLabel('SPEED-SENTINEL'));
      expect(play, isSemantics(isButton: true, hasTapAction: true));
      expect(speed, isSemantics(isButton: true, hasTapAction: true));
      expect(play.isMergedIntoParent, isFalse);
      expect(speed.isMergedIntoParent, isFalse);
      handle.dispose();
    });

    testWidgets('deleted message summary announces the sender', (tester) async {
      final handle = tester.ensureSemantics();
      final message = Message(type: MessageType.deleted, user: hanSolo, createdAt: DateTime.now());

      await pumpItem(tester, message: message);
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel(RegExp('Han Solo, message deleted.', dotAll: true)),
        findsOneWidget,
      );
      handle.dispose();
    });
  });
}

// Renders a voice-recording attachment with two tappable controls — like the
// real player's play and speed buttons — so the test can assert interactive
// controls survive outside the item merge.
class _PlayButtonAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  const _PlayButtonAttachmentBuilder();

  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) {
    return attachments.containsKey(AttachmentType.voiceRecording);
  }

  @override
  bool hasInteractiveControls(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    return true;
  }

  @override
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: 'PLAY-SENTINEL',
          child: GestureDetector(onTap: () {}, child: const SizedBox(width: 50, height: 50)),
        ),
        Semantics(
          button: true,
          label: 'SPEED-SENTINEL',
          child: GestureDetector(onTap: () {}, child: const SizedBox(width: 50, height: 50)),
        ),
      ],
    );
  }
}
