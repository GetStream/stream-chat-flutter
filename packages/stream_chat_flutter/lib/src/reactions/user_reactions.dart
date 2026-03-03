import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/avatar/stream_user_avatar.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

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
    final messageTheme = theme.getMessageTheme(reverse: isCurrentUserReaction);

    final resolver = StreamChatConfiguration.of(context).reactionIconResolver;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: switch (onTap) {
                final onTap? => () => onTap(reactionUser),
                _ => null,
              },
              child: StreamUserAvatar(
                size: .xl,
                user: reactionUser,
                showOnlineIndicator: false,
              ),
            ),
            PositionedDirectional(
              bottom: 8,
              end: isCurrentUserReaction ? null : 0,
              start: isCurrentUserReaction ? 0 : null,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: messageTheme.reactionsMaskColor,
                  borderRadius: const BorderRadius.all(Radius.circular(26)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: messageTheme.reactionsBackgroundColor,
                    border: Border.all(
                      color: messageTheme.reactionsBorderColor ?? Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                  ),
                  child: StreamEmoji(
                    size: StreamEmojiSize.sm,
                    emoji: resolver.resolve(context, reaction.type),
                  ),
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
