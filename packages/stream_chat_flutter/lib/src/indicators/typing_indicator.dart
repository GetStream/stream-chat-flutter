import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';
import '../misc/empty_widget.dart';

/// Shows who is typing as a line of text followed by animated dots.
///
/// Shows [alternativeWidget] when nobody is typing.
///
/// ```dart
/// StreamTypingIndicator(alternativeWidget: Text(lastMessageText))
/// ```
///
/// See also:
///
///  * [StreamMessageListTypingIndicator], for the message list.
///  * [StreamTypingIndicatorDots], for the dots alone.
///  * [StreamTypingUsersBuilder], to build a custom one.
class StreamTypingIndicator extends StatelessWidget {
  /// Creates a typing indicator for [channel], or a thread of it.
  const StreamTypingIndicator({
    super.key,
    this.channel,
    this.parentId,
    this.alternativeWidget,
    this.style,
    this.padding = EdgeInsets.zero,
  });

  /// The channel to watch.
  ///
  /// If null, uses the closest [StreamChannel].
  final Channel? channel;

  /// The parent message id of the thread to watch.
  ///
  /// If null, watches the channel itself.
  final String? parentId;

  /// Shown when nobody is typing.
  final Widget? alternativeWidget;

  /// The style of the typing text.
  ///
  /// If null, uses the surrounding [DefaultTextStyle].
  final TextStyle? style;

  /// The padding around the typing text and dots.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return StreamTypingUsersBuilder(
      channel: channel,
      parentId: parentId,
      builder: (context, users) => AnimatedSwitcher(
        layoutBuilder: (currentChild, previousChildren) => Stack(
          children: [...previousChildren, ?currentChild],
        ),
        duration: const Duration(milliseconds: 300),
        child: switch (users) {
          [] => alternativeWidget ?? const Empty(),
          _ => _TypingText(users: users, style: style, padding: padding),
        },
      ),
    );
  }
}

class _TypingText extends StatelessWidget {
  const _TypingText({
    required this.users,
    this.style,
    required this.padding,
  });

  final List<User> users;
  final TextStyle? style;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final typingText = context.translations.userTypingText(users);

    return Semantics(
      container: true,
      label: typingText,
      excludeSemantics: true,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: .min,
          spacing: context.streamSpacing.xs,
          children: [
            Flexible(
              child: Text(typingText, maxLines: 1, style: style),
            ),
            Padding(
              // Centers the dots on the text.
              padding: const EdgeInsets.only(top: 2),
              child: StreamTypingIndicatorDots(),
            ),
          ],
        ),
      ),
    );
  }
}
