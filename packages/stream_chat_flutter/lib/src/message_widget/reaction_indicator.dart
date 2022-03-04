import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/reaction_bubble.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ReactionIndicator extends StatelessWidget {
  const ReactionIndicator({
    Key? key,
    required this.ownId,
    required this.message,
    required this.shouldShowReactions,
    required this.onTap,
    required this.reverse,
    required this.messageTheme,
  }) : super(key: key);

  final String ownId;
  final Message message;
  final bool shouldShowReactions;
  final VoidCallback onTap;
  final bool reverse;

  /// The message theme
  final MessageThemeData messageTheme;

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
                  child: ReactionBubble(
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
