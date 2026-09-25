import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/response/og_attachment_response.dart';
import 'package:stream_chat/src/repository/mapper/general_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('GetOGResponse.toModel maps every field a link preview is built from', () {
    expect(
      _ogResponse().toModel(requestedUrl: 'https://getstream.io/chat'),
      const OGAttachmentResponse(
        duration: '0.01ms',
        ogScrapeUrl: 'https://getstream.io/chat/',
        assetUrl: 'https://getstream.io/chat/intro.mp4',
        authorLink: 'https://getstream.io',
        authorName: 'Stream',
        imageUrl: 'https://getstream.io/chat/og.png',
        text: 'Build real-time chat in less time.',
        thumbUrl: 'https://getstream.io/chat/og-thumb.png',
        title: 'Chat API & SDKs',
        titleLink: 'https://getstream.io/chat/?utm_source=og',
        type: 'video',
      ),
    );
  });
}

// Populates every field [OGAttachmentResponse] carries, each with a distinct value.
api.GetOGResponse _ogResponse() {
  return const api.GetOGResponse(
    duration: '0.01ms',
    ogScrapeUrl: 'https://getstream.io/chat/',
    assetUrl: 'https://getstream.io/chat/intro.mp4',
    authorLink: 'https://getstream.io',
    authorName: 'Stream',
    custom: {},
    imageUrl: 'https://getstream.io/chat/og.png',
    text: 'Build real-time chat in less time.',
    thumbUrl: 'https://getstream.io/chat/og-thumb.png',
    title: 'Chat API & SDKs',
    titleLink: 'https://getstream.io/chat/?utm_source=og',
    type: 'video',
  );
}
