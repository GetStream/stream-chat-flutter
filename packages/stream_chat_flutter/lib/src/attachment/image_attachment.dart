import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamImageAttachment}
/// Shows an image attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamImageAttachment extends StreamAttachmentWidget {
  /// {@macro streamImageAttachment}
  const StreamImageAttachment({
    super.key,
    required super.message,
    required super.attachment,
    required this.messageTheme,
    super.constraints,
    this.showTitle = false,
    this.onShowMessage,
    this.onReplyMessage,
    this.onAttachmentTap,
    this.imageThumbnailSize = const Size(400, 400),
    this.imageThumbnailResizeType = 'clip',
    this.imageThumbnailCropType = 'center',
    this.attachmentActionsModalBuilder,
  });

  /// The [StreamMessageThemeData] to use for the image title
  final StreamMessageThemeData messageTheme;

  /// Flag for whether the title should be shown or not
  final bool showTitle;

  /// {@macro showMessageCallback}
  final ShowMessageCallback? onShowMessage;

  /// {@macro replyMessageCallback}
  final ReplyMessageCallback? onReplyMessage;

  /// {@macro onAttachmentTap}
  final OnAttachmentTap? onAttachmentTap;

  /// Size of the attachment image thumbnail.
  final Size imageThumbnailSize;

  /// Resize type of the image attachment thumbnail.
  ///
  /// Defaults to [crop]
  final String /*clip|crop|scale|fill*/ imageThumbnailResizeType;

  /// Crop type of the image attachment thumbnail.
  ///
  /// Defaults to [center]
  final String /*center|top|bottom|left|right*/ imageThumbnailCropType;

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  @override
  Widget build(BuildContext context) {
    return source.when(
      local: () {
        if (attachment.file?.bytes != null) {
          return _buildImageAttachment(
            context,
            Image.memory(
              attachment.file!.bytes!,
              height: constraints?.maxHeight,
              width: constraints?.maxWidth,
              fit: BoxFit.cover,
              errorBuilder: _imageErrorBuilder,
            ),
          );
        } else if (attachment.localUri != null) {
          return _buildImageAttachment(
            context,
            Image.asset(
              attachment.localUri!.path,
              height: constraints?.maxHeight,
              width: constraints?.maxWidth,
              fit: BoxFit.cover,
              errorBuilder: _imageErrorBuilder,
            ),
          );
        } else {
          return AttachmentError(
            constraints: constraints,
          );
        }
      },
      network: () {
        var imageUrl =
            attachment.thumbUrl ?? attachment.imageUrl ?? attachment.assetUrl;

        if (imageUrl == null) {
          return AttachmentError(constraints: constraints);
        }

        imageUrl = imageUrl.getResizedImageUrl(
          width: imageThumbnailSize.width,
          height: imageThumbnailSize.height,
          resize: imageThumbnailResizeType,
          crop: imageThumbnailCropType,
        );

        return _buildImageAttachment(
          context,
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: constraints?.maxHeight,
            width: constraints?.maxWidth,
            fit: BoxFit.cover,
            placeholder: (context, __) {
              final image = Image.asset(
                'images/placeholder.png',
                fit: BoxFit.cover,
                package: 'stream_chat_flutter',
              );
              final colorTheme = StreamChatTheme.of(context).colorTheme;
              return Shimmer.fromColors(
                baseColor: colorTheme.disabled,
                highlightColor: colorTheme.inputBg,
                child: image,
              );
            },
            errorWidget: (context, url, error) =>
                AttachmentError(constraints: constraints),
          ),
        );
      },
    );
  }

  Widget _imageErrorBuilder(BuildContext _, Object __, StackTrace? ___) =>
      Image.asset(
        'images/placeholder.png',
        package: 'stream_chat_flutter',
      );

  Widget _buildImageAttachment(BuildContext context, Widget imageWidget) {
    return Container(
      constraints: constraints,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onAttachmentTap ??
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                final channel =
                                    StreamChannel.of(context).channel;
                                return StreamChannel(
                                  channel: channel,
                                  child: StreamFullScreenMediaBuilder(
                                    mediaAttachmentPackages:
                                        message.getAttachmentPackageList(),
                                    startIndex:
                                        message.attachments.indexOf(attachment),
                                    userName: message.user!.name,
                                    onShowMessage: onShowMessage,
                                    onReplyMessage: onReplyMessage,
                                    attachmentActionsModalBuilder:
                                        attachmentActionsModalBuilder,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                    child: imageWidget,
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
          if (showTitle && attachment.title != null)
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
