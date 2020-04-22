import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

import 'attachment_error.dart';
import 'attachment_title.dart';

class VideoAttachment extends StatefulWidget {
  final Attachment attachment;
  final bool enableFullScreen;
  final MessageTheme messageTheme;

  VideoAttachment({
    Key key,
    @required this.attachment,
    @required this.messageTheme,
    this.enableFullScreen = true,
  }) : super(key: key);

  @override
  _VideoAttachmentState createState() => _VideoAttachmentState();
}

class _VideoAttachmentState extends State<VideoAttachment> {
  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      return Container(
        height: 100,
        width: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    _chewieController = ChewieController(
        allowFullScreen: widget.enableFullScreen,
        videoPlayerController: _videoPlayerController,
        autoInitialize: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (_, e) {
          if (widget.attachment.thumbUrl != null) {
            return Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        widget.attachment.thumbUrl,
                      ),
                    ),
                  ),
                ),
                if (widget.attachment.titleLink != null)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          launchURL(context, widget.attachment.titleLink),
                    ),
                  ),
              ],
            );
          }
          return AttachmentError(
            attachment: widget.attachment,
          );
        });

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Chewie(
          controller: _chewieController,
        ),
        if (widget.attachment.title != null)
          AttachmentTitle(
            messageTheme: widget.messageTheme,
            attachment: widget.attachment,
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
        widget.attachment.localUri ?? widget.attachment.assetUrl);
    _videoPlayerController.initialize().whenComplete(() {
      setState(() {
        initialized = true;
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
