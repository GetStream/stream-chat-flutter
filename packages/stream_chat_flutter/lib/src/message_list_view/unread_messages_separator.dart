import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template unreadMessagesSeparator}
/// {@endtemplate}
class UnreadMessagesSeparator extends StatelessWidget {
  /// {@macro unreadMessagesSeparator}
  const UnreadMessagesSeparator({
    super.key,
    required this.unreadCount,
  });

  /// Number of unread messages.
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.backgroundSurfaceSubtle,
          border: Border(
            top: BorderSide(color: colorScheme.borderSubtle),
            bottom: BorderSide(color: colorScheme.borderSubtle),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing.xs),
          child: Text(
            context.translations.unreadMessagesSeparatorText(),
            textAlign: TextAlign.center,
            style: textTheme.metadataEmphasis,
          ),
        ),
      ),
    );
  }
}
