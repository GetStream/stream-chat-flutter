import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../full_screen_media.dart';
import '../stream_chat_theme.dart';
import '../stream_svg_icon.dart';
import 'attachment_widget.dart';

class GiphyAttachment extends AttachmentWidget {
  final ShowMessageCallback? onShowMessage;
  final ValueChanged<ReturnActionType>? onReturnAction;
  final VoidCallback? onAttachmentTap;

  const GiphyAttachment({
    Key? key,
    required Message message,
    required Attachment attachment,
    Size? size,
    this.onShowMessage,
    this.onReturnAction,
    this.onAttachmentTap,
  }) : super(key: key, message: message, attachment: attachment, size: size);

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        attachment.thumbUrl ?? attachment.imageUrl ?? attachment.assetUrl;
    if (imageUrl == null) {
      return AttachmentError();
    }
    if (attachment.actions.isNotEmpty) {
      return _buildSendingAttachment(context, imageUrl);
    }
    return _buildSentAttachment(context, imageUrl);
  }

  Widget _buildSendingAttachment(BuildContext context, String imageUrl) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    StreamSvgIcon.giphyIcon(),
                    SizedBox(width: 8),
                    Text(
                      'Giphy',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    if (attachment.title != null)
                      Flexible(
                        child: Text(
                          attachment.title!,
                          style: TextStyle(
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .black
                                .withOpacity(0.5),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(
                  onTap: () => onAttachmentTap ?? _onImageTap(context),
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
                    imageUrl: imageUrl,
                    errorWidget: (context, url, error) {
                      return AttachmentError(size: size);
                    },
                    fit: BoxFit.cover,
                  ),
                ),
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
                    child: Container(
                      height: 50,
                      child: TextButton(
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
                    child: Container(
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          streamChannel.channel.sendAction(message, {
                            'image_action': 'shuffle',
                          });
                        },
                        child: Text(
                          'Shuffle',
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
                    child: Container(
                      height: 50,
                      child: TextButton(
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 4.0),
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
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          final channel = StreamChannel.of(context).channel;
          return StreamChannel(
            channel: channel,
            child: FullScreenMedia(
              mediaAttachments: [attachment],
              userName: message.user?.name,
              message: message,
              onShowMessage: onShowMessage,
            ),
          );
        },
      ),
    );
    if (res != null) onReturnAction?.call(res);
  }

  Widget _buildSentAttachment(BuildContext context, String imageUrl) {
    return Container(
      child: GestureDetector(
        onTap: () async {
          final res =
              await Navigator.push(context, MaterialPageRoute(builder: (_) {
            final channel = StreamChannel.of(context).channel;
            return StreamChannel(
              channel: channel,
              child: FullScreenMedia(
                mediaAttachments: [attachment],
                userName: message.user?.name,
                message: message,
                onShowMessage: onShowMessage,
              ),
            );
          }));
          if (res != null) onReturnAction!(res);
        },
        child: Stack(
          children: [
            CachedNetworkImage(
              height: size?.height,
              width: size?.width,
              placeholder: (_, __) {
                final image = Image.asset(
                  'images/placeholder.png',
                  fit: BoxFit.cover,
                  package: 'stream_chat_flutter',
                );

                final colorTheme = StreamChatTheme.of(context).colorTheme;
                return Shimmer.fromColors(
                  baseColor: colorTheme.greyGainsboro,
                  highlightColor: colorTheme.whiteSmoke,
                  child: image,
                );
              },
              imageUrl: imageUrl,
              errorWidget: (context, url, error) {
                return AttachmentError(size: size);
              },
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
