import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

ScheduledMessage fakeScheduledMessage({
  String text = 'Can you review the venue shortlist?',
  ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
  ScheduledMessageFailureReason? failureReason,
  List<Attachment> attachments = const [],
  String? parentId,
  Message? quotedMessage,
  String? quotedMessageId,
  ChannelModel? channel,
  DateTime? createdAt,
}) {
  return ScheduledMessage(
    cid: 'messaging:general',
    channel: channel ?? ChannelModel(cid: 'messaging:general', extraData: const {'name': 'General'}),
    user: User(id: 'current-user-id'),
    message: Message(
      id: 'scheduled-id',
      text: text,
      attachments: attachments,
      parentId: parentId,
      quotedMessageId: quotedMessageId ?? quotedMessage?.id,
      quotedMessage: quotedMessage,
    ),
    scheduledAt: DateTime(2026, 10, 21, 8),
    status: status,
    failureReason: failureReason,
    createdAt: createdAt,
  );
}

ScheduledMessage uploading() {
  return fakeScheduledMessage(
    text: '',
    status: ScheduledMessageStatus.preparingToSchedule,
    attachments: [
      Attachment(
        type: AttachmentType.image,
        imageUrl: 'https://example.com/a.jpg',
        uploadState: const UploadState.inProgress(uploaded: 1, total: 4),
      ),
    ],
  );
}

ScheduledMessage failed() {
  return fakeScheduledMessage(
    status: ScheduledMessageStatus.failed,
    failureReason: ScheduledMessageFailureReason.pendingNotSupported,
  );
}

Widget wrapWithMaterialApp(
  Widget widget, {
  Brightness brightness = Brightness.light,
  StreamChatThemeData? chatTheme,
  StreamComponentBuilders? componentBuilders,
  Map<String, Channel> channels = const {},
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final currentUser = OwnUser(id: 'current-user-id', name: 'Current User');

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.channels).thenReturn(channels);

  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: StreamChat(
      client: client,
      componentBuilders: componentBuilders,
      configData: StreamChatConfigurationData(),
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      themeData: chatTheme ?? StreamChatThemeData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: context.streamColorScheme.backgroundApp,
            body: Center(child: widget),
          );
        },
      ),
    ),
  );
}
