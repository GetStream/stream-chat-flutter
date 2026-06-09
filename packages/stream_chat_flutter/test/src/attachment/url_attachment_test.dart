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

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData(),
            child: StreamChannel(
              channel: channel,
              child: SizedBox(
                child: StreamLinkPreviewAttachment(
                  message: Message(),
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

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.text('Flutter'), findsOneWidget);
    },
  );
}
