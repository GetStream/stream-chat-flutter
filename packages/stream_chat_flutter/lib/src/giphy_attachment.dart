import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';

import '../stream_chat_flutter.dart';
import 'attachment_error.dart';
import 'full_screen_media.dart';

class GiphyAttachment extends StatelessWidget {
  final Attachment attachment;
  final MessageTheme messageTheme;
  final Message message;
  final Size size;
  final ShowMessageCallback onShowMessage;
  final ValueChanged<ReturnActionType> onReturnAction;

  const GiphyAttachment({
    Key key,
    this.attachment,
    this.messageTheme,
    this.message,
    this.size,
    this.onShowMessage,
    this.onReturnAction,
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
          color: StreamChatTheme.of(context).colorTheme.white,
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
                      onTap: () async {
                        _onImageTap(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
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
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Material(
                      color: StreamChatTheme.of(context)
                          .colorTheme
                          .black
                          .withOpacity(.5),
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
                            StreamSvgIcon.lightning(
                              color:
                                  StreamChatTheme.of(context).colorTheme.white,
                              size: 16,
                            ),
                            Text(
                              'GIPHY',
                              style: TextStyle(
                                color: StreamChatTheme.of(context)
                                    .colorTheme
                                    .white,
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
              if (attachment.title != null)
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 2,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            constraints: BoxConstraints.tight(Size(32, 32)),
                            icon: StreamSvgIcon.left(
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
                          color: Colors.white,
                          elevation: 2,
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            constraints: BoxConstraints.tight(Size(32, 32)),
                            icon: StreamSvgIcon.right(
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
                color: StreamChatTheme.of(context)
                    .colorTheme
                    .black
                    .withOpacity(0.2),
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
                        style: StreamChatTheme.of(context)
                            .textTheme
                            .bodyBold
                            .copyWith(
                              color: StreamChatTheme.of(context)
                                  .colorTheme
                                  .black
                                  .withOpacity(0.5),
                            ),
                      ),
                    ),
                  ),
                  Container(
                    width: 0.5,
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .black
                        .withOpacity(0.2),
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
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .accentBlue,
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
                StreamSvgIcon.eye(
                  color: StreamChatTheme.of(context)
                      .colorTheme
                      .black
                      .withOpacity(0.5),
                  size: 16.0,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  'Only visible to you',
                  style: StreamChatTheme.of(context)
                      .textTheme
                      .footnote
                      .copyWith(
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .black
                              .withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onImageTap(BuildContext context) async {
    var res = await Navigator.push(context, MaterialPageRoute(
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
            onShowMessage: onShowMessage,
          ),
        );
      },
    ));

    if (res != null) {
      onReturnAction(res);
    }
  }

  Widget _buildSentAttachment(context) {
    return Container(
      child: GestureDetector(
        onTap: () async {
          var res =
              await Navigator.push(context, MaterialPageRoute(builder: (_) {
            var channel = StreamChannel.of(context).channel;

            return StreamChannel(
              channel: channel,
              child: FullScreenMedia(
                mediaAttachments: [
                  attachment,
                ],
                userName: message.user.name,
                sentAt: message.createdAt,
                message: message,
                onShowMessage: onShowMessage,
              ),
            );
          }));

          if (res != null) {
            onReturnAction(res);
          }
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
                color: StreamChatTheme.of(context)
                    .colorTheme
                    .black
                    .withOpacity(.5),
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
                      StreamSvgIcon.lightning(
                        color: StreamChatTheme.of(context).colorTheme.white,
                        size: 16,
                      ),
                      Text(
                        'GIPHY',
                        style: TextStyle(
                          color: StreamChatTheme.of(context).colorTheme.white,
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
