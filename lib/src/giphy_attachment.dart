import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment_actions.dart';

import '../stream_chat_flutter.dart';
import 'attachment_error.dart';
import 'attachment_title.dart';
import 'full_screen_image.dart';

class GiphyAttachment extends StatelessWidget {
  final Attachment attachment;
  final MessageTheme messageTheme;
  final Message message;
  final Size size;

  const GiphyAttachment({
    Key key,
    this.attachment,
    this.messageTheme,
    this.message,
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

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Stack(
            children: <Widget>[
              GestureDetector(
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
            ],
          ),
          if (attachment.title != null)
            Container(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.white,
                child: AttachmentTitle(
                  messageTheme: messageTheme,
                  attachment: attachment,
                ),
              ),
            ),
          if (attachment.actions != null)
            AttachmentActions(
              attachment: attachment,
              message: message,
            ),
        ],
      ),
    );
  }
}
