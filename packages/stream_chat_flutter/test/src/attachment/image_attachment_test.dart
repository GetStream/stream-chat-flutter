import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'Shows the image',
    (WidgetTester tester) async {
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => channel.state).thenReturn(channelState);

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData(),
            child: StreamChannel(
              channel: channel,
              child: SizedBox(
                child: StreamImageAttachment(
                  constraints: BoxConstraints.tight(
                    const Size(
                      300,
                      300,
                    ),
                  ),
                  message: Message(),
                  image: Attachment(
                    type: 'image',
                    title: 'example.png',
                    imageUrl: 'https://logowik.com/content/uploads/images/flutter5786.jpg',
                    extraData: const {
                      'mime_type': 'png',
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pump(Duration.zero);

      expect(find.byType(StreamNetworkImage), findsOneWidget);
    },
  );
}
