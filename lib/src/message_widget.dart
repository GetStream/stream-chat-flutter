import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/message_input.dart';
import 'package:stream_chat_flutter/src/message_list_view.dart';
import 'package:stream_chat_flutter/src/reaction_picker.dart';
import 'package:stream_chat_flutter/src/stream_channel.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'stream_chat.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_widget.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_widget_paint.png)
///
/// It shows a message with reactions, replies and user avatar.
///
/// Usually you don't use this widget as it's the default message widget used by [MessageListView].
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageWidget extends StatefulWidget {
  const MessageWidget({
    Key key,
    @required this.previousMessage,
    @required this.message,
    @required this.nextMessage,
    this.onThreadTap,
    this.onMessageActions,
    this.isParent = false,
  }) : super(key: key);

  /// Function called on long press
  final Function(BuildContext, Message) onMessageActions;

  /// This message
  final Message message;

  /// The previous message
  final Message previousMessage;

  /// The next message
  final Message nextMessage;

  /// The function called when tapping on replies
  final void Function(Message) onThreadTap;

  /// True if this is the parent of the thread being showed
  final bool isParent;

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget>
    with AutomaticKeepAliveClientMixin {
  final Map<String, ChangeNotifier> _videoControllers = {};
  final Map<String, ChangeNotifier> _chuwieControllers = {};

  MessageTheme messageTheme;
  StreamChatState streamChat;
  StreamChannelState streamChannel;
  bool isMyMessage;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    streamChat = StreamChat.of(context);
    streamChannel = StreamChannel.of(context);

    final currentUserId = streamChat.client.state.user.id;
    final messageUserId = widget.message.user.id;
    final previousUserId = widget.previousMessage?.user?.id;
    final nextUserId = widget.nextMessage?.user?.id;
    final isLastUser = previousUserId == messageUserId;
    final isNextUser = nextUserId == messageUserId;

    isMyMessage = messageUserId == currentUserId;
    final alignment =
        isMyMessage ? Alignment.centerRight : Alignment.centerLeft;

    messageTheme = isMyMessage
        ? StreamChatTheme.of(context).ownMessageTheme
        : StreamChatTheme.of(context).otherMessageTheme;

    Widget child;

    if (widget.message.type == 'deleted') {
      child = _buildDeletedMessage(alignment);
    } else {
      var row = <Widget>[
        Column(
          crossAxisAlignment:
              isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            _buildBubble(context, isLastUser),
            streamChannel.channel.config.replies
                ? _buildThreadIndicator(context)
                : SizedBox(),
            isNextUser ? SizedBox() : _buildTimestamp(alignment),
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

      child = AnimatedContainer(
        duration: Duration(milliseconds: 300),
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

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: child,
    );
  }

  Align _buildDeletedMessage(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 54,
          vertical: 14,
        ),
        child: Text(
          'This message was deleted...',
          style: messageTheme.messageText.copyWith(
            fontStyle: FontStyle.italic,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildThreadIndicator(BuildContext context) {
    var row = [
      Text(
        'Replies: ${widget.message.replyCount}',
        style: messageTheme.replies,
      ),
      Transform(
        transform: Matrix4.rotationY(isMyMessage ? 0 : pi),
        alignment: Alignment.center,
        child: Icon(
          Icons.subdirectory_arrow_left,
          color: Colors.black12,
        ),
      ),
    ];

    if (!isMyMessage) {
      row = row.reversed.toList();
    }

    return widget.message.replyCount > 0
        ? GestureDetector(
            onTap: () {
              if (widget.isParent) {
                return;
              }
              if (widget.onThreadTap != null) {
                widget.onThreadTap(widget.message);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: row,
              ),
            ),
          )
        : SizedBox();
  }

  Widget _buildBubble(
    BuildContext context,
    bool isLastUser,
  ) {
    var nOfAttachmentWidgets = 0;

    final column = Column(
      crossAxisAlignment:
          isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: List<Widget>.from(widget.message.attachments.map((attachment) {
        nOfAttachmentWidgets++;

        Widget attachmentWidget;
        if (attachment.type == 'video') {
          attachmentWidget = _buildVideo(attachment, isLastUser);
        } else if (attachment.type == 'image' || attachment.type == 'giphy') {
          attachmentWidget = _buildImage(isLastUser, attachment);
        }

        if (attachmentWidget != null) {
          final boxDecoration = _buildBoxDecoration(isLastUser)
              .copyWith(color: Color(0xffebebeb));
          return Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: ClipRRect(
              borderRadius: boxDecoration.borderRadius,
              child: Container(
                decoration: boxDecoration,
                constraints: BoxConstraints.loose(Size.fromWidth(300)),
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        attachmentWidget,
                        attachment.title != null
                            ? Container(
                                constraints:
                                    BoxConstraints.loose(Size(300, 500)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        attachment.title,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            messageTheme.messageText.copyWith(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                        style: messageTheme.createdAt,
                                      ),
                                    ],
                                  ),
                                ),
                                color: Color(0xffebebeb),
                              )
                            : SizedBox(),
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
            ),
          );
        }

        nOfAttachmentWidgets--;
        return SizedBox();
      })),
    );

    if (widget.message.text.trim().isNotEmpty) {
      column.children.addAll(
        <Widget>[
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: isMyMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                streamChannel.channel.config.reactions
                    ? Align(
                        child: _buildReactions(),
                        alignment: isMyMessage
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                      )
                    : SizedBox(),
                Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    widget.message.reactionCounts?.isNotEmpty == true
                        ? Positioned(
                            left: isMyMessage ? 8 : null,
                            right: !isMyMessage ? 8 : null,
                            top: -6,
                            child: CustomPaint(
                              painter: ReactionBubblePainter(),
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: EdgeInsets.only(
                        right: isMyMessage ? 0.0 : 8.0,
                        left: isMyMessage ? 8.0 : 0.0,
                      ),
                      child: Container(
                        decoration: _buildBoxDecoration(
                            isLastUser || nOfAttachmentWidgets > 0),
                        padding: EdgeInsets.all(10),
                        constraints: BoxConstraints.loose(Size.fromWidth(300)),
                        child: MarkdownBody(
                          data: '${widget.message.text}',
                          onTapLink: (link) {
                            _launchURL(link);
                          },
                          styleSheet: MarkdownStyleSheet.fromTheme(
                            Theme.of(context).copyWith(
                              textTheme: Theme.of(context).textTheme.apply(
                                    bodyColor: messageTheme.messageText.color,
                                    decoration:
                                        messageTheme.messageText.decoration,
                                    decorationColor: messageTheme
                                        .messageText.decorationColor,
                                    decorationStyle: messageTheme
                                        .messageText.decorationStyle,
                                    fontFamily:
                                        messageTheme.messageText.fontFamily,
                                  ),
                            ),
                          ).copyWith(
                            p: messageTheme.messageText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    return GestureDetector(
        child: column,
        onLongPress: () {
          if (widget.onMessageActions != null) {
            widget.onMessageActions(context, widget.message);
          } else {
            _showMessageBottomSheet(context);
          }
        });
  }

  void _showMessageBottomSheet(BuildContext context) {
    if (!streamChannel.channel.config.reactions &&
        !streamChannel.channel.config.replies) {
      return;
    }

    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        context: context,
        builder: (_) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: Colors.black87,
                  child: streamChannel.channel.config.reactions
                      ? ReactionPicker(
                          channel: StreamChannel.of(context).channel,
                          reactionToEmoji: reactionToEmoji,
                          message: widget.message,
                        )
                      : SizedBox(),
                ),
                isMyMessage
                    ? FlatButton(
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Text(
                            'Delete message',
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(color: Colors.red),
                          ),
                        ),
                        onPressed: () {
                          StreamChat.of(context)
                              .client
                              .deleteMessage(widget.message.id);
                          Navigator.pop(context);
                        },
                      )
                    : SizedBox(),
                isMyMessage
                    ? FlatButton(
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Text(
                            'Edit message',
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);

                          _showEditBottomSheet(context);
                        },
                      )
                    : SizedBox(),
                streamChannel.channel.config.replies
                    ? FlatButton(
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Text(
                            'Start a thread',
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onThreadTap(widget.message);
                        },
                      )
                    : SizedBox(),
              ],
            ),
          );
        });
  }

  void _showEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) {
        return Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Edit message',
                    style: Theme.of(context).textTheme.title,
                  ),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.all(2.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 0,
                        highlightElevation: 0,
                        focusElevation: 0,
                        disabledElevation: 0,
                        hoverElevation: 0,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        fillColor: Colors.black.withOpacity(.1),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: MessageInput(
                editMessage: widget.message,
                parentMessage: widget.isParent
                    ? StreamChannel.of(context)
                        .channel
                        .state
                        .messages
                        .firstWhere(
                            (message) => message.id == widget.message.parentId)
                    : null,
                onMessageSent: (_) {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReactions() {
    return GestureDetector(
      onTap: () {
        if (widget.onMessageActions != null) {
          widget.onMessageActions(context, widget.message);
        } else {
          _showMessageBottomSheet(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: widget.message.reactionCounts?.isNotEmpty == true ? 4.0 : 0,
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          padding: widget.message.reactionCounts?.isNotEmpty == true
              ? const EdgeInsets.all(8)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(14))),
          child: (widget.message.reactionCounts != null &&
                  widget.message.reactionCounts.isNotEmpty)
              ? _buildReactionRow()
              : SizedBox(),
        ),
      ),
    );
  }

  Row _buildReactionRow() {
    final List<Widget> children =
        widget.message.reactionCounts.keys.map((reactionType) {
      return Text(
        reactionToEmoji[reactionType] ?? '?',
      ) as Widget;
    }).toList();

    children.add(Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        widget.message.reactionCounts.values
            .fold(0, (t, v) => v + t)
            .toString(),
        style: TextStyle(color: Colors.white),
      ),
    ));
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }

  final Map<String, String> reactionToEmoji = {
    'love': '❤️️',
    'haha': '😂',
    'like': '👍',
    'sad': '😕',
    'angry': '😡',
    'wow': '😲',
  };

  Widget _buildImage(
    bool isLastUser,
    Attachment attachment,
  ) {
    return CachedNetworkImage(
      imageUrl:
          attachment.thumbUrl ?? attachment.imageUrl ?? attachment.assetUrl,
      fit: BoxFit.cover,
    );
  }

  Widget _buildVideo(
    Attachment attachment,
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

  Widget _buildTimestamp(Alignment alignment) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(
        formatDate(widget.message.createdAt.toLocal(), [HH, ':', nn]),
        style: messageTheme.createdAt,
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(bool isLastUser) {
    return BoxDecoration(
      border: isMyMessage ? null : Border.all(color: Colors.black.withAlpha(8)),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular((isMyMessage || !isLastUser) ? 16 : 2),
        bottomLeft: Radius.circular(isMyMessage ? 16 : 2),
        topRight: Radius.circular((isMyMessage && isLastUser) ? 2 : 16),
        bottomRight: Radius.circular(isMyMessage ? 2 : 16),
      ),
      color: messageTheme.messageBackgroundColor,
    );
  }

  @override
  bool get wantKeepAlive {
    return widget.message.attachments.isNotEmpty;
  }
}

class ReactionBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final path = Path();
    path.arcToPoint(Offset(-6, -6));
    path.arcToPoint(Offset(0, 10));
    path.arcToPoint(Offset(6, -6));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
