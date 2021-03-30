import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'control test',
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
      when(channel.initialized).thenAnswer((_) => Future.value(true));
      when(channel.isMuted).thenReturn(false);
      when(channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(channel.extraData).thenReturn({
        'name': 'test',
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

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: ThreadHeader(
                parent: Message(),
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('with '), findsOneWidget);
      expect(find.byType(ChannelName), findsOneWidget);
      expect(find.byType(StreamBackButton), findsOneWidget);
      expect(find.text('Thread Reply'), findsOneWidget);
    },
  );

  testWidgets(
    'it should apply passed props',
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
      when(channel.initialized).thenAnswer((_) => Future.value(true));
      when(channel.isMuted).thenReturn(false);
      when(channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(channel.extraData).thenReturn({
        'name': 'test',
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

      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: ThreadHeader(
                parent: Message(),
                subtitle: Text('subtitle'),
                leading: Text('leading'),
                title: Text('title'),
                onTitleTap: () {
                  tapped = true;
                },
                actions: [
                  Text('action'),
                ],
              ),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('title'), findsOneWidget);
      await tester.tap(find.text('title'));
      expect(tapped, true);
      expect(find.text('subtitle'), findsOneWidget);
      expect(find.text('action'), findsOneWidget);
      expect(find.text('leading'), findsOneWidget);
    },
  );
}
