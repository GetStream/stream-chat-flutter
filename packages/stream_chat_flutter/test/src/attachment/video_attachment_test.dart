import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'Shows the video title',
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
                child: StreamVideoAttachment(
                  messageTheme: streamTheme.ownMessageTheme,
                  constraints: BoxConstraints.tight(const Size(
                    300,
                    300,
                  )),
                  message: Message(),
                  attachment: Attachment(
                    type: 'video',
                    title: 'example',
                    assetUrl: 'https://www.youtube.com/watch?v=OEdQXBUPYOE',
                    file: AttachmentFile(
                      size: 1000,
                      path: 'https://www.youtube.com/watch?v=OEdQXBUPYOE',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StreamAttachmentTitle), findsOneWidget);
    },
  );
}
