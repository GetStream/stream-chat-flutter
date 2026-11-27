import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_widget/stream_message_attachments.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('opens the link a link preview shows', (tester) async {
    String? opened;
    await _pump(
      tester,
      Attachment(
        type: AttachmentType.urlPreview,
        title: 'Flutter',
        titleLink: 'https://flutter.dev',
        ogScrapeUrl: 'https://flutter.dev/?ref=chat',
        assetUrl: 'https://example.com/video.mp4',
      ),
      onLinkTap: (url) => opened = url,
    );

    await tester.tap(find.text('Flutter'));

    expect(opened, 'https://flutter.dev');
  });

  testWidgets('opens the scraped link of a link preview without a title link', (tester) async {
    String? opened;
    await _pump(
      tester,
      Attachment(
        type: AttachmentType.urlPreview,
        title: 'Flutter',
        ogScrapeUrl: 'https://flutter.dev/?ref=chat',
        assetUrl: 'https://example.com/video.mp4',
      ),
      onLinkTap: (url) => opened = url,
    );

    await tester.tap(find.text('Flutter'));

    expect(opened, 'https://flutter.dev/?ref=chat');
  });

  testWidgets('opens the file of a file attachment', (tester) async {
    String? opened;
    await _pump(
      tester,
      Attachment(
        type: AttachmentType.file,
        title: 'report.pdf',
        assetUrl: 'https://example.com/report.pdf',
      ),
      onLinkTap: (url) => opened = url,
    );

    await tester.tap(find.text('report.pdf'));

    expect(opened, 'https://example.com/report.pdf');
  });

  testWidgets('opens a tapped link preview with the configured link handler', (tester) async {
    final handler = _RecordingLinkHandler();
    await _pump(
      tester,
      Attachment(type: AttachmentType.urlPreview, title: 'Flutter', titleLink: 'https://flutter.dev'),
      configuration: StreamChatConfigurationData(linkHandler: handler),
    );

    await tester.tap(find.text('Flutter'));
    await tester.pump();

    expect(handler.opened, [Uri.parse('https://flutter.dev')]);
  });
}

Future<void> _pump(
  WidgetTester tester,
  Attachment attachment, {
  void Function(String)? onLinkTap,
  StreamChatConfigurationData? configuration,
}) async {
  final channel = MockChannel();
  final channelState = MockChannelState();
  when(() => channel.state).thenReturn(channelState);

  final attachments = Scaffold(
    body: StreamMessageAttachments(
      message: Message(attachments: [attachment]),
      onLinkTap: onLinkTap,
    ),
  );

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChatTheme(
        data: StreamChatThemeData(),
        child: StreamChannel(
          channel: channel,
          child: switch (configuration) {
            final data? => StreamChatConfiguration(data: data, child: attachments),
            _ => attachments,
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _RecordingLinkHandler extends StreamLinkHandler {
  final opened = <Uri>[];

  @override
  Future<bool> open(BuildContext context, Uri uri) async {
    opened.add(uri);
    return true;
  }
}
