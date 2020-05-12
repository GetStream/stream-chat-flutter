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

enum DisplayWidget {
  hide,
  gone,
  show,
}

class MessageWidget extends StatelessWidget {
  final void Function(User) onMentionTap;
  final void Function(Message) onThreadTap;
  final Widget Function(BuildContext, Message) editMessageInputBuilder;
  final Widget Function(BuildContext, Message) textBuilder;
  final void Function(BuildContext, Message) onMessageActions;
  final Message message;
  final MessageTheme messageTheme;
  final bool reverse;
  final ShapeBorder shape;
  final ShapeBorder attachmentShape;
  final BorderSide borderSide;
  final BorderSide attachmentBorderSide;
  final BorderRadiusGeometry borderRadiusGeometry;
  final BorderRadiusGeometry attachmentBorderRadiusGeometry;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry textPadding;
  final EdgeInsetsGeometry attachmentPadding;
  final DisplayWidget showUserAvatar;
  final DisplayWidget showSendingIndicator;
  final bool showReactions;
  final bool showReplyIndicator;
  final bool isParent;
  final bool showUsername;
  final bool showTimestamp;
  final bool showDeleteMessage;
  final bool showEditMessage;
  final Map<String, AttachmentBuilder> attachmentBuilders;
  final Map<String, String> reactionToEmoji = {
    'love': '❤️️',
    'haha': '😂',
    'like': '👍',
    'sad': '😕',
    'angry': '😡',
    'wow': '😲',
  };

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
    this.isParent = false,
    this.onThreadTap,
    this.showUsername = true,
    this.showTimestamp = true,
    this.showReactions = true,
    this.showDeleteMessage = true,
    this.showEditMessage = true,
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
  Widget build(BuildContext context) {
    final leftPadding = showUserAvatar != DisplayWidget.gone
        ? messageTheme.avatarTheme.constraints.maxWidth + 22.0
        : 12.0;
    return Portal(
      child: Padding(
        padding: padding ?? EdgeInsets.all(8),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(reverse ? pi : 0),
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
                            if (showSendingIndicator == DisplayWidget.show)
                              _buildSendingIndicator(),
                            SizedBox(
                              width: 2,
                            ),
                            if (showSendingIndicator == DisplayWidget.hide)
                              SizedBox(
                                width: 6,
                              ),
                            if (showUserAvatar == DisplayWidget.show)
                              _buildUserAvatar(),
                            SizedBox(
                              width: 6,
                            ),
                            if (showUserAvatar == DisplayWidget.hide)
                              SizedBox(
                                width: messageTheme
                                        .avatarTheme.constraints.maxWidth +
                                    8,
                              ),
                            Flexible(
                              child: Padding(
                                padding: (message.reactionCounts?.isNotEmpty ==
                                            true &&
                                        showReactions)
                                    ? EdgeInsets.only(
                                        top: _getReactionsTopPadding(),
                                      )
                                    : EdgeInsets.zero,
                                child: PortalEntry(
                                  portalAnchor: Alignment(0, 1),
                                  childAnchor: Alignment.topRight,
                                  portal: _buildReactionIndicator(context),
                                  child: (message.isDeleted &&
                                          message.status !=
                                              MessageSendingStatus
                                                  .FAILED_DELETE)
                                      ? Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(
                                              reverse ? pi : 0),
                                          child: DeletedMessage(
                                            messageTheme: messageTheme,
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ..._parseAttachments(context),
                                            if (message.text.trim().isNotEmpty)
                                              _buildTextBubble(context),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (showReplyIndicator && message.replyCount > 0)
                          _buildReplyIndicator(leftPadding),
                      ],
                    ),
                  ),
                  if ((message.createdAt != null && showTimestamp) ||
                      showUsername)
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
    return 36.0 *
        ((message.reactionCounts.values
                    .where((element) => element > 0)
                    .length ~/
                5) +
            1);
  }

  Widget _buildReactionsTail(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: message.reactionCounts?.isNotEmpty == true
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
        transform: Matrix4.rotationY(reverse ? pi : 0),
        child: RichText(
          text: TextSpan(
            style: messageTheme.createdAt,
            children: <TextSpan>[
              if (showUsername)
                TextSpan(
                  text: message.user.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              if (message.createdAt != null && showTimestamp)
                TextSpan(
                  text: Jiffy(message.createdAt.toLocal()).format(' HH:mm'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReactionIndicator(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: (showReactions &&
              message.reactionCounts?.isNotEmpty == true &&
              !message.isDeleted)
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
                        transform: Matrix4.rotationY(reverse ? pi : 0),
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
      message.reactionCounts.keys.map((reactionType) {
            return reactionToEmoji[reactionType] ?? '?';
          }).join(' ') +
          ' ${message.reactionCounts.values.fold(0, (t, v) => v + t).toString()}',
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
              showDeleteMessage: showDeleteMessage,
              message: message,
              editMessageInputBuilder: editMessageInputBuilder,
              onThreadTap: onThreadTap,
              showEditMessage: showEditMessage,
              showReactions: showReactions,
              showReply: showReplyIndicator,
            ),
          );
        });
  }

  List<Widget> _parseAttachments(BuildContext context) {
    return message.attachments?.map((attachment) {
          final attachmentBuilder = attachmentBuilders[attachment.type];

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
                shape: attachmentShape ??
                    shape ??
                    ContinuousRectangleBorder(
                      side: attachmentBorderSide ??
                          borderSide ??
                          BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withAlpha(24)
                                    : Colors.black.withAlpha(24),
                          ),
                      borderRadius: attachmentBorderRadiusGeometry ??
                          borderRadiusGeometry ??
                          BorderRadius.zero,
                    ),
                child: Padding(
                  padding: attachmentPadding,
                  child: Transform(
                    transform: Matrix4.rotationY(reverse ? pi : 0),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        getFailedMessageWidget(
                          context,
                          padding: const EdgeInsets.all(8.0),
                        ),
                        attachmentBuilder(
                          context,
                          message,
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
    if (message.isEphemeral || message.status == MessageSendingStatus.SENDING) {
      return;
    }

    if (onMessageActions != null) {
      onMessageActions(context, message);
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
        transform: Matrix4.rotationY(reverse ? pi : 0),
        alignment: Alignment.center,
        child: ReplyIndicator(
          message: message,
          reversed: reverse,
          messageTheme: messageTheme,
          onTap: onThreadTap != null
              ? () {
                  onThreadTap(message);
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
        transform: Matrix4.rotationY(reverse ? pi : 0),
        alignment: Alignment.center,
        child: SendingIndicator(
          message: message,
        ),
      ),
    );
  }

  Widget _buildUserAvatar() => Transform(
        transform: Matrix4.rotationY(reverse ? pi : 0),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Transform.translate(
            offset:
                Offset(0, messageTheme.avatarTheme.constraints.maxHeight / 2),
            child: UserAvatar(
              user: message.user,
              constraints: messageTheme.avatarTheme.constraints,
            ),
          ),
        ),
      );

  Widget getFailedMessageWidget(
    BuildContext context, {
    EdgeInsetsGeometry padding,
  }) {
    Widget widget;
    if (message.status == MessageSendingStatus.FAILED)
      widget = Text(
        'MESSAGE FAILED · CLICK TO TRY AGAIN',
        style: messageTheme.messageText.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
      );
    if (message.status == MessageSendingStatus.FAILED_UPDATE)
      widget = Text(
        'MESSAGE UPDATE FAILED · CLICK TO TRY AGAIN',
        style: messageTheme.messageText.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
      );
    if (message.status == MessageSendingStatus.FAILED_DELETE)
      widget = Text(
        'MESSAGE DELETE FAILED · CLICK TO TRY AGAIN',
        style: messageTheme.messageText.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
      );

    if (widget != null) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: widget,
      );
    }

    return SizedBox();
  }

  Widget _buildTextBubble(BuildContext context) {
    return GestureDetector(
      onTap: () => retryMessage(context),
      onLongPress: () => onLongPress(context),
      child: Material(
        shape: shape ??
            ContinuousRectangleBorder(
              side: borderSide ??
                  BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withAlpha(24)
                        : Colors.black.withAlpha(24),
                  ),
              borderRadius: borderRadiusGeometry ?? BorderRadius.zero,
            ),
        color: _getBackgroundColor(),
        child: Transform(
          transform: Matrix4.rotationY(reverse ? pi : 0),
          alignment: Alignment.center,
          child: Padding(
            padding: textPadding,
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
    return (message.status == MessageSendingStatus.FAILED ||
            message.status == MessageSendingStatus.FAILED_UPDATE ||
            message.status == MessageSendingStatus.FAILED_DELETE)
        ? Color(0xffd0021B).withOpacity(.1)
        : messageTheme.messageBackgroundColor;
  }

  void retryMessage(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    if (message.status == MessageSendingStatus.FAILED) {
      channel.sendMessage(message);
      return;
    }
    if (message.status == MessageSendingStatus.FAILED_UPDATE) {
      StreamChat.of(context).client.updateMessage(
            message,
            channel.cid,
          );
      return;
    }

    if (message.status == MessageSendingStatus.FAILED_DELETE) {
      StreamChat.of(context).client.deleteMessage(
            message,
            channel.cid,
          );
      return;
    }
  }

  Widget _buildText(BuildContext context) {
    return textBuilder != null
        ? textBuilder(context, message)
        : MessageText(
            message: message,
            onMentionTap: onMentionTap,
            messageTheme: messageTheme,
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
