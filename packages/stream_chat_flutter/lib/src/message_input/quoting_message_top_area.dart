import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/stream_message_input_icon_button.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template quotingMessageTopArea}
/// The area that appears above [MessageInput] when the user is quoting a
/// message.
///
/// Should only be used on mobile platforms.
/// {@endtemplate}
class QuotingMessageTopArea extends StatelessWidget {
  /// {@macro quotingMessageTopArea}
  const QuotingMessageTopArea({
    super.key,
    required this.hasQuotedMessage,
    this.onQuotedMessageCleared,
  });

  ///
  final bool hasQuotedMessage;

  /// The callback to perform when the "close" button is tapped.
  ///
  /// Should be [MessageInput.onQuotedMessageCleared].
  final VoidCallback? onQuotedMessageCleared;

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);
    if (hasQuotedMessage) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamMessageInputIconButton(
              iconSize: 24,
              color: _streamChatTheme.colorTheme.disabled,
              icon: const StreamSvgIcon(icon: StreamSvgIcons.reply),
              onPressed: null,
            ),
            Text(
              context.translations.replyToMessageLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            StreamMessageInputIconButton(
              iconSize: 24,
              color: _streamChatTheme.colorTheme.textLowEmphasis,
              icon: const StreamSvgIcon(icon: StreamSvgIcons.closeSmall),
              onPressed: onQuotedMessageCleared?.call,
            ),
          ],
        ),
      );
    } else {
      return const Empty();
    }
  }
}
