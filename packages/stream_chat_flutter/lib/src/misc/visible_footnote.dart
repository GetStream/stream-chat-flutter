import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamVisibleFootnote}
/// Informs the user about a [StreamMessageItem]'s visibility to the current
/// user.
///
/// Used in [StreamGiphyAttachment].
/// {@endtemplate}
class StreamVisibleFootnote extends StatelessWidget {
  /// {@macro streamVisibleFootnote}
  const StreamVisibleFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          context.streamIcons.eyeFill,
          size: 16,
          color: colorScheme.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          context.translations.onlyVisibleToYouText,
          style: context.streamTextTheme.captionDefault.copyWith(
            color: colorScheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
