import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  late StreamChatClient client;
  late Channel channel;
  late ChannelClientState channelClientState;
  late ClientState clientState;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'testid'));
    when(() => clientState.currentUserStream)
        .thenAnswer((_) => Stream.value(OwnUser(id: 'testid')));
    channel = MockChannel();
    when(() => channel.on(any(), any(), any(), any()))
        .thenAnswer((_) => const Stream.empty());
    channelClientState = MockChannelState();
    when(() => channel.state).thenReturn(channelClientState);
    when(() => channelClientState.threadsStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messagesStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messages).thenReturn([]);
    when(() => channelClientState.isUpToDateStream)
        .thenAnswer((_) => Stream.value(true));
    when(() => channelClientState.isUpToDate).thenReturn(true);
    when(() => channelClientState.unreadCountStream)
        .thenAnswer((_) => Stream.value(0));
    when(() => channelClientState.unreadCount).thenReturn(0);
    when(() => channelClientState.readStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.read).thenReturn([]);
    when(() => channelClientState.membersStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
  });

  // https://github.com/GetStream/stream-chat-flutter/issues/674
  testWidgets('renders empty message list view', (tester) async {
    const emptyWidgetKey = Key('empty_widget');

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: MessageListView(
              emptyBuilder: (_) => Container(key: emptyWidgetKey),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MessageListView), findsOneWidget);
    expect(find.byKey(emptyWidgetKey), findsOneWidget);
  });

  testWidgets('renders empty message list view with custom background',
      (tester) async {
    when(() => channelClientState.messagesStream)
        .thenAnswer((_) => Stream.value([Message(text: 'Hello world!')]));
    when(() => channelClientState.messages)
        .thenReturn([Message(text: 'Hello world!')]);

    const emptyWidgetKey = Key('empty_widget');

    await tester.pumpWidget(
      MaterialApp(
        home: DefaultAssetBundle(
          bundle: _TestAssetBundle(),
          child: StreamChat(
            client: client,
            streamChatThemeData: StreamChatThemeData.light().copyWith(
              messageListViewTheme: const MessageListViewThemeData(
                backgroundColor: Colors.grey,
                backgroundImage: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            child: StreamChannel(
              channel: channel,
              child: MessageListView(
                emptyBuilder: (_) => Container(key: emptyWidgetKey),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MessageListView), findsOneWidget);
    expect(find.byKey(emptyWidgetKey), findsNothing);
    expect(find.byType(DecorationImage, skipOffstage: false), findsOneWidget);
  });
}

class _TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key == 'assets/background.png') {
      return ByteData.view(
        Uint8List.fromList(
          utf8.encode('Background'),
        ).buffer,
      );
    }
    return ByteData(0);
  }
}
