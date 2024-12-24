import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  testWidgets('control test', (tester) async {
    final client = MockClient();
    final clientState = MockClientState();

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          child: const Scaffold(
            body: StreamDeletedMessage(
              messageTheme: StreamMessageThemeData(
                createdAtStyle: TextStyle(
                  color: Colors.black,
                ),
                messageTextStyle: TextStyle(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Message deleted'), findsOneWidget);
  });

  goldenTest(
    'control golden light',
    fileName: 'deleted_message_light',
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

      final materialTheme = ThemeData.light(
        useMaterial3: false,
      );
      final theme = StreamChatThemeData.fromTheme(materialTheme);
      return MaterialAppWrapper(
        theme: materialTheme,
        home: StreamChat(
          streamChatThemeData: theme,
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Center(
                child: StreamDeletedMessage(
                  messageTheme: theme.ownMessageTheme,
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
    fileName: 'deleted_message_dark',
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

      final materialTheme = ThemeData.dark(
        useMaterial3: false,
      );
      final theme = StreamChatThemeData.fromTheme(materialTheme);
      return MaterialAppWrapper(
        theme: materialTheme,
        home: StreamChat(
          streamChatThemeData: theme,
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Center(
                child: StreamDeletedMessage(
                  messageTheme: theme.ownMessageTheme,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'golden customization test',
    fileName: 'deleted_message_custom',
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

      final materialTheme = ThemeData.light(
        useMaterial3: false,
      );
      final theme = StreamChatThemeData.fromTheme(materialTheme);
      return MaterialAppWrapper(
        theme: materialTheme,
        home: StreamChat(
          streamChatThemeData: theme,
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Center(
                child: StreamDeletedMessage(
                  messageTheme: theme.ownMessageTheme,
                  reverse: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
