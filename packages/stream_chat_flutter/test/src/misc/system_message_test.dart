import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

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
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.extraDataStream).thenAnswer(
        (i) => Stream.value({
          'name': 'test',
        }),
      );
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });

      when(() => clientState.totalUnreadCount).thenReturn(10);
      when(() => clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(10));

      var tapped = false;

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: StreamSystemMessage(
                onMessageTap: (m) => tapped = true,
                message: Message(
                  text: 'demo message',
                ),
              ),
            ),
          ),
        ),
      ));

      await tester.tap(find.byType(StreamSystemMessage));

      expect(find.text('demo message'), findsOneWidget);
      expect(tapped, true);
    },
  );

  goldenTest(
    'control golden light',
    fileName: 'system_message_light',
    constraints: const BoxConstraints.tightFor(width: 200, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.extraDataStream).thenAnswer(
        (i) => Stream.value({
          'name': 'test',
        }),
      );
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });

      when(() => clientState.totalUnreadCount).thenReturn(10);
      when(() => clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(10));

      return MaterialAppWrapper(
        theme: ThemeData.light(),
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value(InternetStatus.connected),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Center(
                child: StreamSystemMessage(
                  message: Message(
                    text: 'demo message',
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'control golden dark',
    fileName: 'system_message_dark',
    constraints: const BoxConstraints.tightFor(width: 200, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.extraDataStream).thenAnswer(
        (i) => Stream.value({
          'name': 'test',
        }),
      );
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });

      when(() => clientState.totalUnreadCount).thenReturn(10);
      when(() => clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(10));

      return MaterialAppWrapper(
        theme: ThemeData.dark(),
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value(InternetStatus.connected),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Center(
                child: StreamSystemMessage(
                  message: Message(
                    text: 'demo message',
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
