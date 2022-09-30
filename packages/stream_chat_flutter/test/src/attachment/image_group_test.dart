import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'Shows 2 images',
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
                child: StreamImageGroup(
                  messageTheme: streamTheme.ownMessageTheme,
                  constraints: BoxConstraints.tight(const Size(
                    300,
                    300,
                  )),
                  message: Message(),
                  images: [
                    Attachment(
                      type: 'image',
                      title: 'example.png',
                      imageUrl:
                          'https://logowik.com/content/uploads/images/flutter5786.jpg',
                      extraData: const {
                        'mime_type': 'png',
                      },
                    ),
                    Attachment(
                      type: 'image',
                      title: 'example.png',
                      imageUrl:
                          'https://logowik.com/content/uploads/images/flutter5786.jpg',
                      extraData: const {
                        'mime_type': 'png',
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsNWidgets(2));
    },
  );
}
