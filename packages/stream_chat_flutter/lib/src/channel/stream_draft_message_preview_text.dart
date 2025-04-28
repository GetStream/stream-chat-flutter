import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that renders a preview of the draft message text.
class StreamDraftMessagePreviewText extends StatelessWidget {
  /// Creates a new instance of [StreamDraftMessagePreviewText].
  const StreamDraftMessagePreviewText({
    super.key,
    required this.draftMessage,
    this.textStyle,
  });

  /// The draft message to display.
  final DraftMessage draftMessage;

  /// The style to use for the text.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    final previewTextSpan = TextSpan(
      text: '${context.translations.draftLabel}: ',
      style: textStyle?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorTheme.accentPrimary,
      ),
      children: [
        TextSpan(text: draftMessage.text, style: textStyle),
      ],
    );

    return Text.rich(
      maxLines: 1,
      previewTextSpan,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }
}
