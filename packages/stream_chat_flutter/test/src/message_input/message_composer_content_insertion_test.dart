import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

AppSettings _appSettings({int imageSizeLimit = UploadConfig.defaultSizeLimit}) {
  return AppSettings(
    name: 'test',
    fileUploadConfig: const UploadConfig(),
    imageUploadConfig: UploadConfig(sizeLimit: imageSizeLimit),
    autoTranslationEnabled: false,
    asyncUrlEnrichEnabled: false,
  );
}

// A valid 1x1 GIF, so the attachment preview can decode it.
final _gifBytes = Uint8List.fromList([
  0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, //
  0xFF, 0xFF, 0xFF, 0x21, 0xF9, 0x04, 0x01, 0x00, 0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x00, //
  0x01, 0x00, 0x01, 0x00, 0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3B,
]);

KeyboardInsertedContent _content({
  String mimeType = 'image/gif',
  String uri = 'content://com.google.android.inputmethod.latin.fileprovider/cat.gif',
  bool hasData = true,
}) {
  return KeyboardInsertedContent(
    mimeType: mimeType,
    uri: uri,
    data: hasData ? _gifBytes : null,
  );
}

Future<void> _pumpComposer(
  WidgetTester tester, {
  required StreamMessageComposerController controller,
  AppSettings? appSettings,
  bool disableAttachments = false,
  List<AttachmentPickerType> allowedAttachmentPickerTypes = AttachmentPickerType.values,
  List<ChannelCapability> ownCapabilities = const [ChannelCapability.sendMessage, ChannelCapability.uploadFile],
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
  when(() => client.appSettings).thenReturn(appSettings ?? _appSettings());
  when(() => channel.state).thenReturn(channelState);
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
              disableAttachments: disableAttachments,
              allowedAttachmentPickerTypes: allowedAttachmentPickerTypes,
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

EditableText _editableText(WidgetTester tester) => tester.widget<EditableText>(find.byType(EditableText));

void _insert(WidgetTester tester, KeyboardInsertedContent content) {
  tester.state<EditableTextState>(find.byType(EditableText)).insertContent(content);
}

void main() {
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  late StreamMessageComposerController controller;
  setUp(() => controller = StreamMessageComposerController());
  tearDown(() => controller.dispose());

  group('StreamMessageComposer keyboard content insertion', () {
    testWidgets('accepts the default image MIME types, including GIFs', (tester) async {
      await _pumpComposer(tester, controller: controller);

      final config = _editableText(tester).contentInsertionConfiguration;
      expect(config, isNotNull);
      expect(config!.allowedMimeTypes, containsAll(['image/gif', 'image/png', 'image/jpeg', 'image/webp']));
    });

    testWidgets('adds an inserted GIF as an image attachment', (tester) async {
      await _pumpComposer(tester, controller: controller);

      _insert(tester, _content());
      await tester.pumpAndSettle();

      final attachment = controller.attachments.single;
      expect(attachment.type, AttachmentType.image);
      expect(attachment.file?.name, 'cat.gif');
      expect(attachment.file?.size, _gifBytes.length);
      expect(attachment.extraData['mime_type'], 'image/gif');
    });

    testWidgets('names the file from the MIME type when the URI has no extension', (tester) async {
      await _pumpComposer(tester, controller: controller);

      _insert(tester, _content(mimeType: 'image/webp', uri: 'content://keyboard/images/42'));
      await tester.pumpAndSettle();

      final attachment = controller.attachments.single;
      expect(attachment.file?.name, endsWith('.webp'));
      expect(attachment.extraData['mime_type'], 'image/webp');
    });

    testWidgets('ignores content the keyboard handed over without data', (tester) async {
      await _pumpComposer(tester, controller: controller);

      _insert(tester, _content(hasData: false));
      await tester.pumpAndSettle();

      expect(controller.attachments, isEmpty);
    });

    testWidgets('ignores content the keyboard handed over as empty data', (tester) async {
      await _pumpComposer(tester, controller: controller);

      _insert(
        tester,
        KeyboardInsertedContent(mimeType: 'image/gif', uri: 'content://keyboard/cat.gif', data: Uint8List(0)),
      );
      await tester.pumpAndSettle();

      expect(controller.attachments, isEmpty);
    });

    testWidgets('rejects an image over the upload size limit, like the picker does', (tester) async {
      await _pumpComposer(tester, controller: controller, appSettings: _appSettings(imageSizeLimit: 10));

      _insert(tester, _content());
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(controller.attachments, isEmpty);
    });

    testWidgets('is off when attachments are disabled', (tester) async {
      await _pumpComposer(tester, controller: controller, disableAttachments: true);

      expect(_editableText(tester).contentInsertionConfiguration, isNull);
    });

    testWidgets('is off when images are not an allowed picker type', (tester) async {
      await _pumpComposer(
        tester,
        controller: controller,
        allowedAttachmentPickerTypes: [AttachmentPickerType.files],
      );

      expect(_editableText(tester).contentInsertionConfiguration, isNull);
    });

    testWidgets('is off while a command is active', (tester) async {
      await _pumpComposer(tester, controller: controller);

      controller.setCommand(Command(name: 'giphy'));
      await tester.pumpAndSettle();

      expect(_editableText(tester).contentInsertionConfiguration, isNull);
    });

    testWidgets('is off when the user cannot upload files', (tester) async {
      await _pumpComposer(
        tester,
        controller: controller,
        ownCapabilities: [ChannelCapability.sendMessage],
      );

      expect(_editableText(tester).contentInsertionConfiguration, isNull);
    });

    testWidgets('names the file from the MIME type when the URI extension disagrees', (tester) async {
      await _pumpComposer(tester, controller: controller);

      _insert(tester, _content(uri: 'content://keyboard/cache/1695812.0'));
      await tester.pumpAndSettle();

      final attachment = controller.attachments.single;
      expect(attachment.file?.name, endsWith('.gif'));
      expect(attachment.extraData['mime_type'], 'image/gif');
    });
  });
}
