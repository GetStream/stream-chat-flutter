import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'control test',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: Scaffold(
            body: DeletedMessage(
              messageTheme: MessageTheme(
                createdAt: TextStyle(
                  color: Colors.black,
                ),
                messageText: TextStyle(),
              ),
            ),
          ),
        ),
      ));

      expect(find.text('Message deleted'), findsOneWidget);
    },
  );

  testGoldens(
    'control golden light',
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

      final materialTheme = ThemeData.light();
      final theme = StreamChatThemeData.fromTheme(materialTheme);
      await tester.pumpWidgetBuilder(
        materialAppWrapper(
          theme: materialTheme,
        )(
          StreamChat(
            streamChatThemeData: theme,
            client: client,
            child: StreamChannel(
              showLoading: false,
              channel: channel,
              child: Center(
                child: DeletedMessage(
                  messageTheme: theme.ownMessageTheme,
                ),
              ),
            ),
          ),
        ),
        surfaceSize: Size.square(200),
      );

      await screenMatchesGolden(tester, 'deleted_message_light');
    },
  );

  testGoldens(
    'control golden dark',
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

      final materialTheme = ThemeData.dark();
      final theme = StreamChatThemeData.fromTheme(materialTheme);
      await tester.pumpWidgetBuilder(
        materialAppWrapper(
          theme: materialTheme,
        )(
          StreamChat(
            streamChatThemeData: theme,
            client: client,
            child: StreamChannel(
              showLoading: false,
              channel: channel,
              child: Center(
                child: DeletedMessage(
                  messageTheme: theme.ownMessageTheme,
                ),
              ),
            ),
          ),
        ),
        surfaceSize: Size.square(200),
      );

      await screenMatchesGolden(tester, 'deleted_message_dark');
    },
  );

  testGoldens(
    'golden customization test',
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

      final materialTheme = ThemeData.light();
      final theme = StreamChatThemeData.fromTheme(materialTheme);
      await tester.pumpWidgetBuilder(
        materialAppWrapper(
          theme: materialTheme,
        )(
          StreamChat(
            streamChatThemeData: theme,
            client: client,
            child: StreamChannel(
              showLoading: false,
              channel: channel,
              child: Center(
                child: DeletedMessage(
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
        surfaceSize: Size.square(200),
      );

      await screenMatchesGolden(tester, 'deleted_message_custom');
    },
  );
}
