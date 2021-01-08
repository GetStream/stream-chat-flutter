import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/reaction_picker.dart';
import 'package:stream_chat_flutter/src/stream_channel.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';

import 'message_input.dart';
import 'message_widget.dart';
import 'stream_chat.dart';
import 'stream_chat_theme.dart';

class MessageActionsModal extends StatefulWidget {
  final Widget Function(BuildContext, Message) editMessageInputBuilder;
  final void Function(Message) onThreadReplyTap;
  final void Function(Message) onReplyTap;
  final Message message;
  final MessageTheme messageTheme;
  final bool showReactions;
  final bool showDeleteMessage;
  final bool showCopyMessage;
  final bool showEditMessage;
  final bool showResendMessage;
  final bool showReply;
  final bool showThreadReply;
  final bool showFlagButton;
  final bool reverse;
  final ShapeBorder messageShape;
  final DisplayWidget showUserAvatar;

  const MessageActionsModal({
    Key key,
    @required this.message,
    @required this.messageTheme,
    this.showReactions = true,
    this.showDeleteMessage = true,
    this.showEditMessage = true,
    this.onReplyTap,
    this.onThreadReplyTap,
    this.showCopyMessage = true,
    this.showReply = true,
    this.showResendMessage = true,
    this.showThreadReply = true,
    this.showFlagButton = true,
    this.showUserAvatar = DisplayWidget.show,
    this.editMessageInputBuilder,
    this.messageShape,
    this.reverse = false,
  }) : super(key: key);

  @override
  _MessageActionsModalState createState() => _MessageActionsModalState();
}

class _MessageActionsModalState extends State<MessageActionsModal> {
  bool showConfirmFlagModal = false;

  @override
  Widget build(BuildContext context) {
    if (showConfirmFlagModal) {
      return _showFlagDialog();
    } else {
      return _showMessageOptionsModal();
    }
  }

  Widget _showMessageOptionsModal() {
    final size = MediaQuery.of(context).size;
    final user = StreamChat.of(context).user;

    final roughMaxSize = 2 * size.width / 3;
    var messageTextLength = widget.message.text.length;
    if (widget.message.quotedMessage != null) {
      var quotedMessageLength = widget.message.quotedMessage.text.length + 40;
      if (widget.message.quotedMessage.attachments?.isNotEmpty == true) {
        quotedMessageLength += 40;
      }
      if (quotedMessageLength > messageTextLength) {
        messageTextLength = quotedMessageLength;
      }
    }
    final roughSentenceSize =
        messageTextLength * widget.messageTheme.messageText.fontSize * 1.2;
    final divFactor = widget.message.attachments?.isNotEmpty == true
        ? 1
        : (roughSentenceSize == 0 ? 1 : (roughSentenceSize / roughMaxSize));

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.maybePop(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                color: StreamChatTheme.of(context).colorTheme.overlay,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (widget.showReactions &&
                        (widget.message.status == MessageSendingStatus.SENT ||
                            widget.message.status == null))
                      Align(
                        alignment: Alignment(
                            user.id == widget.message.user.id
                                ? (divFactor > 1.0 ? 0.0 : (1.0 - divFactor))
                                : (divFactor > 1.0 ? 0.0 : -(1.0 - divFactor)),
                            0.0),
                        child: ReactionPicker(
                          message: widget.message,
                          messageTheme: widget.messageTheme,
                        ),
                      ),
                    TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 300),
                        builder: (context, val, snapshot) {
                          return Transform.scale(
                            scale: val,
                            child: IgnorePointer(
                              child: MessageWidget(
                                key: Key('MessageWidget'),
                                reverse: widget.reverse,
                                message: widget.message.copyWith(
                                  text: widget.message.text.length > 200
                                      ? '${widget.message.text.substring(0, 200)}...'
                                      : widget.message.text,
                                ),
                                messageTheme: widget.messageTheme,
                                showReactions: false,
                                showUsername: false,
                                showThreadReplyIndicator: false,
                                showReplyIndicator: false,
                                showUserAvatar: widget.showUserAvatar,
                                showTimestamp: false,
                                translateUserAvatar: false,
                                showReactionPickerIndicator:
                                    widget.showReactions &&
                                        (widget.message.status ==
                                                MessageSendingStatus.SENT ||
                                            widget.message.status == null),
                                showInChannelIndicator: false,
                                showSendingIndicator: DisplayWidget.gone,
                                shape: widget.messageShape,
                              ),
                            ),
                          );
                        }),
                    SizedBox(height: 8),
                    TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        builder: (context, val, wid) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..scale(val)
                              ..rotateZ(-1.0 + val),
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48.0,
                              ),
                              child: Material(
                                color: StreamChatTheme.of(context)
                                    .colorTheme
                                    .whiteSnow,
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: ListTile.divideTiles(
                                    context: context,
                                    tiles: [
                                      if (widget.showReply &&
                                          (widget.message.status ==
                                                  MessageSendingStatus.SENT ||
                                              widget.message.status == null) &&
                                          widget.message.parentId == null)
                                        _buildReplyButton(context),
                                      if (widget.showThreadReply &&
                                          (widget.message.status ==
                                                  MessageSendingStatus.SENT ||
                                              widget.message.status == null) &&
                                          widget.message.parentId == null)
                                        _buildThreadReplyButton(context),
                                      if (widget.showResendMessage)
                                        _buildResendMessage(context),
                                      if (widget.showEditMessage)
                                        _buildEditMessage(context),
                                      if (widget.showDeleteMessage)
                                        _buildDeleteButton(context),
                                      if (widget.showCopyMessage)
                                        _buildCopyButton(context),
                                      if (widget.showCopyMessage)
                                        _buildFlagButton(context),
                                    ],
                                  ).toList(),
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showFlagDialog() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.maybePop(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                color: StreamChatTheme.of(context).colorTheme.overlay,
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: 0.9,
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: 270.0,
                  height: 156.0,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 19.0,
                      ),
                      Text(
                        'Flag Message',
                        style: StreamChatTheme.of(context)
                            .textTheme
                            .bodyBold
                            .copyWith(fontSize: 17.0),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Do you want to send a copy of this \nmessage to a moderator for further \ninvestigation?',
                          style: TextStyle(fontSize: 13.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 21.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Center(
                              child: InkWell(
                                child: Container(
                                  height: 44.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Cancel',
                                    style: StreamChatTheme.of(context)
                                        .textTheme
                                        .body
                                        .copyWith(
                                            fontSize: 17.0,
                                            color: StreamChatTheme.of(context)
                                                .colorTheme
                                                .accentBlue),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: StreamChatTheme.of(context)
                                              .colorTheme
                                              .grey),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    showConfirmFlagModal = false;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: InkWell(
                                child: Container(
                                  height: 44.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Flag',
                                    style: StreamChatTheme.of(context)
                                        .textTheme
                                        .body
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0,
                                            color: StreamChatTheme.of(context)
                                                .colorTheme
                                                .accentBlue),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.fromBorderSide(
                                      BorderSide(
                                          color: StreamChatTheme.of(context)
                                              .colorTheme
                                              .grey),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    showConfirmFlagModal = false;
                                  });
                                  final client = StreamChat.of(context).client;
                                  client.flagMessage(widget.message.id);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyButton(BuildContext context) {
    return ListTile(
      title: Text(
        'Reply',
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: StreamSvgIcon.reply(
        color: StreamChatTheme.of(context).primaryIconTheme.color,
      ),
      onTap: () {
        Navigator.pop(context);
        if (widget.onReplyTap != null) {
          widget.onReplyTap(widget.message);
        }
      },
    );
  }

  Widget _buildFlagButton(BuildContext context) {
    return ListTile(
      title: Text(
        'Flag',
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: StreamSvgIcon.flag(
        color: StreamChatTheme.of(context).primaryIconTheme.color,
        size: 24.0,
      ),
      onTap: () {
        setState(() {
          showConfirmFlagModal = true;
        });
      },
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    final isDeleteFailed =
        widget.message.status == MessageSendingStatus.FAILED_DELETE;
    return ListTile(
      title: Text(
        isDeleteFailed ? 'Retry deleting message' : 'Delete message',
        style:
            Theme.of(context).textTheme.headline6.copyWith(color: Colors.red),
      ),
      leading: StreamSvgIcon.delete(
        color: Colors.red,
      ),
      onTap: () {
        Navigator.pop(context);
        StreamChat.of(context).client.deleteMessage(
              widget.message,
              StreamChannel.of(context).channel.cid,
            );
      },
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    return ListTile(
      title: Text(
        'Copy message',
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: StreamSvgIcon.copy(
        color: StreamChatTheme.of(context).primaryIconTheme.color,
      ),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: widget.message.text));
        Navigator.pop(context);
      },
    );
  }

  Widget _buildEditMessage(BuildContext context) {
    return ListTile(
      title: Text(
        'Edit message',
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: StreamSvgIcon.edit(
        color: StreamChatTheme.of(context).primaryIconTheme.color,
      ),
      onTap: () async {
        Navigator.pop(context);
        _showEditBottomSheet(context);
      },
    );
  }

  Widget _buildResendMessage(BuildContext context) {
    final isUpdateFailed =
        widget.message.status == MessageSendingStatus.FAILED_UPDATE;
    return ListTile(
      title: Text(
        isUpdateFailed ? 'Resend edited message' : 'Resend',
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: StreamSvgIcon.circle_up(
        color: StreamChatTheme.of(context).colorTheme.accentBlue,
      ),
      onTap: () {
        Navigator.pop(context);
        final client = StreamChat.of(context).client;
        final channel = StreamChannel.of(context).channel;
        if (isUpdateFailed) {
          client.updateMessage(widget.message, channel.cid);
        } else {
          channel.sendMessage(widget.message);
        }
      },
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showModalBottomSheet(
      context: context,
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      backgroundColor: StreamChatTheme.of(context).colorTheme.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return StreamChannel(
          channel: channel,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamSvgIcon.edit(
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .greyGainsboro,
                      ),
                    ),
                    Text(
                      'Edit Message',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: StreamSvgIcon.close_small(),
                      onPressed: Navigator.of(context).pop,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: widget.editMessageInputBuilder != null
                    ? widget.editMessageInputBuilder(context, widget.message)
                    : MessageInput(
                        editMessage: widget.message,
                        preMessageSending: (m) {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                          return m;
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThreadReplyButton(BuildContext context) {
    return ListTile(
      title: Text(
        'Thread reply',
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: StreamSvgIcon.thread(
        color: StreamChatTheme.of(context).primaryIconTheme.color,
      ),
      onTap: () {
        Navigator.pop(context);
        if (widget.onThreadReplyTap != null) {
          widget.onThreadReplyTap(widget.message);
        }
      },
    );
  }
}
