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
    final currentUser = StreamChat.of(context).currentUser!;
    final translatedMessage = message.translate(language ?? 'en');
    final previewMessage = translatedMessage.replaceMentions(linkify: false);

    final previewText = _getPreviewText(context, previewMessage, currentUser);

    final mentionedUsers = message.mentionedUsers;
    final mentionedUsersRegex = RegExp(
      mentionedUsers.map((it) => '@${it.name}').join('|'),
    );

    final previewTextSpan = TextSpan(
      children: [
        ...previewText.splitByRegExp(mentionedUsersRegex).map(
          (text) {
            // Bold the text if it is a mention user.
            if (mentionedUsers.any((it) => '@${it.name}' == text)) {
              return TextSpan(
                text: text,
                style: textStyle?.copyWith(fontWeight: FontWeight.bold),
              );
            }

            return TextSpan(
              text: text,
              style: textStyle,
            );
          },
        )
      ],
    );

    return Text.rich(
      maxLines: 1,
      previewTextSpan,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }

  /// Returns the preview text based on the message context
  String _getPreviewText(
    BuildContext context,
    Message message,
    User currentUser,
  ) {
    if (message.isDeleted) {
      return context.translations.messageDeletedLabel;
    }

    if (message.isSystem) {
      return message.text ?? 'Empty System Message';
    }

    if (message.poll case final poll?) {
      return _pollPreviewText(context, poll, currentUser);
    }

    final previewText = _previewMessageContextText(context, message);
    if (previewText == null) return 'No messages';

    // TODO: Handle Author name, Requires channel member count (breaking)

    return previewText;
  }

  String _pollPreviewText(
    BuildContext context,
    Poll poll,
    User currentUser,
  ) {
    // If the poll already contains some votes, we will preview the latest voter
    // and the poll name
    if (poll.latestVotes.firstOrNull?.user case final latestVoter?) {
      if (latestVoter.id == currentUser.id) {
        return '📊 You voted: "${poll.name}"';
      }

      return '📊 ${latestVoter.name} voted: "${poll.name}"';
    }

    // Otherwise, we will show the creator of the poll and the poll name
    if (poll.createdBy case final creator?) {
      if (creator.id == currentUser.id) {
        return '📊 You created: "${poll.name}"';
      }

      return '📊 ${creator.name} created: "${poll.name}"';
    }

    // Otherwise, we will show the poll name if it exists.
    if (poll.name.trim() case final pollName when pollName.isNotEmpty) {
      return '📊 $pollName';
    }

    // If nothing else, we will show the default poll emoji.
    return '📊';
  }

  /// Gets the message content text, considering translations, attachments, and poll
  String? _previewMessageContextText(
    BuildContext context,
    Message message,
  ) {
    final messageText = switch (message.text) {
      final messageText? when messageText.isNotEmpty => messageText,
      _ => null,
    };

    // If the message contains some attachments, we will show the first one
    // and the text if it exists.
    if (message.attachments.firstOrNull case final attachment?) {
      final attachmentIcon = switch (attachment.type) {
        AttachmentType.audio => '🎧',
        AttachmentType.file => '📄',
        AttachmentType.image => '📷',
        AttachmentType.video => '📹',
        AttachmentType.giphy => '[GIF]',
        AttachmentType.voiceRecording => '🎤',
        _ => null,
      };

      final attachmentTitle = switch (attachment.type) {
        AttachmentType.audio => messageText ?? 'Audio',
        AttachmentType.file => attachment.title ?? messageText,
        AttachmentType.image => messageText ?? 'Image',
        AttachmentType.video => messageText ?? 'Video',
        AttachmentType.giphy => messageText,
        AttachmentType.voiceRecording => messageText ?? 'Voice recording',
        _ => null,
      };

      if (attachmentIcon != null || attachmentTitle != null) {
        return [attachmentIcon, attachmentTitle].nonNulls.join(' ');
      }
    }

    return messageText;
  }
}

extension on String {
  List<String> splitByRegExp(RegExp regex) {
    // If the pattern is empty, return the whole string
    if (regex.pattern.isEmpty) return [this];

    final result = <String>[];
    var start = 0;

    for (final match in regex.allMatches(this)) {
      if (match.start > start) {
        result.add(substring(start, match.start));
      }
      result.add(match.group(0)!);
      start = match.end;
    }

    if (start < length) {
      result.add(substring(start));
    }

    return result;
  }
}
