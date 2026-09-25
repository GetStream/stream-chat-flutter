import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/response/og_attachment_response.dart';
import 'package:stream_chat/src/repository/mapper/general_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('GetOGResponse.toModel maps every field a link preview is built from', () {
    expect(
      _ogResponse().toModel(),
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

// Populates every field of the generated response, including the ones [OGAttachmentResponse] does not carry.
api.GetOGResponse _ogResponse() {
  const image = api.ImageData(frames: '1', height: '200', size: '1024', url: 'https://giphy.com/1.gif', width: '200');

  return const api.GetOGResponse(
    duration: '0.01ms',
    ogScrapeUrl: 'https://getstream.io/chat/',
    assetUrl: 'https://getstream.io/chat/intro.mp4',
    authorIcon: 'https://getstream.io/favicon.ico',
    authorLink: 'https://getstream.io',
    authorName: 'Stream',
    color: '#005fff',
    custom: {'campaign': 'launch'},
    fallback: 'Stream Chat link preview',
    footer: 'getstream.io',
    footerIcon: 'https://getstream.io/footer.png',
    imageUrl: 'https://getstream.io/chat/og.png',
    originalHeight: 630,
    originalWidth: 1200,
    pretext: 'Stream Chat',
    text: 'Build real-time chat in less time.',
    thumbUrl: 'https://getstream.io/chat/og-thumb.png',
    title: 'Chat API & SDKs',
    titleLink: 'https://getstream.io/chat/?utm_source=og',
    type: 'video',
    actions: [api.Action(name: 'image_action', text: 'Send', type: 'button', style: 'primary', value: 'send')],
    fields: [api.Field(short: true, title: 'Plan', value: 'Free')],
    giphy: api.Images(
      fixedHeight: image,
      fixedHeightDownsampled: image,
      fixedHeightStill: image,
      fixedWidth: image,
      fixedWidthDownsampled: image,
      fixedWidthStill: image,
      original: image,
    ),
  );
}
