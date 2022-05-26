import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro streamImageAttachment}
@Deprecated("use 'StreamImageAttachment' instead")
typedef ImageAttachment = StreamImageAttachment;

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
    super.size,
    this.showTitle = false,
    this.onShowMessage,
    this.onReturnAction,
    this.onAttachmentTap,
  });

  /// The [StreamMessageThemeData] to use for the image title
  final StreamMessageThemeData messageTheme;

  /// Flag for whether the title should be shown or not
  final bool showTitle;

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
  }

  Widget _buildImageAttachment(BuildContext context, Widget imageWidget) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(size!),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onAttachmentTap ??
                        () async {
                          final result = await Navigator.of(context).push(
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
                                  ),
                                );
                              },
                            ),
                          );
                          if (result != null) onReturnAction?.call(result);
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
