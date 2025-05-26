import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/avatars/user_avatar.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/reactions/reaction_bubble.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamUserReactions}
/// A widget that displays the reactions of a user to a message.
///
/// This widget is typically used in a modal or a dedicated section
/// to show all reactions made by users on a specific message.
/// {@endtemplate}
class StreamUserReactions extends StatelessWidget {
  /// {@macro streamUserReactions}
  const StreamUserReactions({
    super.key,
    required this.message,
    this.onUserAvatarTap,
  });

  /// Message to display reactions of.
  final Message message;

  /// {@macro onUserAvatarTap}
  final ValueSetter<User>? onUserAvatarTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    return Material(
      color: colorTheme.barsBg,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.translations.messageReactionsLabel,
              style: textTheme.headlineBold,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    ...?message.latestReactions?.map((reaction) {
                      return _UserReactionItem(
                        key: Key('${reaction.userId}-${reaction.type}'),
                        reaction: reaction,
                        onTap: onUserAvatarTap,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserReactionItem extends StatelessWidget {
  const _UserReactionItem({
    super.key,
    required this.reaction,
    this.onTap,
  });

  final Reaction reaction;

  /// {@macro onUserAvatarTap}
  final ValueSetter<User>? onTap;

  @override
  Widget build(BuildContext context) {
    final reactionUser = reaction.user;
    if (reactionUser == null) return const Empty();

    final currentUser = StreamChatCore.of(context).currentUser;
    final isCurrentUserReaction = reactionUser.id == currentUser?.id;

    final theme = StreamChatTheme.of(context);
    final messageTheme = theme.getMessageTheme(reverse: !isCurrentUserReaction);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            StreamUserAvatar(
              onTap: onTap,
              user: reactionUser,
              showOnlineStatus: false,
              borderRadius: BorderRadius.circular(32),
              constraints: const BoxConstraints.tightFor(height: 64, width: 64),
            ),
            PositionedDirectional(
              bottom: 0,
              start: isCurrentUserReaction ? 0 : null,
              end: isCurrentUserReaction ? null : 0,
              child: IgnorePointer(
                child: StreamReactionBubble(
                  reactions: [reaction],
                  reverse: isCurrentUserReaction,
                  flipTail: isCurrentUserReaction,
                  backgroundColor: messageTheme.reactionsBackgroundColor ??
                      Colors.transparent,
                  borderColor:
                      messageTheme.reactionsBorderColor ?? Colors.transparent,
                  maskColor:
                      messageTheme.reactionsMaskColor ?? Colors.transparent,
                  tailCirclesSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          reactionUser.name.split(' ')[0],
          style: theme.textTheme.footnoteBold,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
