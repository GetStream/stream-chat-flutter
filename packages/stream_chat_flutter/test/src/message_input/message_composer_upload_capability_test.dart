import 'dart:async';

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
const _cannotUploadButCanSendPoll = [ChannelCapability.sendMessage, ChannelCapability.sendPoll];
final _giphy = Command(name: 'giphy', args: '[text]');

void main() {
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  late StreamMessageComposerController controller;
  setUp(() => controller = StreamMessageComposerController());
  tearDown(() => controller.dispose());

  group('with the upload-file capability', () {
    testWidgets('shows the attachment button', (tester) async {
      await _pumpComposer(tester, controller: controller);

      expect(_attachmentButton, findsOneWidget);
    });

    testWidgets('shows voice recording', (tester) async {
      await _pumpComposer(tester, controller: controller);

      expect(_micButton, findsOneWidget);
    });

    testWidgets('accepts dropped files', (tester) async {
      await _pumpComposer(tester, controller: controller);

      await _dropFile(tester);

      expect(controller.attachments, hasLength(1));
    });

    testWidgets('accepts keyboard images', (tester) async {
      await _pumpComposer(tester, controller: controller);

      _insertImage(tester);
      await tester.pumpAndSettle();

      expect(controller.attachments, hasLength(1));
    });
  });

  group('without the upload-file capability', () {
    testWidgets('offers only the system picker options that upload nothing', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: _cannotUploadButCanSendPoll);

      expect(await _openSystemPicker(tester), {'poll-creator'});
    });

    testWidgets('offers only the tabbed picker tabs that upload nothing', (tester) async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

      await _pumpComposer(
        tester,
        controller: controller,
        ownCapabilities: _cannotUploadButCanSendPoll,
        commands: [_giphy],
        useSystemAttachmentPicker: false,
      );

      expect(await _openTabbedPicker(tester), {'poll-creator', 'command-picker'});
    });

    testWidgets('hides the attachment button when the channel has no polls or commands', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: _cannotUpload);

      expect(_attachmentButton, findsNothing);
    });

    testWidgets('hides the attachment button when every allowed option uploads', (tester) async {
      await _pumpComposer(
        tester,
        controller: controller,
        ownCapabilities: _cannotUpload,
        allowedAttachmentPickerTypes: const [AttachmentPickerType.images, AttachmentPickerType.files],
      );

      expect(_attachmentButton, findsNothing);
    });

    testWidgets('hides voice recording', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: _cannotUpload);

      expect(_micButton, findsNothing);
    });

    testWidgets('does not accept dropped files', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: _cannotUpload);

      expect(_acceptsDroppedFiles(tester), isFalse);
    });

    testWidgets('ignores keyboard images', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: _cannotUpload);

      _insertImage(tester);
      await tester.pumpAndSettle();

      expect(controller.attachments, isEmpty);
    });
  });

  group('on a channel that is not created yet', () {
    testWidgets('shows the attachment button', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: const [], initialized: false);

      expect(_attachmentButton, findsOneWidget);
    });

    testWidgets('shows voice recording', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: const [], initialized: false);

      expect(_micButton, findsOneWidget);
    });

    testWidgets('accepts keyboard images', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: const [], initialized: false);

      _insertImage(tester);
      await tester.pumpAndSettle();

      expect(controller.attachments, hasLength(1));
    });

    testWidgets('does not offer polls', (tester) async {
      await _pumpComposer(tester, controller: controller, ownCapabilities: const [], initialized: false);

      expect(await _openSystemPicker(tester), isNot(contains('poll-creator')));
    });
  });

  group('once the upload-file capability is granted', () {
    testWidgets('shows voice recording', (tester) async {
      final capabilities = StreamController<List<ChannelCapability>>.broadcast();
      addTearDown(capabilities.close);

      await _pumpComposer(
        tester,
        controller: controller,
        ownCapabilities: _cannotUpload,
        ownCapabilitiesStream: capabilities.stream,
      );
      capabilities.add(_canUpload);
      await tester.pumpAndSettle();

      expect(_micButton, findsOneWidget);
    });

    testWidgets('shows the attachment button', (tester) async {
      final capabilities = StreamController<List<ChannelCapability>>.broadcast();
      addTearDown(capabilities.close);

      await _pumpComposer(
        tester,
        controller: controller,
        ownCapabilities: _cannotUpload,
        ownCapabilitiesStream: capabilities.stream,
      );
      capabilities.add(_canUpload);
      await tester.pumpAndSettle();

      expect(_attachmentButton, findsOneWidget);
    });
  });

  group('once the upload-file capability is revoked', () {
    testWidgets('hides voice recording', (tester) async {
      final capabilities = StreamController<List<ChannelCapability>>.broadcast();
      addTearDown(capabilities.close);

      await _pumpComposer(tester, controller: controller, ownCapabilitiesStream: capabilities.stream);
      capabilities.add(_cannotUpload);
      await tester.pumpAndSettle();

      expect(_micButton, findsNothing);
    });

    testWidgets('hides the attachment button when nothing is left to offer', (tester) async {
      final capabilities = StreamController<List<ChannelCapability>>.broadcast();
      addTearDown(capabilities.close);

      await _pumpComposer(tester, controller: controller, ownCapabilitiesStream: capabilities.stream);
      capabilities.add(_cannotUpload);
      await tester.pumpAndSettle();

      expect(_attachmentButton, findsNothing);
    });

    testWidgets('ignores keyboard images', (tester) async {
      final capabilities = StreamController<List<ChannelCapability>>.broadcast();
      addTearDown(capabilities.close);

      await _pumpComposer(tester, controller: controller, ownCapabilitiesStream: capabilities.stream);
      capabilities.add(_cannotUpload);
      await tester.pumpAndSettle();

      _insertImage(tester);
      await tester.pumpAndSettle();

      expect(controller.attachments, isEmpty);
    });

    testWidgets('moves an open tabbed picker off a tab that uploads', (tester) async {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
      addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);
      final capabilities = StreamController<List<ChannelCapability>>.broadcast();
      addTearDown(capabilities.close);

      await _pumpComposer(
        tester,
        controller: controller,
        ownCapabilities: const [..._canUpload, ChannelCapability.sendPoll],
        ownCapabilitiesStream: capabilities.stream,
        useSystemAttachmentPicker: false,
        attachmentPickerOptionsBuilder: (context, defaultOptions) => [
          TabbedAttachmentPickerOption(
            key: 'upload-tab',
            icon: Icons.upload,
            supportedTypes: const [AttachmentPickerType.files],
            optionViewBuilder: (context, controller) => const Text('Upload tab'),
          ),
          ...defaultOptions.where((option) => option.key == 'poll-creator'),
        ],
      );
      await tester.tap(_attachmentButton);
      await tester.pumpAndSettle();
      expect(find.text('Upload tab'), findsOneWidget);

      capabilities.add(_cannotUploadButCanSendPoll);
      await tester.pumpAndSettle();

      expect(find.text('Upload tab'), findsNothing);
      expect(find.text('Create a poll and let everyone vote!'), findsOneWidget);
    });

    testWidgets('closes an open picker when nothing is left to offer', (tester) async {
      final capabilities = StreamController<List<ChannelCapability>>.broadcast();
      addTearDown(capabilities.close);

      await _pumpComposer(tester, controller: controller, ownCapabilitiesStream: capabilities.stream);
      await tester.tap(_attachmentButton);
      await tester.pumpAndSettle();
      capabilities.add(_cannotUpload);
      await tester.pumpAndSettle();
      capabilities.add(_canUpload);
      await tester.pumpAndSettle();

      expect(find.byType(StreamSystemAttachmentPicker), findsNothing);
    });
  });

  testWidgets('leaves out the command tab when the channel has no commands', (tester) async {
    CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;
    addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

    await _pumpComposer(
      tester,
      controller: controller,
      ownCapabilities: _cannotUploadButCanSendPoll,
      useSystemAttachmentPicker: false,
    );

    expect(await _openTabbedPicker(tester), {'poll-creator'});
  });

  testWidgets('hides polls and commands too when attachments are disabled', (tester) async {
    await _pumpComposer(
      tester,
      controller: controller,
      ownCapabilities: const [..._canUpload, ChannelCapability.sendPoll],
      commands: [_giphy],
      disableAttachments: true,
    );

    expect(_attachmentButton, findsNothing);
  });

  testWidgets('does not accept dropped files when files are not an allowed type', (tester) async {
    await _pumpComposer(
      tester,
      controller: controller,
      allowedAttachmentPickerTypes: const [AttachmentPickerType.images],
    );

    expect(_acceptsDroppedFiles(tester), isFalse);
  });

  testWidgets('does not accept dropped files when attachments are disabled', (tester) async {
    await _pumpComposer(tester, controller: controller, disableAttachments: true);

    expect(_acceptsDroppedFiles(tester), isFalse);
  });
}

Future<void> _pumpComposer(
  WidgetTester tester, {
  required StreamMessageComposerController controller,
  List<ChannelCapability> ownCapabilities = _canUpload,
  Stream<List<ChannelCapability>>? ownCapabilitiesStream,
  List<AttachmentPickerType> allowedAttachmentPickerTypes = AttachmentPickerType.values,
  List<Command> commands = const [],
  bool disableAttachments = false,
  bool useSystemAttachmentPicker = true,
  AttachmentPickerOptionsBuilder? attachmentPickerOptionsBuilder,
  bool initialized = true,
}) async {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = switch (ownCapabilitiesStream) {
    final stream? => _ChannelWithCapabilitiesStream(ownCapabilities: ownCapabilities, capabilitiesStream: stream),
    _ => MockChannel(ownCapabilities: ownCapabilities),
  };
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
  if (initialized) {
    when(() => channel.config).thenReturn(ChannelConfig(polls: true, commands: commands));
  } else {
    when(() => channel.config).thenThrow(StateError('Channel has not been initialized'));
  }
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channel.lastMessageAt).thenReturn(DateTime.parse('2020-06-22 12:00:00'));
  when(() => channel.custom).thenReturn({'name': 'test'});
  when(() => channel.customStream).thenAnswer((_) => Stream.value({'name': 'test'}));
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
              allowedAttachmentPickerTypes: allowedAttachmentPickerTypes,
              disableAttachments: disableAttachments,
              useSystemAttachmentPicker: useSystemAttachmentPicker,
              attachmentPickerOptionsBuilder: attachmentPickerOptionsBuilder,
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

bool _acceptsDroppedFiles(WidgetTester tester) => tester.widget<DropTarget>(find.byType(DropTarget)).enable;

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

Future<Set<String?>> _openSystemPicker(WidgetTester tester) async {
  await tester.tap(_attachmentButton);
  await tester.pumpAndSettle();

  final picker = tester.widget<StreamSystemAttachmentPicker>(find.byType(StreamSystemAttachmentPicker));
  return {...picker.options.map((it) => it.key)};
}

Future<Set<String?>> _openTabbedPicker(WidgetTester tester) async {
  await tester.tap(_attachmentButton);
  await tester.pumpAndSettle();

  final picker = tester.widget<StreamTabbedAttachmentPicker>(find.byType(StreamTabbedAttachmentPicker));
  return {...picker.options.map((it) => it.key)};
}

void _insertImage(WidgetTester tester) {
  tester
      .state<EditableTextState>(find.byType(EditableText))
      .insertContent(
        KeyboardInsertedContent(mimeType: 'image/gif', uri: 'content://keyboard/cat.gif', data: Uint8List(100)),
      );
}

class _ChannelWithCapabilitiesStream extends MockChannel {
  _ChannelWithCapabilitiesStream({
    super.ownCapabilities,
    required this.capabilitiesStream,
  });

  final Stream<List<ChannelCapability>> capabilitiesStream;

  @override
  Stream<List<ChannelCapability>> get ownCapabilitiesStream => capabilitiesStream;
}
