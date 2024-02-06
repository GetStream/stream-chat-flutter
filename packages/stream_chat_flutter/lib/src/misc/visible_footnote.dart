import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamVisibleFootnote}
/// Informs the user about a [StreamMessageWidget]'s visibility to the current
/// user.
///
/// Used in [StreamGiphyAttachment].
/// {@endtemplate}
class StreamVisibleFootnote extends StatelessWidget {
  /// {@macro streamVisibleFootnote}
  const StreamVisibleFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamSvgIcon.eye(
          size: 16,
          color: chatThemeData.colorTheme.textLowEmphasis,
        ),
        const SizedBox(width: 8),
        Text(
          context.translations.onlyVisibleToYouText,
          style: chatThemeData.textTheme.footnote.copyWith(
            color: chatThemeData.colorTheme.textLowEmphasis,
          ),
        ),
      ],
    );
  }
}
