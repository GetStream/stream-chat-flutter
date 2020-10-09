import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/reaction_picker.dart';
import 'package:stream_chat_flutter/src/stream_channel.dart';
import 'package:stream_chat_flutter/src/user_reaction_display.dart';

import '../stream_chat_flutter.dart';
import 'message_input.dart';
import 'stream_chat.dart';

class MessageActionsBottomSheet extends StatelessWidget {
  final Widget Function(BuildContext, Message) editMessageInputBuilder;
  final void Function(Message) onThreadTap;
  final Message message;
  final bool showReactions;
  final bool showDeleteMessage;
  final bool showEditMessage;
  final bool showReply;
  final Map<String, String> reactionToEmoji = const {
    'love': '❤️️',
    'haha': '😂',
    'like': '👍',
    'sad': '😕',
    'angry': '😡',
    'wow': '😲',
  };

  const MessageActionsBottomSheet({
    Key key,
    this.message,
    this.showReactions,
    this.showDeleteMessage,
    this.showEditMessage,
    this.onThreadTap,
    this.showReply,
    this.editMessageInputBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (showReactions &&
              (message.status == MessageSendingStatus.SENT ||
                  message.status == null) &&
              message.latestReactions.isNotEmpty)
            UserReactionDisplay(
              reactionToEmoji: reactionToEmoji,
              message: message,
            ),
          if (showReactions &&
              (message.status == MessageSendingStatus.SENT ||
                  message.status == null))
            ReactionPicker(
              channel: channel,
              reactionToEmoji: reactionToEmoji,
              message: message,
            ),
          if (showDeleteMessage) _buildDeleteButton(context),
          if (showEditMessage) _buildEditMessage(context),
          if (showReply &&
              (message.status == MessageSendingStatus.SENT ||
                  message.status == null) &&
              message.parentId == null)
            _buildReplyButton(context),
        ],
      ),
    );
  }

  FlatButton _buildDeleteButton(BuildContext context) {
    return FlatButton(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Delete message',
          style:
              Theme.of(context).textTheme.headline5.copyWith(color: Colors.red),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        StreamChat.of(context).client.deleteMessage(
              message,
              StreamChannel.of(context).channel.cid,
            );
      },
    );
  }

  FlatButton _buildEditMessage(BuildContext context) {
    return FlatButton(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Edit message',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      onPressed: () async {
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
                    Text(
                      'Edit message',
                      style: Theme.of(context).textTheme.headline6,
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
                            color: StreamChatTheme.of(context)
                                .primaryIconTheme
                                .color,
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

  FlatButton _buildReplyButton(BuildContext context) {
    return FlatButton(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Start a thread',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        if (onThreadTap != null) {
          onThreadTap(message);
        }
      },
    );
  }
}
