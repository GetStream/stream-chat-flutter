import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

// Returns sentinels that no hardcoded English label could produce, so the
// assertions prove the row label was composed through
// `translations.accessibility` rather than matching an inlined string.
class _FakeAccessibilityTranslations extends DefaultAccessibilityTranslations {
  const _FakeAccessibilityTranslations();

  @override
  String outgoingMessageLabel({required String body}) => 'OUT:$body';

  @override
  String incomingMessageLabel({required String senderName, required String body}) => 'IN:$senderName:$body';

  @override
  String outgoingDeletedMessageLabel({required String body}) => 'OUT-DEL:$body';

  @override
  String incomingDeletedMessageLabel({required String senderName, required String body}) => 'IN-DEL:$senderName:$body';

  @override
  String formatRecentDateTime(DateTime date) => 'AT-TIME';
}

class _FakeLocalizations implements StreamChatLocalizations {
  @override
  AccessibilityTranslations get accessibility => const _FakeAccessibilityTranslations();

  @override
  String threadReplyCountText(int count) => count == 1 ? 'singular:$count' : 'plural:$count';

  // Strings the row composes verbatim; only the labels under test are faked.
  @override
  String get messageDeletedLabel => DefaultTranslations.instance.messageDeletedLabel;

  @override
  String get editedMessageLabel => 'EDITED';

  @override
  String photosAttachmentCountText(int count) => DefaultTranslations.instance.photosAttachmentCountText(count);

  @override
  String attachmentsUploadProgressText({required int completed, required int total}) => 'UP:$completed/$total';

  // Anything else throws instead of resolving to null, so an unstubbed lookup
  // fails the test loudly rather than rendering an empty label.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeLocalizationsDelegate extends LocalizationsDelegate<StreamChatLocalizations> {
  const _FakeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<StreamChatLocalizations> load(Locale locale) async => _FakeLocalizations();

  @override
  bool shouldReload(_FakeLocalizationsDelegate old) => false;
}

// A deterministic attachment renderer, so an attachment-only message lays out
// without loading assets. Renders no semantics of its own, keeping the
// assertions about the row label unambiguous.
class _FixedSizeAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  const _FixedSizeAttachmentBuilder();

  @override
  bool canHandle(Message message, Map<String, List<Attachment>> attachments) {
    return attachments.isNotEmpty;
  }

  @override
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    return const SizedBox(width: 200, height: 50);
  }
}

void main() {
  group('StreamMessageItem sender and direction announcement', () {
    // A language is what makes a translated message resolve to the reader's
    // own language, in the bubble and in the announcement alike.
    final currentUser = OwnUser(id: 'current-user', name: 'Luke Skywalker', language: 'en');
    final otherUser = User(id: 'other-user', name: 'Han Solo');

    Widget buildScene(
      Message message, {
      String? semanticsLabel,
      OwnUser? reader,
      bool signedIn = true,
      StreamMessageAlignment alignment = StreamMessageAlignment.start,
      // Set to false to resolve the shipped English strings instead of the
      // sentinels, pinning what a user actually hears.
      bool fakeTranslations = true,
    }) {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      final effectiveReader = switch (signedIn) {
        true => reader ?? currentUser,
        false => null,
      };
      when(() => clientState.currentUser).thenReturn(effectiveReader);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(effectiveReader));
      when(() => channel.client).thenReturn(client);
      when(() => channel.state).thenReturn(channelState);
      when(() => channelState.readStream).thenAnswer((_) => Stream.value(const []));

      return MaterialApp(
        localizationsDelegates: switch (fakeTranslations) {
          true => const [_FakeLocalizationsDelegate()],
          false => const <LocalizationsDelegate<Object>>[],
        },
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: StreamMessageLayout(
                data: StreamMessageLayoutData(alignment: alignment),
                child: StreamMessageItem(
                  message: message,
                  semanticsLabel: semanticsLabel,
                  attachmentBuilders: const [_FixedSizeAttachmentBuilder()],
                ),
              ),
            ),
          ),
        ),
      );
    }

    Message message({
      User? user,
      String? text = 'Are we still meeting tomorrow',
      int replyCount = 0,
      List<Attachment> attachments = const [],
      List<User> mentionedUsers = const [],
      MessageState state = MessageState.sent,
      DateTime? messageTextUpdatedAt,
      String type = MessageType.regular,
    }) {
      return Message(
        id: 'test-message',
        type: type,
        text: text,
        createdAt: DateTime(2026, 8, 26, 15),
        user: user ?? otherUser,
        state: state,
        replyCount: replyCount,
        attachments: attachments,
        mentionedUsers: mentionedUsers,
        messageTextUpdatedAt: messageTextUpdatedAt,
      );
    }

    // What a screen reader walking the row would read out, in order.
    List<String> labelsOf(WidgetTester tester) {
      return tester.semantics.simulatedAccessibilityTraversal().map((it) => it.label).toList();
    }

    testWidgets('own message announces the outgoing label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildScene(
          message(user: currentUser),
          alignment: StreamMessageAlignment.end,
        ),
      );
      await tester.pumpAndSettle();

      expect(labelsOf(tester), contains('OUT:Are we still meeting tomorrow, AT-TIME, Sent'));

      handle.dispose();
    });

    testWidgets('incoming message announces the sender name', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildScene(message()));
      await tester.pumpAndSettle();

      expect(labelsOf(tester), contains('IN:Han Solo:Are we still meeting tomorrow, AT-TIME'));

      handle.dispose();
    });

    testWidgets('announces the sender name exactly once', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildScene(message()));
      await tester.pumpAndSettle();

      // The footer renders the author name visually; announcing it there as
      // well would repeat what the row label already said.
      final withSenderName = labelsOf(tester).where((it) => it.contains('Han Solo'));
      expect(withSenderName, hasLength(1));

      handle.dispose();
    });

    testWidgets('does not announce the message text as a separate stop', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildScene(message()));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Are we still meeting tomorrow'), findsNothing);

      handle.dispose();
    });

    testWidgets('announces the edited marker as part of the row label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildScene(message(messageTextUpdatedAt: DateTime(2026, 8, 26, 16))));
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
        buildScene(
          message(
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

      await tester.pumpWidget(buildScene(translated));
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
        buildScene(
          message(text: 'hallo').copyWith(i18n: const {'en_text': 'hello', 'language': 'de'}),
          reader: OwnUser(id: 'current-user', name: 'Luke Skywalker'),
        ),
      );
      await tester.pumpAndSettle();

      expect(labelsOf(tester), contains('IN:Han Solo:hallo, AT-TIME'));

      handle.dispose();
    });

    testWidgets('announces mentions by display name, not by id', (tester) async {
      final handle = tester.ensureSemantics();

      final leia = User(id: 'leia-id', name: 'Leia Organa');
      await tester.pumpWidget(
        buildScene(message(text: 'Hey @leia-id', mentionedUsers: [leia])),
      );
      await tester.pumpAndSettle();

      expect(labelsOf(tester), contains('IN:Han Solo:Hey @Leia Organa, AT-TIME'));

      handle.dispose();
    });

    testWidgets('attachment-only message announces the attachment type label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildScene(
          message(
            text: null,
            attachments: [Attachment(type: AttachmentType.image, imageUrl: 'https://x.com/a.png')],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(labelsOf(tester), contains('IN:Han Solo:Photo, AT-TIME'));

      handle.dispose();
    });

    testWidgets('own deleted message announces that you deleted it', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildScene(
          message(
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
        buildScene(
          message(type: MessageType.deleted, state: MessageState.softDeleted),
        ),
      );
      await tester.pumpAndSettle();

      final labels = labelsOf(tester);
      expect(labels, contains('IN-DEL:Han Solo:Message deleted, AT-TIME'));
      expect(labels.where((it) => it.startsWith('IN:')), isEmpty);

      handle.dispose();
    });

    testWidgets('semanticsLabel replaces the composed label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildScene(message(), semanticsLabel: 'CUSTOM'));
      await tester.pumpAndSettle();

      final labels = labelsOf(tester);
      expect(labels, contains('CUSTOM'));
      expect(labels.where((it) => it.startsWith('IN:')), isEmpty);

      handle.dispose();
    });

    testWidgets('announces one labeled row per platform, in the shipped phrasing', (tester) async {
      final handle = tester.ensureSemantics();

      // Resolves the real strings rather than the sentinels, so this also pins
      // what a user actually hears — and it gives the desktop context menu the
      // action labels it builds itself.
      await tester.pumpWidget(buildScene(message(), fakeTranslations: false));
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
        buildScene(
          message(
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

    testWidgets('an empty semanticsLabel leaves the row unlabeled', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildScene(
          message(user: currentUser),
          semanticsLabel: '',
          alignment: StreamMessageAlignment.end,
        ),
      );
      await tester.pumpAndSettle();

      // An own message would otherwise have its delivery status appended to
      // nothing, announcing a bare ", Sent".
      expect(labelsOf(tester), isNot(contains(startsWith(','))));
      expect(labelsOf(tester).where((it) => it.contains('Sent')), isEmpty);

      handle.dispose();
    });

    testWidgets("does not take an authorless message for the reader's own", (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildScene(
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

    // Non-regression guards: these pass with and without the row label, and
    // exist to prove the label did not swallow the stops a screen-reader user
    // still needs to reach.
    testWidgets('keeps the thread replies row as its own stop', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildScene(message(replyCount: 3)));
      await tester.pumpAndSettle();

      expect(labelsOf(tester), contains('plural:3'));

      handle.dispose();
    });

    testWidgets('announces upload progress while attachments are sending', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildScene(
          message(
            user: currentUser,
            state: MessageState.sending,
            attachments: [
              Attachment(type: AttachmentType.image, imageUrl: 'https://x/1.png'),
              Attachment(
                type: AttachmentType.image,
                imageUrl: 'https://x/2.png',
                uploadState: const UploadState.success(),
              ),
            ],
          ),
          alignment: StreamMessageAlignment.end,
        ),
      );
      await tester.pumpAndSettle();

      // The footer shows the progress count rather than a tick, so the phrase
      // carries it too instead of flattening to "Sending".
      expect(labelsOf(tester).first, endsWith(', UP:1/2'));
      expect(labelsOf(tester).first, isNot(contains('Sending')));

      handle.dispose();
    });

    testWidgets('announces a message that failed to send', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildScene(
          message(user: currentUser, state: MessageState.sendingFailed(skipPush: false, skipEnrichUrl: false)),
          alignment: StreamMessageAlignment.end,
        ),
      );
      await tester.pumpAndSettle();

      // The failure is shown as a badge on the bubble, which is a bare icon
      // with no text, so the row phrase is the only place it can be heard.
      final failed = DefaultTranslations.instance.accessibility.messageFailedStatusLabel;
      expect(labelsOf(tester).first, endsWith(', $failed'));

      handle.dispose();
    });

    testWidgets('folds the sending status into the row label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildScene(
          message(user: currentUser),
          alignment: StreamMessageAlignment.end,
        ),
      );
      await tester.pumpAndSettle();

      final status = DefaultTranslations.instance.accessibility.messageSentStatusLabel;
      final labels = labelsOf(tester);

      // The status rides on the row phrase rather than costing a focus stop of
      // its own — an own text message is a single stop.
      expect(labels.single, endsWith(', $status'));

      handle.dispose();
    });
  });
}
