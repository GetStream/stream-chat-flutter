// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
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
    } else {
      return const SizedBox.shrink();
    }
  }
}
