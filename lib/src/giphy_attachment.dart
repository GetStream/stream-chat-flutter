import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';
import 'attachment_error.dart';
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

    return attachment.actions != null
        ? _buildSendingAttachment(context)
        : _buildSentAttachment(context);
  }

  Widget _buildSendingAttachment(context) {
    final streamChannel = StreamChannel.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          final channel = StreamChannel.of(context).channel;

                          return StreamChannel(
                            channel: channel,
                            child: FullScreenImage(
                              urls: [
                                attachment.imageUrl ??
                                    attachment.assetUrl ??
                                    attachment.thumbUrl
                              ],
                              userName: message.user.name,
                              sentAt: message.createdAt,
                              message: message,
                            ),
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
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 8.0,
                          bottom: 4.0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              StreamIcons.lightning,
                              color: StreamChatTheme.of(context).accentColor,
                              size: 16.0,
                            ),
                            Text(
                              'GIPHY',
                              style: TextStyle(
                                color: StreamChatTheme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (attachment.title != null)
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 2,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            constraints: BoxConstraints.tight(Size(32, 32)),
                            icon: Icon(
                              StreamIcons.left,
                              size: 24.0,
                            ),
                            splashRadius: 16,
                            onPressed: () {
                              streamChannel.channel.sendAction(message, {
                                'image_action': 'shuffle',
                              });
                            },
                          ),
                          shape: CircleBorder(),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '"${attachment.title}"',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 2,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            constraints: BoxConstraints.tight(Size(32, 32)),
                            icon: Icon(
                              StreamIcons.right,
                              size: 24.0,
                            ),
                            splashRadius: 16,
                            onPressed: () {
                              streamChannel.channel.sendAction(message, {
                                'image_action': 'shuffle',
                              });
                            },
                          ),
                          shape: CircleBorder(),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 4.0,
              ),
              Container(
                color: Colors.black.withOpacity(0.2),
                width: double.infinity,
                height: 0.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: FlatButton(
                      height: 50,
                      onPressed: () {
                        streamChannel.channel.sendAction(message, {
                          'image_action': 'cancel',
                        });
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  Container(
                    width: 0.5,
                    color: Colors.black.withOpacity(0.2),
                    height: 50.0,
                  ),
                  Expanded(
                    child: FlatButton(
                      height: 50,
                      onPressed: () {
                        streamChannel.channel.sendAction(message, {
                          'image_action': 'send',
                        });
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                            color: StreamChatTheme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4.0,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  StreamIcons.eye,
                  color: Colors.black.withOpacity(0.5),
                  size: 16.0,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  'Only visible to you',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentAttachment(context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            var channel = StreamChannel.of(context).channel;

            return StreamChannel(
              channel: channel,
              child: FullScreenImage(
                urls: [
                  attachment.imageUrl ??
                      attachment.assetUrl ??
                      attachment.thumbUrl
                ],
                userName: message.user.name,
                sentAt: message.createdAt,
                message: message,
              ),
            );
          }));
        },
        child: Stack(
          children: [
            CachedNetworkImage(
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
            Positioned(
              bottom: 8,
              left: 8,
              child: Material(
                color: Colors.black.withOpacity(.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        StreamIcons.lightning,
                        color: Colors.white,
                        size: 16,
                      ),
                      Text(
                        'GIPHY',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
