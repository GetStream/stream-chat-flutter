import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamUnsupportedAttachment}
/// Displays a placeholder for attachment types not supported by the SDK.
///
/// Shown automatically by [UnsupportedAttachmentBuilder] when no other
/// [StreamAttachmentWidgetBuilder] can handle the attachment. Can also be used
/// directly for custom attachment builder chains.
///
/// {@tool snippet}
///
/// Using as a standalone widget:
///
/// ```dart
/// StreamUnsupportedAttachment(
///   message: message,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamUnsupportedAttachmentProps], which configures this widget.
///  * [DefaultStreamUnsupportedAttachment], the default implementation.
///  * [UnsupportedAttachmentBuilder], which renders this widget for
///    unrecognised attachment types.
/// {@endtemplate}
class StreamUnsupportedAttachment extends StatelessWidget {
  /// Creates a [StreamUnsupportedAttachment].
  StreamUnsupportedAttachment({
    super.key,
    required Message message,
    BoxConstraints? constraints,
  }) : props = .new(message: message, constraints: constraints);

  /// The properties that configure this attachment.
  final StreamUnsupportedAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamUnsupportedAttachmentProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamUnsupportedAttachment(props: props);
  }
}

/// Properties for configuring a [StreamUnsupportedAttachment].
///
/// This class holds all the configuration options for an unsupported
/// attachment, allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamUnsupportedAttachment], which uses these properties.
///  * [DefaultStreamUnsupportedAttachment], the default implementation.
class StreamUnsupportedAttachmentProps {
  /// Creates properties for an unsupported attachment.
  const StreamUnsupportedAttachmentProps({
    required this.message,
    this.constraints,
  });

  /// The [Message] that the unsupported attachment belongs to.
  final Message message;

  /// Constraints for the attachment widget.
  ///
  /// When null, defaults to a fixed width of 256.
  final BoxConstraints? constraints;
}

const _kDefaultConstraints = BoxConstraints(maxWidth: 256);

/// The default implementation of [StreamUnsupportedAttachment].
///
/// Renders an icon and localised label indicating the attachment type is
/// not supported.
///
/// See also:
///
///  * [StreamUnsupportedAttachment], the public API widget.
///  * [StreamUnsupportedAttachmentProps], which configures this widget.
class DefaultStreamUnsupportedAttachment extends StatelessWidget {
  /// Creates a default Stream unsupported attachment.
  const DefaultStreamUnsupportedAttachment({
    super.key,
    required this.props,
  });

  /// The properties that configure this attachment.
  final StreamUnsupportedAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final foregroundColor = colorScheme.textPrimary;
    final effectiveConstraints = props.constraints ?? _kDefaultConstraints;

    return ConstrainedBox(
      constraints: effectiveConstraints,
      child: Padding(
        padding: .fromLTRB(spacing.sm, spacing.md, spacing.md, spacing.md),
        child: IconTheme(
          data: IconThemeData(size: 20, color: foregroundColor),
          child: DefaultTextStyle(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.captionEmphasis.copyWith(color: foregroundColor),
            child: Row(
              mainAxisSize: .min,
              spacing: spacing.xs,
              children: [
                Icon(context.streamIcons.unsupportedAttachment),
                Expanded(child: Text(context.translations.unsupportedAttachmentLabel)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
