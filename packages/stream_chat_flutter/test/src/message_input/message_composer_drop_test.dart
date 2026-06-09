import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

// Minimal in-memory drop item — no filesystem access needed.
DropItemFile _dropFile({
  required String path,
  String? mimeType,
  int size = 100,
}) {
  return DropItemFile.fromData(
    Uint8List(size),
    path: path,
    mimeType: mimeType,
    name: path.split('/').last,
  );
}

AppSettings _makeAppSettings({
  List<String> blockedExtensions = const [],
  List<String> allowedExtensions = const [],
  int sizeLimit = UploadConfig.defaultSizeLimit,
}) {
  return AppSettings(
    name: 'test',
    fileUploadConfig: UploadConfig(
      blockedFileExtensions: blockedExtensions,
      allowedFileExtensions: allowedExtensions,
      sizeLimit: sizeLimit,
    ),
    imageUploadConfig: const UploadConfig(),
    autoTranslationEnabled: false,
    asyncUrlEnrichEnabled: false,
  );
}

Future<void> pumpComposerWithSettings(
  WidgetTester tester, {
  required AppSettings appSettings,
  StreamMessageComposerController? controller,
}) async {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
  when(() => client.appSettings).thenReturn(appSettings);
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
  when(() => channelState.draft).thenReturn(null);
  when(() => channelState.draftStream).thenAnswer((_) => Stream.value(null));

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        child: StreamChannel(
          channel: channel,
          child: Scaffold(
            body: StreamMessageComposer(
              messageComposerController: controller,
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  group('Fix 4 — DropTarget routes through appSettings validation', () {
    testWidgets('blocked extension → error dialog is shown, attachment not added', (tester) async {
      final composerController = StreamMessageComposerController();
      addTearDown(composerController.dispose);

      await pumpComposerWithSettings(
        tester,
        appSettings: _makeAppSettings(blockedExtensions: ['.exe']),
        controller: composerController,
      );

      final dropTarget = tester.widget<DropTarget>(find.byType(DropTarget));

      dropTarget.onDragDone!(
        DropDoneDetails(
          files: [_dropFile(path: '/tmp/virus.exe')],
          localPosition: Offset.zero,
          globalPosition: Offset.zero,
        ),
      );

      await tester.pumpAndSettle();

      // Error sheet must appear.
      expect(find.byType(BottomSheet), findsOneWidget);
      // Attachment must NOT have been added to the composer.
      expect(composerController.attachments, isEmpty);
    });

    testWidgets('file exceeding size limit → error dialog is shown, attachment not added', (tester) async {
      final composerController = StreamMessageComposerController();
      addTearDown(composerController.dispose);

      // Limit = 50 bytes; dropped file = 100 bytes.
      await pumpComposerWithSettings(
        tester,
        appSettings: _makeAppSettings(sizeLimit: 50),
        controller: composerController,
      );

      final dropTarget = tester.widget<DropTarget>(find.byType(DropTarget));

      dropTarget.onDragDone!(
        DropDoneDetails(
          files: [_dropFile(path: '/tmp/large.pdf', size: 100)],
          localPosition: Offset.zero,
          globalPosition: Offset.zero,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(composerController.attachments, isEmpty);
    });
  });
}
