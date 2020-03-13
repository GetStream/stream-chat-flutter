import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/full_screen_image.dart';
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
    this.onMentionTap,
  }) : super(key: key);

  /// Function called on mention tap
  final void Function(User) onMentionTap;

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
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final Map<String, ChangeNotifier> _videoControllers = {};
  final Map<String, ChangeNotifier> _chuwieControllers = {};

  MessageTheme _messageTheme;
  StreamChatState _streamChat;
  StreamChannelState _streamChannel;
  bool _isMyMessage;

  String _currentUserId;
  String _messageUserId;
  String _previousUserId;
  String _nextUserId;
  bool _isLastUser;
  bool _isNextUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _messageTheme = _isMyMessage
        ? StreamChatTheme.of(context).ownMessageTheme
        : StreamChatTheme.of(context).otherMessageTheme;

    final alignment =
        _isMyMessage ? Alignment.centerRight : Alignment.centerLeft;

    var row = List<Widget>.from([
      Column(
        crossAxisAlignment:
            _isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          widget.message.isDeleted
              ? _buildDeletedMessage(alignment)
              : _buildBubble(context),
          if (_streamChannel.channel.config?.replies == true)
            _buildThreadIndicator(context),
          if (!_isNextUser) _buildTimestamp(alignment),
        ],
      ),
      _isNextUser
          ? Container(
              width: 40,
            )
          : _buildUserAvatar(),
    ]);

    if (!_isMyMessage) {
      row = row.reversed.toList();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (_isMyMessage && widget.nextMessage == null) ? 0.0 : 10,
      ),
      margin: EdgeInsets.only(
        top: _isLastUser ? 5 : 24,
        bottom: widget.nextMessage == null ? 30 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            _isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: row,
      ),
    );
  }

  Padding _buildUserAvatar() {
    return Padding(
      padding: EdgeInsets.only(
        left: _isMyMessage ? 8.0 : 0,
        right: _isMyMessage ? 0 : 8.0,
      ),
      child: Row(
        children: <Widget>[
          UserAvatar(user: widget.message.user),
          if (_isMyMessage &&
              widget.nextMessage == null &&
              (widget.message.status == MessageSendingStatus.SENT ||
                  widget.message.status == null))
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1.0,
              ),
              child: CircleAvatar(
                radius: 4,
                child: Icon(
                  Icons.done,
                  size: 4,
                ),
              ),
            ),
          if (_isMyMessage &&
              (widget.message.status == MessageSendingStatus.SENDING ||
                  widget.message.status == MessageSendingStatus.UPDATING))
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1.0,
              ),
              child: CircleAvatar(
                radius: 4,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.access_time,
                  size: 4,
                  color: Colors.white,
                ),
              ),
            ),
          if (_isMyMessage &&
              (widget.message.status == MessageSendingStatus.FAILED ||
                  widget.message.status == MessageSendingStatus.FAILED_UPDATE))
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1.0,
              ),
              child: CircleAvatar(
                radius: 4,
                backgroundColor: Color(0xffd0021B).withAlpha(125),
                child: Icon(
                  Icons.error_outline,
                  size: 4,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _streamChat = StreamChat.of(context);
    _streamChannel = StreamChannel.of(context);

    _currentUserId = _streamChat.client.state.user.id;
    _messageUserId = widget.message.user.id;
    _previousUserId = widget.previousMessage?.user?.id;
    _nextUserId = widget.nextMessage?.user?.id;
    _isLastUser = _previousUserId == _messageUserId;
    _isNextUser = _nextUserId == _messageUserId;

    _isMyMessage = _messageUserId == _currentUserId;
  }

  Align _buildDeletedMessage(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        child: Text(
          'This message was deleted...',
          style: _messageTheme.messageText.copyWith(
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
        style: _messageTheme.replies,
      ),
      Transform(
        transform: Matrix4.rotationY(_isMyMessage ? 0 : pi),
        alignment: Alignment.center,
        child: Icon(
          Icons.subdirectory_arrow_left,
          color: Colors.black12,
        ),
      ),
    ];

    if (!_isMyMessage) {
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
  ) {
    var nOfAttachmentWidgets = 0;

    final column =
        List<Widget>.from(widget.message.attachments?.map((attachment) {
              nOfAttachmentWidgets++;

              Widget attachmentWidget;
              if (attachment.type == 'video') {
                attachmentWidget = _buildVideo(attachment);
              } else if (attachment.type == 'image' ||
                  attachment.type == 'giphy') {
                attachmentWidget = _buildImage(attachment);
              }

              if (attachmentWidget != null) {
                return _buildAttachment(
                  attachmentWidget,
                  attachment,
                  nOfAttachmentWidgets,
                  context,
                );
              }

              nOfAttachmentWidgets--;
              return SizedBox();
            }) ??
            []);

    if (widget.message.text.trim().isNotEmpty) {
      var text = widget.message.text;
      text = _replaceMentions(text);

      column.addAll(
        <Widget>[
          Column(
            crossAxisAlignment: _isMyMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              if (_streamChannel.channel.config?.reactions == true &&
                  nOfAttachmentWidgets == 0)
                Align(
                  child: _buildReactions(),
                  alignment: _isMyMessage
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                ),
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  if (nOfAttachmentWidgets == 0 &&
                      _streamChannel.channel.config?.reactions == true)
                    _buildReactionPaint(),
                  _buildMessageText(nOfAttachmentWidgets, text, context),
                ],
              ),
            ],
          ),
        ],
      );
    }

    if (_streamChannel.channel.config?.reactions == true &&
        nOfAttachmentWidgets > 0) {
      column.insert(
        0,
        Align(
          child: _buildReactions(),
          alignment:
              _isMyMessage ? Alignment.centerLeft : Alignment.centerRight,
        ),
      );
      column[1] = Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: _isMyMessage ? 0.0 : 8.0,
              left: _isMyMessage ? 8.0 : 0.0,
            ),
            child: column[1],
          ),
          _buildReactionPaint(),
        ],
      );
    }

    return GestureDetector(
      child: IntrinsicWidth(
        child: Column(
          children: column,
          crossAxisAlignment:
              _isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        ),
      ),
      onTap: () {
        final channel = StreamChannel.of(context).channel;
        if (widget.message.status == MessageSendingStatus.FAILED) {
          channel.sendMessage(widget.message);
          return;
        }
        if (widget.message.status == MessageSendingStatus.FAILED_UPDATE) {
          StreamChat.of(context).client.updateMessage(
                widget.message,
                channel.cid,
              );
          return;
        }
      },
      onLongPress: () {
        if (widget.message.isEphemeral ||
            widget.message.status == MessageSendingStatus.SENDING) {
          return;
        }

        if (widget.onMessageActions != null) {
          widget.onMessageActions(context, widget.message);
        } else {
          _showMessageBottomSheet(context);
        }
      },
    );
  }

  Padding _buildAttachment(
    Widget attachmentWidget,
    Attachment attachment,
    int nOfAttachmentWidgets,
    BuildContext context,
  ) {
    final boxDecoration = _buildBoxDecoration(_isLastUser).copyWith(
      color: Color(0xffebebeb),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: boxDecoration.borderRadius,
            child: Container(
              decoration: boxDecoration,
              constraints: BoxConstraints.loose(
                  Size.fromWidth(MediaQuery.of(context).size.width * 0.7)),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      attachmentWidget,
                      if (attachment.title != null)
                        _buildAttachmentTitle(attachment),
                    ],
                  ),
                  if (attachment.type == 'image' &&
                      attachment.titleLink != null)
                    _buildPreviewInkwell(attachment),
                ],
              ),
              margin: EdgeInsets.only(
                top: nOfAttachmentWidgets > 1 ? 5 : 0,
              ),
            ),
          ),
          if (attachment.actions != null)
            _buildAttachmentActions(attachment, context),
        ],
      ),
    );
  }

  Widget _buildSendingError(Widget child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.message.status == MessageSendingStatus.FAILED)
          Text(
            'MESSAGE FAILED · CLICK TO TRY AGAIN',
            style: _messageTheme.messageText.copyWith(
              color: Colors.black.withOpacity(.5),
              fontSize: 11,
            ),
          ),
        if (widget.message.status == MessageSendingStatus.FAILED_UPDATE)
          Text(
            'MESSAGE UPDATE FAILED · CLICK TO TRY AGAIN',
            style: _messageTheme.messageText.copyWith(
              color: Colors.black.withOpacity(.5),
              fontSize: 11,
            ),
          ),
        child,
      ],
    );
  }

  Padding _buildMessageText(
    int nOfAttachmentWidgets,
    String text,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        right: _isMyMessage ? 0.0 : 8.0,
        left: _isMyMessage ? 8.0 : 0.0,
      ),
      child: Container(
        decoration:
            _buildBoxDecoration(_isLastUser || nOfAttachmentWidgets > 0),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints.loose(
          Size.fromWidth(MediaQuery.of(context).size.width * 0.7),
        ),
        child: _buildSendingError(
          MarkdownBody(
            data: text,
            onTapLink: (link) {
              if (link.startsWith('@')) {
                final mentionedUser = widget.message.mentionedUsers.firstWhere(
                  (u) => '@${u.name.replaceAll(' ', '')}' == link,
                  orElse: () => null,
                );

                if (widget.onMentionTap != null) {
                  widget.onMentionTap(mentionedUser);
                } else {
                  print('tap on ${mentionedUser.name}');
                }
              } else {
                _launchURL(link);
              }
            },
            styleSheet: MarkdownStyleSheet.fromTheme(
              Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: _messageTheme.messageText.color,
                      decoration: _messageTheme.messageText.decoration,
                      decorationColor:
                          _messageTheme.messageText.decorationColor,
                      decorationStyle:
                          _messageTheme.messageText.decorationStyle,
                      fontFamily: _messageTheme.messageText.fontFamily,
                    ),
              ),
            ).copyWith(
              p: _messageTheme.messageText,
            ),
          ),
        ),
      ),
    );
  }

  String _replaceMentions(String text) {
    widget.message.mentionedUsers?.forEach((u) {
      text = text.replaceAll(
          '@${u.name}', '[@${u.name}](@${u.name.replaceAll(' ', '')})');
    });
    return text;
  }

  Row _buildAttachmentActions(Attachment attachment, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: attachment.actions?.map((action) {
        if (action.style == 'primary') {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text('${action.text}'),
              color: action.style == 'primary'
                  ? StreamChatTheme.of(context).accentColor
                  : null,
              textColor: Colors.white,
              onPressed: () {
                _streamChannel.channel.sendAction(widget.message.id, {
                  action.name: action.value,
                });
              },
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: OutlineButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text('${action.text}'),
            color: StreamChatTheme.of(context).accentColor,
            onPressed: () {
              _streamChannel.channel.sendAction(widget.message.id, {
                action.name: action.value,
              });
            },
          ),
        );
      })?.toList(),
    );
  }

  Positioned _buildPreviewInkwell(Attachment attachment) {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _launchURL(attachment.titleLink),
        ),
      ),
    );
  }

  GestureDetector _buildAttachmentTitle(Attachment attachment) {
    return GestureDetector(
      onTap: () {
        if (attachment.titleLink != null) {
          _launchURL(attachment.titleLink);
        }
      },
      child: Container(
        constraints: BoxConstraints.loose(
          Size(
            MediaQuery.of(context).size.width * 0.7,
            500,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                attachment.title,
                overflow: TextOverflow.ellipsis,
                style: _messageTheme.messageText.copyWith(
                  color: StreamChatTheme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (attachment.titleLink != null ||
                  attachment.ogScrapeUrl != null)
                Text(
                  Uri.parse(attachment.titleLink ?? attachment.ogScrapeUrl)
                      .authority
                      .split('.')
                      .reversed
                      .take(2)
                      .toList()
                      .reversed
                      .join('.'),
                  overflow: TextOverflow.ellipsis,
                  style: _messageTheme.createdAt,
                ),
            ],
          ),
        ),
        color: Color(0xffebebeb),
      ),
    );
  }

  Widget _buildReactionPaint() {
    return widget.message.reactionCounts?.isNotEmpty == true
        ? Positioned(
            left: _isMyMessage ? 8 : null,
            right: !_isMyMessage ? 8 : null,
            top: -6,
            child: CustomPaint(
              painter: _ReactionBubblePainter(),
            ),
          )
        : SizedBox();
  }

  void _showMessageBottomSheet(BuildContext context) {
    if (!_streamChannel.channel.config.reactions &&
        !_streamChannel.channel.config.replies) {
      return;
    }

    final theme = Theme.of(context);

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
                  child: (_streamChannel.channel.config.reactions &&
                          widget.message.status != MessageSendingStatus.FAILED)
                      ? ReactionPicker(
                          channel: StreamChannel.of(context).channel,
                          reactionToEmoji: reactionToEmoji,
                          message: widget.message,
                        )
                      : SizedBox(),
                ),
                _isMyMessage
                    ? FlatButton(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Delete message',
                            style: theme.textTheme.headline
                                .copyWith(color: Colors.red),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          StreamChat.of(context).client.deleteMessage(
                                widget.message,
                                _streamChannel.channel.cid,
                              );
                        },
                      )
                    : SizedBox(),
                _isMyMessage
                    ? FlatButton(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Edit message',
                            style: theme.textTheme.headline,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);

                          _showEditBottomSheet(context);
                        },
                      )
                    : SizedBox(),
                (_streamChannel.channel.config.replies &&
                        widget.message.status != MessageSendingStatus.FAILED &&
                        widget.message.parentId == null &&
                        !widget.isParent)
                    ? FlatButton(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Start a thread',
                            style: theme.textTheme.headline,
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
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) {
        return StreamChannel(
          channel: _streamChannel.channel,
          child: Flex(
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
                          .firstWhere((message) =>
                              message.id == widget.message.parentId)
                      : null,
                  onMessageSent: (_) {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
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
        child: Container(
          padding: widget.message.reactionCounts?.isNotEmpty == true
              ? const EdgeInsets.all(8)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(14))),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            reverseDuration: Duration(milliseconds: 0),
            child: (widget.message.reactionCounts != null &&
                    widget.message.reactionCounts.isNotEmpty)
                ? _buildReactionRow()
                : SizedBox(),
          ),
        ),
      ),
    );
  }

  Row _buildReactionRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ...widget.message.reactionCounts.keys.map((reactionType) {
          return Text(
            reactionToEmoji[reactionType] ?? '?',
          );
        }),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            widget.message.reactionCounts.values
                .fold(0, (t, v) => v + t)
                .toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
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
    Attachment attachment,
  ) {
    return Hero(
      tag: attachment.imageUrl ?? attachment.assetUrl ?? attachment.thumbUrl,
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
        imageUrl:
            attachment.thumbUrl ?? attachment.imageUrl ?? attachment.assetUrl,
        errorWidget: (context, url, error) => _buildErrorImage(attachment),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildErrorImage(Attachment attachment) {
    if (attachment.localUri != null) {
      return Image.file(
        File(attachment.localUri.path),
      );
    }
    return Center(
      child: Container(
        width: 200,
        height: 140,
        color: Color(0xffd0021B).withAlpha(26),
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildVideo(
    Attachment attachment,
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
            if (attachment.thumbUrl == null) {
              return _buildErrorImage(attachment);
            }
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
      child: widget.message.createdAt != null
          ? Text(
              Jiffy(widget.message.createdAt.toLocal()).format('HH:mm'),
              style: _messageTheme.createdAt,
            )
          : SizedBox(),
    );
  }

  BoxDecoration _buildBoxDecoration(bool rectBorders) {
    return BoxDecoration(
      border:
          _isMyMessage ? null : Border.all(color: Colors.black.withAlpha(8)),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular((_isMyMessage || !rectBorders) ? 16 : 2),
        bottomLeft: Radius.circular(_isMyMessage ? 16 : 2),
        topRight: Radius.circular((_isMyMessage && rectBorders) ? 2 : 16),
        bottomRight: Radius.circular(_isMyMessage ? 2 : 16),
      ),
      color: (widget.message.status == MessageSendingStatus.FAILED ||
              widget.message.status == MessageSendingStatus.FAILED_UPDATE)
          ? Color(0xffd0021B).withAlpha(26)
          : _messageTheme.messageBackgroundColor,
    );
  }

  @override
  bool get wantKeepAlive {
    return widget.message.attachments?.isNotEmpty == true;
  }
}

class _ReactionBubblePainter extends CustomPainter {
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
