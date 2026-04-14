import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// {@template unreadMessagesSeparator}
/// A full-width banner that marks the boundary between read and unread
/// messages in a [StreamMessageListView].
///
/// [UnreadMessagesSeparator] displays a localised "Unread Messages" label
/// inside a subtle container with top and bottom borders.
///
/// {@tool snippet}
///
/// Display an unread messages separator with default styling:
///
/// ```dart
/// UnreadMessagesSeparator(
///   unreadCount: 5,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ThreadSeparator], which separates the parent message from thread
///    replies.
///  * [StreamMessageListView], which hosts this separator in the chat list.
/// {@endtemplate}
class UnreadMessagesSeparator extends StatelessWidget {
  /// Creates an unread messages separator widget.
  ///
  /// The [unreadCount] is required. All other parameters are optional.
  const UnreadMessagesSeparator({
    super.key,
    required this.unreadCount,
    this.margin,
    this.contentPadding,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
  });

  /// Number of unread messages.
  final int unreadCount;

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

  /// Text style for the unread label.
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
            context.translations.unreadMessagesSeparatorText(),
            textAlign: TextAlign.center,
            style: effectiveTextStyle,
          ),
        ),
      ),
    );
  }
}
