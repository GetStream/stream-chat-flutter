import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

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
///   TextSpan? formatGroupMessage(
///     BuildContext context,
///     User? messageAuthor,
///     User? currentUser,
///   ) {
///     final name = messageAuthor?.name;
///     if (name == null || name.isEmpty) return null;
///     return TextSpan(text: '$name says: ');
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
/// types including regular text, attachments, polls, locations, system
/// messages, and deleted messages.
///
/// ## Message Type Handling
///
/// The formatter handles messages differently based on their type:
///
/// * **Deleted messages** - Shows a ban icon with localized deleted label
/// * **System messages** - Shows the message text directly
/// * **Poll messages** - Shows a poll icon with the poll name
/// * **Location messages** - Shows a map pin icon with location label or
///   message caption
/// * **Regular messages** - Shows text with optional attachment previews
///
/// ## Sender Context
///
/// In group channels (member count > 2), [formatGroupMessage] prepends
/// a sender prefix:
///
/// * **Current user** - Adds bold "You:" prefix
/// * **Other users** - Adds bold first-name prefix
///
/// In direct (1-on-1) channels, no sender prefix is added.
///
/// ## Customization
///
/// All formatting methods are marked [@protected] and can be overridden:
///
/// ```dart
/// class ShortFormatter extends StreamMessagePreviewFormatter {
///   @override
///   TextSpan? formatGroupMessage(
///     BuildContext context,
///     User? messageAuthor,
///     User? currentUser,
///   ) {
///     // Remove sender prefix for cleaner display.
///     return null;
///   }
///
///   @override
///   TextSpan formatPollMessage(
///     BuildContext context,
///     Poll poll,
///     User? currentUser,
///   ) {
///     return TextSpan(text: poll.name.isEmpty ? 'Poll' : poll.name);
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
/// * [formatMessageAttachments] - Formats attachment previews with icons
///
/// **Message Types:**
/// * [formatDeletedMessage] - Formats deleted messages
/// * [formatSystemMessage] - Formats system messages
/// * [formatEmptyMessage] - Formats empty messages
/// * [formatPollMessage] - Formats poll messages
/// * [formatLocationMessage] - Formats shared location messages
///
/// **Sender Context:**
/// * [formatGroupMessage] - Adds sender prefix in group channels
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
    bool showCaption = true,
    ChannelModel? channel,
    User? currentUser,
    TextStyle? textStyle,
  }) {
    final previewText = _buildPreviewText(
      context,
      message,
      channel,
      currentUser,
      showCaption: showCaption,
    );

    return TextSpan(children: [previewText], style: textStyle);
  }

  TextSpan _buildPreviewText(
    BuildContext context,
    Message message,
    ChannelModel? channel,
    User? currentUser, {
    bool showCaption = true,
  }) {
    if (message.isDeleted) {
      return formatDeletedMessage(context, message);
    }

    if (message.isSystem) {
      return formatSystemMessage(context, message);
    }

    if (message.poll case final poll?) {
      return formatPollMessage(context, poll, currentUser);
    }

    TextSpan? messageSpan;

    if (message.sharedLocation case final location?) {
      messageSpan = formatLocationMessage(
        context,
        message,
        location,
        showCaption: showCaption,
      );
    } else {
      messageSpan = formatRegularMessage(
        context,
        message,
        showCaption: showCaption,
      );
    }

    if (messageSpan == null) return formatEmptyMessage(context, message);

    if (channel == null) return messageSpan;

    return TextSpan(
      children: [
        if (channel.memberCount > 2) ?formatGroupMessage(context, message.user, currentUser),
        messageSpan,
      ],
    );
  }

  TextSpan _textSpanWithMentions(String text, List<User> mentionedUsers, StreamColorScheme colorScheme) {
    if (mentionedUsers.isEmpty) return TextSpan(text: text);

    final mentionRegex = RegExp(
      mentionedUsers.map((it) => '@${RegExp.escape(it.name)}').join('|'),
    );

    final parts = text.splitByRegExp(mentionRegex);
    if (parts.length <= 1) return TextSpan(text: text);

    return TextSpan(
      children: parts.map((part) {
        if (mentionedUsers.any((it) => '@${it.name}' == part)) {
          return TextSpan(
            text: part,
            style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.accentPrimary),
          );
        }
        return TextSpan(text: part);
      }).toList(),
    );
  }

  /// The content of a regular [message] as a [TextSpan], including attachment
  /// previews.
  ///
  /// Extracts the message text and formats any attachments using
  /// [formatMessageAttachments]. Mentions within the text are bolded.
  /// Returns `null` if the message has no text or attachments.
  ///
  /// When [showCaption] is `true` and the message has both text and
  /// attachments, the text is shown alongside the attachment icon.
  ///
  /// Override to customize how message content is extracted:
  ///
  /// ```dart
  /// @override
  /// TextSpan? formatRegularMessage(
  ///   BuildContext context,
  ///   Message message, {
  ///   bool showCaption = true,
  /// }) {
  ///   final text = message.text;
  ///   if (text == null || text.isEmpty) return null;
  ///   return TextSpan(text: text);
  /// }
  /// ```
  @protected
  TextSpan? formatRegularMessage(
    BuildContext context,
    Message message, {
    bool showCaption = true,
  }) {
    final messageText = switch (message.text?.trim()) {
      final text? when text.isNotEmpty => text,
      _ => null,
    };

    final attachments = message.attachments;
    final mentionedUsers = message.mentionedUsers;
    final colorScheme = context.streamColorScheme;

    if (attachments.isEmpty) {
      return messageText != null ? _textSpanWithMentions(messageText, mentionedUsers, colorScheme) : null;
    }

    return formatMessageAttachments(
      context,
      messageText,
      message.attachments,
      mentionedUsers: mentionedUsers,
      showCaption: showCaption,
    );
  }

  /// The preview [TextSpan] for a deleted [message].
  ///
  /// Shows a ban icon followed by the localized deleted message label,
  /// both styled with the tertiary text color.
  @protected
  TextSpan formatDeletedMessage(BuildContext context, Message message) {
    return TextSpan(
      children: [
        WidgetSpan(
          child: Icon(
            context.streamIcons.noSign20,
            size: 16,
            color: context.streamColorScheme.textTertiary,
          ),
        ),
        WidgetSpan(
          child: SizedBox(width: context.streamSpacing.xxs),
        ),
        TextSpan(
          text: context.translations.messageDeletedLabel,
          style: TextStyle(color: context.streamColorScheme.textTertiary),
        ),
      ],
    );
  }

  /// The preview [TextSpan] for a system [message].
  ///
  /// Returns the message text if available, otherwise a localized
  /// system message label.
  @protected
  TextSpan formatSystemMessage(BuildContext context, Message message) {
    if (message.text case final text? when text.isNotEmpty) return TextSpan(text: text);
    return TextSpan(text: context.translations.systemMessageLabel);
  }

  /// The preview [TextSpan] for an empty [message].
  ///
  /// Returns the localized empty message preview text, styled with the
  /// tertiary text color.
  @protected
  TextSpan formatEmptyMessage(BuildContext context, Message message) {
    return TextSpan(
      text: context.translations.emptyMessagePreviewText,
      style: TextStyle(color: context.streamColorScheme.textTertiary),
    );
  }

  /// A bold sender prefix [TextSpan] for group channel previews.
  ///
  /// Returns a "You: " prefix when [messageAuthor] matches [currentUser],
  /// or the author's first name followed by ": " for other users. Returns
  /// `null` if the author name is unavailable.
  ///
  /// Override to customize the sender prefix:
  ///
  /// ```dart
  /// @override
  /// TextSpan? formatGroupMessage(
  ///   BuildContext context,
  ///   User? messageAuthor,
  ///   User? currentUser,
  /// ) {
  ///   final name = messageAuthor?.name;
  ///   if (name == null || name.isEmpty) return null;
  ///   return TextSpan(text: '$name: ');
  /// }
  /// ```
  @protected
  TextSpan? formatGroupMessage(
    BuildContext context,
    User? messageAuthor,
    User? currentUser,
  ) {
    if (messageAuthor?.id == currentUser?.id) {
      return TextSpan(
        text: '${context.translations.youText}: ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: context.streamColorScheme.textTertiary,
        ),
      );
    }

    final authorName = messageAuthor?.name.split(' ')[0];
    if (authorName == null || authorName.isEmpty) return null;

    return TextSpan(
      text: '$authorName: ',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: context.streamColorScheme.textTertiary,
      ),
    );
  }

  /// The formatted preview [TextSpan] for [attachments].
  ///
  /// Renders an icon prefix based on the attachment type, followed by either
  /// the [messageText] (when [showCaption] is `true`) or a descriptive suffix
  /// (attachment name, count, or duration). [mentionedUsers] in the message
  /// text are bolded.
  ///
  /// Returns `null` if [attachments] is empty and [messageText] is `null`.
  ///
  /// When attachments have mixed types, a generic file icon is used with the
  /// total file count. For uniform types, a type-specific icon is shown:
  /// Audio/Voice Recording (microphone), Image (camera), Video (video),
  /// Giphy (/giphy), and File (file).
  ///
  /// Override to handle custom attachment types:
  ///
  /// ```dart
  /// @override
  /// TextSpan? formatMessageAttachments(
  ///   BuildContext context,
  ///   String? messageText,
  ///   Iterable<Attachment> attachments, {
  ///   List<User> mentionedUsers = const [],
  ///   bool showCaption = true,
  /// }) {
  ///   final attachment = attachments.firstOrNull;
  ///   if (attachment?.type == 'product') {
  ///     return TextSpan(text: '🛍️ Product');
  ///   }
  ///   return super.formatMessageAttachments(
  ///     context,
  ///     messageText,
  ///     attachments,
  ///     mentionedUsers: mentionedUsers,
  ///     showCaption: showCaption,
  ///   );
  /// }
  /// ```
  @protected
  TextSpan? formatMessageAttachments(
    BuildContext context,
    String? messageText,
    Iterable<Attachment> attachments, {
    List<User> mentionedUsers = const [],
    bool showCaption = true,
  }) {
    final colorScheme = context.streamColorScheme;
    final attachment = attachments.firstOrNull;
    if (attachment == null) {
      return messageText != null ? _textSpanWithMentions(messageText, mentionedUsers, colorScheme) : null;
    }

    final mixedTypes = attachments.any((it) => it.type != attachment.type);
    final prefix = _attachmentPrefix(context, mixedTypes ? null : attachment.type);

    if (showCaption && messageText != null) {
      return TextSpan(
        children: [
          prefix,
          WidgetSpan(child: SizedBox(width: context.streamSpacing.xxs)),
          _textSpanWithMentions(messageText, mentionedUsers, colorScheme),
        ],
      );
    }

    final suffix = _attachmentSuffix(
      context,
      attachment,
      count: attachments.length,
      isMixed: mixedTypes,
    );

    return TextSpan(
      children: [
        prefix,
        WidgetSpan(child: SizedBox(width: context.streamSpacing.xxs)),
        ?suffix,
      ],
    );
  }

  InlineSpan _attachmentPrefix(BuildContext context, String? type) {
    final icons = context.streamIcons;
    return switch (type) {
      AttachmentType.audio || AttachmentType.voiceRecording => WidgetSpan(child: Icon(icons.voice20, size: 16)),
      AttachmentType.image => WidgetSpan(child: Icon(icons.camera20, size: 16)),
      AttachmentType.video => WidgetSpan(child: Icon(icons.video20, size: 16)),
      AttachmentType.giphy => const TextSpan(text: '/giphy'),
      _ => WidgetSpan(child: Icon(icons.file20, size: 16)),
    };
  }

  TextSpan? _attachmentSuffix(
    BuildContext context,
    Attachment attachment, {
    required int count,
    required bool isMixed,
  }) {
    final translations = context.translations;

    if (isMixed) return TextSpan(text: translations.filesAttachmentCountText(count));

    return switch (attachment.type) {
      AttachmentType.audio => TextSpan(text: translations.audioAttachmentText),
      AttachmentType.voiceRecording => TextSpan(
        text: '${translations.voiceRecordingText} (${attachment.duration.toMinutesAndSeconds()})',
      ),
      AttachmentType.file => TextSpan(
        text: (count == 1 ? attachment.file?.name : null) ?? translations.filesAttachmentCountText(count),
      ),
      AttachmentType.image => TextSpan(text: translations.photosAttachmentCountText(count)),
      AttachmentType.video => TextSpan(text: translations.videosAttachmentCountText(count)),
      _ => null,
    };
  }

  /// The formatted preview [TextSpan] for a [poll] message.
  ///
  /// Shows a poll chart icon followed by the latest vote activity when
  /// available, or the poll name as a fallback. Specifically:
  ///
  /// - If the [currentUser] cast the latest vote, shows "You voted: {answer}".
  /// - If another user cast the latest vote, shows "{name} voted: {answer}".
  /// - Otherwise, falls back to displaying the [poll] name (trimmed). If the
  ///   name is empty, only the icon is shown.
  ///
  /// Override to customize poll formatting:
  ///
  /// ```dart
  /// @override
  /// TextSpan formatPollMessage(
  ///   BuildContext context,
  ///   Poll poll,
  ///   User? currentUser,
  /// ) {
  ///   return TextSpan(
  ///     text: poll.name.isEmpty ? 'Poll' : poll.name,
  ///   );
  /// }
  /// ```
  @protected
  TextSpan formatPollMessage(
    BuildContext context,
    Poll poll,
    User? currentUser,
  ) {
    final translations = context.translations;
    TextSpan? latestVoterSpan;

    if (poll.latestVotes.firstOrNull case final latestVote?) {
      if (latestVote.user?.id == currentUser?.id) {
        final youVoted = translations.pollYouVotedText;
        latestVoterSpan = TextSpan(text: '$youVoted: ${latestVote.answerText}');
      } else if (latestVote.user case final latestVoter?) {
        if (latestVote.answerText != null) {
          final someoneVoted = translations.pollSomeoneVotedText(latestVoter.name.split(' ')[0]);
          latestVoterSpan = TextSpan(text: '$someoneVoted: ${latestVote.answerText}');
        }
      }
    }

    return TextSpan(
      children: [
        WidgetSpan(child: Icon(context.streamIcons.poll20, size: 16)),
        if (latestVoterSpan case final latestVoterSpan?) ...[
          WidgetSpan(child: SizedBox(width: context.streamSpacing.xxs)),
          latestVoterSpan,
        ] else if (poll.name.trim() case final pollName when pollName.isNotEmpty) ...[
          WidgetSpan(child: SizedBox(width: context.streamSpacing.xxs)),
          TextSpan(text: pollName),
        ],
      ],
    );
  }

  /// The formatted preview [TextSpan] for a shared [location] message.
  ///
  /// Shows a map pin icon followed by the [message] text (when [showCaption]
  /// is `true` and text is available) or a localized location label. Live
  /// locations use a distinct label from static ones.
  ///
  /// Override to customize shared location formatting:
  ///
  /// ```dart
  /// @override
  /// TextSpan formatLocationMessage(
  ///   BuildContext context,
  ///   Message message,
  ///   Location location, {
  ///   bool showCaption = true,
  /// }) {
  ///   return TextSpan(
  ///     text: '(${location.latitude}, ${location.longitude})',
  ///   );
  /// }
  /// ```
  @protected
  TextSpan formatLocationMessage(
    BuildContext context,
    Message message,
    Location location, {
    bool showCaption = true,
  }) {
    final colorScheme = context.streamColorScheme;
    return TextSpan(
      children: [
        WidgetSpan(child: Icon(context.streamIcons.location20, size: 16)),
        WidgetSpan(
          child: SizedBox(width: context.streamSpacing.xxs),
        ),
        if (message.text?.trim() case final messageText? when messageText.isNotEmpty && showCaption) ...[
          _textSpanWithMentions(messageText, message.mentionedUsers, colorScheme),
        ] else ...[
          TextSpan(text: context.translations.locationLabel(isLive: location.isLive)),
        ],
      ],
    );
  }

  @override
  TextSpan formatDraftMessage(
    BuildContext context,
    DraftMessage draftMessage, {
    TextStyle? textStyle,
  }) {
    final colorScheme = context.streamColorScheme;

    return TextSpan(
      children: [
        TextSpan(
          text: getDraftPrefix(context),
          style: (textStyle ?? context.streamTextTheme.captionEmphasis).copyWith(
            color: colorScheme.accentPrimary,
          ),
        ),
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
