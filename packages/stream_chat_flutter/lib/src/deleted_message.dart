import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';

/// {@macro deleted_message}
@Deprecated("Use 'StreamDeletedMessage' instead")
typedef DeletedMessage = StreamDeletedMessage;

/// {@template deleted_message}
/// Widget to display deleted message.
/// {@endtemplate}
class StreamDeletedMessage extends StatelessWidget {
  /// Constructor to create [StreamDeletedMessage]
  const StreamDeletedMessage({
    super.key,
    required this.messageTheme,
    this.borderRadiusGeometry,
    this.shape,
    this.borderSide,
    this.reverse = false,
  });

  /// The theme of the message
  final StreamMessageThemeData messageTheme;

  /// The border radius of the message text
  final BorderRadiusGeometry? borderRadiusGeometry;

  /// The shape of the message text
  final ShapeBorder? shape;

  /// The borderside of the message text
  final BorderSide? borderSide;

  /// If true the widget will be mirrored
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return Material(
      color: messageTheme.messageBackgroundColor,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: borderRadiusGeometry ?? BorderRadius.zero,
            side: borderSide ??
                BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chatThemeData.colorTheme.barsBg.withAlpha(24)
                      : chatThemeData.colorTheme.textHighEmphasis.withAlpha(24),
                ),
          ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Text(
          context.translations.messageDeletedLabel,
          style: messageTheme.messageTextStyle?.copyWith(
            fontStyle: FontStyle.italic,
            color: messageTheme.createdAtStyle?.color,
          ),
        ),
      ),
    );
  }
}
