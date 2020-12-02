import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/full_screen_media.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

import 'attachment_error.dart';
import 'attachment_title.dart';

class VideoAttachment extends StatefulWidget {
  final Attachment attachment;
  final MessageTheme messageTheme;
  final Size size;
  final Message message;

  VideoAttachment({
    Key key,
    @required this.attachment,
    @required this.messageTheme,
    this.message,
    this.size,
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
        height: widget.size?.height ?? 100,
        width: widget.size?.width ?? 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        showControls: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (_, e) {
          if (widget.attachment.thumbUrl != null) {
            return Stack(
              children: <Widget>[
                Container(
                  height: widget.size?.height,
                  width: widget.size?.width,
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
            size: widget.size,
          );
        });

    return GestureDetector(
      onTap: () {
        final channel = StreamChannel.of(context).channel;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: FullScreenMedia(
                mediaAttachments: [widget.attachment],
                userName: widget.message.user.name,
                sentAt: widget.message.createdAt,
                message: widget.message,
              ),
            ),
          ),
        );
      },
      child: Container(
        height: widget.size?.height,
        width: widget.size?.width,
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FittedBox(
                fit: BoxFit.none,
                child: Stack(
                  children: <Widget>[
                    Chewie(
                      controller: _chewieController,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Material(
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.play_arrow),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.attachment.title != null)
              Material(
                color: widget.messageTheme.messageBackgroundColor,
                child: AttachmentTitle(
                  messageTheme: widget.messageTheme,
                  attachment: widget.attachment,
                ),
              ),
          ],
        ),
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
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
