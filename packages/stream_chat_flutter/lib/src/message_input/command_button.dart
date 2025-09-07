import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/message_input/stream_message_input_icon_button.dart';

/// {@template commandButton}
/// The button that allows a user to use commands in a chat.
/// {@endtemplate}
class CommandButton extends StatelessWidget {
  /// {@macro commandButton}
  const CommandButton({
    super.key,
    required this.onPressed,
    this.color,
    this.icon,
    this.size = kDefaultMessageInputIconSize,
  });

  /// The color of the button.
  /// Should be set if no [icon] is provided.
  final Color? color;

  /// The callback to perform when the button is tapped or clicked.
  final VoidCallback onPressed;

  /// The icon to display inside the button.
  /// if not provided, a default icon will be used
  /// and [color] property should be set.
  final Widget? icon;

  /// The size of the button and splash radius.
  final double size;

  /// Returns a copy of this object with the given fields updated.
  CommandButton copyWith({
    Key? key,
    Color? color,
    VoidCallback? onPressed,
    Widget? icon,
    double? size,
  }) {
    return CommandButton(
      key: key ?? this.key,
      color: color ?? this.color,
      onPressed: onPressed ?? this.onPressed,
      icon: icon ?? this.icon,
      size: size ?? this.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamMessageInputIconButton(
      color: color,
      iconSize: size,
      onPressed: onPressed,
      icon: icon ?? const StreamSvgIcon(icon: StreamSvgIcons.lightning),
    );
  }
}
