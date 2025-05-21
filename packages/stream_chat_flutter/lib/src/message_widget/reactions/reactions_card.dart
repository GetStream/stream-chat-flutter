import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/avatars/user_avatar.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reaction_bubble.dart';
import 'package:stream_chat_flutter/src/theme/message_theme.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template reactionsCard}
/// A card that displays the reactions to a message.
///
/// Used in [StreamMessageReactionsModal] and [DesktopReactionsBuilder].
/// {@endtemplate}
class ReactionsCard extends StatelessWidget {
  /// {@macro reactionsCard}
  const ReactionsCard({
    super.key,
    this.elevation,
    required this.currentUser,
    required this.message,
    required this.messageTheme,
    this.onUserAvatarTap,
  });

  /// The elevation of the card.
  final double? elevation;

  /// Current logged in user.
  final User currentUser;

  /// Message to display reactions of.
  final Message message;

  /// [StreamMessageThemeData] to apply to [message].
  final StreamMessageThemeData messageTheme;

  /// {@macro onUserAvatarTap}
  final void Function(User)? onUserAvatarTap;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return Card(
      elevation: elevation,
      color: chatThemeData.colorTheme.barsBg,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.translations.messageReactionsLabel,
              style: chatThemeData.textTheme.headlineBold,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: message.latestReactions!
                      .map((e) => _buildReaction(
                            e,
                            currentUser,
                            context,
                          ))
                      .toList(),
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
    final isCurrentUser = reaction.user?.id == currentUser.id;
    final chatThemeData = StreamChatTheme.of(context);
    final reverse = !isCurrentUser;
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        const Size(64, 100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              StreamUserAvatar(
                onTap: onUserAvatarTap,
                user: reaction.user!,
                constraints: const BoxConstraints.tightFor(
                  height: 64,
                  width: 64,
                ),
                onlineIndicatorConstraints: const BoxConstraints.tightFor(
                  height: 12,
                  width: 12,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              Positioned(
                bottom: 6,
                left: !reverse ? -3 : null,
                right: reverse ? -3 : null,
                child: Align(
                  alignment:
                      reverse ? Alignment.centerRight : Alignment.centerLeft,
                  child: StreamReactionBubble(
                    reactions: [reaction],
                    reverse: !reverse,
                    flipTail: !reverse,
                    borderColor:
                        messageTheme.reactionsBorderColor ?? Colors.transparent,
                    backgroundColor: messageTheme.reactionsBackgroundColor ??
                        Colors.transparent,
                    maskColor: chatThemeData.colorTheme.barsBg,
                    tailCirclesSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reaction.user!.name.split(' ')[0],
            style: chatThemeData.textTheme.footnoteBold,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
