import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template videoAttachment}
/// Shows a video attachment in a [MessageWidget].
/// {@endtemplate}
class VideoAttachment extends AttachmentWidget {
  /// {@macro videoAttachment}
  const VideoAttachment({
    Key? key,
    required Message message,
    required Attachment attachment,
    required this.messageTheme,
    Size? size,
    this.onShowMessage,
    this.onReturnAction,
    this.onAttachmentTap,
  }) : super(
          key: key,
          message: message,
          attachment: attachment,
          size: size,
        );

  /// The [MessageThemeData] to use for the title
  final MessageThemeData messageTheme;

  /// {@macro showMessageCallback}
  final ShowMessageCallback? onShowMessage;

  /// {@macro onReturnAction}
  final OnReturnAction? onReturnAction;

  /// {@macro onAttachmentTap}
  final OnAttachmentTap? onAttachmentTap;

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
            video: attachment.file!.path!,
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
            video: attachment.assetUrl!,
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
      constraints: BoxConstraints.loose(size ?? Size.infinite),
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: onAttachmentTap ??
                  () async {
                    final channel = StreamChannel.of(context).channel;
                    final res = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StreamChannel(
                          channel: channel,
                          child: FullScreenMediaBuilder(
                            mediaAttachments: message.attachments,
                            startIndex: message.attachments.indexOf(attachment),
                            userName: message.user!.name,
                            message: message,
                            onShowMessage: onShowMessage,
                          ),
                        ),
                      ),
                    );
                    if (res != null) onReturnAction?.call(res);
                  },
              child: Stack(
                children: [
                  videoWidget,
                  const Center(
                    child: Material(
                      shape: CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Icon(Icons.play_arrow),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
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
