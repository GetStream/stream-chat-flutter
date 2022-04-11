import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'Shows the attachment title',
    (WidgetTester tester) async {
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => channel.state).thenReturn(channelState);

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: streamTheme,
            child: StreamChannel(
              channel: channel,
              child: SizedBox(
                child: StreamUrlAttachment(
                  messageTheme: streamTheme.ownMessageTheme,
                  hostDisplayName: 'Test',
                  urlAttachment: Attachment(
                    title: 'Flutter',
                    titleLink: 'https://flutter.dev',
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Flutter'), findsOneWidget);
    },
  );
}
