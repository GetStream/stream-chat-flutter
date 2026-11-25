import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../mocks.dart';

final _currentUser = OwnUser(id: 'me', name: 'Luke Skywalker');
final _otherUser = User(id: 'han', name: 'Han Solo');

final _voiceRecording = Attachment(
  type: AttachmentType.voiceRecording,
  assetUrl: 'https://example.com/voice.m4a',
  extraData: const {'duration': 3},
);

void main() {
  testWidgets('a voice message played by more than 99 members reads 99+', (tester) async {
    await tester.pumpWidget(_wrap(_item(_voiceMessage(playedBy: 100))));
    await tester.pumpAndSettle();

    expect(find.text('Played by 99+'), findsOneWidget);
  });

  testWidgets('a two-member voice message nobody played shows no mark', (tester) async {
    await tester.pumpWidget(_wrap(_item(_voiceMessage()), isTwoMember: true));
    await tester.pumpAndSettle();

    expect(find.byType(StreamMessagePlayedMark), findsNothing);
    expect(find.textContaining('Played'), findsNothing);
  });

  testWidgets('a group voice message nobody played shows no mark', (tester) async {
    await tester.pumpWidget(_wrap(_item(_voiceMessage())));
    await tester.pumpAndSettle();

    expect(find.byType(StreamMessagePlayedMark), findsNothing);
    expect(find.textContaining('Played'), findsNothing);
  });

  testWidgets('a two-member voice message the other member played reads played', (tester) async {
    final message = _voiceMessage(playedBy: 1);
    await tester.pumpWidget(_wrap(_item(message), isTwoMember: true));
    await tester.pumpAndSettle();

    expect(find.text('Played'), findsOneWidget);
  });

  testWidgets('a group voice message reads how many members played it', (tester) async {
    await tester.pumpWidget(_wrap(_item(_voiceMessage(playedBy: 2))));
    await tester.pumpAndSettle();

    expect(find.text('Played by 2'), findsOneWidget);
  });

  testWidgets('no mark shows when the channel does not allow played marks', (tester) async {
    await tester.pumpWidget(_wrap(_item(_voiceMessage(playedBy: 2)), markTypes: const []));
    await tester.pumpAndSettle();

    expect(find.textContaining('Played by'), findsNothing);
  });

  testWidgets("no mark shows on another user's voice message", (tester) async {
    final message = _voiceMessage(user: _otherUser, playedBy: 2);
    await tester.pumpWidget(_wrap(_item(message)));
    await tester.pumpAndSettle();

    expect(find.textContaining('Played by'), findsNothing);
  });

  testWidgets('no mark shows on a deleted message', (tester) async {
    final message = _voiceMessage(playedBy: 2, attachments: const []).copyWith(type: MessageType.deleted);
    await tester.pumpWidget(_wrap(_item(message)));
    await tester.pumpAndSettle();

    expect(find.textContaining('Played by'), findsNothing);
  });

  testWidgets('a text message reads how many members played it', (tester) async {
    final message = _voiceMessage(playedBy: 2, text: 'Listen to this', attachments: const []);
    await tester.pumpWidget(_wrap(_item(message)));
    await tester.pumpAndSettle();

    expect(find.text('Played by 2'), findsOneWidget);
  });

  testWidgets('an audio file reads how many members played it', (tester) async {
    final audio = Attachment(type: AttachmentType.audio, assetUrl: 'https://example.com/song.mp3');
    final message = _voiceMessage(playedBy: 2).copyWith(attachments: [audio]);
    await tester.pumpWidget(_wrap(_item(message)));
    await tester.pumpAndSettle();

    expect(find.text('Played by 2'), findsOneWidget);
  });

  testWidgets('a group video reads how many members played it', (tester) async {
    final video = Attachment(type: AttachmentType.video, assetUrl: 'https://example.com/video.mp4');
    final message = _voiceMessage(playedBy: 2).copyWith(attachments: [video]);
    await tester.pumpWidget(_wrap(_item(message)));
    // The video thumbnail keeps loading, so the frame never settles.
    await tester.pump();

    expect(find.text('Played by 2'), findsOneWidget);
  });

  testWidgets('a voice message is announced with its played state', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_wrap(_item(_voiceMessage(playedBy: 2))));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel(RegExp('Played by 2')), findsWidgets);
    semantics.dispose();
  });

  testWidgets('a tappable played mark can be reached by a screen reader', (tester) async {
    final semantics = tester.ensureSemantics();
    final item = StreamMessageItem(
      message: _voiceMessage(playedBy: 2),
      onMessageMarkTap: (_, __) {},
    );
    await tester.pumpWidget(_wrap(item));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.text('Played by 2')),
      containsSemantics(label: 'Played by 2', hasTapAction: true),
    );
    semantics.dispose();
  });

  testWidgets('tapping a two-member played mark reports the message', (tester) async {
    MessageMarkTapDetails? tapped;
    final message = _voiceMessage(playedBy: 1);
    final item = StreamMessageItem(
      message: message,
      onMessageMarkTap: (_, details) => tapped = details,
    );
    await tester.pumpWidget(_wrap(item, isTwoMember: true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Played'));

    expect(tapped?.message, message);
  });

  testWidgets('a single voice message shows no mark when the theme hides metadata', (tester) async {
    final item = core.StreamMessageItemTheme(
      data: core.StreamMessageItemThemeData(
        metadataVisibility: .all(.gone),
      ),
      child: _item(_voiceMessage(playedBy: 2)),
    );
    await tester.pumpWidget(_wrap(item));
    await tester.pumpAndSettle();

    expect(find.text('Played by 2'), findsNothing);
  });

  testWidgets('an earlier voice message shows no mark when the theme hides metadata', (tester) async {
    final item = core.StreamMessageItemTheme(
      data: core.StreamMessageItemThemeData(
        metadataVisibility: .all(.gone),
      ),
      child: _item(_voiceMessage(playedBy: 2)),
    );
    await tester.pumpWidget(_wrap(item, stackPosition: .top));
    await tester.pumpAndSettle();

    expect(find.text('Played by 2'), findsNothing);
  });

  testWidgets('an earlier voice message in a group keeps its mark', (tester) async {
    await tester.pumpWidget(
      _wrap(_item(_voiceMessage(playedBy: 2)), stackPosition: .top),
    );
    await tester.pumpAndSettle();

    expect(find.text('Played by 2'), findsOneWidget);
  });

  testWidgets('a dot separates the mark from the rest of the metadata', (tester) async {
    await tester.pumpWidget(_wrap(_item(_voiceMessage(playedBy: 2))));
    await tester.pumpAndSettle();

    final markRight = tester.getTopRight(find.text('Played by 2')).dx;
    final dotLeft = tester.getTopLeft(find.text('·')).dx;
    expect(dotLeft, greaterThan(markRight));
  });

  testWidgets('an earlier voice message keeps its metadata when played', (tester) async {
    await tester.pumpWidget(
      _wrap(_item(_voiceMessage(playedBy: 2)), stackPosition: .top),
    );
    await tester.pumpAndSettle();

    expect(find.text('·'), findsOneWidget);
    expect(find.byType(StreamTimestamp), findsOneWidget);
  });

  testWidgets('an earlier voice message nobody played shows no metadata', (tester) async {
    await tester.pumpWidget(
      _wrap(_item(_voiceMessage()), stackPosition: .top),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StreamTimestamp), findsNothing);
  });

  testWidgets('an earlier voice message uses the accent color by default', (tester) async {
    await tester.pumpWidget(
      _wrap(_item(_voiceMessage(playedBy: 2)), stackPosition: .top),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.text('Played by 2'));
    final accent = context.streamColorScheme.accentPrimary;
    expect(_textColor(tester, 'Played by 2'), accent);
  });

  testWidgets('an earlier voice message uses the themed mark color', (tester) async {
    const themedColor = Color(0xFF00AA55);
    final item = core.StreamMessageItemTheme(
      data: core.StreamMessageItemThemeData(
        metadata: core.StreamMessageMetadataStyle.from(markColor: themedColor),
      ),
      child: _item(_voiceMessage(playedBy: 2)),
    );
    await tester.pumpWidget(_wrap(item, stackPosition: .top));
    await tester.pumpAndSettle();

    expect(_textColor(tester, 'Played by 2'), themedColor);
  });

  testWidgets('tapping the played by mark reports the message and mark type', (tester) async {
    MessageMarkTapDetails? tapped;
    final message = _voiceMessage(playedBy: 2);
    final item = StreamMessageItem(
      message: message,
      onMessageMarkTap: (_, details) => tapped = details,
    );
    await tester.pumpWidget(_wrap(item));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Played by 2'));

    expect(tapped?.message, message);
    expect(tapped?.type, MessageMarkType.played);
  });

  testWidgets("tapping an earlier voice message's mark reports the message", (tester) async {
    MessageMarkTapDetails? tapped;
    final message = _voiceMessage(playedBy: 2);
    final item = StreamMessageItem(
      message: message,
      onMessageMarkTap: (_, details) => tapped = details,
    );
    await tester.pumpWidget(_wrap(item, stackPosition: .top));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Played by 2'));

    expect(tapped?.message, message);
  });

  for (final brightness in Brightness.values) {
    final theme = brightness.name;

    goldenTest(
      'played marks in $theme theme',
      fileName: 'stream_message_played_mark_$theme',
      constraints: const BoxConstraints.tightFor(width: 400, height: 240),
      builder: () {
        final message = _voiceMessage(playedBy: 3, text: 'Listen to this', attachments: const []);
        final stackPositions = <StreamMessageStackPosition>[.top, .single];
        final scene = Builder(
          builder: (context) => ColoredBox(
            color: context.streamColorScheme.backgroundApp,
            child: Column(
              mainAxisAlignment: .center,
              children: [
                for (final stackPosition in stackPositions)
                  StreamMessageLayout(
                    data: StreamMessageLayoutData(
                      alignment: StreamMessageAlignment.end,
                      stackPosition: stackPosition,
                    ),
                    child: _item(message),
                  ),
              ],
            ),
          ),
        );
        return _wrap(scene, brightness: brightness);
      },
    );
  }
}

StreamMessageItem _item(Message message) => StreamMessageItem(message: message);

Color? _textColor(WidgetTester tester, String text) {
  final richText = find.descendant(
    of: find.text(text),
    matching: find.byType(RichText),
  );
  return tester.widget<RichText>(richText).text.style?.color;
}

Message _voiceMessage({User? user, int playedBy = 0, String? text, List<Attachment>? attachments}) {
  final markers = [
    for (var i = 0; i < playedBy; i++)
      MessageMarker(
        userId: 'listener-$i',
        createdAt: DateTime(2026, 11, 20),
      ),
  ];
  return Message(
    id: 'voice-note',
    createdAt: DateTime(2026, 11, 20, 9),
    text: text,
    user: user ?? _currentUser,
    state: MessageState.sent,
    attachments: attachments ?? [_voiceRecording],
    markGroups: {
      if (playedBy > 0) MessageMarkType.played: MarkGroup(count: playedBy, latestBy: markers),
    },
  );
}

Widget _wrap(
  Widget body, {
  bool isTwoMember = false,
  List<MessageMarkType> markTypes = const [MessageMarkType.played],
  StreamMessageStackPosition stackPosition = StreamMessageStackPosition.single,
  Brightness brightness = Brightness.light,
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(_currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(_currentUser));
  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelState);
  when(() => channel.memberCount).thenReturn(isTwoMember ? 2 : 5);
  final channelModel = ChannelModel(
    cid: 'messaging:test',
    config: ChannelConfig(markTypes: markTypes),
  );
  when(() => channelState.channelState).thenReturn(ChannelState(channel: channelModel));
  when(() => channelState.readStream).thenAnswer((_) => Stream.value(const []));

  final layout = StreamMessageLayoutData(
    alignment: StreamMessageAlignment.end,
    stackPosition: stackPosition,
  );

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: brightness),
    home: StreamChat(
      client: client,
      connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
      child: StreamChannel(
        channel: channel,
        child: Scaffold(
          body: StreamMessageLayout(
            data: layout,
            child: Align(alignment: Alignment.topLeft, child: body),
          ),
        ),
      ),
    ),
  );
}
