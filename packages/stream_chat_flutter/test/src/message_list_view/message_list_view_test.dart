import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

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
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);
    when(() => channelClientState.threadsStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messagesStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messages).thenReturn([]);
    when(() => channelClientState.isUpToDate).thenReturn(true);
    when(() => channelClientState.isUpToDateStream)
        .thenAnswer((_) => Stream.value(true));
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
            child: StreamMessageListView(
              emptyBuilder: (_) => Container(key: emptyWidgetKey),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StreamMessageListView), findsOneWidget);
    expect(find.byKey(emptyWidgetKey), findsOneWidget);
  });

  testWidgets('renders a non empty message list view with custom background',
      (tester) async {
    final message = Message(
      id: 'message1',
      text: 'Hello world!',
      user: User(
        id: 'user',
        name: 'Test User',
      ),
    );

    when(() => channelClientState.messagesStream).thenAnswer(
      (_) => Stream.value([message]),
    );
    when(() => channelClientState.messages).thenReturn([message]);

    const nonEmptyWidgetKey = Key('non_empty_widget');
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: rootBundle,
            child: StreamChat(
              client: client,
              streamChatThemeData: StreamChatThemeData.light().copyWith(
                messageListViewTheme: const StreamMessageListViewThemeData(
                  backgroundColor: Colors.grey,
                  backgroundImage: DecorationImage(
                    image: AssetImage('images/placeholder.png'),
                    fit: BoxFit.none,
                  ),
                ),
              ),
              child: StreamChannel(
                channel: channel,
                child: const StreamMessageListView(
                  key: nonEmptyWidgetKey,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    });

    bool findBackground(Widget widget) =>
        widget is DecoratedBox &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).image != null;

    expect(find.byType(StreamMessageListView), findsOneWidget);
    expect(find.byKey(nonEmptyWidgetKey), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        findBackground,
        description: 'findBackground',
      ),
      findsOneWidget,
    );
  });
}
