import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_thumbnail/stream_thumbnail.dart';

Future<void> _pumpThumbnail(WidgetTester tester, Attachment video) {
  return tester.pumpWidget(
    MaterialApp(
      home: StreamChatTheme(
        data: StreamChatThemeData(),
        child: StreamVideoAttachmentThumbnail(video: video, width: 100, height: 100),
      ),
    ),
  );
}

StreamThumbnailSource? _thumbnailSource(WidgetTester tester) {
  final image = tester.widget<Image>(find.byType(Image)).image;
  return image is StreamVideoThumbnailImage ? image.source : null;
}

void main() {
  testWidgets('a video with only an asset URL is thumbnailed from the network', (tester) async {
    await _pumpThumbnail(tester, Attachment(type: 'video', assetUrl: 'https://cdn.example.com/a.mp4'));

    expect(_thumbnailSource(tester), StreamThumbnailSource.network(Uri.parse('https://cdn.example.com/a.mp4')));
  });

  testWidgets('a video with a local file is thumbnailed from the file', (tester) async {
    await _pumpThumbnail(
      tester,
      Attachment(
        type: 'video',
        assetUrl: 'https://cdn.example.com/a.mp4',
        file: AttachmentFile(path: '/videos/a.mp4', size: 100),
      ),
    );

    expect(_thumbnailSource(tester), StreamThumbnailSource.file('/videos/a.mp4'));
  });

  testWidgets('a video whose asset URL cannot be parsed shows the error placeholder', (tester) async {
    await _pumpThumbnail(tester, Attachment(type: 'video', assetUrl: 'http://[invalid'));

    expect(find.byType(StreamImageErrorPlaceholder), findsOneWidget);
  });
}
