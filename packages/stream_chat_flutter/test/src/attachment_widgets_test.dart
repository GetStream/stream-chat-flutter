import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'it should show file details',
    (WidgetTester tester) async {
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(channel.state).thenReturn(channelState);

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.getDefaultTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: streamTheme,
            child: StreamChannel(
              channel: channel,
              child: Container(
                child: FileAttachment(
                  size: Size(
                    300.0,
                    300.0,
                  ),
                  message: Message(),
                  attachment: Attachment(
                    type: 'file',
                    title: 'example.pdf',
                    extraData: {
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
