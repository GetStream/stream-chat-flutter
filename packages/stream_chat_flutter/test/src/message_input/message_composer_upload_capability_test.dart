import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

const _canUpload = [ChannelCapability.sendMessage, ChannelCapability.uploadFile];
const _cannotUpload = [ChannelCapability.sendMessage];

Future<void> _pumpComposer(
  WidgetTester tester, {
  required StreamMessageComposerController controller,
  List<ChannelCapability> ownCapabilities = _canUpload,
  bool initialized = true,
}) async {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(ownCapabilities: ownCapabilities);
  final channelState = MockChannelState();
  final member = Member(
    userId: 'user-id',
    user: User(id: 'user-id'),
  );

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
  when(() => client.appSettings).thenReturn(
    const AppSettings(
      name: 'test',
      fileUploadConfig: UploadConfig(),
      imageUploadConfig: UploadConfig(),
      autoTranslationEnabled: false,
      asyncUrlEnrichEnabled: false,
    ),
  );
  when(() => channel.state).thenReturn(initialized ? channelState : null);
  when(() => channel.client).thenReturn(client);
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channel.lastMessageAt).thenReturn(DateTime.parse('2020-06-22 12:00:00'));
  when(() => channel.extraData).thenReturn({'name': 'test'});
  when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({'name': 'test'}));
  when(() => channelState.members).thenReturn([member]);
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value([member]));
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

final _attachmentButton = find.descendant(
  of: find.byType(DefaultStreamMessageComposerLeading),
  matching: find.byType(StreamButton),
);

final _micButton = find.byKey(const ValueKey('microphone_key'));

Future<void> _dropFile(WidgetTester tester) async {
  tester.widget<DropTarget>(find.byType(DropTarget)).onDragDone!(
    DropDoneDetails(
      files: [DropItemFile.fromData(Uint8List(100), path: '/tmp/doc.pdf', name: 'doc.pdf')],
      localPosition: Offset.zero,
      globalPosition: Offset.zero,
    ),
  );
  await tester.pumpAndSettle();
}

ContentInsertionConfiguration? _keyboardConfig(WidgetTester tester) {
  return tester.widget<EditableText>(find.byType(EditableText)).contentInsertionConfiguration;
}

void main() {
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  late StreamMessageComposerController controller;
  setUp(() => controller = StreamMessageComposerController());
  tearDown(() => controller.dispose());

  group('StreamMessageComposer with the upload-file capability', () {
    testWidgets('offers every way to add an upload', (tester) async {
      await _pumpComposer(tester, controller: controller);

      expect(_attachmentButton, findsOneWidget);
      expect(_micButton, findsOneWidget);
      expect(_keyboardConfig(tester), isNotNull);

      await _dropFile(tester);
      expect(controller.attachments, hasLength(1));
    });
  });

  group('StreamMessageComposer without the upload-file capability', () {
    testWidgets('hides the attachment button', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: _cannotUpload);

      expect(_attachmentButton, findsNothing);
    });

    testWidgets('hides voice recording', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: _cannotUpload);

      expect(_micButton, findsNothing);
    });

    testWidgets('ignores dropped files', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: _cannotUpload);

      await _dropFile(tester);

      expect(controller.attachments, isEmpty);
    });

    testWidgets('does not accept keyboard images', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: _cannotUpload);

      expect(_keyboardConfig(tester), isNull);
    });
  });

  group('StreamMessageComposer on a channel that is not created yet', () {
    testWidgets('keeps uploads available, as there are no capabilities to check', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: const [], initialized: false);

      expect(_attachmentButton, findsOneWidget);
      expect(_micButton, findsOneWidget);
      expect(_keyboardConfig(tester), isNotNull);
    });
  });
}
