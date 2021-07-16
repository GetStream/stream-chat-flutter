import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/video_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// Widget for creating video thumbnail image
class VideoThumbnailImage extends StatefulWidget {
  /// Constructor for creating [VideoThumbnailImage]
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

  /// Fit of iamge
  final BoxFit? fit;

  /// Image format
  final ImageFormat format;

  /// Builds widget on error
  final Widget Function(BuildContext, Object?)? errorBuilder;

  /// Builds placeholder
  final WidgetBuilder? placeholderBuilder;

  @override
  _VideoThumbnailImageState createState() => _VideoThumbnailImageState();
}

class _VideoThumbnailImageState extends State<VideoThumbnailImage> {
  late Future<Uint8List?> thumbnailFuture;
  late StreamChatThemeData _streamChatTheme;

  @override
  void initState() {
    thumbnailFuture = VideoService.generateVideoThumbnail(
      video: widget.video,
      imageFormat: widget.format,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _streamChatTheme = StreamChatTheme.of(context);
    super.didChangeDependencies();
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
  Widget build(BuildContext context) => FutureBuilder<Uint8List?>(
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
