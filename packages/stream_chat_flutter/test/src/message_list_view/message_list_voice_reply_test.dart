import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  group('when a voice recording is sent as a reply', () {
    testWidgets('shows a lone recording directly on the bubble', (tester) async {
      final message = _reply(attachments: [_voiceRecording()]);

      await _pumpMessageList(tester, message);
      final fills = _containerFills(tester);

      expect(fills, [StreamColors.transparent]);
    });

    testWidgets('places a lone recording right below the quote', (tester) async {
      final message = _reply(attachments: [_voiceRecording()]);

      await _pumpMessageList(tester, message);

      final quote = tester.getRect(find.byType(StreamQuotedMessage));
      final recording = tester.getRect(find.byType(StreamVoiceRecordingAttachment));
      expect(recording.top, quote.bottom);
    });

    testWidgets('keeps the container fill when there is text', (tester) async {
      final message = _reply(text: 'Listen to this', attachments: [_voiceRecording()]);

      await _pumpMessageList(tester, message);
      final fills = _containerFills(tester);

      expect(fills, hasLength(1));
      expect(fills, everyElement(isNot(StreamColors.transparent)));
    });

    testWidgets('keeps the container fills of several recordings', (tester) async {
      final message = _reply(attachments: [_voiceRecording(), _voiceRecording()]);

      await _pumpMessageList(tester, message);
      final fills = _containerFills(tester);

      expect(fills, hasLength(2));
      expect(fills, everyElement(isNot(StreamColors.transparent)));
    });
  });

  testWidgets('keeps the gap below the quote of a poll sent with a recording as a reply', (tester) async {
    final message = _reply(attachments: [_voiceRecording()]).copyWith(
      poll: Poll(
        id: 'poll',
        name: 'Lunch?',
        options: const [
          PollOption(id: 'pizza', text: 'Pizza'),
          PollOption(id: 'sushi', text: 'Sushi'),
        ],
      ),
    );

    await _pumpMessageList(tester, message);

    final quote = tester.getRect(find.byType(StreamQuotedMessage));
    final poll = tester.getRect(find.byType(StreamPollAttachment));
    expect(poll.top, greaterThan(quote.bottom));
  });

  testWidgets('keeps the container fill of a file sent as a reply without text', (tester) async {
    final message = _reply(attachments: [_file()]);

    await _pumpMessageList(tester, message);
    final fills = _containerFills(tester);

    expect(fills, hasLength(1));
    expect(fills, everyElement(isNot(StreamColors.transparent)));
  });
}

Message _reply({String? text, required List<Attachment> attachments}) {
  final quotedMessage = Message(
    id: 'quoted',
    text: 'Can you send me a voice note?',
    createdAt: DateTime(2026, 8, 26, 14),
    user: User(id: 'jason', name: 'Jason Thompson'),
    state: MessageState.sent,
  );

  return Message(
    id: 'reply',
    text: text,
    createdAt: DateTime(2026, 8, 26, 15),
    user: User(id: 'maya', name: 'Maya Ross'),
    state: MessageState.sent,
    quotedMessageId: quotedMessage.id,
    quotedMessage: quotedMessage,
    attachments: attachments,
  );
}

Attachment _voiceRecording() => Attachment(
  type: AttachmentType.voiceRecording,
  title: 'voice_note.m4a',
  file: AttachmentFile(size: 10000, path: 'voice_recordings/voice_note.m4a'),
  extraData: {'duration': 12, 'waveform_data': List.filled(50, 0.5)},
);

Attachment _file() => Attachment(
  type: AttachmentType.file,
  title: 'bloom-and-harbor-cafe-menu.pdf',
  file: AttachmentFile(size: 4000000, path: 'files/menu.pdf'),
  uploadState: const UploadState.success(),
);

// Pumps a message list showing only [message].
Future<void> _pumpMessageList(WidgetTester tester, Message message) async {
  final currentUser = OwnUser(id: 'maya', name: 'Maya Ross');
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.threadsStream).thenAnswer((_) => const Stream.empty());
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([message]));
  when(() => channelState.messages).thenReturn([message]);
  when(() => channelState.isUpToDate).thenReturn(true);
  when(() => channelState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
  when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(0));
  when(() => channelState.unreadCount).thenReturn(0);
  when(() => channelState.readStream).thenAnswer((_) => const Stream.empty());
  when(() => channelState.read).thenReturn([]);
  when(() => channelState.membersStream).thenAnswer((_) => const Stream.empty());
  when(() => channelState.members).thenReturn([]);
  when(() => channelState.currentUserRead).thenReturn(null);
  when(() => channelState.currentUserReadStream).thenAnswer((_) => const Stream.empty());

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
        child: StreamChannel(
          channel: channel,
          child: const StreamMessageListView(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

// The background color of each attachment container on screen. The first
// Material under a container is the one painting its background.
List<Color?> _containerFills(WidgetTester tester) {
  return [
    for (final container in find.byType(StreamMessageAttachment).evaluate())
      tester
          .widget<Material>(find.descendant(of: find.byWidget(container.widget), matching: find.byType(Material)).first)
          .color,
  ];
}
