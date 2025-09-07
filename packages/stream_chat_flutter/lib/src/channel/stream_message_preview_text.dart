import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that renders a preview of the message text.
class StreamMessagePreviewText extends StatelessWidget {
  /// Creates a new instance of [StreamMessagePreviewText].
  const StreamMessagePreviewText({
    super.key,
    required this.message,
    this.channel,
    this.language,
    this.textStyle,
  });

  /// The message to display.
  final Message message;

  /// The channel to which the message belongs.
  final ChannelModel? channel;

  /// The language to use for translations.
  final String? language;

  /// The style to use for the text.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final currentUser = StreamChat.of(context).currentUser!;
    final translationLanguage = language ?? currentUser.language ?? 'en';
    final translatedMessage = message.translate(translationLanguage);
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

  String _getPreviewText(
    BuildContext context,
    Message message,
    User currentUser,
  ) {
    final translations = context.translations;

    if (message.isDeleted) {
      return translations.messageDeletedLabel;
    }

    if (message.isSystem) {
      return message.text ?? translations.systemMessageLabel;
    }

    if (message.poll case final poll?) {
      return _pollPreviewText(context, poll, currentUser);
    }

    if (message.sharedLocation case final location?) {
      return translations.locationLabel(isLive: location.isLive);
    }

    final previewText = _previewMessageContextText(context, message);
    if (previewText == null) return translations.emptyMessagePreviewText;

    if (channel case final channel?) {
      if (message.user?.id == currentUser.id) {
        return '${translations.youText}: $previewText';
      }

      if (channel.memberCount > 2) {
        return '${message.user?.name}: $previewText';
      }
    }

    return previewText;
  }

  String _pollPreviewText(
    BuildContext context,
    Poll poll,
    User currentUser,
  ) {
    final translations = context.translations;

    // If the poll already contains some votes, we will preview the latest voter
    // and the poll name
    if (poll.latestVotes.firstOrNull?.user case final latestVoter?) {
      if (latestVoter.id == currentUser.id) {
        final youVoted = translations.pollYouVotedText;
        return '📊 $youVoted: "${poll.name}"';
      }

      final someoneVoted = translations.pollSomeoneVotedText(latestVoter.name);
      return '📊 $someoneVoted: "${poll.name}"';
    }

    // Otherwise, we will show the creator of the poll and the poll name
    if (poll.createdBy case final creator?) {
      if (creator.id == currentUser.id) {
        final youCreated = translations.pollYouCreatedText;
        return '📊 $youCreated: "${poll.name}"';
      }

      final someoneCreated = translations.pollSomeoneCreatedText(creator.name);
      return '📊 $someoneCreated: "${poll.name}"';
    }

    // Otherwise, we will show the poll name if it exists.
    if (poll.name.trim() case final pollName when pollName.isNotEmpty) {
      return '📊 $pollName';
    }

    // If nothing else, we will show the default poll emoji.
    return '📊';
  }

  String? _previewMessageContextText(
    BuildContext context,
    Message message,
  ) {
    final translations = context.translations;

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
        AttachmentType.giphy => '/giphy',
        AttachmentType.voiceRecording => '🎤',
        _ => null,
      };

      final attachmentTitle = switch (attachment.type) {
        AttachmentType.audio => messageText ?? translations.audioAttachmentText,
        AttachmentType.file => attachment.title ?? messageText,
        AttachmentType.image => messageText ?? translations.imageAttachmentText,
        AttachmentType.video => messageText ?? translations.videoAttachmentText,
        AttachmentType.giphy => messageText,
        AttachmentType.voiceRecording => translations.voiceRecordingText,
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
