import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/message_input.dart';
import 'package:stream_chat_flutter/src/message_list_view.dart';
import 'package:stream_chat_flutter/src/reaction_picker.dart';
import 'package:stream_chat_flutter/src/reply_indicator.dart';
import 'package:stream_chat_flutter/src/sending_indicator.dart';
import 'package:stream_chat_flutter/src/stream_channel.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/src/video_attachment.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'deleted_message.dart';
import 'file_attachment.dart';
import 'giphy_attachment.dart';
import 'image_attachment.dart';
import 'stream_chat.dart';

typedef AttachmentBuilder = Widget Function(BuildContext, Message, Attachment);

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
  /// Instantiate a new MessageWidget
  const MessageWidget({
    Key key,
    @required this.previousMessage,
    @required this.message,
    @required this.nextMessage,
    this.onThreadTap,
    this.onUserAvatarTap,
    this.onMessageActions,
    this.isParent = false,
    this.onMentionTap,
    this.showOtherMessageUsername = false,
    this.showVideoFullScreen = true,
    this.attachmentBuilders,
    this.showAvatar = true,
  }) : super(key: key);

  /// Function called on mention tap
  final void Function(User) onMentionTap;

  /// Function called on long press
  final Function(BuildContext, Message) onMessageActions;

  /// If true show the other users username next to the timestamp of the message
  final bool showOtherMessageUsername;

  /// This message
  final Message message;

  /// The previous message
  final Message previousMessage;

  /// The next message
  final Message nextMessage;

  /// The function called when tapping on replies
  final void Function(Message) onThreadTap;

  /// The function called when tapping on UserAvatar
  final void Function(User) onUserAvatarTap;

  /// True if this is the parent of the thread being showed
  final bool isParent;

  /// True if the video player will allow fullscreen mode
  final bool showVideoFullScreen;

  /// Map that defines a builder for an attachment type
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// if true shows the user avatar
  final bool showAvatar;

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
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

  Map<String, AttachmentBuilder> _attachmentBuilders;

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
          (widget.message.isDeleted &&
                  widget.message.status != MessageSendingStatus.FAILED_DELETE)
              ? _buildDeletedMessage(alignment)
              : _buildBubble(context),
          if (_streamChannel.channel.config?.replies == true)
            _buildThreadIndicator(context),
          if (!_isNextUser) _buildTimestamp(alignment),
        ],
      ),
      _isNextUser
          ? Container(
              width: widget.showAvatar ? 40 : 8,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (widget.showAvatar)
            UserAvatar(
              user: widget.message.user,
              onTap: widget.onUserAvatarTap,
            ),
          if (_isMyMessage && widget.nextMessage == null)
            SendingIndicator(
              message: widget.message,
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

    _mergeAttachmentBuilders();
  }

  @override
  void didUpdateWidget(MessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _mergeAttachmentBuilders();
  }

  void _mergeAttachmentBuilders() {
    _attachmentBuilders = {
      'image': (context, message, attachment) {
        return ImageAttachment(
          attachment: attachment,
          messageTheme: _messageTheme,
        );
      },
      'video': (context, message, attachment) {
        return VideoAttachment(
          enableFullScreen: widget.showVideoFullScreen,
          attachment: attachment,
          messageTheme: _messageTheme,
        );
      },
      'giphy': (context, message, attachment) {
        return GiphyAttachment(
          attachment: attachment,
          messageTheme: _messageTheme,
          message: message,
        );
      },
      'file': (context, message, attachment) {
        return FileAttachment(
          attachment: attachment,
        );
      },
    }..addAll(widget.attachmentBuilders ?? {});
  }

  Widget _buildDeletedMessage(Alignment alignment) {
    return DeletedMessage(
      messageTheme: _messageTheme,
      alignment: alignment,
    );
  }

  Widget _buildThreadIndicator(BuildContext context) {
    if (widget.message?.replyCount != null && widget.message.replyCount > 0) {
      return ReplyIndicator(
        onTap: !widget.isParent
            ? () {
                widget.onThreadTap(widget.message);
              }
            : null,
        message: widget.message,
        messageTheme: _messageTheme,
        reversed: _isMyMessage,
      );
    }
    return SizedBox();
  }

  Widget _buildBubble(
    BuildContext context,
  ) {
    var nOfAttachmentWidgets = 0;

    final column =
        List<Widget>.from(widget.message.attachments.map((attachment) {
              nOfAttachmentWidgets++;

              Widget attachmentWidget;
              final attachmentBuilder = _attachmentBuilders[attachment.type];
              if (attachmentBuilder == null) {
                return SizedBox();
              }

              attachmentWidget = attachmentBuilder(
                context,
                widget.message,
                attachment,
              );

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

        if (widget.message.status == MessageSendingStatus.FAILED_DELETE) {
          StreamChat.of(context).client.deleteMessage(
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
    final boxDecoration = _buildBoxDecoration(_isLastUser);
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
                Size.fromWidth(MediaQuery.of(context).size.width * 0.7),
              ),
              child: attachmentWidget,
              margin: EdgeInsets.only(
                top: nOfAttachmentWidgets > 1 ? 5 : 0,
              ),
            ),
          ),
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
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(.5)
                  : Colors.black.withOpacity(.5),
              fontSize: 11,
            ),
          ),
        if (widget.message.status == MessageSendingStatus.FAILED_UPDATE)
          Text(
            'MESSAGE UPDATE FAILED · CLICK TO TRY AGAIN',
            style: _messageTheme.messageText.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(.5)
                  : Colors.black.withOpacity(.5),
              fontSize: 11,
            ),
          ),
        if (widget.message.status == MessageSendingStatus.FAILED_DELETE)
          Text(
            'MESSAGE DELETE FAILED · CLICK TO TRY AGAIN',
            style: _messageTheme.messageText.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(.5)
                  : Colors.black.withOpacity(.5),
              fontSize: 11,
            ),
          ),
        child,
      ],
    );
  }

  Widget _buildMessageText(
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
                launchURL(context, link);
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

  Widget _buildReactionPaint() {
    return widget.message.reactionCounts?.isNotEmpty == true
        ? Positioned(
            left: _isMyMessage ? 4 : null,
            right: !_isMyMessage ? 4 : null,
            top: -6,
            child: Transform(
              transform:
                  !_isMyMessage ? Matrix4.rotationY(pi) : Matrix4.identity(),
              alignment: Alignment.center,
              child: CustomPaint(
                painter: _ReactionBubblePainter(
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
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
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withOpacity(.1)
                                  : Colors.black.withOpacity(.1),
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            size: 15,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
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
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
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
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
            ),
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

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildTimestamp(Alignment alignment) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: RichText(
        text: TextSpan(
          style: _messageTheme.createdAt,
          children: <TextSpan>[
            if (!_isMyMessage && widget.showOtherMessageUsername)
              TextSpan(
                text: widget.message.user.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            if (widget.message.createdAt != null)
              TextSpan(
                text:
                    Jiffy(widget.message.createdAt.toLocal()).format(' HH:mm'),
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(bool rectBorders) {
    return BoxDecoration(
      border: _isMyMessage
          ? null
          : Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withAlpha(24)
                  : Colors.black.withAlpha(24),
            ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular((_isMyMessage || !rectBorders) ? 16 : 2),
        bottomLeft: Radius.circular(_isMyMessage ? 16 : 2),
        topRight: Radius.circular((_isMyMessage && rectBorders) ? 2 : 16),
        bottomRight: Radius.circular(_isMyMessage ? 2 : 16),
      ),
      color: (widget.message.status == MessageSendingStatus.FAILED ||
              widget.message.status == MessageSendingStatus.FAILED_UPDATE ||
              widget.message.status == MessageSendingStatus.FAILED_DELETE)
          ? Color(0xffd0021B).withOpacity(.1)
          : _messageTheme.messageBackgroundColor,
    );
  }

  @override
  bool get wantKeepAlive {
    return widget.message.attachments?.isNotEmpty == true;
  }
}

class _ReactionBubblePainter extends CustomPainter {
  final Color color;

  _ReactionBubblePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.lineTo(-2, -6);
    path.lineTo(0, 10);
    path.lineTo(10, -6);
    path.lineTo(-2, -6);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
