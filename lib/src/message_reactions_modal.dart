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
  final bool reverse;
  final bool showReactions;
  final DisplayWidget showUserAvatar;
  final ShapeBorder messageShape;
  final void Function(User) onUserAvatarTap;

  const MessageReactionsModal({
    Key key,
    @required this.message,
    @required this.messageTheme,
    this.showReactions = true,
    this.onThreadTap,
    this.editMessageInputBuilder,
    this.messageShape,
    this.reverse = false,
    this.showUserAvatar = DisplayWidget.show,
    this.onUserAvatarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                color: Colors.black.withOpacity(0.1),
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
                        alignment: Alignment(-0.3, 0.0),
                        child: ReactionPicker(
                          message: message,
                          messageTheme: messageTheme,
                        ),
                      ),
                    IgnorePointer(
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
                        showUserAvatar: showUserAvatar,
                        showReplyIndicator: false,
                        showTimestamp: false,
                        translateUserAvatar: false,
                        showSendingIndicator: DisplayWidget.gone,
                        shape: messageShape,
                        showReactionPickerIndicator: true,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    if (message.latestReactions?.isNotEmpty == true)
                      _buildReactionCard(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 18,
                    bottom: 26,
                  ),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 22,
                    alignment: WrapAlignment.start,
                    children: message.latestReactions
                        .map((e) => _buildReaction(
                              e,
                              currentUser,
                              context,
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReaction(
    Reaction reaction,
    User currentUser,
    BuildContext context,
  ) {
    final isCurrentUser = reaction.user.id == currentUser.id;
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(
        64,
        98,
      )),
      child: Column(
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ReactionBubble(
                    reactions: [reaction],
                    borderColor: messageTheme.reactionsBorderColor,
                    backgroundColor: messageTheme.reactionsBackgroundColor,
                    highlightOwnReactions: false,
                  ),
                ),
                bottom: 4,
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
      ),
    );
  }
}
