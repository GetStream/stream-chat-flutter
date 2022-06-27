import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/video/video_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// {@template streamVideoThumbnailImage}
/// Displays a video thumbnail for video attachments in a message.
/// {@endtemplate}
class StreamVideoThumbnailImage extends StatefulWidget {
  /// {@macro streamVideoThumbnailImage}
  const StreamVideoThumbnailImage({
    super.key,
    required this.video,
    this.constraints,
    this.fit,
    this.format = ImageFormat.PNG,
    this.errorBuilder,
    this.placeholderBuilder,
  });

  /// Video path
  final String video;

  /// Contraints of attachments
  final BoxConstraints? constraints;

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
  _StreamVideoThumbnailImageState createState() =>
      _StreamVideoThumbnailImageState();
}

class _StreamVideoThumbnailImageState extends State<StreamVideoThumbnailImage> {
  late Future<Uint8List?> thumbnailFuture;
  late StreamChatThemeData _streamChatTheme;

  @override
  void initState() {
    super.initState();
    thumbnailFuture = StreamVideoService.generateVideoThumbnail(
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
  void didUpdateWidget(covariant StreamVideoThumbnailImage oldWidget) {
    if (oldWidget.video != widget.video || oldWidget.format != widget.format) {
      thumbnailFuture = StreamVideoService.generateVideoThumbnail(
        video: widget.video,
        imageFormat: widget.format,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: widget.constraints ?? const BoxConstraints.expand(),
      child: FutureBuilder<Uint8List?>(
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
                return SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: widget.placeholderBuilder?.call(context) ??
                      Shimmer.fromColors(
                        baseColor: _streamChatTheme.colorTheme.disabled,
                        highlightColor: _streamChatTheme.colorTheme.inputBg,
                        child: Image.asset(
                          'images/placeholder.png',
                          fit: BoxFit.cover,
                          height: widget.constraints?.maxHeight,
                          width: widget.constraints?.maxWidth,
                          package: 'stream_chat_flutter',
                        ),
                      ),
                );
              }
              return SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Image.memory(
                  snapshot.data!,
                  fit: widget.fit,
                  height: widget.constraints?.maxHeight ?? double.infinity,
                  width: widget.constraints?.maxWidth ?? double.infinity,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
