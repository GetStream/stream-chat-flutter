import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

final _currentUser = OwnUser(id: 'me', name: 'Luke Skywalker');
final _otherUser = User(id: 'han', name: 'Han Solo');

void main() {
  setUpAll(() => registerFallbackValue(Message()));

  testWidgets('playing a video opened from a message marks it played', (tester) async {
    final channel = _channel();
    final message = _videoMessage();
    await _openGallery(tester, channel, message);

    await _play(tester);

    verify(() => channel.markMessagePlayed(message)).called(1);
  });

  testWidgets('playing the second video of a message marks that message', (tester) async {
    final channel = _channel();
    final message = _videoMessage(videos: 2);
    await _openGallery(tester, channel, message);

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await _play(tester);

    verify(() => channel.markMessagePlayed(message)).called(1);
  });

  testWidgets('a gallery shown outside a message marks nothing', (tester) async {
    final channel = _channel();
    final message = _videoMessage();
    final gallery = StreamMediaGalleryPreview(
      attachments: message.toMediaGalleryAttachments(),
    );
    await tester.pumpWidget(_wrap(channel, gallery));
    await tester.pump();

    await _play(tester);

    verifyNever(() => channel.markMessagePlayed(any()));
  });

  testWidgets('a gallery reports the video that started playing', (tester) async {
    final message = _videoMessage();
    final started = <AttachmentPlaybackStartedDetails>[];
    final gallery = StreamMediaGalleryPreview(
      attachments: message.toMediaGalleryAttachments(),
      onPlaybackStarted: started.add,
    );
    await tester.pumpWidget(_wrap(_channel(), gallery));
    await tester.pump();

    await _play(tester);

    expect(started.single.message, message);
    expect(started.single.attachment, message.attachments.single);
  });
}

Future<void> _play(WidgetTester tester) async {
  await tester.tap(find.text('play'));
  await tester.pump();
}

// Shows [message] and opens its first video in the media gallery.
Future<void> _openGallery(WidgetTester tester, MockChannel channel, Message message) async {
  await tester.pumpWidget(_wrap(channel, StreamMessageItem(message: message)));
  await tester.pump();

  await tester.tap(find.byType(StreamVideoPlayIndicator).first);
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

Message _videoMessage({int videos = 1}) {
  return Message(
    id: 'video',
    createdAt: DateTime(2026, 11, 20, 9),
    user: _otherUser,
    state: MessageState.sent,
    attachments: [
      for (var i = 0; i < videos; i++)
        Attachment(
          type: AttachmentType.video,
          assetUrl: 'https://example.com/video-$i.mp4',
          uploadState: const UploadState.success(),
        ),
    ],
  );
}

MockChannel _channel() {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(_currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(_currentUser));
  when(() => channel.client).thenReturn(client);
  final channelState = MockChannelState();
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.memberCount).thenReturn(5);
  when(() => channelState.readStream).thenAnswer((_) => Stream.value(const []));
  when(() => channel.markMessagePlayed(any())).thenAnswer((_) async => true);
  return channel;
}

// Swaps the platform video player for a button that reports a play.
Widget _wrap(MockChannel channel, Widget body) {
  final builders = StreamComponentBuilders(
    extensions: streamChatComponentBuilders(
      videoPlayer: (context, props) => TextButton(
        onPressed: () => props.onPlaybackStarted?.call(PlaybackStartedDetails(attachment: props.attachment)),
        child: const Text('play'),
      ),
    ),
  );

  // StreamChat and the factory sit above the navigator so the gallery route
  // the message opens sees them too.
  return MaterialApp(
    builder: (context, child) => StreamChat(
      client: channel.client,
      connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
      child: StreamComponentFactory(builders: builders, child: child!),
    ),
    home: StreamChannel(
      channel: channel,
      child: Scaffold(
        body: StreamMessageLayout(
          data: const StreamMessageLayoutData(alignment: StreamMessageAlignment.start),
          child: body,
        ),
      ),
    ),
  );
}
