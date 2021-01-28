import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';

class UserReactionDisplay extends StatelessWidget {
  const UserReactionDisplay({
    Key key,
    @required this.reactionToEmoji,
    @required this.message,
    this.size = 30,
  }) : super(key: key);

  final Map<String, String> reactionToEmoji;
  final Message message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: reactionToEmoji.keys.map((reactionType) {
          var firstUserReaction = message.latestReactions.firstWhere(
              (element) => element.type == reactionType, orElse: () {
            return null;
          });

          if (firstUserReaction == null) {
            return IconButton(
              iconSize: size,
              icon: Container(),
              onPressed: null,
            );
          }

          return IconButton(
            iconSize: size,
            icon: UserAvatar(
              user: firstUserReaction.user,
              constraints: BoxConstraints(
                maxHeight: size - 5,
                maxWidth: size - 5,
              ),
              onTap: (user) {},
            ),
            onPressed: () {},
          );
        }).toList(),
      ),
    );
  }
}
