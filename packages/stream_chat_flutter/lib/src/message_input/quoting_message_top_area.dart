import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The area that appears above [MessageInput] when the user is quoting a
/// message.
///
/// Should only be used on mobile platforms.
class QuotingMessageTopArea extends StatelessWidget {
  /// Builds a [QuotingMessageTopArea].
  const QuotingMessageTopArea({
    Key? key,
    this.onQuotedMessageCleared,
  }) : super(key: key);

  /// The callback to perform when the "close" button is tapped.
  ///
  /// Should be [MessageInput.onQuotedMessageCleared].
  final VoidCallback? onQuotedMessageCleared;

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: StreamSvgIcon.reply(
              color: _streamChatTheme.colorTheme.disabled,
            ),
          ),
          Text(
            context.translations.replyToMessageLabel,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: StreamSvgIcon.closeSmall(),
            onPressed: onQuotedMessageCleared?.call,
          ),
        ],
      ),
    );
  }
}
