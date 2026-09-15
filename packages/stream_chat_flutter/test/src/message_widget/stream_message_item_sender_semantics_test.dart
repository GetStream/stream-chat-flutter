import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'message_semantics_scene.dart';

void main() {
  testWidgets('own message announces the outgoing label', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(user: currentUser),
        alignment: StreamMessageAlignment.end,
      ),
    );
    await tester.pumpAndSettle();

    expect(labelsOf(tester), contains('OUT:Are we still meeting tomorrow, AT-TIME, Sent'));

    handle.dispose();
  });

  testWidgets('incoming message announces the sender name', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(buildMessageScene(testMessage()));
    await tester.pumpAndSettle();

    expect(labelsOf(tester), contains('IN:Han Solo:Are we still meeting tomorrow, AT-TIME'));

    handle.dispose();
  });

  testWidgets('announces the sender name exactly once', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(buildMessageScene(testMessage()));
    await tester.pumpAndSettle();

    // The footer renders the author name visually; announcing it there as
    // well would repeat what the row label already said.
    final withSenderName = labelsOf(tester).where((it) => it.contains('Han Solo'));
    expect(withSenderName, hasLength(1));

    handle.dispose();
  });

  testWidgets('own deleted message announces that you deleted it', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(
          user: currentUser,
          type: MessageType.deleted,
          state: MessageState.softDeleted,
        ),
        alignment: StreamMessageAlignment.end,
      ),
    );
    await tester.pumpAndSettle();

    final labels = labelsOf(tester);
    // A deleted message keeps its footer, so the time and the delivery
    // status are on screen and belong in the announcement.
    expect(labels, contains('OUT-DEL:Message deleted, AT-TIME, Sent'));
    // The placeholder inside the bubble would otherwise repeat it.
    expect(labels.where((it) => it.contains('Message deleted')), hasLength(1));
    // A deleted message is not something the sender said.
    expect(labels.where((it) => it.startsWith('OUT:')), isEmpty);

    handle.dispose();
  });

  testWidgets('incoming deleted message announces who deleted it', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(type: MessageType.deleted, state: MessageState.softDeleted),
      ),
    );
    await tester.pumpAndSettle();

    final labels = labelsOf(tester);
    expect(labels, contains('IN-DEL:Han Solo:Message deleted, AT-TIME'));
    expect(labels.where((it) => it.startsWith('IN:')), isEmpty);

    handle.dispose();
  });

  testWidgets("does not take an authorless message for the reader's own", (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        Message(
          id: 'authorless-message',
          text: 'no one sent this',
          createdAt: DateTime(2026, 8, 26, 15),
          state: MessageState.sent,
        ),
        signedIn: false,
      ),
    );
    await tester.pumpAndSettle();

    // A null author and a null reader used to compare equal, so the row
    // claimed a delivery status for a message nobody sent.
    expect(labelsOf(tester).first, 'no one sent this, AT-TIME');

    handle.dispose();
  });

  testWidgets('announces one labeled row per platform, in the shipped phrasing', (tester) async {
    final handle = tester.ensureSemantics();

    // Resolves the real strings rather than the sentinels, so this also pins
    // what a user actually hears — and it gives the desktop context menu the
    // action labels it builds itself.
    await tester.pumpWidget(buildMessageScene(testMessage(), fakeTranslations: false));
    await tester.pumpAndSettle();

    // On mobile the label merges into the row's tappable node; on desktop and
    // web nothing inside the row contributes one, so the annotation forms
    // that node itself. Either way the row is announced exactly once.
    final announced = labelsOf(tester).where((it) => it.startsWith('Han Solo said, '));
    expect(announced, hasLength(1));
    expect(announced.single, startsWith('Han Solo said, Are we still meeting tomorrow, '));

    handle.dispose();
  }, variant: TargetPlatformVariant.all());

  testWidgets('composes the shipped English phrasing for a deleted message', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(
          user: currentUser,
          type: MessageType.deleted,
          state: MessageState.softDeleted,
        ),
        alignment: StreamMessageAlignment.end,
        fakeTranslations: false,
      ),
    );
    await tester.pumpAndSettle();

    final announced = labelsOf(tester).singleWhere((it) => it.contains('Message deleted'));
    expect(announced, startsWith('You, Message deleted, '));

    handle.dispose();
  });
}
