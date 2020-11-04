import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
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
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            left: 4.0, right: 4.0, top: 6.0, bottom: 2.0),
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
                  child: Material(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          child: IconButton(
                            icon: Icon(
                              StreamIcons.left,
                              size: 24.0,
                            ),
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
                          child: IconButton(
                            icon: Icon(
                              StreamIcons.right,
                              size: 24.0,
                            ),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlatButton(
                    onPressed: () {
                      streamChannel.channel.sendAction(message, {
                        'image_action': 'cancel',
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 0.5,
                    color: Colors.black.withOpacity(0.2),
                    height: 50.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      streamChannel.channel.sendAction(message, {
                        'image_action': 'send',
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Send',
                          style: TextStyle(
                              color: StreamChatTheme.of(context).accentColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
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
      child: Column(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(
                      StreamIcons.lightning,
                      color: StreamChatTheme.of(context).accentColor,
                      size: 15.0,
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
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          )
        ],
      ),
    );
  }
}
