import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Displays a list of users who reacted
class UserReactionDisplay extends StatelessWidget {
  /// Constructor for creating a [UserReactionDisplay]
  const UserReactionDisplay({
    Key? key,
    required this.reactionToEmoji,
    required this.message,
    this.size = 30,
  }) : super(key: key);

  /// Reaction map
  final Map<String, String> reactionToEmoji;

  /// Message which is reacted to
  final Message message;

  /// Size of Icon
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.black87,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: reactionToEmoji.keys.map((reactionType) {
            final firstUserReaction = message.latestReactions!
                .firstWhere((element) => element.type == reactionType,
                    //ignore: unnecessary_parenthesis
                    orElse: (() => null) as Reaction Function()?);

            if (firstUserReaction.user == null) {
              return IconButton(
                iconSize: size,
                icon: Container(),
                onPressed: null,
              );
            }

            return IconButton(
              iconSize: size,
              icon: UserAvatar(
                user: firstUserReaction.user!,
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
