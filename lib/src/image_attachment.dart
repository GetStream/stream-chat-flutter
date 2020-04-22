import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';
import 'attachment_error.dart';
import 'attachment_title.dart';
import 'full_screen_image.dart';
import 'utils.dart';

class ImageAttachment extends StatelessWidget {
  final Attachment attachment;
  final MessageTheme messageTheme;

  const ImageAttachment({
    Key key,
    this.attachment,
    this.messageTheme,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Hero(
              tag: attachment.imageUrl ??
                  attachment.assetUrl ??
                  attachment.thumbUrl,
              child: CachedNetworkImage(
                imageBuilder: (context, provider) {
                  return GestureDetector(
                    child: Image(image: provider),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return FullScreenImage(
                          url: attachment.imageUrl ??
                              attachment.assetUrl ??
                              attachment.thumbUrl,
                        );
                      }));
                    },
                  );
                },
                placeholder: (_, __) {
                  return Container(
                    width: 200,
                    height: 140,
                  );
                },
                imageUrl: attachment.thumbUrl ??
                    attachment.imageUrl ??
                    attachment.assetUrl,
                errorWidget: (context, url, error) => AttachmentError(
                  attachment: attachment,
                ),
                fit: BoxFit.cover,
              ),
            ),
            if (attachment.titleLink != null || attachment.ogScrapeUrl != null)
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
        if (attachment.title != null)
          AttachmentTitle(
            messageTheme: messageTheme,
            attachment: attachment,
          ),
      ],
    );
  }
}
