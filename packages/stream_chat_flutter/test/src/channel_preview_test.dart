import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'it should show basic channel information',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(channel.lastMessageAt).thenReturn(lastMessageAt);
      when(channel.state).thenReturn(channelState);
      when(channel.client).thenReturn(client);
      when(channel.isMuted).thenReturn(false);
      when(channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test name',
          }));
      when(channel.extraData).thenReturn({
        'name': 'test name',
      });
      when(channelState.unreadCount).thenReturn(1);
      when(channelState.unreadCountStream).thenAnswer((i) => Stream.value(1));
      when(channelState.membersStream).thenAnswer((i) => Stream.value([
            Member(
              userId: 'user-id',
              user: User(id: 'user-id'),
            )
          ]));
      when(channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(channelState.messages).thenReturn([
        Message(
          text: 'hello',
          user: User(id: 'other-user'),
        )
      ]);
      when(channelState.messagesStream).thenAnswer((i) => Stream.value([
            Message(
              text: 'hello',
              user: User(id: 'other-user'),
            )
          ]));

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: ChannelPreview(
                channel: channel,
              ),
            ),
          ),
        ),
      ));

      expect(find.text('6/22/2020'), findsOneWidget);
      expect(find.text('test name'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('hello'), findsOneWidget);
      expect(find.byType(ChannelImage), findsOneWidget);
    },
  );
}
