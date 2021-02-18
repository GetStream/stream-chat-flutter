import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/full_screen_media.dart';
import 'package:stream_chat_flutter/src/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'attachment_title.dart';
import 'attachment_upload_state_builder.dart';
import 'attachment_widget.dart';

class VideoAttachment extends AttachmentWidget {
  final MessageTheme messageTheme;
  final ShowMessageCallback onShowMessage;
  final ValueChanged<ReturnActionType> onReturnAction;

  const VideoAttachment({
    Key key,
    @required Message message,
    @required Attachment attachment,
    Size size,
    this.messageTheme,
    this.onShowMessage,
    this.onReturnAction,
  }) : super(key: key, message: message, attachment: attachment, size: size);

  @override
  Widget build(BuildContext context) {
    return source.when(
      local: () {
        if (attachment.file == null) {
          return AttachmentError(size: size);
        }
        return _buildVideoAttachment(
          context,
          VideoThumbnailImage(
            video: attachment.file.path,
            height: size?.height,
            width: size?.width,
            fit: BoxFit.cover,
            errorBuilder: (_, __) => AttachmentError(size: size),
          ),
        );
      },
      network: () {
        if (attachment.assetUrl == null) {
          return AttachmentError(size: size);
        }
        return _buildVideoAttachment(
          context,
          VideoThumbnailImage(
            video: attachment.assetUrl,
            height: size?.height,
            width: size?.width,
            fit: BoxFit.cover,
            errorBuilder: (_, __) => AttachmentError(size: size),
          ),
        );
      },
    );
  }

  Widget _buildVideoAttachment(BuildContext context, Widget videoWidget) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(size),
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final channel = StreamChannel.of(context).channel;
                final res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StreamChannel(
                      channel: channel,
                      child: FullScreenMedia(
                        mediaAttachments: [attachment],
                        userName: message.user.name,
                        sentAt: message.createdAt,
                        message: message,
                        onShowMessage: onShowMessage,
                      ),
                    ),
                  ),
                );
                if (res != null) onReturnAction(res);
              },
              child: Stack(
                children: [
                  videoWidget,
                  Center(
                    child: Material(
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(Icons.play_arrow),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AttachmentUploadStateBuilder(
                      message: message,
                      attachment: attachment,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (attachment.title != null)
            Material(
              color: messageTheme.messageBackgroundColor,
              child: AttachmentTitle(
                messageTheme: messageTheme,
                attachment: attachment,
              ),
            ),
        ],
      ),
    );
  }
}
