import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/src/message_action.dart';
import 'package:stream_chat_flutter/src/reaction_picker.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'extension.dart';
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
  final bool showReplyMessage;
  final bool showThreadReplyMessage;
  final bool showFlagButton;
  final bool reverse;
  final ShapeBorder messageShape;
  final ShapeBorder attachmentShape;
  final DisplayWidget showUserAvatar;
  final BorderRadius attachmentBorderRadiusGeometry;

  /// List of custom actions
  final List<MessageAction> customActions;

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
    this.showReplyMessage = true,
    this.showResendMessage = true,
    this.showThreadReplyMessage = true,
    this.showFlagButton = true,
    this.showUserAvatar = DisplayWidget.show,
    this.editMessageInputBuilder,
    this.messageShape,
    this.attachmentShape,
    this.reverse = false,
    this.customActions = const [],
    this.attachmentBorderRadiusGeometry,
  }) : super(key: key);

  @override
  _MessageActionsModalState createState() => _MessageActionsModalState();
}

class _MessageActionsModalState extends State<MessageActionsModal> {
  bool _showActions = true;

  @override
  Widget build(BuildContext context) {
    return _showMessageOptionsModal();
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

    final hasFileAttachment =
        widget.message.attachments?.any((it) => it.type == 'file') == true;

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
          if (_showActions)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              builder: (context, val, snapshot) {
                return Transform.scale(
                  scale: val,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: widget.reverse
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: <Widget>[
                            if (widget.showReactions &&
                                (widget.message.status ==
                                        MessageSendingStatus.sent ||
                                    widget.message.status == null))
                              Align(
                                alignment: Alignment(
                                    user.id == widget.message.user.id
                                        ? (divFactor > 1.0
                                            ? 0.0
                                            : (1.0 - divFactor))
                                        : (divFactor > 1.0
                                            ? 0.0
                                            : -(1.0 - divFactor)),
                                    0.0),
                                child: ReactionPicker(
                                  message: widget.message,
                                  messageTheme: widget.messageTheme,
                                ),
                              ),
                            SizedBox(height: 8),
                            IgnorePointer(
                              child: MessageWidget(
                                key: Key('MessageWidget'),
                                reverse: widget.reverse,
                                attachmentBorderRadiusGeometry:
                                    widget.attachmentBorderRadiusGeometry,
                                message: widget.message.copyWith(
                                  text: widget.message.text.length > 200
                                      ? '${widget.message.text.substring(0, 200)}...'
                                      : widget.message.text,
                                ),
                                messageTheme: widget.messageTheme,
                                showReactions: false,
                                showUsername: false,
                                showThreadReplyIndicator: false,
                                showReplyMessage: false,
                                showUserAvatar: widget.showUserAvatar,
                                attachmentPadding: EdgeInsets.all(
                                  hasFileAttachment ? 4 : 2,
                                ),
                                showTimestamp: false,
                                translateUserAvatar: false,
                                padding: const EdgeInsets.all(0),
                                textPadding: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: widget.message.text.isOnlyEmoji
                                      ? 0
                                      : 16.0,
                                ),
                                showReactionPickerIndicator:
                                    widget.showReactions &&
                                        (widget.message.status ==
                                                MessageSendingStatus.sent ||
                                            widget.message.status == null),
                                showInChannelIndicator: false,
                                showSendingIndicator: false,
                                shape: widget.messageShape,
                                attachmentShape: widget.attachmentShape,
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.only(
                                left: widget.reverse ? 0 : 40,
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
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
                                    children: [
                                      if (widget.showReplyMessage &&
                                          (widget.message.status ==
                                                  MessageSendingStatus.sent ||
                                              widget.message.status == null) &&
                                          widget.message.parentId == null)
                                        _buildReplyButton(context),
                                      if (widget.showThreadReplyMessage &&
                                          (widget.message.status ==
                                                  MessageSendingStatus.sent ||
                                              widget.message.status == null) &&
                                          widget.message.parentId == null)
                                        _buildThreadReplyButton(context),
                                      if (widget.showResendMessage)
                                        _buildResendMessage(context),
                                      if (widget.showEditMessage)
                                        _buildEditMessage(context),
                                      if (widget.showCopyMessage)
                                        _buildCopyButton(context),
                                      if (widget.showFlagButton)
                                        _buildFlagButton(context),
                                      if (widget.showDeleteMessage)
                                        _buildDeleteButton(context),
                                      ...widget.customActions.map((action) {
                                        return _buildCustomAction(
                                          context,
                                          action,
                                        );
                                      })
                                    ].insertBetween(
                                      Container(
                                        height: 1,
                                        color: StreamChatTheme.of(context)
                                            .colorTheme
                                            .greyWhisper,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  InkWell _buildCustomAction(
    BuildContext context,
    MessageAction messageAction,
  ) {
    return InkWell(
      onTap: () {
        messageAction.onTap?.call(widget.message);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
        child: Row(
          children: [
            messageAction.leading ?? Offstage(),
            const SizedBox(width: 16),
            messageAction.title ?? Offstage(),
          ],
        ),
      ),
    );
  }

  void _showFlagDialog() async {
    final client = StreamChat.of(context).client;

    final answer = await showConfirmationDialog(
      context,
      title: 'Flag Message',
      icon: StreamSvgIcon.flag(
        color: StreamChatTheme.of(context).colorTheme.accentRed,
        size: 24.0,
      ),
      question:
          'Do you want to send a copy of this message to a\nmoderator for further investigation?',
      okText: 'FLAG',
      cancelText: 'CANCEL',
    );

    final theme = StreamChatTheme.of(context);
    if (answer == true) {
      try {
        await client.flagMessage(widget.message.id);
        await showInfoDialog(
          context,
          icon: StreamSvgIcon.flag(
            color: theme.colorTheme.accentRed,
            size: 24.0,
          ),
          details: 'The message has been reported to a moderator.',
          title: 'Message flagged',
          okText: 'OK',
        );
      } catch (err) {
        if (json.decode(err?.body ?? {})['code'] == 4) {
          await showInfoDialog(
            context,
            icon: StreamSvgIcon.flag(
              color: theme.colorTheme.accentRed,
              size: 24.0,
            ),
            details: 'The message has been reported to a moderator.',
            title: 'Message flagged',
            okText: 'OK',
          );
        } else {
          _showErrorAlert();
        }
      }
    }
  }

  void _showDeleteDialog() async {
    setState(() {
      _showActions = false;
    });
    var answer = await showConfirmationDialog(
      context,
      title: 'Delete message',
      icon: StreamSvgIcon.flag(
        color: StreamChatTheme.of(context).colorTheme.accentRed,
        size: 24.0,
      ),
      question: 'Are you sure you want to permanently delete this\nmessage?',
      okText: 'DELETE',
      cancelText: 'CANCEL',
    );

    if (answer) {
      try {
        Navigator.pop(context);
        await StreamChannel.of(context).channel.deleteMessage(widget.message);
      } catch (err) {
        _showErrorAlert();
      }
    } else {
      setState(() {
        _showActions = true;
      });
    }
  }

  void _showErrorAlert() {
    showInfoDialog(
      context,
      icon: StreamSvgIcon.error(
        color: StreamChatTheme.of(context).colorTheme.accentRed,
        size: 24.0,
      ),
      details: 'The operation couldn\'t be completed.',
      title: 'Something went wrong',
      okText: 'OK',
    );
  }

  Widget _buildReplyButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (widget.onReplyTap != null) {
          widget.onReplyTap(widget.message);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
        child: Row(
          children: [
            StreamSvgIcon.reply(
              color: StreamChatTheme.of(context).primaryIconTheme.color,
            ),
            const SizedBox(width: 16),
            Text(
              'Reply',
              style: StreamChatTheme.of(context).textTheme.body,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagButton(BuildContext context) {
    return InkWell(
      onTap: () => _showFlagDialog(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
        child: Row(
          children: [
            StreamSvgIcon.iconFlag(
              color: StreamChatTheme.of(context).primaryIconTheme.color,
            ),
            const SizedBox(width: 16),
            Text(
              'Flag Message',
              style: StreamChatTheme.of(context).textTheme.body,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    final isDeleteFailed =
        widget.message.status == MessageSendingStatus.failed_delete;
    return InkWell(
      onTap: () => _showDeleteDialog(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
        child: Row(
          children: [
            StreamSvgIcon.delete(
              color: Colors.red,
            ),
            const SizedBox(width: 16),
            Text(
              isDeleteFailed ? 'Retry Deleting Message' : 'Delete Message',
              style: StreamChatTheme.of(context)
                  .textTheme
                  .body
                  .copyWith(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: widget.message.text));
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
        child: Row(
          children: [
            StreamSvgIcon.copy(
              size: 24,
              color: StreamChatTheme.of(context).primaryIconTheme.color,
            ),
            const SizedBox(width: 16),
            Text(
              'Copy Message',
              style: StreamChatTheme.of(context).textTheme.body,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditMessage(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        _showEditBottomSheet(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
        child: Row(
          children: [
            StreamSvgIcon.edit(
              color: StreamChatTheme.of(context).primaryIconTheme.color,
            ),
            const SizedBox(width: 16),
            Text(
              'Edit Message',
              style: StreamChatTheme.of(context).textTheme.body,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResendMessage(BuildContext context) {
    final isUpdateFailed =
        widget.message.status == MessageSendingStatus.failed_update;
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        final channel = StreamChannel.of(context).channel;
        if (isUpdateFailed) {
          channel.updateMessage(widget.message);
        } else {
          channel.sendMessage(widget.message);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
        child: Row(
          children: [
            StreamSvgIcon.circleUp(
              color: StreamChatTheme.of(context).colorTheme.accentBlue,
            ),
            const SizedBox(width: 16),
            Text(
              isUpdateFailed ? 'Resend Edited Message' : 'Resend',
              style: StreamChatTheme.of(context).textTheme.body,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showModalBottomSheet(
      context: context,
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      backgroundColor:
          StreamChatTheme.of(context).messageInputTheme.inputBackground,
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
                      icon: StreamSvgIcon.closeSmall(),
                      onPressed: Navigator.of(context).pop,
                    ),
                  ],
                ),
              ),
              widget.editMessageInputBuilder != null
                  ? widget.editMessageInputBuilder(context, widget.message)
                  : MessageInput(
                      editMessage: widget.message,
                      preMessageSending: (m) {
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                        return m;
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThreadReplyButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (widget.onThreadReplyTap != null) {
          widget.onThreadReplyTap(widget.message);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
        child: Row(
          children: [
            StreamSvgIcon.thread(
              color: StreamChatTheme.of(context).primaryIconTheme.color,
            ),
            const SizedBox(width: 16),
            Text(
              'Thread Reply',
              style: StreamChatTheme.of(context).textTheme.body,
            ),
          ],
        ),
      ),
    );
  }
}
