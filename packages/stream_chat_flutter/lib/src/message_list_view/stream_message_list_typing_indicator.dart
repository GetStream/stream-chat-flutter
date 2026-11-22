import 'package:flutter/widgets.dart';

import '../../stream_chat_flutter.dart';

/// Shows who is typing as an incoming message.
///
/// ```dart
/// StreamMessageListTypingIndicator(users: typingUsers)
/// ```
///
/// See also:
///
///  * [StreamMessageListViewBuilders.typingIndicator], to replace it.
///  * [StreamMessageListViewConfiguration.showTypingIndicator], to hide it.
class StreamMessageListTypingIndicator extends StatelessWidget {
  /// Creates a typing indicator row for [users].
  const StreamMessageListTypingIndicator({super.key, required this.users});

  // Same height as a single-line message.
  static const _bubbleHeight = 36.0;

  /// The users currently typing.
  final List<User> users;

  @override
  Widget build(BuildContext context) {
    final theme = StreamMessageItemTheme.of(context);
    final spacing = context.streamSpacing;

    final effectivePadding = theme.padding ?? EdgeInsets.symmetric(horizontal: spacing.md);
    final effectiveSpacing = theme.spacing ?? spacing.xs;

    return Semantics(
      container: true,
      label: context.translations.userTypingText(users),
      excludeSemantics: true,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: effectivePadding,
          child: Row(
            mainAxisSize: .min,
            spacing: effectiveSpacing,
            crossAxisAlignment: .end,
            children: [
              StreamUserAvatarStack(users: users, size: .md, max: 3),
              StreamMessageBubble(
                padding: .symmetric(horizontal: spacing.sm, vertical: spacing.xs),
                style: .new(constraints: .all(const .tightFor(height: _bubbleHeight))),
                child: Center(child: StreamTypingIndicatorDots()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
