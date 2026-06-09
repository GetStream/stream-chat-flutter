import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/stream_system_message.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/src/utils/typedefs.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamModeratedMessage}
/// A widget that displays a message that has been moderated.
///
/// [StreamModeratedMessage] renders messages that have been flagged or
/// moderated according to content policies. It displays either the original
/// message text (when available) or a localised fallback indicating the
/// content was blocked.
///
/// {@tool snippet}
///
/// Display a moderated message with default styling:
///
/// ```dart
/// StreamModeratedMessage(
///   message: message,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamSystemMessage], which displays system messages with the same
///    pill style.
///  * [StreamMessageListView], which hosts moderated messages in the chat list.
/// {@endtemplate}
class StreamModeratedMessage extends StatelessWidget {
  /// Creates a moderated message widget.
  ///
  /// The [message] is required. All other parameters are optional.
  const StreamModeratedMessage({
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

  /// The moderated message to display.
  final Message message;

  /// Called when the message is tapped.
  ///
  /// If null, no tap gesture is registered on the message.
  final OnMessageTap? onMessageTap;

  /// Outer margin around the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  final EdgeInsetsGeometry? margin;

  /// Inner padding inside the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  final EdgeInsetsGeometry? contentPadding;

  /// Text style for the moderated message text.
  ///
  /// When non-null, takes precedence over the theme default.
  final TextStyle? textStyle;

  /// Background color of the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  final Color? backgroundColor;

  /// Border color of the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  final Color? borderColor;

  /// Border radius of the pill container.
  ///
  /// When non-null, takes precedence over the theme default.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final moderatedText = switch (message.text) {
      final messageText? when messageText.isNotEmpty => messageText,
      _ => context.translations.moderatedMessageBlockedText,
    };

    return StreamSystemMessage(
      message: message.copyWith(text: moderatedText),
      onMessageTap: onMessageTap,
      margin: margin,
      contentPadding: contentPadding,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
    );
  }
}
