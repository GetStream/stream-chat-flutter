import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_title.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
import 'package:stream_chat_flutter/src/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro video_attachment}
@Deprecated("Use 'StreamVideoAttachment' instead")
typedef VideoAttachment = StreamVideoAttachment;

/// {@template video_attachment}
/// Widget for showing a video attachment
/// {@endtemplate}
class StreamVideoAttachment extends StreamAttachmentWidget {
  /// Constructor for creating a [StreamVideoAttachment] widget
  const StreamVideoAttachment({
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

  /// [StreamMessageThemeData] for showing title
  final StreamMessageThemeData messageTheme;

  /// Callback when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// Callback when attachment is returned to from other screens
  final ValueChanged<ReturnActionType>? onReturnAction;

  /// Callback when attachment is tapped
  final VoidCallback? onAttachmentTap;

  @override
  Widget build(BuildContext context) => source.when(
        local: () {
          if (attachment.file == null) {
            return AttachmentError(size: size);
          }
          return _buildVideoAttachment(
            context,
            StreamVideoThumbnailImage(
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
            StreamVideoThumbnailImage(
              video: attachment.assetUrl!,
              height: size?.height,
              width: size?.width,
              fit: BoxFit.cover,
              errorBuilder: (_, __) => AttachmentError(size: size),
            ),
          );
        },
      );

  Widget _buildVideoAttachment(BuildContext context, Widget videoWidget) =>
      ConstrainedBox(
        constraints: BoxConstraints.loose(size ?? Size.infinite),
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: onAttachmentTap ??
                    () async {
                      final channel = StreamChannel.of(context).channel;
                      final res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StreamChannel(
                            channel: channel,
                            child: StreamFullScreenMedia(
                              mediaAttachments: message.attachments,
                              startIndex:
                                  message.attachments.indexOf(attachment),
                              userName: message.user?.name,
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
                      child: StreamAttachmentUploadStateBuilder(
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
                child: StreamAttachmentTitle(
                  messageTheme: messageTheme,
                  attachment: attachment,
                ),
              ),
          ],
        ),
      );
}
