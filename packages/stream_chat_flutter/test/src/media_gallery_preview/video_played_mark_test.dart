import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

final _currentUser = OwnUser(id: 'me', name: 'Luke Skywalker');
final _otherUser = User(id: 'han', name: 'Han Solo');

void main() {
  setUpAll(() => registerFallbackValue(Message()));

  testWidgets("playing another user's video marks it played", (tester) async {
    final channel = _channel();
    final message = _videoMessage(user: _otherUser);
    await tester.pumpWidget(_wrap(channel, _gallery(message)));
    await tester.pump();

    await _play(tester);

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(1);
  });

  testWidgets('playing a video again marks it played once', (tester) async {
    final channel = _channel();
    final message = _videoMessage(user: _otherUser);
    await tester.pumpWidget(_wrap(channel, _gallery(message)));
    await tester.pump();

    await _play(tester);
    await _play(tester);

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(1);
  });

  testWidgets('playing two videos of one message marks it played once', (tester) async {
    final channel = _channel();
    final message = _videoMessage(user: _otherUser, videos: 2);
    await tester.pumpWidget(_wrap(channel, _gallery(message)));
    await tester.pump();

    await _play(tester);
    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await _play(tester);

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(1);
  });

  testWidgets('playing a video again after a failed mark retries it', (tester) async {
    final channel = _channel();
    final message = _videoMessage(user: _otherUser);
    when(() => channel.sendMessageMark(any(), any())).thenAnswer((_) async => throw const StreamChatError('offline'));
    await tester.pumpWidget(_wrap(channel, _gallery(message)));
    await tester.pump();

    await _play(tester);
    await _play(tester);

    verify(() => channel.sendMessageMark(message, MessageMarkType.played)).called(2);
  });

  testWidgets("playing the current user's own video marks nothing", (tester) async {
    final channel = _channel();
    await tester.pumpWidget(_wrap(channel, _gallery(_videoMessage(user: _currentUser))));
    await tester.pump();

    await _play(tester);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });

  testWidgets('playing a video without the capability marks nothing', (tester) async {
    final channel = _channel(canMark: false);
    await tester.pumpWidget(_wrap(channel, _gallery(_videoMessage(user: _otherUser))));
    await tester.pump();

    await _play(tester);

    verifyNever(() => channel.sendMessageMark(any(), any()));
  });
}

Future<void> _play(WidgetTester tester) async {
  await tester.tap(find.text('play'));
  await tester.pump();
}

StreamMediaGalleryPreview _gallery(Message message) {
  return StreamMediaGalleryPreview(
    attachments: message.toMediaGalleryAttachments(),
  );
}

Message _videoMessage({required User user, int videos = 1}) {
  return Message(
    id: 'video',
    createdAt: DateTime(2026, 11, 20, 9),
    user: user,
    state: MessageState.sent,
    attachments: [
      for (var i = 0; i < videos; i++)
        Attachment(
          type: AttachmentType.video,
          assetUrl: 'https://example.com/video-$i.mp4',
        ),
    ],
  );
}

MockChannel _channel({bool canMark = true}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(
    ownCapabilities: [
      ChannelCapability.sendMessage,
      if (canMark) ChannelCapability.sendMessageMark,
    ],
  );

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(_currentUser);
  when(() => client.logger).thenReturn(Logger.detached('test'));
  when(() => channel.client).thenReturn(client);
  final channelState = MockChannelState();
  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.channelState).thenReturn(
    ChannelState(
      channel: ChannelModel(
        cid: 'messaging:test',
        config: ChannelConfig(markTypes: const [MessageMarkType.played]),
      ),
    ),
  );
  when(() => channel.sendMessageMark(any(), any())).thenAnswer(
    (_) async => SendMessageMarkResponse(),
  );
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

  return MaterialApp(
    theme: ThemeData(extensions: [StreamTheme.light()]),
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: StreamComponentFactory(
        builders: builders,
        child: StreamChannel(
          channel: channel,
          child: body,
        ),
      ),
    ),
  );
}
