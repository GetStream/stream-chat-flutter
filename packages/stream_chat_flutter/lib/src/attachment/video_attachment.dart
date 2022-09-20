import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamVideoAttachment}
/// Shows a video attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamVideoAttachment extends StreamAttachmentWidget {
  /// {@macro streamVideoAttachment}
  const StreamVideoAttachment({
    super.key,
    required super.message,
    required super.attachment,
    required this.messageTheme,
    super.constraints,
    this.onShowMessage,
    this.onReplyMessage,
    this.onAttachmentTap,
  });

  /// The [StreamMessageThemeData] to use for the title
  final StreamMessageThemeData messageTheme;

  /// {@macro showMessageCallback}
  final ShowMessageCallback? onShowMessage;

  /// {@macro replyMessageCallback}
  final ReplyMessageCallback? onReplyMessage;

  /// {@macro onAttachmentTap}
  final OnAttachmentTap? onAttachmentTap;

  @override
  Widget build(BuildContext context) {
    return source.when(
      local: () {
        if (attachment.file == null) {
          return AttachmentError(constraints: constraints);
        }
        return _buildVideoAttachment(
          context,
          StreamVideoThumbnailImage(
            video: attachment.file!.path!,
            constraints: constraints,
            fit: BoxFit.cover,
            errorBuilder: (_, __) => AttachmentError(constraints: constraints),
          ),
        );
      },
      network: () {
        if (attachment.assetUrl == null) {
          return AttachmentError(constraints: constraints);
        }
        return _buildVideoAttachment(
          context,
          StreamVideoThumbnailImage(
            video: attachment.assetUrl!,
            constraints: constraints,
            fit: BoxFit.cover,
            errorBuilder: (_, __) => AttachmentError(constraints: constraints),
          ),
        );
      },
    );
  }

  Widget _buildVideoAttachment(BuildContext context, Widget videoWidget) {
    return ConstrainedBox(
      constraints: constraints ?? const BoxConstraints.expand(),
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: onAttachmentTap ??
                  () async {
                    if (attachment.uploadState == const UploadState.success()) {
                      final channel = StreamChannel.of(context).channel;
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => StreamChannel(
                            channel: channel,
                            child: StreamFullScreenMediaBuilder(
                              mediaAttachmentPackages:
                                  message.getAttachmentPackageList(),
                              startIndex:
                                  message.attachments.indexOf(attachment),
                              userName: message.user!.name,
                              onShowMessage: onShowMessage,
                              onReplyMessage: onReplyMessage,
                            ),
                          ),
                        ),
                      );
                    }
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
        ],
      ),
    );
  }
}
