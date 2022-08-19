import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_title.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro image_attachment}
@Deprecated("use 'StreamImageAttachment' instead")
typedef ImageAttachment = StreamImageAttachment;

/// {@template image_attachment}
/// Widget for showing an image attachment
/// {@endtemplate}
class StreamImageAttachment extends StreamAttachmentWidget {
  /// Constructor for creating a [StreamImageAttachment] widget
  const StreamImageAttachment({
    super.key,
    required super.message,
    required super.attachment,
    required this.messageTheme,
    super.size,
    this.showTitle = false,
    this.onShowMessage,
    this.onReturnAction,
    this.onAttachmentTap,
    this.imageThumbnailSize = const Size(400, 400),
    this.imageThumbnailResizeType = 'crop',
    this.imageThumbnailCropType = 'center',
  });

  /// [StreamMessageThemeData] for showing image title
  final StreamMessageThemeData messageTheme;

  /// Flag for showing title
  final bool showTitle;

  /// Callback when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// Callback when attachment is returned to from other screens
  final ValueChanged<ReturnActionType>? onReturnAction;

  /// Callback when attachment is tapped
  final VoidCallback? onAttachmentTap;

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

  @override
  Widget build(BuildContext context) => source.when(
        local: () {
          if (attachment.localUri == null || attachment.file?.bytes == null) {
            return AttachmentError(size: size);
          }
          return _buildImageAttachment(
            context,
            Image.memory(
              attachment.file!.bytes!,
              height: size?.height,
              width: size?.width,
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) => Image.asset(
                'images/placeholder.png',
                package: 'stream_chat_flutter',
              ),
            ),
          );
        },
        network: () {
          var imageUrl =
              attachment.thumbUrl ?? attachment.imageUrl ?? attachment.assetUrl;

          if (imageUrl == null) return AttachmentError(size: size);

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
              height: size?.height,
              width: size?.width,
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
              errorWidget: (context, url, error) => AttachmentError(size: size),
            ),
          );
        },
      );

  Widget _buildImageAttachment(BuildContext context, Widget imageWidget) =>
      ConstrainedBox(
        constraints: BoxConstraints.loose(size!),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: onAttachmentTap ??
                        () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                final channel =
                                    StreamChannel.of(context).channel;
                                return StreamChannel(
                                  channel: channel,
                                  child: StreamFullScreenMedia(
                                    mediaAttachmentPackages:
                                        message.getAttachmentPackageList(),
                                    startIndex:
                                        message.attachments.indexOf(attachment),
                                    userName: message.user?.name,
                                    onShowMessage: onShowMessage,
                                  ),
                                );
                              },
                            ),
                          );
                          if (result != null) onReturnAction?.call(result);
                        },
                    child: imageWidget,
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
