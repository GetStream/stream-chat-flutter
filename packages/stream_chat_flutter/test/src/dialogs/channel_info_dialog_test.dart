import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/dialogs/channel_info_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  late MockClient client;
  late MockClientState clientState;
  late MockOwnUser user;
  late MockChannel channel;
  late MockChannelState channelState;

  setUpAll(() {
    client = MockClient();
    clientState = MockClientState();
    user = MockOwnUser();
    channel = MockChannel();
    channelState = MockChannelState();
    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(user);
    when(() => user.id).thenReturn('1');
    when(() => channel.state).thenReturn(channelState);
    when(() => channelState.members).thenReturn([
      Member(
        user: User(
          id: '1',
        ),
      ),
      Member(
        user: User(
          id: '2',
        ),
      ),
    ]);
    when(() => channel.name).thenReturn('test-channel');
    when(() => channel.id).thenReturn('123456789');
    when(() => channel.isDistinct).thenReturn(true);
    when(() => channel.memberCount).thenReturn(2);
    when(() => channelState.membersStream).thenAnswer(
      (_) => Stream.value([
        Member(
          user: User(
            id: '1',
          ),
        ),
        Member(
          user: User(
            id: '2',
          ),
        ),
      ]),
    );
  });

  testWidgets('ChannelInfoDialog shows info and members', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: ChannelInfoDialog(
                channel: channel,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SimpleDialog), findsOneWidget);
    expect(find.byType(StreamChannelInfo), findsOneWidget);
    expect(find.byType(StreamUserAvatar), findsOneWidget);
  });
}
