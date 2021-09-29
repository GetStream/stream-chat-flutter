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

  setUp(() {
    client = MockClient();
    channel = MockChannel();
    when(() => channel.on(any(), any(), any(), any()))
        .thenAnswer((_) => const Stream.empty());
    final channelClientState = MockChannelState();
    when(() => channel.state).thenReturn(channelClientState);
    when(() => channelClientState.threadsStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messagesStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messages)
        .thenReturn([Message(text: 'Hello World!')]);
    when(() => channelClientState.isUpToDate).thenReturn(true);
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
                    ))),
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
    expect(find.byKey(emptyWidgetKey), findsOneWidget);
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
