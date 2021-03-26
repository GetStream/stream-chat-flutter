import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(channel.lastMessageAt).thenReturn(lastMessageAt);
      when(channel.state).thenReturn(channelState);
      when(channel.client).thenReturn(client);
      when(channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(channel.extraData).thenReturn({
        'name': 'test',
      });

      when(clientState.totalUnreadCount).thenReturn(10);
      when(clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(10));

      var tapped = false;

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: SystemMessage(
                onMessageTap: (m) => tapped = true,
                message: Message(
                  text: 'demo message',
                ),
              ),
            ),
          ),
        ),
      ));

      await tester.tap(find.byType(SystemMessage));

      expect(find.text('demo message'), findsOneWidget);
      expect(tapped, true);
    },
  );
}
