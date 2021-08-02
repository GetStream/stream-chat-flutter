import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter/src/extension.dart';

/// Widget for displaying a footnote
class VisibleFootnote extends StatelessWidget {
  /// Constructor for creating a [VisibleFootnote]
  const VisibleFootnote({Key? key}) : super(key: key);

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
