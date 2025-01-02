import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that renders a preview of the message text.
class StreamMessagePreviewText extends StatelessWidget {
  /// Creates a new instance of [StreamMessagePreviewText].
  const StreamMessagePreviewText({
    super.key,
    required this.message,
    this.language,
    this.textStyle,
  });

  /// The message to display.
  final Message message;

  /// The language to use for translations.
  final String? language;

  /// The style to use for the text.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final messageText = message
        .translate(language ?? 'en')
        .replaceMentions(linkify: false)
        .text;
    final messageAttachments = message.attachments;
    final messageMentionedUsers = message.mentionedUsers;

    final mentionedUsersRegex = RegExp(
      messageMentionedUsers.map((it) => '@${it.name}').join('|'),
      caseSensitive: false,
    );

    final messageTextParts = switch (message.isDeleted) {
      // Show the deleted message label if the message is deleted.
      true => [context.translations.messageDeletedLabel],
      // Otherwise, combine the message text with the attachments and poll.
      false => [
          ...messageAttachments.map(
            (it) => switch (it.type) {
              AttachmentType.image => '📷',
              AttachmentType.video => '🎬',
              AttachmentType.giphy => '[GIF]',
              _ => it == message.attachments.last
                  ? (it.title ?? 'File')
                  : '${it.title ?? 'File'} , ',
            },
          ),
          if (message.poll?.name case final pollName?) '📊 $pollName',
          if (messageText != null)
            if (messageMentionedUsers.isNotEmpty)
              ...mentionedUsersRegex.allMatchesWithSep(messageText)
            else
              messageText,
        ]
    };

    final fontStyle = (message.isSystem || message.isDeleted)
        ? FontStyle.italic
        : FontStyle.normal;

    final regularTextStyle = textStyle?.copyWith(fontStyle: fontStyle);

    final mentionsTextStyle = textStyle?.copyWith(
      fontStyle: fontStyle,
      fontWeight: FontWeight.bold,
    );

    final spans = [
      ...messageTextParts.map((part) {
        if (messageMentionedUsers.any((it) => '@${it.name}' == part)) {
          return TextSpan(
            text: part,
            style: mentionsTextStyle,
          );
        }

        if (messageAttachments.any((it) => it.title == part)) {
          return TextSpan(
            text: part,
            style: regularTextStyle?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          );
        }

        return TextSpan(
          text: part,
          style: regularTextStyle,
        );
      })
    ];

    return Text.rich(
      TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }
}

extension _RegExpX on RegExp {
  List<String> allMatchesWithSep(String input, [int start = 0]) {
    final result = <String>[];
    for (final match in allMatches(input, start)) {
      result.add(input.substring(start, match.start));
      // ignore: cascade_invocations
      result.add(match[0]!);
      // ignore: parameter_assignments
      start = match.end;
    }
    result.add(input.substring(start));
    return result;
  }
}
