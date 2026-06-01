import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  // Stands up a composer with the given controller and a draft stream the
  // test can drive on demand.
  Future<void> pumpComposer(
    WidgetTester tester, {
    required StreamMessageComposerController composerController,
    required Stream<Draft?> draftStream,
    Draft? initialDraft,
  }) async {
    final client = MockClient();
    final clientState = MockClientState();
    final channel = MockChannel();
    final channelState = MockChannelState();

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
    when(() => channel.state).thenReturn(channelState);
    when(() => channel.client).thenReturn(client);
    when(channel.getRemainingCooldown).thenReturn(0);
    when(() => channel.lastMessageAt).thenReturn(DateTime.parse('2020-06-22 12:00:00'));
    when(() => channel.extraData).thenReturn({'name': 'test'});
    when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({'name': 'test'}));
    when(() => channelState.members).thenReturn([
      Member(
        userId: 'user-id',
        user: User(id: 'user-id'),
      ),
    ]);
    when(() => channelState.membersStream).thenAnswer(
      (_) => Stream.value([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]),
    );
    when(() => channelState.messages).thenReturn([]);
    when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
    when(() => channelState.draft).thenReturn(initialDraft);
    when(() => channelState.draftStream).thenAnswer((_) => draftStream);

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: StreamMessageComposer(messageComposerController: composerController),
            ),
          ),
        ),
      ),
    );

    // Let the post-frame callback fire and set up the draft stream listener
    // before the test starts emitting events.
    await tester.pumpAndSettle();
  }

  group('draft stream', () {
    testWidgets('initial null does not clobber pre-populated text', (tester) async {
      final composerController = StreamMessageComposerController()..text = 'hello';
      addTearDown(composerController.dispose);

      final draftStream = StreamController<Draft?>.broadcast();
      addTearDown(draftStream.close);

      await pumpComposer(
        tester,
        composerController: composerController,
        draftStream: draftStream.stream,
      );

      draftStream.add(null);
      await tester.pumpAndSettle();

      expect(composerController.text, 'hello');
    });

    testWidgets('initial null does not clobber pre-populated quoted message', (tester) async {
      final composerController = StreamMessageComposerController()
        ..quotedMessage = Message(
          id: 'q1',
          text: 'quoted',
          user: User(id: 'other-user'),
        );
      addTearDown(composerController.dispose);

      final draftStream = StreamController<Draft?>.broadcast();
      addTearDown(draftStream.close);

      await pumpComposer(
        tester,
        composerController: composerController,
        draftStream: draftStream.stream,
      );

      draftStream.add(null);
      await tester.pumpAndSettle();

      expect(composerController.message.quotedMessageId, 'q1');
      expect(composerController.message.quotedMessage?.text, 'quoted');
    });

    testWidgets('initial null does not clobber pre-populated attachments', (tester) async {
      final attachment = Attachment(
        type: 'voiceRecording',
        assetUrl: 'https://example.com/recording.m4a',
        uploadState: const UploadState.success(),
      );
      final composerController = StreamMessageComposerController()..addAttachment(attachment);
      addTearDown(composerController.dispose);

      final draftStream = StreamController<Draft?>.broadcast();
      addTearDown(draftStream.close);

      await pumpComposer(
        tester,
        composerController: composerController,
        draftStream: draftStream.stream,
      );

      draftStream.add(null);
      await tester.pumpAndSettle();

      expect(composerController.attachments, hasLength(1));
      expect(composerController.attachments.first.assetUrl, attachment.assetUrl);
    });

    testWidgets('non-null draft loads its content into the controller', (tester) async {
      final composerController = StreamMessageComposerController();
      addTearDown(composerController.dispose);

      final draftStream = StreamController<Draft?>.broadcast();
      addTearDown(draftStream.close);

      await pumpComposer(
        tester,
        composerController: composerController,
        draftStream: draftStream.stream,
      );

      final draft = Draft(
        channelCid: 'messaging:test',
        createdAt: DateTime(2026),
        message: DraftMessage(text: 'from server'),
      );
      draftStream.add(draft);
      await tester.pumpAndSettle();

      expect(composerController.text, 'from server');
    });

    testWidgets('non-null then null resets the controller', (tester) async {
      final composerController = StreamMessageComposerController();
      addTearDown(composerController.dispose);

      final draftStream = StreamController<Draft?>.broadcast();
      addTearDown(draftStream.close);

      await pumpComposer(
        tester,
        composerController: composerController,
        draftStream: draftStream.stream,
      );

      // First load a draft so _lastDraft is non-null.
      final draft = Draft(
        channelCid: 'messaging:test',
        createdAt: DateTime(2026),
        message: DraftMessage(text: 'from server'),
      );
      draftStream.add(draft);
      await tester.pumpAndSettle();
      expect(composerController.text, 'from server');

      // Then the draft is removed.
      draftStream.add(null);
      await tester.pumpAndSettle();

      expect(composerController.text, isEmpty);
    });
  });
}
