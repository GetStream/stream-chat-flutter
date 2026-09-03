import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

import '../attachment/thumbnail/media_attachment_thumbnail.dart';
import '../channel/stream_message_preview_text.dart';
import '../components/stream_chat_component_builders.dart';
import '../stream_chat.dart';
import '../theme/quoted_message_theme.dart';
import '../utils/extensions.dart';

/// A preview of a quoted message rendered above a reply.
///
/// [StreamQuotedMessage] shows the quoted message's author and a short text
/// preview, with an optional trailing thumbnail when the quoted message has
/// a media or file attachment. It is rendered above the body of a message
/// that has a non-null [Message.quotedMessage].
///
/// The card chrome (background, shape, outer padding) and the inner content
/// padding are all controlled via [StreamQuotedMessageThemeData].
///
/// {@tool snippet}
///
/// Basic usage:
///
/// ```dart
/// StreamQuotedMessage(
///   quotedMessage: message.quotedMessage!,
///   onTap: () => navigateToMessage(message.quotedMessage!),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamQuotedMessageProps], which configures this widget.
///  * [DefaultStreamQuotedMessage], the default implementation.
///  * [StreamQuotedMessageTheme], for theming.
class StreamQuotedMessage extends StatelessWidget {
  /// Creates a [StreamQuotedMessage].
  StreamQuotedMessage({
    super.key,
    required Message quotedMessage,
    Message? replyMessage,
    BoxConstraints? constraints,
    VoidCallback? onTap,
  }) : props = .new(
         quotedMessage: quotedMessage,
         replyMessage: replyMessage,
         constraints: constraints,
         onTap: onTap,
       );

  /// The properties that configure this widget.
  final StreamQuotedMessageProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamQuotedMessageProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamQuotedMessage(props: props);
  }
}

/// Properties for configuring a [StreamQuotedMessage].
///
/// Holds all the configuration options for the quoted-message preview,
/// allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamQuotedMessage], which uses these properties.
///  * [DefaultStreamQuotedMessage], the default implementation.
class StreamQuotedMessageProps {
  /// Creates properties for a quoted-message preview.
  const StreamQuotedMessageProps({
    required this.quotedMessage,
    this.replyMessage,
    this.constraints,
    this.onTap,
  });

  /// The message being quoted.
  final Message quotedMessage;

  /// The message doing the quoting.
  ///
  /// Only used to describe the preview to a screen reader — who replied, and
  /// whether they replied to the current user's message
  /// ("Han Solo replied to your message") or to someone else's
  /// ("You replied to Leia's message").
  ///
  /// When null, the preview falls back to announcing the quoted author's name
  /// on its own, which says nothing about the reply relationship.
  final Message? replyMessage;

  /// The constraints to use when displaying the preview.
  final BoxConstraints? constraints;

  /// Called when the user taps the preview.
  ///
  /// Typically used to scroll to the quoted message in the message list.
  final VoidCallback? onTap;
}

const _kDefaultConstraints = BoxConstraints.tightFor(width: 272);

const _kIndicatorWidth = 2.0;
const _kIndicatorVerticalMargin = 2.0;

/// The default implementation of [StreamQuotedMessage].
///
/// Renders the quoted-message preview with a vertical color indicator on
/// the leading edge, the author name as the title, a short text preview as
/// the subtitle, and an optional 40×40 trailing thumbnail or file-type icon.
///
/// Colors are picked directly off [StreamColorScheme] using the alignment
/// provided by the surrounding [StreamMessageLayout].
///
/// See also:
///
///  * [StreamQuotedMessage], the public API widget.
///  * [StreamQuotedMessageProps], which configures this widget.
class DefaultStreamQuotedMessage extends StatelessWidget {
  /// Creates a default Stream quoted-message preview.
  const DefaultStreamQuotedMessage({super.key, required this.props});

  /// The properties that configure this widget.
  final StreamQuotedMessageProps props;

  // Describes the reply relationship the preview stands for: who replied, and
  // whose message they replied to. Returns null when there is no replying
  // message to attribute, leaving the author's name to be announced as shown.
  //
  // The current user replying is a separate label rather than their name
  // swapped for the word "you", so a locale can conjugate the verb for the
  // person doing the replying.
  String? _semanticsLabel(BuildContext context) {
    final replyMessage = props.replyMessage;
    if (replyMessage == null) return null;

    final replier = replyMessage.user;
    if (replier == null) return null;

    final quotedAuthor = props.quotedMessage.user;
    if (quotedAuthor == null) return null;

    final a11y = context.translations.accessibility;
    final currentUser = StreamChat.maybeOf(context)?.currentUser;

    // Compared as nullables, an authorless message read by nobody signed in
    // would match on `null == null` and be announced as the reader's own.
    bool isCurrentUser(User user) => switch (currentUser) {
      final reader? => user.id == reader.id,
      _ => false,
    };

    final repliedToOwnMessage = isCurrentUser(quotedAuthor);

    if (isCurrentUser(replier)) {
      if (repliedToOwnMessage) return a11y.outgoingReplyToOwnMessageLabel();

      final authorName = quotedAuthor.name.trim();
      if (authorName.isEmpty) return null;

      return a11y.outgoingReplyToMessageLabel(authorName: authorName);
    }

    // With no name there is nothing to attribute the reply to, so the preview
    // falls back to announcing the author's name as shown.
    final replierName = replier.name.trim();
    if (replierName.isEmpty) return null;

    if (repliedToOwnMessage) {
      return a11y.incomingReplyToOwnMessageLabel(replierName: replierName);
    }

    final authorName = quotedAuthor.name.trim();
    if (authorName.isEmpty) return null;

    return a11y.incomingReplyToMessageLabel(replierName: replierName, authorName: authorName);
  }

  @override
  Widget build(BuildContext context) {
    final quotedMessage = props.quotedMessage;
    final spacing = context.streamSpacing;
    final radius = context.streamRadius;

    final theme = StreamQuotedMessageTheme.of(context);
    final defaults = _StreamQuotedMessageDefaults(context);

    final effectiveTitleTextStyle = theme.titleTextStyle ?? defaults.titleTextStyle;
    final effectiveSubtitleTextStyle = theme.subtitleTextStyle ?? defaults.subtitleTextStyle;
    final effectiveIndicatorColor = theme.indicatorColor ?? defaults.indicatorColor;
    final effectiveBackgroundColor = theme.backgroundColor ?? defaults.backgroundColor;

    final effectiveSide = theme.side ?? defaults.side;
    final effectiveShape = (theme.shape ?? defaults.shape).copyWith(side: effectiveSide);
    final effectiveMargin = theme.margin ?? defaults.margin;
    final effectivePadding = theme.padding ?? defaults.padding;
    final effectiveThumbnailSide = theme.thumbnailSide ?? defaults.thumbnailSide;
    final effectiveThumbnailShape = (theme.thumbnailShape ?? defaults.thumbnailShape).copyWith(
      side: effectiveThumbnailSide,
    );
    final effectiveThumbnailSize = theme.thumbnailSize ?? defaults.thumbnailSize;

    final canTap = !quotedMessage.isDeleted && props.onTap != null;
    final constraints = props.constraints ?? _kDefaultConstraints;

    final effectiveTitle = DefaultTextStyle.merge(
      style: effectiveTitleTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      // The visible title is just the quoted author's name, which leaves a
      // screen reader to guess at the relationship. Announcing who replied to
      // whom instead turns the preview into a sentence; it merges with the
      // body preview below into one phrase.
      child: Text(
        quotedMessage.user?.name ?? '',
        semanticsLabel: _semanticsLabel(context),
      ),
    );

    final effectiveSubtitle = DefaultTextStyle.merge(
      style: effectiveSubtitleTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: StreamMessagePreviewText(message: quotedMessage),
    );

    Widget? effectiveThumbnail;
    if (_buildThumbnail(context, quotedMessage) case final thumbnail?) {
      effectiveThumbnail = SizedBox.fromSize(
        size: effectiveThumbnailSize,
        child: Material(
          type: MaterialType.transparency,
          clipBehavior: Clip.hardEdge,
          shape: effectiveThumbnailShape,
          child: thumbnail,
        ),
      );
    }

    return Padding(
      padding: effectiveMargin,
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: effectiveShape,
        color: effectiveBackgroundColor,
        child: ConstrainedBox(
          constraints: constraints,
          child: InkWell(
            onTap: canTap ? props.onTap : null,
            child: Padding(
              padding: effectivePadding,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: .min,
                  spacing: spacing.xs,
                  children: [
                    VerticalDivider(
                      width: _kIndicatorWidth,
                      thickness: _kIndicatorWidth,
                      indent: _kIndicatorVerticalMargin,
                      endIndent: _kIndicatorVerticalMargin,
                      radius: BorderRadius.all(radius.max),
                      color: effectiveIndicatorColor,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: .min,
                        spacing: spacing.xxxs,
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .start,
                        children: [effectiveTitle, effectiveSubtitle],
                      ),
                    ),
                    ?effectiveThumbnail,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildThumbnail(BuildContext context, Message message) {
    final attachments = message.attachments;
    if (attachments.isEmpty || attachments.length > 1) return null;

    final attachment = attachments.first;
    final type = attachment.type;

    if (type == .image || type == .video || type == .giphy) {
      return StreamMediaAttachmentThumbnail(media: attachment, fit: .cover);
    }

    if (type == .file) {
      // Only show a single file-type icon when every file shares a mime type.
      final mimeType = attachment.mimeType;
      if (mimeType == null) return null;
      if (attachments.any((it) => it.mimeType != mimeType)) return null;
      return StreamFileTypeIcon.fromMimeType(mimeType: mimeType, size: .lg);
    }

    return null;
  }
}

// Default values for [StreamQuotedMessageThemeData] backed by stream design
// tokens. The incoming/outgoing palette is picked directly off
// [StreamColorScheme] using the alignment provided by [StreamMessageLayout].
class _StreamQuotedMessageDefaults extends StreamQuotedMessageThemeData {
  _StreamQuotedMessageDefaults(this._context);

  final BuildContext _context;

  late final _alignment = StreamMessageLayout.messageAlignmentOf(_context);

  late final StreamSpacing _spacing = _context.streamSpacing;
  late final StreamRadius _radius = _context.streamRadius;
  late final StreamColorScheme _colorScheme = _context.streamColorScheme;
  late final StreamTextTheme _textTheme = _context.streamTextTheme;

  Color get _textColor => switch (_alignment) {
    .start => _colorScheme.textPrimary,
    .end => _colorScheme.brand.shade900,
  };

  @override
  TextStyle get titleTextStyle => _textTheme.metadataEmphasis.copyWith(color: _textColor);

  @override
  TextStyle get subtitleTextStyle => _textTheme.metadataDefault.copyWith(color: _textColor);

  @override
  Color get indicatorColor => switch (_alignment) {
    .start => _colorScheme.chrome.shade400,
    .end => _colorScheme.brand.shade400,
  };

  @override
  Color get backgroundColor => switch (_alignment) {
    .start => _colorScheme.backgroundSurfaceStrong,
    .end => _colorScheme.brand.shade150,
  };

  @override
  OutlinedBorder get shape => RoundedSuperellipseBorder(borderRadius: .all(_radius.lg));

  @override
  BorderSide get side => BorderSide.none;

  @override
  EdgeInsetsGeometry get margin => EdgeInsets.symmetric(horizontal: _spacing.xs);

  @override
  EdgeInsetsGeometry get padding => EdgeInsetsDirectional.only(
    start: _spacing.sm,
    end: _spacing.xs,
    top: _spacing.xs,
    bottom: _spacing.xs,
  );

  @override
  OutlinedBorder get thumbnailShape => RoundedSuperellipseBorder(borderRadius: .all(_radius.md));

  @override
  Size get thumbnailSize => const Size.square(40);
}
