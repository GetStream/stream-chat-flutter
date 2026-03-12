import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template threadSeparator}
/// A widget that separates messages in a thread. Not intended for use outside
/// of [StreamMessageWidget].
/// {@endtemplate}
class ThreadSeparator extends StatelessWidget {
  ///{@macro threadSeparator}
  const ThreadSeparator({
    super.key,
    this.parentMessage,
  });

  // ignore: public_member_api_docs
  final Message? parentMessage;

  @override
  Widget build(BuildContext context) {
    final replyCount = parentMessage!.replyCount!;
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
            context.translations.threadSeparatorText(replyCount),
            textAlign: TextAlign.center,
            style: textTheme.metadataEmphasis,
          ),
        ),
      ),
    );
  }
}
