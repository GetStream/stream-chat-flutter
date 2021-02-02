import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/full_screen_media.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'attachment_title.dart';

class VideoAttachment extends StatefulWidget {
  final Attachment attachment;
  final MessageTheme messageTheme;
  final Size size;
  final Message message;
  final ShowMessageCallback onShowMessage;
  final ValueChanged<ReturnActionType> onReturnAction;
  final VideoPackage videoPackage;

  VideoAttachment({
    Key key,
    @required this.attachment,
    @required this.messageTheme,
    this.videoPackage,
    this.message,
    this.size,
    this.onShowMessage,
    this.onReturnAction,
  }) : super(key: key);

  @override
  _VideoAttachmentState createState() => _VideoAttachmentState();
}

class _VideoAttachmentState extends State<VideoAttachment> {
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    widget.videoPackage.onInit = () {
      setState(() {
        initialized = true;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.videoPackage.initialised) {
      return Container(
        height: widget.size?.height ?? 100,
        width: widget.size?.width ?? 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return GestureDetector(
      onTap: () async {
        final channel = StreamChannel.of(context).channel;

        var res = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: FullScreenMedia(
                mediaAttachments: [widget.attachment],
                userName: widget.message.user.name,
                sentAt: widget.message.createdAt,
                message: widget.message,
                onShowMessage: widget.onShowMessage,
              ),
            ),
          ),
        );

        if (res != null) {
          widget.onReturnAction(res);
        }
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
                      controller: widget.videoPackage.chewieController,
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
}
