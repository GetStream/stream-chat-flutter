import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'message_list_view.dart';
import 'stream_chat.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    Key key,
    @required this.previousMessage,
    @required this.message,
    @required this.nextMessage,
    this.onThreadSelect,
  }) : super(key: key);

  final Message previousMessage;
  final Message message;
  final Message nextMessage;
  final OnThreadSelectCallback onThreadSelect;

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget>
    with AutomaticKeepAliveClientMixin {
  final Map<String, ChangeNotifier> _videoControllers = {};
  final Map<String, ChangeNotifier> _chuwieControllers = {};

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final streamChat = StreamChat.of(context);
    final currentUserId = streamChat.user.id;
    final messageUserId = widget.message.user.id;
    final previousUserId = widget.previousMessage?.user?.id;
    final nextUserId = widget.nextMessage?.user?.id;
    final isMyMessage = messageUserId == currentUserId;
    final isLastUser = previousUserId == messageUserId;
    final isNextUser = nextUserId == messageUserId;
    final alignment =
        isMyMessage ? Alignment.centerRight : Alignment.centerLeft;

    var row = <Widget>[
      Column(
        crossAxisAlignment:
            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          _buildBubble(context, isMyMessage, isLastUser),
          widget.message.replyCount > 0
              ? GestureDetector(
                  onTap: () {
                    if (widget.onThreadSelect != null) {
                      widget.onThreadSelect(widget.message);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Replies: ${widget.message.replyCount}',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.blue),
                        ),
                        Icon(
                          Icons.subdirectory_arrow_left,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          isNextUser ? Container() : _buildTimestamp(isMyMessage, alignment),
        ],
      ),
      isNextUser
          ? Container(
              width: 40,
            )
          : Padding(
              padding: EdgeInsets.only(
                left: isMyMessage ? 8.0 : 0,
                right: isMyMessage ? 0 : 8.0,
              ),
              child: UserAvatar(user: widget.message.user),
            ),
    ];

    if (!isMyMessage) {
      row = row.reversed.toList();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(
        top: isLastUser ? 5 : 24,
        bottom: widget.nextMessage == null ? 30 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: row,
      ),
    );
  }

  Widget _buildBubble(
    BuildContext context,
    bool isMyMessage,
    bool isLastUser,
  ) {
    var nOfAttachmentWidgets = 0;

    final column = Column(
      crossAxisAlignment:
          isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: widget.message.attachments.map((attachment) {
        nOfAttachmentWidgets++;

        Widget attachmentWidget;
        if (attachment.type == 'video') {
          attachmentWidget = _buildVideo(attachment, isMyMessage, isLastUser);
        } else if (attachment.type == 'image' || attachment.type == 'giphy') {
          attachmentWidget = _buildImage(isMyMessage, isLastUser, attachment);
        }

        if (attachmentWidget != null) {
          final boxDecoration = _buildBoxDecoration(isMyMessage, isLastUser)
              .copyWith(color: Color(0xffebebeb));
          return ClipRRect(
            borderRadius: boxDecoration.borderRadius,
            child: Container(
              decoration: boxDecoration,
              constraints: BoxConstraints.loose(Size.fromWidth(300)),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      attachmentWidget,
                      attachment.title != null
                          ? Container(
                              constraints:
                                  BoxConstraints.loose(Size.fromHeight(70)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      attachment.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle
                                          .copyWith(color: Colors.blue),
                                    ),
                                    Text(
                                      Uri.parse(attachment.thumbUrl)
                                          .authority
                                          .split('.')
                                          .reversed
                                          .take(2)
                                          .toList()
                                          .reversed
                                          .join('.'),
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                              ),
                              color: Color(0xffebebeb),
                            )
                          : Container(),
                    ],
                  ),
                  attachment.type == 'image' && attachment.titleLink != null
                      ? Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _launchURL(attachment.titleLink),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              margin: EdgeInsets.only(
                top: nOfAttachmentWidgets > 1 ? 5 : 0,
              ),
            ),
          );
        }

        nOfAttachmentWidgets--;
        return Container();
      }).toList(),
    );

    if (widget.message.text.trim().isNotEmpty) {
      column.children.add(Container(
        margin: EdgeInsets.only(
          top: nOfAttachmentWidgets > 0 ? 5 : 0,
        ),
        decoration: _buildBoxDecoration(
            isMyMessage, isLastUser || nOfAttachmentWidgets > 0),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints.loose(Size.fromWidth(300)),
        child: MarkdownBody(
          data: '${widget.message.text}',
          onTapLink: (link) {
            _launchURL(link);
          },
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        ),
      ));
    }

    return column;
  }

  Widget _buildImage(
    bool isMyMessage,
    bool isLastUser,
    Attachment attachment,
  ) {
    return CachedNetworkImage(
      imageUrl: attachment.thumbUrl ?? attachment.imageUrl,
      fit: BoxFit.cover,
    );
  }

  Widget _buildVideo(
    Attachment attachment,
    bool isMyMessage,
    bool isLastUser,
  ) {
    VideoPlayerController videoController;
    if (_videoControllers.containsKey(attachment.assetUrl)) {
      videoController = _videoControllers[attachment.assetUrl];
    } else {
      videoController = VideoPlayerController.network(attachment.assetUrl);
      _videoControllers[attachment.assetUrl] = videoController;
    }

    ChewieController chewieController;
    if (_chuwieControllers.containsKey(attachment.assetUrl)) {
      chewieController = _chuwieControllers[attachment.assetUrl];
    } else {
      chewieController = ChewieController(
          videoPlayerController: videoController,
          autoInitialize: true,
          errorBuilder: (_, e) {
            return Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        attachment.thumbUrl,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _launchURL(attachment.titleLink),
                  ),
                ),
              ],
            );
          });
      _chuwieControllers[attachment.assetUrl] = chewieController;
    }

    return Chewie(
      key: ValueKey<String>(
          'ATTACHMENT-${attachment.title}-${widget.message.id}'),
      controller: chewieController,
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot launch the url'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _videoControllers.values.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  Widget _buildTimestamp(bool isMyMessage, Alignment alignment) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(
        formatDate(widget.message.createdAt.toLocal(), [HH, ':', nn]),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(bool isMyMessage, bool isLastUser) {
    return BoxDecoration(
      border: isMyMessage ? null : Border.all(color: Colors.black.withAlpha(8)),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular((isMyMessage || !isLastUser) ? 16 : 2),
        bottomLeft: Radius.circular(isMyMessage ? 16 : 2),
        topRight: Radius.circular((isMyMessage && isLastUser) ? 2 : 16),
        bottomRight: Radius.circular(isMyMessage ? 2 : 16),
      ),
      color: isMyMessage ? Color(0xffebebeb) : Colors.white,
    );
  }

  @override
  bool get wantKeepAlive {
    return widget.message.attachments.isNotEmpty;
  }
}
