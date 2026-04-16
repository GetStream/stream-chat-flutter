import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// {@template threadSeparator}
/// A full-width banner that separates the parent message from its thread
/// replies in a [StreamMessageListView].
///
/// [ThreadSeparator] displays a localised reply-count label (e.g. "2 Replies")
/// inside a subtle container with top and bottom borders.
///
/// {@tool snippet}
///
/// Display a thread separator with default styling:
///
/// ```dart
/// ThreadSeparator(
///   parentMessage: message,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [UnreadMessagesSeparator], which separates read from unread messages.
///  * [StreamMessageListView], which hosts this separator in a thread view.
/// {@endtemplate}
class ThreadSeparator extends StatelessWidget {
  /// Creates a thread separator widget.
  ///
  /// The [parentMessage] is required. All other parameters are optional.
  const ThreadSeparator({
    super.key,
    required this.parentMessage,
    this.margin,
    this.contentPadding,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
  });

  /// The parent message of the thread.
  final Message parentMessage;

  /// Outer margin around the separator.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses vertical [core.StreamSpacing.xs].
  final EdgeInsetsGeometry? margin;

  /// Inner padding inside the separator.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses horizontal [core.StreamSpacing.md] and
  /// vertical [core.StreamSpacing.xs].
  final EdgeInsetsGeometry? contentPadding;

  /// Text style for the reply count label.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses [core.StreamTextTheme.metadataEmphasis]
  /// with [core.StreamColorScheme.textSecondary] as the text color.
  final TextStyle? textStyle;

  /// Background color of the separator.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses
  /// [core.StreamColorScheme.backgroundSurfaceSubtle].
  final Color? backgroundColor;

  /// Border color for the top and bottom edges.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses [core.StreamColorScheme.borderSubtle].
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final replyCount = parentMessage.replyCount ?? 0;

    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    final effectiveMargin = margin ?? .symmetric(vertical: spacing.xs);
    final effectiveContentPadding = contentPadding ?? .symmetric(horizontal: spacing.md, vertical: spacing.xs);
    final effectiveTextStyle = textStyle ?? textTheme.metadataEmphasis.copyWith(color: colorScheme.textSecondary);
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.backgroundSurfaceSubtle;
    final effectiveBorderColor = borderColor ?? colorScheme.borderSubtle;

    return Padding(
      padding: effectiveMargin,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          border: Border(
            top: BorderSide(color: effectiveBorderColor),
            bottom: BorderSide(color: effectiveBorderColor),
          ),
        ),
        child: Padding(
          padding: effectiveContentPadding,
          child: Text(
            context.translations.threadSeparatorText(replyCount),
            textAlign: TextAlign.center,
            style: effectiveTextStyle,
          ),
        ),
      ),
    );
  }
}
