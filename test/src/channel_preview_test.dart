import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MockClient extends Mock implements Client {}

class MockChannel extends Mock implements Channel {}

class MockChannelState extends Mock implements ChannelClientState {}

void main() {
  testWidgets(
    'it should show basic channel information',
    (WidgetTester tester) async {
      final client = MockClient();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(channel.lastMessageAt).thenReturn(lastMessageAt);
      when(channel.state).thenReturn(channelState);
      when(channel.extraData).thenReturn({
        'name': 'test name',
      });
      when(channelState.unreadCount).thenReturn(1);
      when(channelState.lastMessage).thenReturn(Message(
        text: 'hello',
      ));

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

      expect(find.text('22/06/2020'), findsOneWidget);
      expect(find.text('test name'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('hello'), findsOneWidget);
      expect(find.byType(ChannelImage), findsOneWidget);
    },
  );
}
