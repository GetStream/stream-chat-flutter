import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/src/reaction_picker.dart';
import 'package:stream_chat_flutter/src/stream_channel.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';

import 'message_widget.dart';
import 'stream_chat_theme.dart';

class MessageReactionsModal extends StatelessWidget {
  final Widget Function(BuildContext, Message) editMessageInputBuilder;
  final void Function(Message) onThreadTap;
  final Message message;
  final MessageTheme messageTheme;
  final bool showReactions;
  final bool showDeleteMessage;
  final bool showEditMessage;
  final bool showReply;
  final bool reverse;
  final ShapeBorder messageShape;

  const MessageReactionsModal({
    Key key,
    @required this.message,
    @required this.messageTheme,
    this.showReactions,
    this.showDeleteMessage,
    this.showEditMessage,
    this.onThreadTap,
    this.showReply,
    this.editMessageInputBuilder,
    this.messageShape,
    this.reverse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (showReactions &&
                (message.status == MessageSendingStatus.SENT ||
                    message.status == null))
              Center(
                child: ReactionPicker(
                  channel: channel,
                  message: message,
                  messageTheme: messageTheme,
                ),
              ),
            AbsorbPointer(
              child: MessageWidget(
                reverse: reverse,
                message: message,
                messageTheme: messageTheme,
                showReactions: false,
                showUsername: false,
                showReplyIndicator: false,
                showTimestamp: false,
                showSendingIndicator: DisplayWidget.gone,
                shape: messageShape,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            if (message.latestReactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 22,
                    ),
                    itemCount: message.latestReactions.length,
                    itemBuilder: (context, i) {
                      final reaction = message.latestReactions[i];
                      final isCurrentUser =
                          reaction.user.id == StreamChat.of(context).user.id;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              UserAvatar(
                                user: reaction.user,
                                constraints: BoxConstraints.tightFor(
                                  height: 64,
                                  width: 64,
                                ),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              Positioned(
                                child: ReactionBubble(
                                  reactions: [reaction],
                                  borderColor: isCurrentUser
                                      ? messageTheme.ownReactionsBorderColor
                                      : messageTheme.otherReactionsBorderColor,
                                  backgroundColor: isCurrentUser
                                      ? messageTheme.ownReactionsBackgroundColor
                                      : messageTheme
                                          .otherReactionsBackgroundColor,
                                  flipTail: !isCurrentUser,
                                ),
                                bottom: 0,
                                left: isCurrentUser ? 0 : null,
                                right: isCurrentUser ? 0 : null,
                              ),
                            ],
                          ),
                          Text(
                            reaction.user.name,
                            style: Theme.of(context).textTheme.subtitle2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}
