import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';
import 'simple_frame.dart';

void expectTextStrings(Iterable<Widget> widgets, List<String> strings) {
  var currentString = 0;
  for (final widget in widgets) {
    if (widget is RichText) {
      final span = widget.text as TextSpan;
      final text = _extractTextFromTextSpan(span);
      expect(text, equals(strings[currentString]));
      currentString += 1;
    }
  }
}

String _extractTextFromTextSpan(TextSpan span) {
  var text = span.text ?? '';
  if (span.children != null) {
    for (final child in span.children! as Iterable<TextSpan>) {
      text += _extractTextFromTextSpan(child);
    }
  }
  return text;
}

void main() {
  testWidgets(
    'it should show correct message text',
    (WidgetTester tester) async {
      final currentUser = OwnUser(id: 'user-id');
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');
      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream)
          .thenAnswer((_) => Stream.value(currentUser));
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
              body: StreamMessageText(
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

  group('Message with i18n field', () {
    final client = MockClient();
    final clientState = MockClientState();
    final channel = MockChannel();
    final channelState = MockChannelState();
    const messageTheme = StreamMessageThemeData();

    final currentUser = OwnUser(
      id: 'sahil',
      language: 'hi',
    );

    setUp(() {
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream)
          .thenAnswer((_) => Stream.value(currentUser));

      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));
    });

    testWidgets(
      'should show correct translated message text as per user language',
      (WidgetTester tester) async {
        final message = Message(
          text: 'Hello',
          i18n: const {
            'en_text': 'Hello',
            'hi_text': 'नमस्ते',
            'language': 'en',
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  body: StreamMessageText(
                    message: message,
                    messageTheme: messageTheme,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(MarkdownBody), findsOneWidget);

        final widgets = tester.allWidgets;
        expectTextStrings(widgets, <String>['नमस्ते']);
      },
    );

    testWidgets(
      '''should show default text if i18n does not contain translations as per user language''',
      (WidgetTester tester) async {
        final message = Message(
          text: 'Hello',
          i18n: const {
            'en_text': 'Hello',
            'fr_text': 'Bonjour',
            'language': 'en',
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  body: StreamMessageText(
                    message: message,
                    messageTheme: messageTheme,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(MarkdownBody), findsOneWidget);

        final widgets = tester.allWidgets;
        expectTextStrings(widgets, <String>['Hello']);
      },
    );
  });

  testGoldens(
    'control test',
    (WidgetTester tester) async {
      final currentUser = OwnUser(id: 'user-id');
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');
      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream)
          .thenAnswer((_) => Stream.value(currentUser));
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
          child: StreamChat(
            client: client,
            connectivityStream: Stream.value(ConnectivityResult.wifi),
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamMessageText(
                  message: Message(
                    text: messageText,
                  ),
                  messageTheme: streamTheme.otherMessageTheme,
                ),
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
