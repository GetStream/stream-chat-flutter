import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// {@template streamSystemMessage}
/// A widget that displays a system message as a centered pill-shaped container.
///
/// [StreamSystemMessage] renders non-user messages such as "User X was added
/// to the group" or "User Y is now an admin".
///
/// {@tool snippet}
///
/// Display a system message with default styling:
///
/// ```dart
/// StreamSystemMessage(
///   message: message,
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// Customise the appearance per-instance:
///
/// ```dart
/// StreamSystemMessage(
///   message: message,
///   onMessageTap: (msg) => print('Tapped: ${msg.id}'),
///   backgroundColor: Colors.amber.shade50,
///   borderColor: Colors.amber.shade200,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamModeratedMessage], which displays moderated messages with the
///    same pill style.
///  * [StreamMessageListView], which hosts system messages in the chat list.
/// {@endtemplate}
class StreamSystemMessage extends StatelessWidget {
  /// Creates a system message widget.
  ///
  /// The [message] is required. All other parameters are optional.
  const StreamSystemMessage({
    super.key,
    required this.message,
    this.onMessageTap,
    this.margin,
    this.contentPadding,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
  });

  /// The system message to display.
  final Message message;

  /// Called when the message is tapped.
  ///
  /// If null, no tap gesture is registered on the message.
  final OnMessageTap? onMessageTap;

  /// Outer margin around the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses horizontal [core.StreamSpacing.xxl].
  final EdgeInsetsGeometry? margin;

  /// Inner padding inside the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses horizontal [core.StreamSpacing.sm] and
  /// vertical [core.StreamSpacing.xs].
  final EdgeInsetsGeometry? contentPadding;

  /// Text style for the system message text.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses [core.StreamTextTheme.metadataDefault]
  /// with [core.StreamColorScheme.textSecondary] as the text color.
  final TextStyle? textStyle;

  /// Background color of the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses
  /// [core.StreamColorScheme.backgroundSurfaceSubtle].
  final Color? backgroundColor;

  /// Border color of the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses [core.StreamColorScheme.borderSubtle].
  final Color? borderColor;

  /// Border radius of the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  ///
  /// When null (the default), uses [core.StreamRadius.xl].
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final message = this.message.replaceMentions(linkify: false);

    final messageText = message.text;
    if (messageText == null) return const Empty();

    final radius = context.streamRadius;
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final effectiveMargin = margin ?? .symmetric(horizontal: spacing.xxl);
    final effectiveContentPadding = contentPadding ?? .symmetric(horizontal: spacing.sm, vertical: spacing.xs);
    final effectiveTextStyle = textStyle ?? textTheme.metadataDefault.copyWith(color: colorScheme.textSecondary);

    final effectiveBorderColor = borderColor ?? colorScheme.borderSubtle;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.all(radius.xl);
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.backgroundSurfaceSubtle;

    return Material(
      type: .transparency,
      child: InkWell(
        onTap: switch (onMessageTap) {
          final onTap? => () => onTap(message),
          _ => null,
        },
        child: Center(
          child: Container(
            margin: effectiveMargin,
            decoration: BoxDecoration(
              color: effectiveBackgroundColor,
              border: .all(color: effectiveBorderColor),
              borderRadius: effectiveBorderRadius,
            ),
            child: Padding(
              padding: effectiveContentPadding,
              child: Text(
                messageText,
                softWrap: true,
                textAlign: .center,
                style: effectiveTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
