import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_upload_state_builder.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:transparent_image/transparent_image.dart';

import 'attachment_title.dart';
import '../full_screen_media.dart';
import '../stream_chat_theme.dart';
import 'attachment_widget.dart';

class ImageAttachment extends AttachmentWidget {
  final MessageTheme messageTheme;
  final bool showTitle;
  final ShowMessageCallback onShowMessage;
  final ValueChanged<ReturnActionType> onReturnAction;
  final VoidCallback onAttachmentTap;

  const ImageAttachment({
    Key key,
    @required Message message,
    @required Attachment attachment,
    Size size,
    this.messageTheme,
    this.showTitle = false,
    this.onShowMessage,
    this.onReturnAction,
    this.onAttachmentTap,
  }) : super(key: key, message: message, attachment: attachment, size: size);

  @override
  Widget build(BuildContext context) {
    return source.when(
      local: () {
        if (attachment.localUri == null) {
          return AttachmentError(size: size);
        }
        return _buildImageAttachment(
          context,
          Image.memory(
            attachment.file.bytes,
            height: size?.height,
            width: size?.width,
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) {
              return Image.asset(
                'images/placeholder.png',
                package: 'stream_chat_flutter',
              );
            },
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
        if (imageUri.host == 'stream-io-cdn.com') {
          imageUri = imageUri.replace(queryParameters: {
            ...imageUri.queryParameters,
            'h': '500',
            'w': '500',
            'crop': 'center',
            'resize': 'crop',
          });
        } else if (imageUri.host == 'stream-cloud-uploads.imgix.net') {
          imageUri = imageUri.replace(queryParameters: {
            ...imageUri.queryParameters,
            'height': '500',
            'width': '500',
            'fit': 'crop',
          });
        }
        imageUrl = imageUri.toString();

        return _buildImageAttachment(
          context,
          CachedNetworkImage(
            height: size?.height,
            width: size?.width,
            placeholder: (_, __) {
              return Image.asset(
                'images/placeholder.png',
                fit: BoxFit.cover,
                package: 'stream_chat_flutter',
              );
            },
            imageUrl: imageUrl,
            errorWidget: (context, url, error) {
              return AttachmentError(size: size);
            },
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget _buildImageAttachment(BuildContext context, Widget imageWidget) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(size),
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
                              final channel = StreamChannel.of(context).channel;
                              return StreamChannel(
                                channel: channel,
                                child: FullScreenMedia(
                                  mediaAttachments: [attachment],
                                  userName: message.user.name,
                                  sentAt: message.createdAt,
                                  message: message,
                                  onShowMessage: onShowMessage,
                                ),
                              );
                            },
                          ),
                        );
                        if (result != null) onReturnAction(result);
                      },
                  child: imageWidget,
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
          if (showTitle && attachment.title != null)
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
