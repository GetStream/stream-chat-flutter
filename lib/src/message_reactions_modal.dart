import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/src/reaction_picker.dart';
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
  final void Function(User) onUserAvatarTap;

  const MessageReactionsModal({
    Key key,
    @required this.message,
    @required this.messageTheme,
    this.showReactions = true,
    this.showDeleteMessage,
    this.showEditMessage,
    this.onThreadTap,
    this.showReply,
    this.editMessageInputBuilder,
    this.messageShape,
    this.reverse = false,
    this.onUserAvatarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              height: 16,
            ),
            if (message.latestReactions?.isNotEmpty == true)
              Container(
                constraints: BoxConstraints.loose(Size.fromHeight(400)),
                child: _buildReactionCard(context),
              ),
          ],
        ),
      ],
    );
  }

  Padding _buildReactionCard(BuildContext context) {
    final currentUser = StreamChat.of(context).user;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Message Reactions',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  bottom: 16,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 22,
                  ),
                  itemCount: message.latestReactions.length,
                  itemBuilder: (context, i) {
                    final reaction = message.latestReactions[i];

                    return _buildReaction(
                      reaction,
                      currentUser,
                      context,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildReaction(
    Reaction reaction,
    User currentUser,
    BuildContext context,
  ) {
    final isCurrentUser = reaction.user.id == currentUser.id;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            UserAvatar(
              onTap: onUserAvatarTap,
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
                    : messageTheme.otherReactionsBackgroundColor,
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
  }
}
