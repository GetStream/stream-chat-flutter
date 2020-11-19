import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  final File file;

  const VideoThumbnail({
    Key key,
    @required this.file,
  }) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController _videoPlayerController;
  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_videoPlayerController);
  }

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.file(widget.file)
      ..initialize();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
