import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro visible_footnote}
@Deprecated("Use 'StreamVisibleFootnote' instead")
typedef VisibleFootnote = StreamVisibleFootnote;

/// {@template visible_footnote}
/// Widget for displaying a footnote
/// {@endtemplate}
class StreamVisibleFootnote extends StatelessWidget {
  /// Constructor for creating a [StreamVisibleFootnote]
  const StreamVisibleFootnote({super.key});

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamSvgIcon.eye(
          color: chatThemeData.colorTheme.textLowEmphasis,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          context.translations.onlyVisibleToYouText,
          style: chatThemeData.textTheme.footnote
              .copyWith(color: chatThemeData.colorTheme.textLowEmphasis),
        ),
      ],
    );
  }
}
