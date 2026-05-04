import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/media_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/channel/stream_message_preview_text.dart';
import 'package:stream_chat_flutter/src/components/stream_chat_component_builders.dart';
import 'package:stream_chat_flutter/src/theme/quoted_message_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A preview of a quoted message rendered above a reply.
///
/// [StreamQuotedMessage] shows the quoted message's author and a short text
/// preview, with an optional trailing thumbnail when the quoted message has
/// a media or file attachment. It is rendered above the body of a message
/// that has a non-null [Message.quotedMessage].
///
/// The card chrome (background, shape, outer margin) is supplied by the
/// surrounding [StreamMessageAttachment], so this widget only renders its
/// content (indicator, title, subtitle, optional trailing thumbnail).
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
    BoxConstraints? constraints,
    VoidCallback? onTap,
  }) : props = .new(
         quotedMessage: quotedMessage,
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
    this.constraints,
    this.onTap,
  });

  /// The message being quoted.
  final Message quotedMessage;

  /// The constraints to use when displaying the preview.
  final BoxConstraints? constraints;

  /// Called when the user taps the preview.
  ///
  /// Typically used to scroll to the quoted message in the message list.
  final VoidCallback? onTap;
}

const _kDefaultConstraints = BoxConstraints.tightFor(width: 272);
const _kIndicatorWidth = 2.0;
const _kIndicatorHeight = 36.0;
const _kInnerRowMinHeight = 40.0;
const _kTrailingSize = Size(40, 40);

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
    final effectiveContentPadding = theme.contentPadding ?? defaults.contentPadding;

    final canTap = !quotedMessage.isDeleted && props.onTap != null;
    final constraints = props.constraints ?? _kDefaultConstraints;
    final trailing = _buildTrailing(context, quotedMessage);

    return StreamMessageAttachment(
      child: ConstrainedBox(
        constraints: constraints,
        child: InkWell(
          onTap: canTap ? props.onTap : null,
          child: Padding(
            padding: effectiveContentPadding,
            child: Row(
              spacing: spacing.xs,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: _kInnerRowMinHeight),
                    child: Row(
                      spacing: spacing.xs,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: _kIndicatorWidth,
                          height: _kIndicatorHeight,
                          decoration: BoxDecoration(
                            color: effectiveIndicatorColor,
                            borderRadius: BorderRadius.all(radius.max),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: spacing.xxxs,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DefaultTextStyle.merge(
                                maxLines: 1,
                                style: effectiveTitleTextStyle,
                                overflow: TextOverflow.ellipsis,
                                child: Text(quotedMessage.user?.name ?? ''),
                              ),
                              DefaultTextStyle.merge(
                                maxLines: 1,
                                style: effectiveSubtitleTextStyle,
                                overflow: TextOverflow.ellipsis,
                                child: StreamMessagePreviewText(message: quotedMessage),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildTrailing(BuildContext context, Message message) {
    final attachments = message.attachments;
    if (attachments.isEmpty) return null;

    final attachment = attachments.first;
    final type = attachment.type;

    if (type == AttachmentType.image || type == AttachmentType.video || type == AttachmentType.giphy) {
      return ClipRRect(
        borderRadius: BorderRadius.all(context.streamRadius.md),
        child: SizedBox.fromSize(
          size: _kTrailingSize,
          child: StreamMediaAttachmentThumbnail(
            media: attachment,
            width: _kTrailingSize.width,
            height: _kTrailingSize.height,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (type == AttachmentType.file) {
      // Only show a single file-type icon when every file shares a mime type.
      final mimeType = attachment.mimeType;
      if (mimeType == null) return null;
      if (attachments.any((it) => it.mimeType != mimeType)) return null;
      return StreamFileTypeIcon.fromMimeType(mimeType: mimeType);
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
  EdgeInsetsGeometry get contentPadding => EdgeInsetsDirectional.only(
    start: _spacing.sm,
    end: _spacing.xs,
    top: _spacing.xs,
    bottom: _spacing.xs,
  );
}
