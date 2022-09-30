import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'Shows GIPHY text',
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
                child: StreamGiphyAttachment(
                  constraints: BoxConstraints.tight(const Size(
                    300,
                    300,
                  )),
                  message: Message(),
                  attachment: Attachment(
                    type: 'giphy',
                    title: 'example.gif',
                    imageUrl:
                        'https://media.giphy.com/media/35H0pwQNaO2iLTnnBf/giphy.gif',
                    extraData: const {
                      'mime_type': 'gif',
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('GIPHY'), findsOneWidget);
    },
  );
}
