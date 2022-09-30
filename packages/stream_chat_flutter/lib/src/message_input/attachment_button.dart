import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template attachmentButton}
/// A button for adding attachments to a chat on mobile.
/// {@endtemplate}
class AttachmentButton extends StatelessWidget {
  /// {@macro attachmentButton}
  const AttachmentButton({
    super.key,
    required this.color,
    required this.onPressed,
  });

  /// The color of the button.
  final Color color;

  /// The callback to perform when the button is tapped or clicked.
  final VoidCallback onPressed;

  /// Returns a copy of this object with the given fields updated.
  AttachmentButton copyWith({
    Key? key,
    Color? color,
    VoidCallback? onPressed,
  }) {
    return AttachmentButton(
      key: key ?? this.key,
      color: color ?? this.color,
      onPressed: onPressed ?? this.onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: StreamSvgIcon.attach(
        color: color,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        height: 24,
        width: 24,
      ),
      splashRadius: 24,
      onPressed: onPressed,
    );
  }
}
