import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/input_attachment.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('InputAttachment shows an image', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: InputAttachment(
                attachment: Attachment(
                  type: 'image',
                  imageUrl: 'https://imgur.com/gallery/ekGggq3',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('InputAttachment shows a video thumbnail', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: InputAttachment(
                attachment: Attachment(
                  type: 'video',
                  assetUrl: 'https://www.youtube.com/watch?v=OEdQXBUPYOE',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(VideoThumbnailImage), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('InputAttachment shows the default UI', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: InputAttachment(
                attachment: Attachment(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ColoredBox), findsOneWidget);
    expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
  });
}
