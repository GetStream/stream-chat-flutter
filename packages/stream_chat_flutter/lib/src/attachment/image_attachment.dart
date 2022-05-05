import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_title.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
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
    Key? key,
    required Message message,
    required Attachment attachment,
    required this.messageTheme,
    Size? size,
    this.showTitle = false,
    this.onShowMessage,
    this.onReturnAction,
    this.onAttachmentTap,
  }) : super(
          key: key,
          message: message,
          attachment: attachment,
          size: size,
        );

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

          if (imageUrl == null) {
            return AttachmentError(size: size);
          }

          var imageUri = Uri.parse(imageUrl);
          if (imageUri.host.endsWith('stream-io-cdn.com') &&
              imageUri.queryParameters['h'] == '*' &&
              imageUri.queryParameters['w'] == '*' &&
              imageUri.queryParameters['crop'] == '*' &&
              imageUri.queryParameters['resize'] == '*') {
            imageUri = imageUri.replace(queryParameters: {
              ...imageUri.queryParameters,
              'h': '400',
              'w': '400',
              'crop': 'center',
              'resize': 'crop',
            });
          } else if (imageUri.host.endsWith('stream-cloud-uploads.imgix.net')) {
            imageUri = imageUri.replace(queryParameters: {
              ...imageUri.queryParameters,
              'height': '400',
              'width': '400',
              'fit': 'crop',
            });
          }
          imageUrl = imageUri.toString();

          return _buildImageAttachment(
            context,
            CachedNetworkImage(
              cacheKey: imageUri.replace(queryParameters: {}).toString(),
              height: size?.height,
              width: size?.width,
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
              imageUrl: imageUrl,
              errorWidget: (context, url, error) => AttachmentError(size: size),
              fit: BoxFit.cover,
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
