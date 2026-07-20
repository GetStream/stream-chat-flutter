import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/localization/translations.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// Formats a [Message] or [DraftMessage] into a preview [TextSpan] suitable
/// for channel lists, quoted replies, and similar compact contexts.
///
/// Implementations are responsible for producing a single [TextSpan] that
/// combines the message body, any attachment summary, and — when relevant —
/// the sender's name. The returned span can be rendered with a standard
/// [Text.rich] widget.
///
/// The default implementation is [StreamMessagePreviewFormatter]; the unnamed
/// factory constructor returns an instance of it.
///
/// {@tool snippet}
///
/// Format a message using the default implementation:
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
/// {@end-tool}
///
/// {@tool snippet}
///
/// Install a custom formatter globally via [StreamChatConfigurationData]:
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
/// {@end-tool}
///
/// ## Customization
///
/// To change only part of the preview, extend [StreamMessagePreviewFormatter]
/// and override one of its `format*` methods — each one returns a [TextSpan]
/// fragment and is composed together by [formatMessage].
///
/// See also:
///
///  * [StreamMessagePreviewFormatter], the default implementation.
///  * [AccessibleMessagePreviewFormatter], the optional a11y-aware
///    extension of this interface.
///  * [StreamChatConfigurationData.messagePreviewFormatter], which configures
///    the formatter used across the Stream Chat widget tree.
abstract interface class MessagePreviewFormatter {
  /// Creates a [MessagePreviewFormatter].
  ///
  /// Returns the default [StreamMessagePreviewFormatter] implementation.
  factory MessagePreviewFormatter() => const StreamMessagePreviewFormatter();

  /// Formats [message] as a preview [TextSpan].
  ///
  /// The output adapts to the message kind (regular, deleted, system, poll,
  /// location) and to the surrounding [channel] — for example, group channels
  /// prepend a bold "You:" or "FirstName:" prefix.
  ///
  /// [showCaption] controls how attachment and location previews label
  /// themselves: when `true` (the default) they display the message text; when
  /// `false` (for example in quoted-reply previews) they fall back to a
  /// type-based label such as "Photo", "2 Videos", or "Location". Pure text
  /// messages always show their text.
  ///
  /// The returned span carries structural style only (bold sender prefix,
  /// tinted deleted-message text). Base text color and font should be
  /// applied by the caller via [Text.rich]'s `style` parameter or an
  /// ambient [DefaultTextStyle]; inline icons pick up their color from the
  /// ambient [IconTheme].
  TextSpan formatMessage(
    BuildContext context,
    Message message, {
    ChannelModel? channel,
    User? currentUser,
    bool showCaption = true,
  });

  /// Formats [draftMessage] as a preview [TextSpan] with a highlighted
  /// "Draft:" prefix.
  ///
  /// The prefix is rendered in bold using the theme's accent color. The
  /// draft body is formatted using the same rules as a regular message —
  /// plain text, attachments, and polls all get a rich preview.
  ///
  /// [currentUser] is forwarded to body formatters that need viewer context
  /// (for example, [formatPollMessage] to resolve the current user's vote).
  ///
  /// [showCaption] controls how attachment and location previews label
  /// themselves: when `true` (the default) they display the draft text;
  /// when `false` they fall back to a type-based label such as "Photo" or
  /// "2 Videos". Pure text drafts always show their text.
  ///
  /// Like [formatMessage], the returned span carries only the structural
  /// overrides the preview needs; the caller is responsible for the base
  /// text style.
  TextSpan formatDraftMessage(
    BuildContext context,
    DraftMessage draftMessage, {
    User? currentUser,
    bool showCaption = true,
  });
}

/// A [MessagePreviewFormatter] that also emits plain-text a11y labels
/// suitable for [Text.semanticsLabel] / [Semantics.label].
///
/// Implementing this interface is optional; consumers implementing only
/// [MessagePreviewFormatter] continue to work with a visual-derived a11y
/// fallback.
///
/// See also:
///
///  * [StreamMessagePreviewFormatter], which implements this interface.
abstract interface class AccessibleMessagePreviewFormatter implements MessagePreviewFormatter {
  /// Formats [message] as a plain-text natural-language string for screen
  /// readers — the accessible counterpart to [formatMessage].
  ///
  /// [showCaption] mirrors [formatMessage]: when `true` (the default),
  /// attachment and location labels include the message text as a caption;
  /// when `false` they fall back to a type-only label.
  String formatMessageSemanticsLabel(
    BuildContext context,
    Message message, {
    ChannelModel? channel,
    User? currentUser,
    bool showCaption = true,
  });

  /// Formats [draftMessage] as a plain-text natural-language string for
  /// screen readers — the accessible counterpart to [formatDraftMessage].
  ///
  /// [showCaption] mirrors [formatDraftMessage].
  String formatDraftMessageSemanticsLabel(
    BuildContext context,
    DraftMessage draftMessage, {
    User? currentUser,
    bool showCaption = true,
  });
}

/// The default implementation of [MessagePreviewFormatter] and
/// [AccessibleMessagePreviewFormatter].
///
/// The preview is assembled in two layers, each produced by a separate
/// `format*` method so subclasses can override a specific piece without
/// reimplementing the rest:
///
///  * A body span for the message kind — [formatRegularMessage] (plain text
///    and/or attachments), [formatDeletedMessage], [formatSystemMessage],
///    [formatPollMessage], [formatLocationMessage], or [formatEmptyMessage].
///  * A channel-context prefix — [formatCurrentUserMessage] ("You: "),
///    [formatGroupMessage] ("FirstName: "), or [formatDirectMessage] (no
///    prefix by default).
///
/// Each visual `format*` method has a paired `format*SemanticsLabel`
/// variant that returns the equivalent screen-reader label.
///
/// {@tool snippet}
///
/// Customize only the "You:" prefix and poll rendering:
///
/// ```dart
/// class ShortFormatter extends StreamMessagePreviewFormatter {
///   @override
///   TextSpan formatCurrentUserMessage(
///     BuildContext context,
///     TextSpan messageBody,
///   ) {
///     // Remove the "You:" prefix for cleaner display.
///     return messageBody;
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
/// {@end-tool}
///
/// See also:
///
///  * [MessagePreviewFormatter], the public interface.
///  * [formatMessage], which composes the final preview span.
class StreamMessagePreviewFormatter implements AccessibleMessagePreviewFormatter {
  /// Creates a [StreamMessagePreviewFormatter].
  const StreamMessagePreviewFormatter();

  @override
  TextSpan formatMessage(
    BuildContext context,
    Message message, {
    bool showCaption = true,
    ChannelModel? channel,
    User? currentUser,
  }) {
    final content = _formatContent(
      context,
      message,
      currentUser: currentUser,
      showCaption: showCaption,
    );

    if (channel == null) return content;

    if (message.user?.id == currentUser?.id) {
      return formatCurrentUserMessage(context, content);
    }

    if (channel.memberCount > 2) {
      return formatGroupMessage(context, message.user, content);
    }

    return formatDirectMessage(context, content);
  }

  // Dispatches to the `format*` method that matches the kind of [message].
  // Returns the bare body span, without the author prefix or mention pass.
  TextSpan _formatContent(
    BuildContext context,
    Message message, {
    User? currentUser,
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

    if (message.sharedLocation case final location?) {
      return formatLocationMessage(context, message, location, showCaption: showCaption);
    }

    final regular = formatRegularMessage(context, message, showCaption: showCaption);
    if (regular != null) return regular;

    return formatEmptyMessage(context, message);
  }

  /// Formats a regular [message] — plain text, attachments, or both — as a
  /// preview [TextSpan].
  ///
  /// When the message has attachments, the message text is used as their
  /// caption (subject to [showCaption]). Otherwise the plain message text is
  /// shown on its own.
  ///
  /// Returns `null` when the message has neither text nor attachments.
  @protected
  TextSpan? formatRegularMessage(
    BuildContext context,
    Message message, {
    bool showCaption = true,
  }) {
    final messageText = message.text?.trim().nullIfEmpty;
    final attachments = message.attachments;

    if (attachments.isNotEmpty) {
      return formatMessageAttachments(context, messageText, attachments, showCaption: showCaption);
    }

    if (messageText == null) return null;
    return _labeledIcon(label: messageText);
  }

  /// Formats a deleted [message] as a preview [TextSpan].
  ///
  /// Shows a "no-sign" icon followed by the localized "Message deleted"
  /// label, both tinted with the theme's tertiary text color to signal the
  /// deleted state. The tint overrides the ambient text/icon color.
  @protected
  TextSpan formatDeletedMessage(BuildContext context, Message message) {
    return _labeledIcon(
      icon: context.streamIcons.noSign,
      label: context.translations.messageDeletedLabel,
      foregroundColor: context.streamColorScheme.textTertiary,
    );
  }

  /// Formats a system [message] as a preview [TextSpan].
  ///
  /// Uses the message text directly, or a localized fallback label when the
  /// text is missing or empty.
  @protected
  TextSpan formatSystemMessage(BuildContext context, Message message) {
    return TextSpan(text: message.text?.nullIfEmpty ?? context.translations.systemMessageLabel);
  }

  /// Formats an empty [message] — no text and no attachments — as a preview
  /// [TextSpan].
  ///
  /// Shows a localized "no-content" fallback label.
  @protected
  TextSpan formatEmptyMessage(BuildContext context, Message message) {
    return TextSpan(text: context.translations.emptyMessagePreviewText);
  }

  /// Formats a regular message sent by the current user.
  ///
  /// Prepends a bold, localized "You: " prefix to [messageBody] and returns
  /// the combined span. Override to customize or remove the prefix:
  ///
  /// {@tool snippet}
  ///
  /// Remove the "You:" prefix entirely:
  ///
  /// ```dart
  /// @override
  /// TextSpan formatCurrentUserMessage(
  ///   BuildContext context,
  ///   TextSpan messageBody,
  /// ) {
  ///   return messageBody;
  /// }
  /// ```
  /// {@end-tool}
  @protected
  TextSpan formatCurrentUserMessage(BuildContext context, TextSpan messageBody) {
    return TextSpan(children: [_boldSpan('${context.translations.youText}: '), messageBody]);
  }

  /// Formats a regular message shown in a 1-on-1 channel.
  ///
  /// No prefix is added by default — the other user's identity is clear from
  /// the channel itself. Override to add context (for example a 💬 badge):
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// @override
  /// TextSpan formatDirectMessage(
  ///   BuildContext context,
  ///   TextSpan messageBody,
  /// ) {
  ///   return TextSpan(children: [
  ///     const TextSpan(text: '💬 '),
  ///     messageBody,
  ///   ]);
  /// }
  /// ```
  /// {@end-tool}
  @protected
  TextSpan formatDirectMessage(BuildContext context, TextSpan messageBody) {
    return messageBody;
  }

  /// Formats a regular message sent by another user in a group channel.
  ///
  /// Prepends a bold "FirstName: " prefix (the first word of
  /// [messageAuthor]'s name) to [messageBody] and returns the combined span.
  /// Returns [messageBody] unchanged when [messageAuthor] is `null` or has
  /// no renderable name.
  ///
  /// Override to customize the prefix text:
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// @override
  /// TextSpan formatGroupMessage(
  ///   BuildContext context,
  ///   User? messageAuthor,
  ///   TextSpan messageBody,
  /// ) {
  ///   final authorName = messageAuthor?.name;
  ///   if (authorName == null || authorName.isEmpty) return messageBody;
  ///   return TextSpan(children: [
  ///     TextSpan(text: '$authorName says: '),
  ///     messageBody,
  ///   ]);
  /// }
  /// ```
  /// {@end-tool}
  @protected
  TextSpan formatGroupMessage(
    BuildContext context,
    User? messageAuthor,
    TextSpan messageBody,
  ) {
    final authorName = messageAuthor?.name.trim().nullIfEmpty;
    if (authorName == null) return formatDirectMessage(context, messageBody);

    // Use only the first name to keep the prefix compact in narrow
    // single-line preview rows.
    final firstName = authorName.split(RegExp(r'\s+')).first;
    return TextSpan(children: [_boldSpan('$firstName: '), messageBody]);
  }

  /// Formats a list of [attachments] as a preview [TextSpan].
  ///
  /// Produces an "icon + label" preview, where the label prefers
  /// [messageText] (when [showCaption] is `true`), then any
  /// attachment-intrinsic text (filename, voice duration, link title), then
  /// a localized type-based fallback ("Photo", "Video", "Audio", "File",
  /// "Link", or pluralized counts for multi-attachment groups).
  ///
  /// Grouping rules, summarized:
  ///
  ///  * Single attachment → type-specific icon + caption, filename/title, or
  ///    a localized singular label ("Photo", "Video", "Audio", "File",
  ///    "Link").
  ///  * Multiple same-type attachments → type-specific icon + pluralized
  ///    count ("2 Photos", "3 Videos", "4 files").
  ///  * Mixed-type attachments → file icon + "N files".
  ///  * Voice recording → voice icon + "Voice recording (mm:ss)" when no
  ///    caption is available.
  ///  * Giphy → file icon + caption, or "Giphy" when no caption is set.
  ///  * Unknown / custom types → unsupported-attachment icon + caption (if
  ///    any).
  ///
  /// Returns `null` when both [attachments] and [messageText] are empty.
  @protected
  TextSpan? formatMessageAttachments(
    BuildContext context,
    String? messageText,
    Iterable<Attachment> attachments, {
    bool showCaption = true,
  }) {
    if (attachments.isEmpty) {
      if (messageText == null) return null;
      return _labeledIcon(label: messageText);
    }

    final caption = showCaption ? messageText : null;
    final preview = _resolveAttachmentPreview(context, attachments, caption);

    return _labeledIcon(icon: preview.icon, label: preview.label);
  }

  /// Formats a [poll] message as a preview [TextSpan].
  ///
  /// Shows the poll chart icon followed by the poll name. When the poll name
  /// is empty, only the icon is shown.
  ///
  /// [currentUser] is unused by the default implementation and provided for
  /// overrides that want to render current-user context (for example, a
  /// "You voted X" hint).
  @protected
  TextSpan formatPollMessage(BuildContext context, Poll poll, User? currentUser) {
    return _labeledIcon(icon: context.streamIcons.poll, label: poll.name.trim());
  }

  /// Formats a shared [location] message as a preview [TextSpan].
  ///
  /// Shows the map-pin icon followed by the [message] text when
  /// [showCaption] is `true` (and text is available), or a localized
  /// type-based fallback otherwise. Live locations and static locations use
  /// distinct fallback labels.
  @protected
  TextSpan formatLocationMessage(
    BuildContext context,
    Message message,
    Location location, {
    bool showCaption = true,
  }) {
    final caption = showCaption ? message.text?.trim().nullIfEmpty : null;
    final label = caption ?? context.translations.locationLabel(isLive: location.isLive);

    return _labeledIcon(icon: context.streamIcons.location, label: label);
  }

  @override
  TextSpan formatDraftMessage(
    BuildContext context,
    DraftMessage draftMessage, {
    User? currentUser,
    bool showCaption = true,
  }) {
    final message = draftMessage.toMessage();

    final content = _formatContent(
      context,
      message,
      currentUser: currentUser,
      showCaption: showCaption,
    );

    final prefix = _labeledIcon(
      label: getDraftPrefix(context),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      foregroundColor: context.streamColorScheme.accentPrimary,
    );

    return TextSpan(
      children: [
        prefix,
        const TextSpan(text: ' '),
        content,
      ],
    );
  }

  /// The text shown as the bold prefix of a draft preview.
  ///
  /// Defaults to the localized "Draft:" label.
  ///
  /// {@tool snippet}
  ///
  /// Override to customize the prefix:
  ///
  /// ```dart
  /// @override
  /// String getDraftPrefix(BuildContext context) => 'Unsent:';
  /// ```
  /// {@end-tool}
  @protected
  String getDraftPrefix(BuildContext context) {
    return '${context.translations.draftLabel}:';
  }

  @override
  String formatMessageSemanticsLabel(
    BuildContext context,
    Message message, {
    ChannelModel? channel,
    User? currentUser,
    bool showCaption = true,
  }) {
    final body = _formatContentSemanticsLabel(
      context,
      message,
      currentUser: currentUser,
      showCaption: showCaption,
    );

    // Deleted and system messages describe state / channel events, not
    // something the sender authored — the speaker prefix would read as
    // "You, Message deleted", which sounds like the user said the literal
    // phrase "Message deleted". Return the body verbatim in these cases.
    if (message.isDeleted || message.isSystem) return body;

    if (channel == null) return body;

    final a11y = context.translations.accessibility;

    if (message.user?.id == currentUser?.id) {
      return '${a11y.outgoingMessagePreviewLabel}\n$body';
    }

    // 1-on-1 channel — sender identity is implicit from the channel.
    if (channel.memberCount <= 2) return body;

    // Announce the full sender name — screen readers aren't width-bound
    // like the visual preview, and a surname disambiguates when multiple
    // members share a first name. When the sender has no derivable name,
    // skip the prefix entirely — a bare "Message, ..." token carries no
    // information.
    final authorName = message.user?.name.trim().nullIfEmpty;
    if (authorName == null) return body;

    return '${a11y.incomingMessagePreviewLabel(senderName: authorName)}\n$body';
  }

  // Dispatches to the `format*SemanticsLabel` method that matches the kind of
  // [message]. Mirrors [_formatContent] but returns a plain-text a11y label
  // instead of a visual TextSpan.
  String _formatContentSemanticsLabel(
    BuildContext context,
    Message message, {
    User? currentUser,
    bool showCaption = true,
  }) {
    if (message.isDeleted) {
      return formatDeletedMessageSemanticsLabel(context, message);
    }

    if (message.isSystem) {
      return formatSystemMessageSemanticsLabel(context, message);
    }

    if (message.poll case final poll?) {
      return formatPollMessageSemanticsLabel(context, poll, currentUser);
    }

    if (message.sharedLocation case final location?) {
      return formatLocationMessageSemanticsLabel(context, message, location, showCaption: showCaption);
    }

    final regular = formatRegularMessageSemanticsLabel(context, message, showCaption: showCaption);
    if (regular != null) return regular;

    return formatEmptyMessageSemanticsLabel(context, message);
  }

  /// Formats a regular [message] — plain text, attachments, or both — as a
  /// plain-text a11y label. Returns `null` when the message has neither
  /// text nor attachments.
  ///
  /// [showCaption] gates whether the message text is used as an attachment
  /// caption; set to `false` for tight contexts (e.g. quoted replies) so
  /// the label falls back to a type-only fragment.
  @protected
  String? formatRegularMessageSemanticsLabel(
    BuildContext context,
    Message message, {
    bool showCaption = true,
  }) {
    final messageText = message.text?.trim().nullIfEmpty;
    final attachments = message.attachments;

    if (attachments.isNotEmpty) {
      final caption = showCaption ? messageText : null;
      return formatMessageAttachmentsSemanticsLabel(context, caption, attachments);
    }

    return messageText;
  }

  /// Formats a deleted [message] as a plain-text a11y label — the localized
  /// "Message deleted" text.
  @protected
  String formatDeletedMessageSemanticsLabel(BuildContext context, Message message) {
    return context.translations.messageDeletedLabel;
  }

  /// Formats a system [message] as a plain-text a11y label —
  /// `"System\n<body>"`.
  ///
  /// Falls back to the localized `"System message"` label when the event
  /// text is missing.
  @protected
  String formatSystemMessageSemanticsLabel(BuildContext context, Message message) {
    final body = message.text?.trim().nullIfEmpty;
    if (body == null) return context.translations.systemMessageLabel;
    final a11y = context.translations.accessibility;
    return '${a11y.systemMessagePreviewLabel}\n$body';
  }

  /// Formats an empty [message] as a plain-text a11y label — the localized
  /// "no content" fallback.
  @protected
  String formatEmptyMessageSemanticsLabel(BuildContext context, Message message) {
    return context.translations.emptyMessagePreviewText;
  }

  /// Formats a [poll] message as a plain-text a11y label — `"Poll\n<name>"`.
  @protected
  String formatPollMessageSemanticsLabel(BuildContext context, Poll poll, User? currentUser) {
    final a11y = context.translations.accessibility;
    final name = poll.name.trim();
    if (name.isEmpty) return a11y.pollPreviewLabel;
    return '${a11y.pollPreviewLabel}\n$name';
  }

  /// Formats a shared-[location] message as a plain-text a11y label — the
  /// localized `"Location"` / `"Live location"` label, optionally suffixed
  /// with the message text when a caption is present and [showCaption] is
  /// `true`.
  @protected
  String formatLocationMessageSemanticsLabel(
    BuildContext context,
    Message message,
    Location location, {
    bool showCaption = true,
  }) {
    final typeLabel = context.translations.locationLabel(isLive: location.isLive);
    final caption = showCaption ? message.text?.trim().nullIfEmpty : null;
    if (caption == null) return typeLabel;
    return '$typeLabel\n$caption';
  }

  /// Formats non-empty [attachments] as a plain-text a11y label —
  /// `"<typeLabel>[\n<extra>]"`.
  ///
  /// `typeLabel` is a translated, count-aware type label (`"Photo"`,
  /// `"2 photos"`, `"Video"`, `"3 files"`, `"Voice recording"`, etc.);
  /// mixed-type groups collapse to `"N files"`. `extra` is the caption or,
  /// when absent, the attachment's intrinsic text — filename, URL-preview
  /// title, or voice-recording duration.
  @protected
  String formatMessageAttachmentsSemanticsLabel(
    BuildContext context,
    String? caption,
    Iterable<Attachment> attachments,
  ) {
    final preview = _resolveAttachmentSemanticsPreview(context, attachments, caption);
    if (preview.extra == null) return preview.typeLabel;
    return '${preview.typeLabel}\n${preview.extra}';
  }

  @override
  String formatDraftMessageSemanticsLabel(
    BuildContext context,
    DraftMessage draftMessage, {
    User? currentUser,
    bool showCaption = true,
  }) {
    final body = _formatContentSemanticsLabel(
      context,
      draftMessage.toMessage(),
      currentUser: currentUser,
      showCaption: showCaption,
    );

    final a11y = context.translations.accessibility;
    return '${a11y.draftPreviewLabel}\n$body';
  }
}

// ---------------------------------------------------------------------------
// Span primitives
//
// The preview is composed from three small helpers:
//
//  * [_iconSpan]       — an inline icon as a [WidgetSpan].
//  * [_labeledIcon]    — the common "icon + space + label" pattern.
//  * [_applyMentions]  — a single post-pass that bolds "@Mention" fragments
//                         anywhere in the assembled span tree.
//
// Most `format*` methods above reduce to a single call to [_labeledIcon], and
// mention handling stays out of every individual formatter — it's applied
// once at the root by [formatMessage].
// ---------------------------------------------------------------------------

// Builds an "icon + space + label" [TextSpan]. The icon slot is dropped
// when [icon] is null; the text slot (and separator) is dropped when
// [label] is empty.
//
// [textStyle] sets typography; [foregroundColor] tints the label and
// overrides [textStyle.color]. The inline icon always renders at the
// resulting effective text color so text and icon stay in sync.
TextSpan _labeledIcon({
  IconData? icon,
  required String label,
  TextStyle? textStyle,
  Color? foregroundColor,
}) {
  final effectiveTextStyle = (textStyle ?? const TextStyle()).copyWith(color: foregroundColor);

  return TextSpan(
    style: effectiveTextStyle,
    children: [
      if (icon != null) ...[
        _iconSpan(icon, color: effectiveTextStyle.color),
        if (label.isNotEmpty) const TextSpan(text: ' '),
      ],
      if (label.isNotEmpty) TextSpan(text: label),
    ],
  );
}

// Builds an inline icon [WidgetSpan] that vertically centers against the
// surrounding text.
//
// Uses [PlaceholderAlignment.middle] so the icon anchors to the line's
// vertical midline rather than a text baseline — this keeps icons visually
// aligned regardless of the icon font's intrinsic baseline, which rarely
// matches the body font.
WidgetSpan _iconSpan(
  IconData icon, {
  double size = 16,
  Color? color,
}) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Icon(icon, size: size, color: color),
  );
}

// Walks the assembled [span] tree once and bolds any text fragments that
// match a [mentionedUsers] entry (as "@UserName").
//
// Kept as a single post-pass so individual `format*` methods don't need to
// know about mentions. [WidgetSpan]s (e.g. inline icons) and styled
// descendants pass through untouched; only plain text fragments are split
// and re-wrapped.
// ignore: unused_element
TextSpan _applyMentions(TextSpan span, List<User> mentionedUsers) {
  if (mentionedUsers.isEmpty) return span;

  final regex = RegExp(mentionedUsers.map((it) => '@${RegExp.escape(it.name)}').join('|'));
  bool isMention(String s) => mentionedUsers.any((it) => '@${it.name}' == s);

  InlineSpan visit(InlineSpan node) {
    if (node is! TextSpan) return node;

    final mappedChildren = node.children?.map(visit).toList(growable: false);
    final text = node.text;

    if (text == null || text.isEmpty || !regex.hasMatch(text)) {
      return TextSpan(text: text, style: node.style, children: mappedChildren);
    }

    // Only the bolded mention fragments need an explicit style override;
    // non-mention fragments inherit from [node.style] (and ancestors).
    const boldStyle = TextStyle(fontWeight: FontWeight.bold);
    return TextSpan(
      style: node.style,
      children: [
        for (final part in text.splitByRegExp(regex))
          if (isMention(part)) TextSpan(text: part, style: boldStyle) else TextSpan(text: part),
        if (mappedChildren != null) ...mappedChildren,
      ],
    );
  }

  return visit(span) as TextSpan;
}

// Builds a bold [TextSpan] wrapping [text]. Used for the "You:" / "FirstName:"
// sender prefix.
TextSpan _boldSpan(String text) => TextSpan(
  text: text,
  style: const TextStyle(fontWeight: FontWeight.bold),
);

// ---------------------------------------------------------------------------
// Attachment presentation
//
// Resolving an attachment preview is split into three helpers:
//
//  * [_resolveAttachmentPreview]          — dispatcher: single vs multiple.
//  * [_resolveSingleAttachmentPreview]    — one attachment, one flat switch
//                                            over [AttachmentType].
//  * [_resolveMultipleAttachmentsPreview] — 2+ attachments: same-type groups
//                                            get a pluralized count,
//                                            mixed-type groups fall back to
//                                            the generic "N files" label.
// ---------------------------------------------------------------------------

// A resolved attachment preview: the inline [icon] (null = no icon) and the
// text [label] to render next to it.
typedef _AttachmentPreview = ({IconData? icon, String label});

// Resolves the icon + label to show for a message with [attachments],
// optionally falling back to [caption] when provided.
//
// Thin dispatcher that picks between the single- and multi-attachment
// resolvers so `format*` callers don't need to branch on attachment count.
// Assumes [attachments] is non-empty.
_AttachmentPreview _resolveAttachmentPreview(
  BuildContext context,
  Iterable<Attachment> attachments,
  String? caption,
) {
  if (attachments.length > 1) {
    return _resolveMultipleAttachmentsPreview(context, attachments, caption);
  }
  return _resolveSingleAttachmentPreview(context, attachments.first, caption);
}

// Resolves the preview for a message with a single [attachment].
//
// Produces a type-specific icon + label, preferring [caption], then any
// attachment-intrinsic text (filename, OG title, voice duration), and
// finally a localized type label ("Photo", "Video", "Audio", "File", "Link").
_AttachmentPreview _resolveSingleAttachmentPreview(
  BuildContext context,
  Attachment attachment,
  String? caption,
) {
  final icons = context.streamIcons;
  final translations = context.translations;

  return switch (attachment.type) {
    // Giphy previews are branded — fall back to the literal "Giphy" label
    // when no caption is available rather than a localized type name.
    .giphy => (icon: icons.file, label: caption ?? 'Giphy'),
    // Voice recordings embed the duration (mm:ss) in the label.
    .voiceRecording => (
      icon: icons.voice,
      label: caption ?? '${translations.voiceRecordingText} (${attachment.duration.toMinutesAndSeconds()})',
    ),
    .image => (icon: icons.camera, label: caption ?? translations.photosAttachmentCountText(1)),
    .video => (icon: icons.video, label: caption ?? translations.videosAttachmentCountText(1)),
    .file => (icon: icons.file, label: caption ?? attachment.title ?? translations.fileAttachmentText),
    .audio => (icon: icons.voice, label: caption ?? translations.audioAttachmentText),
    // Link previews are auto-generated from message text. Prefer the caption
    // (original message text) or the OG-scraped title; fall back to "Link".
    .urlPreview => (icon: icons.link, label: caption ?? attachment.title ?? translations.linkAttachmentText),
    // Unknown / custom types: unsupported icon + caption (if any).
    _ => (icon: icons.unsupportedAttachment, label: caption ?? ''),
  };
}

// Resolves the preview for a message with two or more [attachments].
//
// Same-type groups get a type-specific pluralized count ("2 Photos",
// "3 Videos", "4 files"). Mixed-type groups fall back to a generic file icon
// with "N files". Rarer same-type groups (audio, voice recording, giphy,
// link preview, custom) delegate to [_resolveSingleAttachmentPreview] of the
// first attachment — plural forms aren't defined for them.
//
// Assumes [attachments] has at least two entries.
_AttachmentPreview _resolveMultipleAttachmentsPreview(
  BuildContext context,
  Iterable<Attachment> attachments,
  String? caption,
) {
  final icons = context.streamIcons;
  final translations = context.translations;

  final first = attachments.first;
  final count = attachments.length;

  final hasMixedTypes = attachments.any((it) => it.type != first.type);
  if (hasMixedTypes) return (icon: icons.file, label: caption ?? translations.filesAttachmentCountText(count));

  return switch (first.type) {
    .image => (icon: icons.camera, label: caption ?? translations.photosAttachmentCountText(count)),
    .video => (icon: icons.video, label: caption ?? translations.videosAttachmentCountText(count)),
    .file => (icon: icons.file, label: caption ?? translations.filesAttachmentCountText(count)),
    _ => _resolveSingleAttachmentPreview(context, first, caption),
  };
}

// ---------------------------------------------------------------------------
// Attachment presentation (a11y)
//
// Mirror of the visual attachment resolvers above, producing a plain-text
// `(typeLabel, extra)` pair used by [formatMessageAttachmentsSemanticsLabel]:
//
//  * [_resolveAttachmentSemanticsPreview]          — dispatcher.
//  * [_resolveSingleAttachmentSemanticsPreview]    — one attachment; adds
//                                                     the attachment-intrinsic
//                                                     extra (filename, link
//                                                     title, voice duration)
//                                                     when no caption exists.
//  * [_resolveMultipleAttachmentsSemanticsPreview] — 2+ attachments; a
//                                                     type-only label plus
//                                                     the caption when set.
// ---------------------------------------------------------------------------

// A resolved a11y attachment preview: the localized [typeLabel] ("Photo",
// "2 photos", "Voice recording", ...) and an optional [extra] appended
// after a newline (caption, filename, or spelled-out duration).
typedef _AttachmentSemanticsPreview = ({String typeLabel, String? extra});

// Resolves the type label + extra to announce for a message with
// [attachments], optionally falling back to [caption] when provided.
//
// Thin dispatcher that picks between the single- and multi-attachment
// resolvers. Assumes [attachments] is non-empty.
_AttachmentSemanticsPreview _resolveAttachmentSemanticsPreview(
  BuildContext context,
  Iterable<Attachment> attachments,
  String? caption,
) {
  if (attachments.length > 1) {
    return _resolveMultipleAttachmentsSemanticsPreview(context, attachments, caption);
  }
  return _resolveSingleAttachmentSemanticsPreview(context, attachments.first, caption);
}

// Resolves the a11y preview for a message with a single [attachment].
//
// The type label is always emitted so screen-reader users hear the kind of
// attachment ("Photo", "File", "Voice recording", ...) even when a caption
// is present. The [extra] slot prefers [caption], then falls back to
// attachment-intrinsic text (filename, OG title, spelled-out voice
// duration) that would otherwise be lost.
_AttachmentSemanticsPreview _resolveSingleAttachmentSemanticsPreview(
  BuildContext context,
  Attachment attachment,
  String? caption,
) {
  final translations = context.translations;
  final a11y = translations.accessibility;
  final typeLabel = _semanticsTypeLabelFor(translations, attachment.type, 1);

  final extra = caption ?? switch (attachment.type) {
    // Spell the voice-recording duration out ("1 minute 23 seconds") rather
    // than a colon-separated clock string ("1:23") — screen readers announce
    // ":" inconsistently.
    AttachmentType.voiceRecording => a11y.formatDuration(attachment.duration),
    AttachmentType.file || AttachmentType.urlPreview => attachment.title?.trim().nullIfEmpty,
    _ => null,
  };

  return (typeLabel: typeLabel, extra: extra);
}

// Resolves the a11y preview for a message with two or more [attachments].
//
// Same-type groups get a pluralized count via
// [Translations.photosAttachmentCountText] / etc.; mixed-type groups
// collapse to a generic "N files" label. Attachment-intrinsic text
// (filename, duration) is not appended for multi-attachment groups — with
// no caption the group is announced as type-only.
//
// Assumes [attachments] has at least two entries.
_AttachmentSemanticsPreview _resolveMultipleAttachmentsSemanticsPreview(
  BuildContext context,
  Iterable<Attachment> attachments,
  String? caption,
) {
  final translations = context.translations;

  final first = attachments.first;
  final count = attachments.length;

  final hasMixedTypes = attachments.any((it) => it.type != first.type);
  if (hasMixedTypes) return (typeLabel: translations.filesAttachmentCountText(count), extra: caption);

  return (typeLabel: _semanticsTypeLabelFor(translations, first.type, count), extra: caption);
}

// Returns the localized, count-aware type label for the given attachment
// [type] — used by both single- and multi-attachment a11y resolvers.
//
// Types with a plural form (image / video / file) honor [count]; others
// return their singular label regardless.
String _semanticsTypeLabelFor(Translations t, AttachmentType? type, int count) {
  return switch (type) {
    AttachmentType.image => t.photosAttachmentCountText(count),
    AttachmentType.video => t.videosAttachmentCountText(count),
    AttachmentType.file => t.filesAttachmentCountText(count),
    AttachmentType.audio => t.audioAttachmentText,
    AttachmentType.voiceRecording => t.voiceRecordingText,
    AttachmentType.urlPreview => t.linkAttachmentText,
    // Giphy has no dedicated translation — the visual formatter uses the
    // literal 'Giphy' brand name.
    AttachmentType.giphy => 'Giphy',
    _ => t.filesAttachmentCountText(count),
  };
}

// Small [String] helpers used by the formatter.
extension on String {
  // Returns the string, or `null` when it is empty. Lets call sites collapse
  // "missing or blank" into a single null-check.
  String? get nullIfEmpty => isEmpty ? null : this;

  // Splits the string on every match of [regex], keeping the matched
  // fragments in the result.
  //
  // Unlike [String.split], this preserves the delimiters as their own
  // entries, so a mention-matching regex can split "Hi @Alice!" into
  // `["Hi ", "@Alice", "!"]` — the caller can then style only the mention
  // fragment.
  List<String> splitByRegExp(RegExp regex) {
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
