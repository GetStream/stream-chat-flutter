import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

import 'utils.dart';

class FullScreenVideo extends StatefulWidget {
  final Attachment attachment;

  FullScreenVideo({
    Key key,
    @required this.attachment,
  }) : super(key: key);

  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;
  bool initialized = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Builder(
        key: _scaffoldKey,
        builder: (context) {
          if (!initialized) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Chewie(
            controller: _chewieController,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(widget.attachment.assetUrl);
    _videoPlayerController.initialize().whenComplete(() {
      setState(() {
        initialized = true;
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoInitialize: false,
          aspectRatio: _videoPlayerController.value.aspectRatio,
        );
      });
    });

    VoidCallback errorListener;
    errorListener = () {
      if (_videoPlayerController.value.hasError) {
        Navigator.pop(context);
        launchURL(_scaffoldKey.currentContext, widget.attachment.titleLink);
      }
      _videoPlayerController.removeListener(errorListener);
    };
    _videoPlayerController.addListener(errorListener);
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
