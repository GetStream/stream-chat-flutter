import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reaction_bubble.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template reactionIndicator}
/// Indicates the reaction a [StreamMessageWidget] has.
///
/// Used in [MessageWidgetContent].
/// {@endtemplate}
class ReactionIndicator extends StatelessWidget {
  /// {@macro reactionIndicator}
  const ReactionIndicator({
    super.key,
    required this.ownId,
    required this.message,
    required this.shouldShowReactions,
    required this.onTap,
    required this.reverse,
    required this.messageTheme,
  });

  /// The id of the current user.
  final String ownId;

  /// {@macro message}
  final Message message;

  /// {@macro shouldShowReactions}
  final bool shouldShowReactions;

  /// The callback to perform when the widget is tapped or clicked.
  final VoidCallback onTap;

  /// {@macro reverse}
  final bool reverse;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  @override
  Widget build(BuildContext context) {
    final reactionsMap = <String, Reaction>{};
    message.latestReactions?.forEach((element) {
      if (!reactionsMap.containsKey(element.type) ||
          element.user!.id == ownId) {
        reactionsMap[element.type] = element;
      }
    });
    final reactionsList = reactionsMap.values.toList()
      ..sort((a, b) => a.user!.id == ownId ? 1 : -1);

    return Transform(
      transform: Matrix4.translationValues(
        reverse ? 12 : -12,
        0,
        0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 22 * 6.0,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: shouldShowReactions
              ? GestureDetector(
                  onTap: onTap,
                  child: StreamReactionBubble(
                    key: ValueKey('${message.id}.reactions'),
                    reverse: reverse,
                    flipTail: reverse,
                    backgroundColor: messageTheme.reactionsBackgroundColor ??
                        Colors.transparent,
                    borderColor:
                        messageTheme.reactionsBorderColor ?? Colors.transparent,
                    maskColor:
                        messageTheme.reactionsMaskColor ?? Colors.transparent,
                    reactions: reactionsList,
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
