import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';

const double _kDefaultCommandButtonSize = 24;

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
    this.size = _kDefaultCommandButtonSize,
  }) : assert(
            (icon == null && color == null) ||
                (icon != null && color == null) ||
                (icon == null && color != null),
            'Either icon or color should be provided');

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
    return IconButton(
      icon: icon ??
          StreamSvgIcon(
            color: color,
            icon: StreamSvgIcons.lightning,
          ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(
        height: size,
        width: size,
      ),
      splashRadius: size,
      onPressed: onPressed,
    );
  }
}
