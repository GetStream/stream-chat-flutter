import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A CDN that leaves every URL alone, the way an integrator disables
/// resizing without giving up the rest of the SDK.
class _NoResizeImageCDN extends StreamImageCDN {
  const _NoResizeImageCDN();

  @override
  String resolveUrl(String sourceUrl, {ImageResize? resize}) => sourceUrl;
}

/// A CDN pointing at something that is not Stream's.
class _CustomHostImageCDN extends StreamImageCDN {
  const _CustomHostImageCDN();

  @override
  String resolveUrl(String sourceUrl, {ImageResize? resize}) =>
      '$sourceUrl?width=${resize?.width.floor()}';

  @override
  String cacheKey(String imageUrl) => imageUrl.split('?').first;
}

/// Pumps the thumbnail for an uploaded image of a known original size, so the
/// size calculator has an aspect ratio to work from.
Future<void> _pumpThumbnail(
  WidgetTester tester, {
  StreamImageCDN? imageCDN,
  String url = 'https://us-east.stream-io-cdn.com/1/images/a.jpg',
}) {
  final image = Attachment(
    type: AttachmentType.image,
    imageUrl: url,
    originalWidth: 1000,
    originalHeight: 1000,
  );

  return tester.pumpWidget(
    MaterialApp(
      home: StreamChatConfiguration(
        data: StreamChatConfigurationData(
          imageCDN: imageCDN ?? const StreamImageCDN(),
        ),
        child: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: StreamImageAttachmentThumbnail(image: image),
            ),
          ),
        ),
      ),
    ),
  );
}

CachedNetworkImage _networkImage(WidgetTester tester) =>
    tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));

void main() {
  testWidgets('requests a resized URL from the default CDN', (tester) async {
    await _pumpThumbnail(tester);

    expect(_networkImage(tester).imageUrl, contains('resize=clip'));
    expect(_networkImage(tester).imageUrl, contains('w='));
  });

  testWidgets('uses the resolveUrl of a custom CDN', (tester) async {
    await _pumpThumbnail(tester, imageCDN: const _CustomHostImageCDN());

    expect(_networkImage(tester).imageUrl, contains('width='));
    expect(_networkImage(tester).imageUrl, isNot(contains('resize=')));
  });

  testWidgets('uses the cacheKey of a custom CDN', (tester) async {
    await _pumpThumbnail(tester, imageCDN: const _CustomHostImageCDN());

    expect(
      _networkImage(tester).cacheKey,
      equals('https://us-east.stream-io-cdn.com/1/images/a.jpg'),
    );
  });

  testWidgets('leaves the URL untouched when resizing is overridden off',
      (tester) async {
    const url = 'https://us-east.stream-io-cdn.com/1/images/a.jpg';

    await _pumpThumbnail(tester, imageCDN: const _NoResizeImageCDN());

    expect(_networkImage(tester).imageUrl, equals(url));
  });
}
