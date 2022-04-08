import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/video/video_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// {@template videoThumbnailImage}
/// Displays a video thumbnail for video attachments in a message.
/// {@endtemplate}
class VideoThumbnailImage extends StatefulWidget {
  /// {@macro videoThumbnailImage}
  const VideoThumbnailImage({
    Key? key,
    required this.video,
    this.width,
    this.height,
    this.fit,
    this.format = ImageFormat.PNG,
    this.errorBuilder,
    this.placeholderBuilder,
  }) : super(key: key);

  /// Video path
  final String video;

  /// Width of widget
  final double? width;

  /// Height of widget
  final double? height;

  /// Fit of image
  final BoxFit? fit;

  /// Image format
  final ImageFormat format;

  /// A builder for building a custom error widget when the thumbnail
  /// creation fails
  final Widget Function(BuildContext, Object?)? errorBuilder;

  /// A builder for building custom thumbnail loading UI
  final WidgetBuilder? placeholderBuilder;

  @override
  _VideoThumbnailImageState createState() => _VideoThumbnailImageState();
}

class _VideoThumbnailImageState extends State<VideoThumbnailImage> {
  late Future<Uint8List?> thumbnailFuture;
  late StreamChatThemeData _streamChatTheme;

  @override
  void initState() {
    super.initState();
    thumbnailFuture = VideoService.generateVideoThumbnail(
      video: widget.video,
      imageFormat: widget.format,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _streamChatTheme = StreamChatTheme.of(context);
  }

  @override
  void didUpdateWidget(covariant VideoThumbnailImage oldWidget) {
    if (oldWidget.video != widget.video || oldWidget.format != widget.format) {
      thumbnailFuture = VideoService.generateVideoThumbnail(
        video: widget.video,
        imageFormat: widget.format,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: thumbnailFuture,
      builder: (context, snapshot) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Builder(
          key: ValueKey<AsyncSnapshot<Uint8List?>>(snapshot),
          builder: (_) {
            if (snapshot.hasError) {
              return widget.errorBuilder?.call(context, snapshot.error) ??
                  Center(
                    child: StreamSvgIcon.error(),
                  );
            }
            if (!snapshot.hasData) {
              return Container(
                constraints: const BoxConstraints.expand(),
                child: widget.placeholderBuilder?.call(context) ??
                    Shimmer.fromColors(
                      baseColor: _streamChatTheme.colorTheme.disabled,
                      highlightColor: _streamChatTheme.colorTheme.inputBg,
                      child: Image.asset(
                        'images/placeholder.png',
                        fit: BoxFit.cover,
                        package: 'stream_chat_flutter',
                      ),
                    ),
              );
            }
            return Image.memory(
              snapshot.data!,
              fit: widget.fit,
              height: widget.height,
              width: widget.width,
            );
          },
        ),
      ),
    );
  }
}
