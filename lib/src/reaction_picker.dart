import 'package:flutter/material.dart';

import '../stream_chat_flutter.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/reaction_picker.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/reaction_picker_paint.png)
///
/// It shows a reaction picker
///
/// Usually you don't use this widget as it's one of the default widgets used by [MessageWidget.onMessageActions].
class ReactionPicker extends StatelessWidget {
  const ReactionPicker({
    Key key,
    @required this.message,
    @required this.channel,
    @required this.messageTheme,
  }) : super(key: key);

  final Message message;
  final MessageTheme messageTheme;
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final reactionAssets = StreamChatTheme.of(context).reactionIcons;
    return Material(
      color: messageTheme.ownReactionsBackgroundColor,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: reactionAssets.map((reactionIcon) {
          final ownReactionIndex = message.ownReactions?.indexWhere(
                  (reaction) => reaction.type == reactionIcon.type) ??
              -1;
          return IconButton(
            iconSize: 24,
            icon: Icon(
              reactionIcon.iconData,
              color: ownReactionIndex != -1
                  ? StreamChatTheme.of(context).accentColor
                  : Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              if (ownReactionIndex != -1) {
                removeReaction(
                  context,
                  message.ownReactions[ownReactionIndex],
                );
              } else {
                sendReaction(
                  context,
                  reactionIcon.type,
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }

  /// Add a reaction to the message
  void sendReaction(BuildContext context, String reactionType) {
    channel.sendReaction(message, reactionType);
    Navigator.of(context).pop();
  }

  /// Remove a reaction from the message
  void removeReaction(BuildContext context, Reaction reaction) {
    channel.deleteReaction(message, reaction);
    Navigator.of(context).pop();
  }
}
