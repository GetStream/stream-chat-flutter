import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Docs
class RecordButton extends StatefulWidget {
  /// Docs
  const RecordButton({
    super.key,
    required this.icon,
    this.onHold,
    this.onPressed,
  });

  /// Docs
  factory RecordButton.startButton({
    required VoidCallback onHold,
    VoidCallback? onPressed,
  }) {
    return RecordButton(
      onHold: onHold,
      icon: StreamSvgIcon.microphone(size: 20),
      onPressed: onPressed,
    );
  }

  /// Docs
  factory RecordButton.resumeButton({
    required VoidCallback onPressed,
  }) {
    return RecordButton(
      onPressed: onPressed,
      icon: StreamSvgIcon.microphone(
        color: Colors.red,
      ),
    );
  }

  /// Docs
  final VoidCallback? onHold;

  /// Docs
  final VoidCallback? onPressed;

  /// Docs
  final Widget icon;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  double posX = 0;

  void onTap(BuildContext context) {
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        widget.onHold?.call();
      },
      child: IconButton(
        icon: widget.icon,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(
          height: 24,
          width: 24,
        ),
        splashRadius: 24,
        onPressed: () {
          onTap(context);
        },
      ),
    );
  }
}

/// Docs
enum Trigger {
  /// Docs
  onTap,

  /// Docs
  onHold,
}
