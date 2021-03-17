import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/src/channel_unread_indicator.dart';
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
      when(channelState.unreadCount).thenReturn(1);
      when(channelState.unreadCountStream).thenAnswer((i) => Stream.value(1));

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: ChannelUnreadIndicator(channel: channel),
            ),
          ),
        ),
      ));

      expect(find.text('1'), findsOneWidget);
    },
  );
}
