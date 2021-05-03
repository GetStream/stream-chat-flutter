import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'it should show total unread count',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });

      when(() => clientState.totalUnreadCount).thenReturn(10);
      when(() => clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(10));

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: UnreadIndicator(),
            ),
          ),
        ),
      ));

      expect(find.text('10'), findsOneWidget);
    },
  );

  testWidgets(
    'it should show nothing if no unread messages',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      when(() => channel.cid).thenReturn('cid');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.channels).thenReturn({
        channel.cid!: channel,
      });
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channelState.unreadCount).thenReturn(0);
      when(() => channelState.unreadCountStream)
          .thenAnswer((i) => Stream.value(0));

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: UnreadIndicator(
                cid: channel.cid,
              ),
            ),
          ),
        ),
      ));

      expect(find.byType(SizedBox), findsOneWidget);
    },
  );

  testWidgets(
    'it should show 99+ if more than 99 unreads',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      when(() => channel.cid).thenReturn('cid');
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.channels).thenReturn({
        channel.cid!: channel,
      });
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channelState.unreadCount).thenReturn(100);
      when(() => channelState.unreadCountStream)
          .thenAnswer((i) => Stream.value(100));

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: UnreadIndicator(
                cid: channel.cid,
              ),
            ),
          ),
        ),
      ));

      expect(find.text('99+'), findsOneWidget);
    },
  );
}
