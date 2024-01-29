import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const double _kDefaultCommandButtonSize = 24;

/// {@template attachmentButton}
/// A button for adding attachments to a chat on mobile.
/// {@endtemplate}
class AttachmentButton extends StatelessWidget {
  /// {@macro attachmentButton}
  const AttachmentButton({
    super.key,
    required this.onPressed,
    this.color,
    this.icon,
    this.size = 24,
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
  AttachmentButton copyWith({
    Key? key,
    Color? color,
    VoidCallback? onPressed,
    Widget? icon,
    double? size,
  }) {
    return AttachmentButton(
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
          StreamSvgIcon.attach(
            color: color,
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
