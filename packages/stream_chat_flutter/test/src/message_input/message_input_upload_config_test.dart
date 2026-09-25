import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  const appSettings = AppSettings(
    fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
    imageUploadConfig: UploadConfig(allowedFileExtensions: ['.png']),
  );

  testWidgets(
    'StreamMessageInput opens the attachment picker with the upload config',
    (tester) async {
      _useFakeRecordPlatform();

      await tester.pumpWidget(
        _buildMessageInput(
          const StreamMessageInput(attachmentLimit: 5),
          appSettings: appSettings,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AttachmentButton));
      await tester.pumpAndSettle();

      final validator = _pickerValidator(tester);
      expect(validator.fileUploadConfig, appSettings.fileUploadConfig);
      expect(validator.imageUploadConfig, appSettings.imageUploadConfig);
    },
  );

  testWidgets(
    'StreamMessageInput limits the attachment picker to attachmentLimit',
    (tester) async {
      _useFakeRecordPlatform();

      await tester.pumpWidget(
        _buildMessageInput(const StreamMessageInput(attachmentLimit: 5)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AttachmentButton));
      await tester.pumpAndSettle();

      expect(_pickerValidator(tester).maxAttachmentCount, 5);
    },
  );

  testWidgets(
    'StreamMessageInput does not limit the attachment picker below the '
    'attachments already added',
    (tester) async {
      _useFakeRecordPlatform();
      final messageInputController = StreamMessageInputController(
        message: Message(
          attachments: [
            for (var i = 0; i < 3; i++)
              Attachment(
                type: AttachmentType.file,
                title: 'file-$i.pdf',
                uploadState: const UploadState.success(),
              ),
          ],
        ),
      );
      addTearDown(messageInputController.dispose);

      await tester.pumpWidget(
        _buildMessageInput(
          StreamMessageInput(
            messageInputController: messageInputController,
            attachmentLimit: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(AttachmentButton));
      await tester.pumpAndSettle();

      expect(_pickerValidator(tester).maxAttachmentCount, 3);
    },
  );

  testWidgets(
    'StreamMessageInput reports dropping more files than attachmentLimit '
    'to onAttachmentLimitExceed',
    (tester) async {
      _useFakeRecordPlatform();
      final messageInputController = StreamMessageInputController();
      addTearDown(messageInputController.dispose);

      int? exceededLimit;
      await tester.pumpWidget(
        _buildMessageInput(
          StreamMessageInput(
            messageInputController: messageInputController,
            attachmentLimit: 1,
            onAttachmentLimitExceed: (limit, _) => exceededLimit = limit,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _dropFiles(tester, ['a.pdf', 'b.pdf']);

      expect(exceededLimit, 1);
    },
  );

  testWidgets(
    'StreamMessageInput adds none of the dropped files when they exceed '
    'attachmentLimit',
    (tester) async {
      _useFakeRecordPlatform();
      final messageInputController = StreamMessageInputController();
      addTearDown(messageInputController.dispose);

      await tester.pumpWidget(
        _buildMessageInput(
          StreamMessageInput(
            messageInputController: messageInputController,
            attachmentLimit: 1,
            onAttachmentLimitExceed: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _dropFiles(tester, ['a.pdf', 'b.pdf']);

      expect(messageInputController.attachments, isEmpty);
    },
  );

  testWidgets(
    'StreamMessageInput reports a dropped file blocked by the upload config '
    'to onError',
    (tester) async {
      _useFakeRecordPlatform();
      final messageInputController = StreamMessageInputController();
      addTearDown(messageInputController.dispose);

      Object? error;
      await tester.pumpWidget(
        _buildMessageInput(
          StreamMessageInput(
            messageInputController: messageInputController,
            onError: (e, _) => error = e,
          ),
          appSettings: appSettings,
        ),
      );
      await tester.pumpAndSettle();

      await _dropFiles(tester, ['setup.exe']);

      expect(
        error,
        const AttachmentBlockedError(
          fileExtension: 'exe',
          mimeType: 'application/x-msdownload',
        ),
      );
    },
  );

  testWidgets(
    'StreamMessageInput shows the unsupported file type error when onError '
    'is not set',
    (tester) async {
      _useFakeRecordPlatform();
      final app = _buildMessageInput(
        const StreamMessageInput(),
        appSettings: appSettings,
      );

      // Mount StreamChat above the navigator, so the error sheet can use it.
      final streamChat = app.home! as StreamChat;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: streamChat.client,
            child: child,
          ),
          home: streamChat.child,
        ),
      );
      await tester.pumpAndSettle();

      await _dropFiles(tester, ['setup.exe']);

      expect(
        find.text("'.exe' files are not supported for upload."),
        findsOneWidget,
      );
    },
  );
}

void _useFakeRecordPlatform() {
  final original = RecordPlatform.instance;
  RecordPlatform.instance = FakeRecordPlatform();
  addTearDown(() => RecordPlatform.instance = original);
}

StreamAttachmentValidator _pickerValidator(WidgetTester tester) {
  final picker =
      tester.widget<StreamPlatformAttachmentPickerBottomSheetBuilder>(
    find.byType(StreamPlatformAttachmentPickerBottomSheetBuilder),
  );

  return picker.validator!;
}

Future<void> _dropFiles(WidgetTester tester, List<String> names) async {
  final files = [
    for (final name in names)
      DropItemFile.fromData(
        Uint8List.fromList([1, 2, 3]),
        name: name,
        path: '/tmp/$name',
      ),
  ];

  final dropTarget = tester.widget<DropTarget>(find.byType(DropTarget));
  dropTarget.onDragDone?.call(
    DropDoneDetails(
      files: files,
      localPosition: Offset.zero,
      globalPosition: Offset.zero,
    ),
  );
  await tester.pumpAndSettle();
}

MaterialApp _buildMessageInput(
  StreamMessageInput input, {
  AppSettings appSettings = const AppSettings(),
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => client.appSettings).thenReturn(appSettings);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
  when(() => channel.lastMessageAt).thenReturn(DateTime(2020, 6, 22, 12));
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.client).thenReturn(client);
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channel.isMuted).thenReturn(false);
  when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));
  when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({}));
  when(() => channel.extraData).thenReturn({});
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.members).thenReturn([]);
  when(() => channelState.messages).thenReturn([]);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));

  return MaterialApp(
    home: StreamChat(
      client: client,
      child: StreamChannel(
        channel: channel,
        child: Scaffold(body: input),
      ),
    ),
  );
}
