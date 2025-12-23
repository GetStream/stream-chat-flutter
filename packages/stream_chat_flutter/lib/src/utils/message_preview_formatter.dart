import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template messagePreviewFormatter}
/// Formats message previews for display.
///
/// This interface provides two main methods for formatting message previews:
/// [formatMessage] for regular messages and [formatDraftMessage] for drafts.
///
/// ## Default Implementation
///
/// The factory constructor returns [StreamMessagePreviewFormatter], which
/// provides context-aware formatting based on message type, sender, and
/// channel configuration.
///
/// ```dart
/// final formatter = MessagePreviewFormatter();
/// final preview = formatter.formatMessage(
///   context,
///   message,
///   channel: channel,
///   currentUser: currentUser,
/// );
/// ```
///
/// ## Configuration
///
/// Set a custom formatter globally via [StreamChatConfigurationData]:
///
/// ```dart
/// StreamChat(
///   client: client,
///   streamChatConfigurationData: StreamChatConfigurationData(
///     messagePreviewFormatter: CustomFormatter(),
///   ),
///   child: child,
/// );
/// ```
///
/// ## Custom Implementation
///
/// Extend [StreamMessagePreviewFormatter] to customize specific behaviors:
///
/// ```dart
/// class CustomFormatter extends StreamMessagePreviewFormatter {
///   @override
///   String formatGroupMessage(
///     BuildContext context,
///     User? messageAuthor,
///     String messageText,
///   ) {
///     if (messageAuthor == null) return messageText;
///     return '${messageAuthor.name} says: $messageText';
///   }
/// }
/// ```
/// {@endtemplate}
abstract interface class MessagePreviewFormatter {
  /// Creates a [MessagePreviewFormatter].
  ///
  /// Returns the default [StreamMessagePreviewFormatter] implementation.
  factory MessagePreviewFormatter() {
    return const StreamMessagePreviewFormatter();
  }

  /// A formatted message preview.
  ///
  /// Formats [message] based on its type, [channel], and [currentUser].
  /// Mentions are bolded. The [textStyle] applies to all text.
  TextSpan formatMessage(
    BuildContext context,
    Message message, {
    ChannelModel? channel,
    User? currentUser,
    TextStyle? textStyle,
  });

  /// A formatted draft message preview with highlighted prefix.
  ///
  /// Adds a bold, accent-colored "Draft:" prefix to [draftMessage].
  /// The [textStyle] applies to the message text.
  TextSpan formatDraftMessage(
    BuildContext context,
    DraftMessage draftMessage, {
    TextStyle? textStyle,
  });
}

/// {@template streamMessagePreviewFormatter}
/// Default implementation of [MessagePreviewFormatter].
///
/// This formatter applies context-aware formatting based on message type,
/// sender identity, and channel configuration. It handles various message
/// types including regular text, attachments, polls, system messages, and
/// deleted messages.
///
/// ## Message Type Handling
///
/// The formatter handles messages differently based on their type:
///
/// * **Deleted messages** - Shows "Message deleted"
/// * **System messages** - Shows the message text directly
/// * **Poll messages** - Shows poll emoji with voter/creator info
/// * **Regular messages** - Shows text with optional attachment previews
///
/// ## Sender Context
///
/// The formatting adapts based on who sent the message:
///
/// * **Current user** - Adds "You:" prefix
/// * **Direct messages (1-on-1)** - No prefix
/// * **Group messages** - Adds sender name prefix
///
/// ## Customization
///
/// All formatting methods are marked [@protected] and can be overridden:
///
/// ```dart
/// class ShortFormatter extends StreamMessagePreviewFormatter {
///   @override
///   String formatCurrentUserMessage(BuildContext context, String text) {
///     // Remove "You:" prefix for cleaner display.
///     return text;
///   }
///
///   @override
///   String formatPollMessage(
///     BuildContext context,
///     Poll poll,
///     User? currentUser,
///   ) {
///     // Always show just the poll name.
///     return poll.name.isEmpty ? '📊 Poll' : '📊 ${poll.name}';
///   }
/// }
/// ```
///
/// ## Protected Methods
///
/// These methods can be overridden for customization:
///
/// **Content Extraction:**
/// * [formatRegularMessage] - Extracts message content (text + attachments)
/// * [formatMessageAttachments] - Formats attachment previews
///
/// **Message Types:**
/// * [formatDeletedMessage] - Formats deleted messages
/// * [formatSystemMessage] - Formats system messages
/// * [formatEmptyMessage] - Formats empty messages
/// * [formatPollMessage] - Formats poll messages
///
/// **Sender Context:**
/// * [formatCurrentUserMessage] - Formats messages from current user
/// * [formatDirectMessage] - Formats messages in 1-on-1 channels
/// * [formatGroupMessage] - Formats messages in group channels
///
/// **Draft Messages:**
/// * [getDraftPrefix] - Returns the draft message prefix text
/// {@endtemplate}
class StreamMessagePreviewFormatter implements MessagePreviewFormatter {
  /// Creates a [StreamMessagePreviewFormatter].
  const StreamMessagePreviewFormatter();

  @override
  TextSpan formatMessage(
    BuildContext context,
    Message message, {
    ChannelModel? channel,
    User? currentUser,
    TextStyle? textStyle,
  }) {
    final previewText = _buildPreviewText(
      context,
      message,
      channel,
      currentUser,
    );

    final mentionedUsers = message.mentionedUsers;
    if (mentionedUsers.isEmpty) {
      return TextSpan(text: previewText, style: textStyle);
    }

    final mentionedUsersRegex = RegExp(
      mentionedUsers.map((it) => '@${RegExp.escape(it.name)}').join('|'),
    );

    final children = <TextSpan>[
      ...previewText.splitByRegExp(mentionedUsersRegex).map(
        (text) {
          if (mentionedUsers.any((it) => '@${it.name}' == text)) {
            return TextSpan(
              text: text,
              style: textStyle?.copyWith(fontWeight: FontWeight.bold),
            );
          }

          return TextSpan(text: text, style: textStyle);
        },
      )
    ];

    return TextSpan(children: children);
  }

  String _buildPreviewText(
    BuildContext context,
    Message message,
    ChannelModel? channel,
    User? currentUser,
  ) {
    if (message.isDeleted) {
      return formatDeletedMessage(context, message);
    }

    if (message.isSystem) {
      return formatSystemMessage(context, message);
    }

    if (message.poll case final poll?) {
      return formatPollMessage(context, poll, currentUser);
    }

    if (message.sharedLocation case final location?) {
      return formatLocationMessage(context, location);
    }

    final messagePreviewText = formatRegularMessage(context, message);
    if (messagePreviewText == null) return formatEmptyMessage(context, message);

    if (channel == null) return messagePreviewText;

    if (message.user?.id == currentUser?.id) {
      return formatCurrentUserMessage(context, messagePreviewText);
    }

    if (channel.memberCount > 2) {
      return formatGroupMessage(context, message.user, messagePreviewText);
    }

    return formatDirectMessage(context, messagePreviewText);
  }

  /// The text content of a regular [message], including attachment previews.
  ///
  /// Extracts the message text and formats any attachments using
  /// [formatMessageAttachments]. Returns `null` if the message has no text
  /// or attachments.
  ///
  /// Override to customize how message content is extracted:
  ///
  /// ```dart
  /// @override
  /// String? formatRegularMessage(BuildContext context, Message message) {
  ///   // Only show text, ignore attachments
  ///   return message.text;
  /// }
  /// ```
  @protected
  String? formatRegularMessage(BuildContext context, Message message) {
    final messageText = switch (message.text?.trim()) {
      final text? when text.isNotEmpty => text,
      _ => null,
    };

    final attachments = message.attachments;
    if (attachments.isEmpty) return messageText;

    return formatMessageAttachments(context, messageText, message.attachments);
  }

  /// The preview text for a deleted [message].
  @protected
  String formatDeletedMessage(BuildContext context, Message message) {
    return context.translations.messageDeletedLabel;
  }

  /// The preview text for a system [message].
  @protected
  String formatSystemMessage(BuildContext context, Message message) {
    if (message.text case final text? when text.isNotEmpty) return text;
    return context.translations.systemMessageLabel;
  }

  /// The preview text for an empty [message].
  @protected
  String formatEmptyMessage(BuildContext context, Message message) {
    return context.translations.emptyMessagePreviewText;
  }

  /// The formatted [messageText] with "You:" prefix for the current user.
  ///
  /// Override this to customize how messages from the current user are
  /// displayed:
  ///
  /// ```dart
  /// @override
  /// String formatCurrentUserMessage(
  ///   BuildContext context,
  ///   String messageText,
  /// ) {
  ///   return messageText; // Remove prefix
  /// }
  /// ```
  @protected
  String formatCurrentUserMessage(BuildContext context, String messageText) {
    return '${context.translations.youText}: $messageText';
  }

  /// The [messageText] without prefix for 1-on-1 channels.
  ///
  /// No prefix is added since the other user's identity is clear from the
  /// channel itself. Override to add context if needed:
  ///
  /// ```dart
  /// @override
  /// String formatDirectMessage(BuildContext context, String messageText) {
  ///   return '💬 $messageText';
  /// }
  /// ```
  @protected
  String formatDirectMessage(BuildContext context, String messageText) {
    return messageText;
  }

  /// The formatted [messageText] with [messageAuthor] name prefix for groups.
  ///
  /// Adds the author's name as a prefix. Returns [messageText] without
  /// prefix if [messageAuthor] is `null`.
  ///
  /// Override to customize author name formatting:
  ///
  /// ```dart
  /// @override
  /// String formatGroupMessage(
  ///   BuildContext context,
  ///   User? messageAuthor,
  ///   String messageText,
  /// ) {
  ///   if (messageAuthor == null) return messageText;
  ///   return '${messageAuthor.name} says: $messageText';
  /// }
  /// ```
  @protected
  String formatGroupMessage(
    BuildContext context,
    User? messageAuthor,
    String messageText,
  ) {
    final authorName = messageAuthor?.name;
    if (authorName == null || authorName.isEmpty) return messageText;

    return '$authorName: $messageText';
  }

  /// The formatted preview for the first attachment in [attachments].
  ///
  /// Formats each attachment type with an emoji icon and title. The
  /// [messageText] is used as fallback for certain types. Returns
  /// [messageText] if no attachments are present or the type is unsupported.
  ///
  /// Supported types: Audio (🎧), File (📄), Image (📷), Video (📹),
  /// Giphy (/giphy), and Voice Recording (🎤).
  ///
  /// Override to handle custom attachment types:
  ///
  /// ```dart
  /// @override
  /// String? formatMessageAttachments(
  ///   BuildContext context,
  ///   String? messageText,
  ///   Iterable<Attachment> attachments,
  /// ) {
  ///   final attachment = attachments.firstOrNull;
  ///   if (attachment?.type == 'product') {
  ///     return '🛍️ ${attachment?.extraData['title'] ?? "Product"}';
  ///   }
  ///   return super.formatMessageAttachments(
  ///     context,
  ///     messageText,
  ///     attachments,
  ///   );
  /// }
  /// ```
  @protected
  String? formatMessageAttachments(
    BuildContext context,
    String? messageText,
    Iterable<Attachment> attachments,
  ) {
    final translations = context.translations;
    final attachment = attachments.firstOrNull;
    if (attachment == null) return messageText;

    // If the message contains some attachments, we will show the first one
    // and the text if it exists.
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

    return messageText;
  }

  /// The formatted preview for a [poll] message with voter or creator info.
  ///
  /// Shows the latest voter and poll name if the poll has votes, otherwise
  /// shows the creator and poll name. If the poll has no votes or creator,
  /// shows just the poll name. Actions by [currentUser] show as "You",
  /// while actions by other users show their name.
  ///
  /// Override to customize poll formatting:
  ///
  /// ```dart
  /// @override
  /// String formatPollMessage(
  ///   BuildContext context,
  ///   Poll poll,
  ///   User? currentUser,
  /// ) {
  ///   return poll.name.isEmpty ? '📊 Poll' : '📊 ${poll.name}';
  /// }
  /// ```
  @protected
  String formatPollMessage(
    BuildContext context,
    Poll poll,
    User? currentUser,
  ) {
    final translations = context.translations;

    // If the poll already contains some votes, we will preview the latest voter
    // and the poll name
    if (poll.latestVotes.firstOrNull?.user case final latestVoter?) {
      if (latestVoter.id == currentUser?.id) {
        final youVoted = translations.pollYouVotedText;
        return '📊 $youVoted: "${poll.name}"';
      }

      final someoneVoted = translations.pollSomeoneVotedText(latestVoter.name);
      return '📊 $someoneVoted: "${poll.name}"';
    }

    // Otherwise, we will show the creator of the poll and the poll name
    if (poll.createdBy case final creator?) {
      if (creator.id == currentUser?.id) {
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

  /// The formatted preview for a shared [location] message.
  ///
  /// Override to customize shared location formatting:
  ///
  /// ```dart
  /// @override
  /// String formatLocationMessage(
  ///   BuildContext context,
  ///   Location location,
  /// ) {
  ///   return '📍 (${location.latitude}, ${location.longitude})';
  /// }
  /// ```
  @protected
  String formatLocationMessage(
    BuildContext context,
    Location location,
  ) {
    final translations = context.translations;
    return translations.locationLabel(isLive: location.isLive);
  }

  @override
  TextSpan formatDraftMessage(
    BuildContext context,
    DraftMessage draftMessage, {
    TextStyle? textStyle,
  }) {
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    return TextSpan(
      text: getDraftPrefix(context),
      style: textStyle?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorTheme.accentPrimary,
      ),
      children: [
        const TextSpan(text: ' '), // Space between prefix and message
        TextSpan(text: draftMessage.text, style: textStyle),
      ],
    );
  }

  /// The draft message prefix text.
  ///
  /// Returns the localized "Draft" label. Override to customize the prefix:
  ///
  /// ```dart
  /// @override
  /// String getDraftPrefix(BuildContext context) {
  ///   return 'Unsent';
  /// }
  /// ```
  @protected
  String getDraftPrefix(BuildContext context) {
    return '${context.translations.draftLabel}:';
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
