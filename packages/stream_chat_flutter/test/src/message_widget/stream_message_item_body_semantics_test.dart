import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'message_semantics_scene.dart';

void main() {
  testWidgets('does not announce the message text as a separate stop', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(buildMessageScene(testMessage()));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Are we still meeting tomorrow'), findsNothing);

    handle.dispose();
  });

  testWidgets('announces the rendered text rather than its markdown source', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(testMessage(text: 'check [our docs](https://getstream.io) now')),
    );
    await tester.pumpAndSettle();

    // The bubble renders "check our docs now"; announcing the source would
    // spell out the brackets and read the whole URL aloud.
    expect(labelsOf(tester), contains('IN:Han Solo:check our docs now, AT-TIME'));

    handle.dispose();
  });

  testWidgets('announces emphasized text without its markers', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(testMessage(text: 'that is **really** important')),
    );
    await tester.pumpAndSettle();

    expect(labelsOf(tester), contains('IN:Han Solo:that is really important, AT-TIME'));

    handle.dispose();
  });

  testWidgets('announces mentions by display name, not by id', (tester) async {
    final handle = tester.ensureSemantics();

    final leia = User(id: 'leia-id', name: 'Leia Organa');
    await tester.pumpWidget(
      buildMessageScene(testMessage(text: 'Hey @leia-id', mentionedUsers: [leia])),
    );
    await tester.pumpAndSettle();

    expect(labelsOf(tester), contains('IN:Han Solo:Hey @Leia Organa, AT-TIME'));

    handle.dispose();
  });

  testWidgets('attachment-only message announces the attachment type label', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(
          text: null,
          attachments: [Attachment(type: AttachmentType.image, imageUrl: 'https://x.com/a.png')],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(labelsOf(tester), contains('IN:Han Solo:Photo, AT-TIME'));

    handle.dispose();
  });

  testWidgets('announces the translation the bubble shows, and the original when toggled', (tester) async {
    final handle = tester.ensureSemantics();

    final translated = Message(
      id: 'translated-message',
      text: 'hallo',
      createdAt: DateTime(2026, 8, 26, 15),
      user: otherUser,
      state: MessageState.sent,
      i18n: const {'en_text': 'hello', 'language': 'de'},
    );

    await tester.pumpWidget(buildMessageScene(translated));
    await tester.pumpAndSettle();

    expect(labelsOf(tester), contains('IN:Han Solo:hello, AT-TIME'));

    // Toggling back to the original has to move the announcement with it,
    // or the phrase describes text that is no longer on screen.
    StreamMessageTranslations.toggleOriginalText(
      tester.element(find.byType(DefaultStreamMessageItem)),
      translated.id,
    );
    await tester.pumpAndSettle();

    expect(labelsOf(tester), contains('IN:Han Solo:hallo, AT-TIME'));

    handle.dispose();
  });

  testWidgets('announces the original text to a reader with no language set', (tester) async {
    final handle = tester.ensureSemantics();

    // The bubble does not translate for a reader with no language, so the
    // announcement must not either.
    await tester.pumpWidget(
      buildMessageScene(
        testMessage(text: 'hallo').copyWith(i18n: const {'en_text': 'hello', 'language': 'de'}),
        reader: OwnUser(id: 'current-user', name: 'Luke Skywalker'),
      ),
    );
    await tester.pumpAndSettle();

    expect(labelsOf(tester), contains('IN:Han Solo:hallo, AT-TIME'));

    handle.dispose();
  });

  testWidgets('announces the edited marker as part of the row label', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(buildMessageScene(testMessage(messageTextUpdatedAt: DateTime(2026, 8, 26, 16))));
    await tester.pumpAndSettle();

    expect(
      labelsOf(tester),
      contains('IN:Han Solo:Are we still meeting tomorrow, AT-TIME, EDITED'),
    );

    handle.dispose();
  });

  testWidgets('a deleted message shows and announces no edited marker', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      buildMessageScene(
        testMessage(
          user: currentUser,
          type: MessageType.deleted,
          state: MessageState.softDeleted,
          messageTextUpdatedAt: DateTime(2026, 8, 26, 16),
        ),
        alignment: StreamMessageAlignment.end,
      ),
    );
    await tester.pumpAndSettle();

    // There is no text left to have been edited, so the marker would
    // describe history the reader can no longer see.
    expect(find.text('EDITED'), findsNothing);
    expect(labelsOf(tester), isNot(contains(contains('EDITED'))));

    handle.dispose();
  });

  // Non-regression guard: this passes with and without the row label, and
  // exists to prove the label did not swallow a stop a screen-reader user
  // still needs to reach.
  testWidgets('keeps the thread replies row as its own stop', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(buildMessageScene(testMessage(replyCount: 3)));
    await tester.pumpAndSettle();

    expect(labelsOf(tester), contains('plural:3'));

    handle.dispose();
  });
}
