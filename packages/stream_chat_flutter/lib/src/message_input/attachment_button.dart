import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/stream_message_input_icon_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
    return StreamMessageInputIconButton(
      color: color,
      iconSize: size,
      onPressed: onPressed,
      icon: icon ?? const StreamSvgIcon(icon: StreamSvgIcons.attach),
    );
  }
}
