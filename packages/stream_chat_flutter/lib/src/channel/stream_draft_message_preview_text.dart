import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that renders a preview of the draft message text.
class StreamDraftMessagePreviewText extends StatelessWidget {
  /// Creates a new instance of [StreamDraftMessagePreviewText].
  const StreamDraftMessagePreviewText({
    super.key,
    required this.draftMessage,
    this.textStyle,
    this.showCaption = true,
  });

  /// The draft message to display.
  final DraftMessage draftMessage;

  /// The style to use for the text.
  final TextStyle? textStyle;

  /// Whether to include the draft text caption alongside the type label.
  ///
  /// Set to `false` for tight previews (e.g. quoted / edit headers) where
  /// only the attachment type label should be shown.
  final bool showCaption;

  @override
  Widget build(BuildContext context) {
    final currentUser = StreamChat.maybeOf(context)?.currentUser;

    final config = StreamChatConfiguration.of(context);
    final formatter = config.messagePreviewFormatter;

    final previewTextSpan = formatter.formatDraftMessage(
      context,
      draftMessage,
      currentUser: currentUser,
      showCaption: showCaption,
    );

    return Text.rich(
      maxLines: 1,
      previewTextSpan,
      style: textStyle,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }
}
