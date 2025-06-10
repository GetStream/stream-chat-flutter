import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
    required this.onTap,
    required this.reverse,
    required this.messageTheme,
  });

  /// The id of the current user.
  final String ownId;

  /// {@macro message}
  final Message message;

  /// The callback to perform when the widget is tapped or clicked.
  final VoidCallback onTap;

  /// {@macro reverse}
  final bool reverse;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  @override
  Widget build(BuildContext context) {
    final reactionsMap = <String, Reaction>{};
    for (final reaction in [...?message.latestReactions]) {
      final reactionType = reaction.type;
      final userId = reaction.user?.id;

      if (reactionsMap.containsKey(reactionType) && userId != ownId) continue;
      reactionsMap[reactionType] = reaction;
    }

    final reactionsList = reactionsMap.values.sorted((prev, curr) {
      final prevUserId = prev.user?.id;
      final currUserId = curr.user?.id;

      if (prevUserId == null && currUserId == null) return 0;
      if (prevUserId == null) return 1;
      if (currUserId == null) return -1;

      if (prevUserId == ownId) return 1;
      return -1;
    });

    return GestureDetector(
      onTap: onTap,
      child: StreamReactionBubble(
        key: ValueKey('${message.id}.reactions'),
        reverse: reverse,
        flipTail: reverse,
        backgroundColor:
            messageTheme.reactionsBackgroundColor ?? Colors.transparent,
        borderColor: messageTheme.reactionsBorderColor ?? Colors.transparent,
        maskColor: messageTheme.reactionsMaskColor ?? Colors.transparent,
        reactions: reactionsList,
      ),
    );
  }
}
