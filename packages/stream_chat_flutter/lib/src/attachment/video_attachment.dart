import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro streamVideoAttachment}
@Deprecated("Use 'StreamVideoAttachment' instead")
typedef VideoAttachment = StreamVideoAttachment;

/// {@template streamVideoAttachment}
/// Shows a video attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamVideoAttachment extends StreamAttachmentWidget {
  /// {@macro streamVideoAttachment}
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

  /// The [StreamMessageThemeData] to use for the title
  final StreamMessageThemeData messageTheme;

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
                            mediaAttachmentPackages:
                                message.getAttachmentPackageList(),
                            startIndex: message.attachments.indexOf(attachment),
                            userName: message.user!.name,
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
}
