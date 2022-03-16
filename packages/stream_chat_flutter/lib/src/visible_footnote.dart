import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template visibleFootnote}
/// Informs the user about a [MessageWidget]'s visibility to the current user.
///
/// Used in [GiphyAttachment].
/// {@endtemplate}
class VisibleFootnote extends StatelessWidget {
  /// {@macro visibleFootnote}
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
