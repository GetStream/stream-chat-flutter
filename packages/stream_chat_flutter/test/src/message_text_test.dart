import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';
import 'simple_frame.dart';

void main() {
  testWidgets(
    'it should show correct message text',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');
      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: MessageText(
                  message: Message(
                    text: 'demo',
                  ),
                  messageTheme: streamTheme.otherMessageTheme),
            ),
          ),
        ),
      ));

      expect(find.byType(MarkdownBody), findsOneWidget);
    },
  );

  testGoldens(
    'control test',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');
      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });

      const messageText = '''
a message.
with multiple lines
and a list:
- a. okasd
- b lllll

cool.''';

      await tester.pumpWidgetBuilder(
        materialAppWrapper()(SimpleFrame(
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: MessageText(
                message: Message(
                  text: messageText,
                ),
                messageTheme: streamTheme.otherMessageTheme,
              ),
            ),
          ),
        )),
        surfaceSize: const Size(500, 500),
      );
      await screenMatchesGolden(tester, 'message_text');
    },
  );
}
