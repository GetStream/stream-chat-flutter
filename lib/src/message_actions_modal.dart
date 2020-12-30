import 'dart:ui';

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

class MessageActionsModal extends StatelessWidget {
  final Widget Function(BuildContext, Message) editMessageInputBuilder;
  final void Function(Message) onThreadTap;
  final Message message;
  final MessageTheme messageTheme;
  final bool showReactions;
  final bool showDeleteMessage;
  final bool showCopyMessage;
  final bool showEditMessage;
  final bool showReply;
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
    this.onThreadTap,
    this.showCopyMessage = true,
    this.showReply = true,
    this.showUserAvatar = DisplayWidget.show,
    this.editMessageInputBuilder,
    this.messageShape,
    this.reverse = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = StreamChat.of(context).user;

    final roughMaxSize = 2 * size.width / 3;
    final roughSentenceSize =
        message.text.length * messageTheme.messageText.fontSize * 1.2;
    final divFactor = message.attachments?.isNotEmpty == true
        ? 1
        : (roughSentenceSize == 0 ? 1 : (roughSentenceSize / roughMaxSize));

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pop(context);
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.8731,
                sigmaY: 10.8731,
              ),
              child: Container(
                color: Colors.black.withOpacity(.2),
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
                    if (showReactions &&
                        (message.status == MessageSendingStatus.SENT ||
                            message.status == null))
                      Align(
                        alignment: Alignment(
                            user.id == message.user.id
                                ? (divFactor > 1.0 ? 0.0 : (1.0 - divFactor))
                                : (divFactor > 1.0 ? 0.0 : -(1.0 - divFactor)),
                            0.0),
                        child: ReactionPicker(
                          message: message,
                          messageTheme: messageTheme,
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
                                reverse: reverse,
                                message: message.copyWith(
                                  text: message.text.length > 200
                                      ? '${message.text.substring(0, 200)}...'
                                      : message.text,
                                ),
                                messageTheme: messageTheme,
                                showReactions: false,
                                showUsername: false,
                                showThreadReplyIndicator: false,
                                showUserAvatar: showUserAvatar,
                                showTimestamp: false,
                                translateUserAvatar: false,
                                showReactionPickerIndicator: true,
                                showInChannelIndicator: false,
                                showSendingIndicator: DisplayWidget.gone,
                                shape: messageShape,
                              ),
                            ),
                          );
                        }),
                    SizedBox(
                      height: 8,
                    ),
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
                                      if (showReply &&
                                          (message.status ==
                                                  MessageSendingStatus.SENT ||
                                              message.status == null) &&
                                          message.parentId == null)
                                        _buildReplyButton(context),
                                      if (showEditMessage)
                                        _buildEditMessage(context),
                                      if (showDeleteMessage)
                                        _buildDeleteButton(context),
                                      if (showCopyMessage)
                                        _buildCopyButton(context),
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

  Widget _buildDeleteButton(BuildContext context) {
    return ListTile(
      title: Text(
        'Delete message',
        style:
            Theme.of(context).textTheme.headline6.copyWith(color: Colors.red),
      ),
      leading: StreamSvgIcon.delete(
        color: Colors.red,
      ),
      onTap: () {
        Navigator.pop(context);
        StreamChat.of(context).client.deleteMessage(
              message,
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
        await Clipboard.setData(ClipboardData(text: message.text));
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

  void _showEditBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
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
          channel: channel,
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
                    IconButton(
                      icon: StreamSvgIcon.edit(
                        size: 22,
                        color:
                            StreamChatTheme.of(context).primaryIconTheme.color,
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      'Edit message',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: 22,
                        color:
                            StreamChatTheme.of(context).primaryIconTheme.color,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: editMessageInputBuilder != null
                    ? editMessageInputBuilder(context, message)
                    : MessageInput(
                        editMessage: message,
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

  Widget _buildReplyButton(BuildContext context) {
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
        if (onThreadTap != null) {
          onThreadTap(message);
        }
      },
    );
  }
}
