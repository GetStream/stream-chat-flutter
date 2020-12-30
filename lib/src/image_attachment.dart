import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';
import 'attachment_error.dart';
import 'attachment_title.dart';
import 'full_screen_media.dart';
import 'utils.dart';

class ImageAttachment extends StatelessWidget {
  final Attachment attachment;
  final Message message;
  final MessageTheme messageTheme;
  final Size size;
  final bool showTitle;

  const ImageAttachment({
    Key key,
    @required this.attachment,
    @required this.message,
    @required this.size,
    this.messageTheme,
    this.showTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (attachment.thumbUrl == null &&
        attachment.imageUrl == null &&
        attachment.assetUrl == null) {
      return AttachmentError(
        attachment: attachment,
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints.loose(size),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          final channel = StreamChannel.of(context).channel;

                          return StreamChannel(
                            channel: channel,
                            child: FullScreenMedia(
                              mediaAttachments: [
                                attachment,
                              ],
                              userName: message.user.name,
                              sentAt: message.createdAt,
                              message: message,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    height: size?.height,
                    width: size?.width,
                    placeholder: (_, __) {
                      return Container(
                        width: size?.width,
                        height: size?.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    imageUrl: attachment.thumbUrl ??
                        attachment.imageUrl ??
                        attachment.assetUrl,
                    errorWidget: (context, url, error) => AttachmentError(
                      attachment: attachment,
                      size: size,
                    ),
                    fit: BoxFit.cover,
                  ),
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
          if (showTitle &&
              (attachment.titleLink != null || attachment.ogScrapeUrl != null))
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => launchURL(
                    context,
                    attachment.titleLink ?? attachment.ogScrapeUrl,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
