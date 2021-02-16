import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'stream_svg_icon.dart';
import 'video_service.dart';

class VideoThumbnailImage extends StatefulWidget {
  final String video;
  final double width;
  final double height;
  final BoxFit fit;
  final ImageFormat format;
  final Widget Function(BuildContext, Object) errorBuilder;
  final WidgetBuilder placeholderBuilder;

  const VideoThumbnailImage({
    Key key,
    @required this.video,
    this.width,
    this.height,
    this.fit,
    this.format = ImageFormat.PNG,
    this.errorBuilder,
    this.placeholderBuilder,
  }) : super(key: key);

  @override
  _VideoThumbnailImageState createState() => _VideoThumbnailImageState();
}

class _VideoThumbnailImageState extends State<VideoThumbnailImage> {
  Future<Uint8List> thumbnailFuture;

  @override
  void initState() {
    thumbnailFuture = VideoService.generateVideoThumbnail(
      video: widget.video,
      imageFormat: widget.format,
    );
    super.initState();
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
    return FutureBuilder<Uint8List>(
      future: thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder(context, snapshot.error);
          }
          return Center(child: StreamSvgIcon.error());
        }
        if (!snapshot.hasData) {
          if (widget.placeholderBuilder != null) {
            return widget.placeholderBuilder(context);
          }
          return Image.asset(
            'images/placeholder.png',
            package: 'stream_chat_flutter',
            fit: widget.fit,
          );
        }
        final data = snapshot.data;
        return Image.memory(
          data,
          fit: widget.fit,
          height: widget.height,
          width: widget.width,
        );
      },
    );
  }
}
