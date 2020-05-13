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
  final Size size;

  const ImageAttachment({
    Key key,
    this.attachment,
    this.messageTheme,
    this.size,
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
    return SizedBox.fromSize(
      size: size,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: attachment.imageUrl ??
                      attachment.assetUrl ??
                      attachment.thumbUrl,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return FullScreenImage(
                          url: attachment.imageUrl ??
                              attachment.assetUrl ??
                              attachment.thumbUrl,
                        );
                      }));
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
              ),
              if (attachment.title != null)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      child: AttachmentTitle(
                        messageTheme: messageTheme,
                        attachment: attachment,
                      ),
                    ),
                  ),
                ),
            ],
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
    );
  }
}
