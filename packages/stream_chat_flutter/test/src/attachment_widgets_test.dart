import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'it should show file details',
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
                child: StreamFileAttachment(
                  size: const Size(
                    300,
                    300,
                  ),
                  message: Message(),
                  attachment: Attachment(
                    type: 'file',
                    title: 'example.pdf',
                    extraData: const {
                      'mime_type': 'pdf',
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('example.pdf'), findsOneWidget);
    },
  );
}
