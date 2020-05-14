import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'message_actions_bottom_sheet.dart';
import 'message_text.dart';

typedef AttachmentBuilder = Widget Function(BuildContext, Message, Attachment);

/// The display behaviour of a widget
enum DisplayWidget {
  /// Hides the widget replacing its space with a spacer
  hide,

  /// Hides the widget not replacing its space
  gone,

  /// Shows the widget normally
  show,
}

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
  /// Function called on mention tap
  final void Function(User) onMentionTap;

  /// The function called when tapping on replies
  final void Function(Message) onThreadTap;
  final Widget Function(BuildContext, Message) editMessageInputBuilder;
  final Widget Function(BuildContext, Message) textBuilder;

  /// Function called on long press
  final void Function(BuildContext, Message) onMessageActions;

  /// The message
  final Message message;

  /// The message theme
  final MessageTheme messageTheme;

  /// If true the widget will be mirrored
  final bool reverse;

  /// The shape of the message text
  final ShapeBorder shape;

  /// The shape of an attachment
  final ShapeBorder attachmentShape;

  /// The borderside of the message text
  final BorderSide borderSide;

  /// The borderside of an attachment
  final BorderSide attachmentBorderSide;

  /// The border radius of the message text
  final BorderRadiusGeometry borderRadiusGeometry;

  /// The border radius of an attachment
  final BorderRadiusGeometry attachmentBorderRadiusGeometry;

  /// The padding of the widget
  final EdgeInsetsGeometry padding;

  /// The internal padding of the message text
  final EdgeInsetsGeometry textPadding;

  /// The internal padding of an attachment
  final EdgeInsetsGeometry attachmentPadding;

  /// It controls the display behaviour of the user avatar
  final DisplayWidget showUserAvatar;

  /// It controls the display behaviour of the sending indicator
  final DisplayWidget showSendingIndicator;

  /// If true the widget will show the reactions
  final bool showReactions;

  /// If true the widget will show the reply indicator
  final bool showReplyIndicator;

  /// The function called when tapping on UserAvatar
  final void Function(User) onUserAvatarTap;

  /// If true show the users username next to the timestamp of the message
  final bool showUsername;
  final bool showTimestamp;
  final bool showDeleteMessage;
  final bool showEditMessage;
  final Map<String, AttachmentBuilder> attachmentBuilders;

  MessageWidget({
    Key key,
    @required this.message,
    @required this.messageTheme,
    this.reverse = false,
    this.shape,
    this.attachmentShape,
    this.borderSide,
    this.attachmentBorderSide,
    this.borderRadiusGeometry,
    this.attachmentBorderRadiusGeometry,
    this.onMentionTap,
    this.showUserAvatar = DisplayWidget.show,
    this.showSendingIndicator = DisplayWidget.show,
    this.showReplyIndicator = true,
    this.onThreadTap,
    this.showUsername = true,
    this.showTimestamp = true,
    this.showReactions = true,
    this.showDeleteMessage = true,
    this.showEditMessage = true,
    this.onUserAvatarTap,
    this.onMessageActions,
    this.editMessageInputBuilder,
    this.textBuilder,
    Map<String, AttachmentBuilder> customAttachmentBuilders,
    this.padding,
    this.textPadding = const EdgeInsets.all(8.0),
    this.attachmentPadding = EdgeInsets.zero,
  })  : attachmentBuilders = {
          'image': (context, message, attachment) {
            return ImageAttachment(
              attachment: attachment,
              messageTheme: messageTheme,
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.3,
              ),
            );
          },
          'video': (context, message, attachment) {
            return VideoAttachment(
              attachment: attachment,
              messageTheme: messageTheme,
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.3,
              ),
            );
          },
          'giphy': (context, message, attachment) {
            return GiphyAttachment(
              attachment: attachment,
              messageTheme: messageTheme,
              message: message,
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.3,
              ),
            );
          },
          'file': (context, message, attachment) {
            return FileAttachment(
              attachment: attachment,
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.3,
              ),
            );
          },
        }..addAll(customAttachmentBuilders ?? {}),
        super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final Map<String, String> _reactionToEmoji = {
    'love': '❤️️',
    'haha': '😂',
    'like': '👍',
    'sad': '😕',
    'angry': '😡',
    'wow': '😲',
  };

  final GlobalKey _reactionPickerKey = GlobalKey();
  double _reactionPadding = 0;

  @override
  Widget build(BuildContext context) {
    var leftPadding = widget.showUserAvatar != DisplayWidget.gone
        ? widget.messageTheme.avatarTheme.constraints.maxWidth + 23.0
        : 12.0;
    if (widget.showSendingIndicator == DisplayWidget.gone) {
      leftPadding -= 7;
    }
    return Portal(
      child: Padding(
        padding: widget.padding ?? EdgeInsets.all(8),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(widget.reverse ? pi : 0),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints.loose(
                Size.fromWidth(MediaQuery.of(context).size.width * 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (widget.showSendingIndicator ==
                                DisplayWidget.show)
                              _buildSendingIndicator(),
                            SizedBox(
                              width: 2,
                            ),
                            if (widget.showSendingIndicator ==
                                DisplayWidget.hide)
                              SizedBox(
                                width: 8,
                              ),
                            if (widget.showUserAvatar == DisplayWidget.show)
                              _buildUserAvatar(),
                            SizedBox(
                              width: 6,
                            ),
                            if (widget.showUserAvatar == DisplayWidget.hide)
                              SizedBox(
                                width: widget.messageTheme.avatarTheme
                                        .constraints.maxWidth +
                                    8,
                              ),
                            Flexible(
                              child: Padding(
                                padding: widget.showReactions
                                    ? EdgeInsets.only(
                                        top: _getReactionsTopPadding(),
                                      )
                                    : EdgeInsets.zero,
                                child: PortalEntry(
                                  portalAnchor: Alignment(0, 1),
                                  childAnchor: Alignment.topRight,
                                  portal: _buildReactionIndicator(context),
                                  child: (widget.message.isDeleted &&
                                          widget.message.status !=
                                              MessageSendingStatus
                                                  .FAILED_DELETE)
                                      ? Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(
                                              widget.reverse ? pi : 0),
                                          child: DeletedMessage(
                                            messageTheme: widget.messageTheme,
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ..._parseAttachments(context),
                                            if (widget.message.text
                                                .trim()
                                                .isNotEmpty)
                                              _buildTextBubble(context),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (widget.showReplyIndicator &&
                            widget.message.replyCount > 0)
                          _buildReplyIndicator(leftPadding),
                      ],
                    ),
                  ),
                  if ((widget.message.createdAt != null &&
                          widget.showTimestamp) ||
                      widget.showUsername)
                    _buildUsernameAndTimestamp(leftPadding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getReactionsTopPadding() {
    return _reactionPadding;
    return 36.0 *
        ((widget.message.reactionCounts.values
                    .where((element) => element > 0)
                    .length ~/
                5) +
            1);
  }

  @override
  void didUpdateWidget(MessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateReactionPadding();
  }

  @override
  void initState() {
    super.initState();
    _updateReactionPadding();
  }

  void _updateReactionPadding() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) {
        return;
      }
      if (_reactionPickerKey.currentContext != null &&
          widget.message.reactionCounts != null &&
          widget.message.reactionCounts.values
                  .where((element) => element > 0)
                  .length >
              0) {
        setState(() {
          _reactionPadding = _reactionPickerKey.currentContext.size.height;
        });
      } else {
        setState(() {
          _reactionPadding = 0;
        });
      }
    });
  }

  Widget _buildReactionsTail(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: widget.message.reactionCounts?.isNotEmpty == true
          ? Transform.translate(
              offset: Offset(4, 0),
              child: CustomPaint(
                painter: ReactionBubblePainter(
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            )
          : SizedBox(),
    );
  }

  Padding _buildUsernameAndTimestamp(double leftPadding) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        top: 2,
      ),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(widget.reverse ? pi : 0),
        child: RichText(
          text: TextSpan(
            style: widget.messageTheme.createdAt,
            children: <TextSpan>[
              if (widget.showUsername)
                TextSpan(
                  text: widget.message.user.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              if (widget.message.createdAt != null && widget.showTimestamp)
                TextSpan(
                  text: Jiffy(widget.message.createdAt.toLocal())
                      .format(' HH:mm'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReactionIndicator(BuildContext context) {
    return AnimatedSwitcher(
      key: _reactionPickerKey,
      duration: Duration(milliseconds: 300),
      child: (widget.showReactions &&
              widget.message.reactionCounts?.isNotEmpty == true &&
              !widget.message.isDeleted)
          ? Container(
              child: GestureDetector(
                onTap: () => onLongPress(context),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: const EdgeInsets.only(
                    bottom: 4.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Transform(
                        transform: Matrix4.rotationY(widget.reverse ? pi : 0),
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                          child: _buildReactionsText(context),
                        ),
                      ),
                      _buildReactionsTail(context),
                    ],
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }

  Text _buildReactionsText(BuildContext context) {
    return Text(
      widget.message.reactionCounts.keys.map((reactionType) {
            return _reactionToEmoji[reactionType] ?? '?';
          }).join(' ') +
          ' ${widget.message.reactionCounts.values.fold(0, (t, v) => v + t).toString()}',
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
      ),
      textAlign: TextAlign.justify,
    );
  }

  void _showMessageBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        context: context,
        builder: (context) {
          return StreamChannel(
            channel: channel,
            child: MessageActionsBottomSheet(
              showDeleteMessage: widget.showDeleteMessage,
              message: widget.message,
              editMessageInputBuilder: widget.editMessageInputBuilder,
              onThreadTap: widget.onThreadTap,
              showEditMessage: widget.showEditMessage,
              showReactions: widget.showReactions,
              showReply:
                  widget.showReplyIndicator && widget.onThreadTap != null,
            ),
          );
        });
  }

  List<Widget> _parseAttachments(BuildContext context) {
    return widget.message.attachments?.map((attachment) {
          final attachmentBuilder = widget.attachmentBuilders[attachment.type];

          if (attachmentBuilder == null) {
            return SizedBox();
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: 4,
            ),
            child: GestureDetector(
              onTap: () => retryMessage(context),
              onLongPress: () => onLongPress(context),
              child: Material(
                color: _getBackgroundColor(),
                clipBehavior: Clip.hardEdge,
                shape: widget.attachmentShape ??
                    widget.shape ??
                    ContinuousRectangleBorder(
                      side: widget.attachmentBorderSide ??
                          widget.borderSide ??
                          BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withAlpha(24)
                                    : Colors.black.withAlpha(24),
                          ),
                      borderRadius: widget.attachmentBorderRadiusGeometry ??
                          widget.borderRadiusGeometry ??
                          BorderRadius.zero,
                    ),
                child: Padding(
                  padding: widget.attachmentPadding,
                  child: Transform(
                    transform: Matrix4.rotationY(widget.reverse ? pi : 0),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        getFailedMessageWidget(
                          context,
                          padding: const EdgeInsets.all(8.0),
                        ),
                        attachmentBuilder(
                          context,
                          widget.message,
                          attachment,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        })?.toList() ??
        [];
  }

  void onLongPress(BuildContext context) {
    if (widget.message.isEphemeral ||
        widget.message.status == MessageSendingStatus.SENDING) {
      return;
    }

    if (widget.onMessageActions != null) {
      widget.onMessageActions(context, widget.message);
    } else {
      _showMessageBottomSheet(context);
    }
    return;
  }

  Widget _buildReplyIndicator(double leftPadding) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
      ),
      child: Transform(
        transform: Matrix4.rotationY(widget.reverse ? pi : 0),
        alignment: Alignment.center,
        child: ReplyIndicator(
          message: widget.message,
          reversed: widget.reverse,
          messageTheme: widget.messageTheme,
          onTap: widget.onThreadTap != null
              ? () {
                  widget.onThreadTap(widget.message);
                }
              : null,
        ),
      ),
    );
  }

  Widget _buildSendingIndicator() {
    return Transform.translate(
      offset: Offset(
        0,
        4,
      ),
      child: Transform(
        transform: Matrix4.rotationY(widget.reverse ? pi : 0),
        alignment: Alignment.center,
        child: SendingIndicator(
          message: widget.message,
        ),
      ),
    );
  }

  Widget _buildUserAvatar() => Transform(
        transform: Matrix4.rotationY(widget.reverse ? pi : 0),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Transform.translate(
            offset: Offset(
                0, widget.messageTheme.avatarTheme.constraints.maxHeight / 2),
            child: UserAvatar(
              user: widget.message.user,
              onTap: widget.onUserAvatarTap,
              constraints: widget.messageTheme.avatarTheme.constraints,
            ),
          ),
        ),
      );

  Widget getFailedMessageWidget(
    BuildContext context, {
    EdgeInsetsGeometry padding,
  }) {
    Widget failedWidget;
    if (widget.message.status == MessageSendingStatus.FAILED)
      failedWidget = Text(
        'MESSAGE FAILED · CLICK TO TRY AGAIN',
        style: widget.messageTheme.messageText.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
      );
    if (widget.message.status == MessageSendingStatus.FAILED_UPDATE)
      failedWidget = Text(
        'MESSAGE UPDATE FAILED · CLICK TO TRY AGAIN',
        style: widget.messageTheme.messageText.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
      );
    if (widget.message.status == MessageSendingStatus.FAILED_DELETE)
      failedWidget = Text(
        'MESSAGE DELETE FAILED · CLICK TO TRY AGAIN',
        style: widget.messageTheme.messageText.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
      );

    if (failedWidget != null) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: failedWidget,
      );
    }

    return SizedBox();
  }

  Widget _buildTextBubble(BuildContext context) {
    return GestureDetector(
      onTap: () => retryMessage(context),
      onLongPress: () => onLongPress(context),
      child: Material(
        shape: widget.shape ??
            ContinuousRectangleBorder(
              side: widget.borderSide ??
                  BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withAlpha(24)
                        : Colors.black.withAlpha(24),
                  ),
              borderRadius: widget.borderRadiusGeometry ?? BorderRadius.zero,
            ),
        color: _getBackgroundColor(),
        child: Transform(
          transform: Matrix4.rotationY(widget.reverse ? pi : 0),
          alignment: Alignment.center,
          child: Padding(
            padding: widget.textPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                getFailedMessageWidget(context),
                _buildText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    return (widget.message.status == MessageSendingStatus.FAILED ||
            widget.message.status == MessageSendingStatus.FAILED_UPDATE ||
            widget.message.status == MessageSendingStatus.FAILED_DELETE)
        ? Color(0xffd0021B).withOpacity(.1)
        : widget.messageTheme.messageBackgroundColor;
  }

  void retryMessage(BuildContext context) {
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
  }

  Widget _buildText(BuildContext context) {
    return widget.textBuilder != null
        ? widget.textBuilder(context, widget.message)
        : MessageText(
            message: widget.message,
            onMentionTap: widget.onMentionTap,
            messageTheme: widget.messageTheme,
          );
  }
}

class ReactionBubblePainter extends CustomPainter {
  final Color color;

  ReactionBubblePainter(this.color);

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
