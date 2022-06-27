import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('AttachmentTitle renders properly', (tester) async {
    final mockClient = MockClient();
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: mockClient,
          streamChatThemeData: StreamChatThemeData.light(),
          child: child,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: StreamAttachmentTitle(
                  attachment: Attachment(
                    title: 'Test Attachment',
                    type: 'video',
                    titleLink: 'https://www.youtube.com/watch?v=lytQi-slT5Y',
                    ogScrapeUrl: 'https://www.youtube.com/watch?v=lytQi-slT5Y',
                  ),
                  messageTheme: StreamChatTheme.of(context).ownMessageTheme,
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(StreamAttachmentTitle), findsOneWidget);
    expect(find.text('Test Attachment'), findsOneWidget);
    expect(find.text('https://www.youtube.com/watch?v=lytQi-slT5Y'),
        findsOneWidget);
  });
}
