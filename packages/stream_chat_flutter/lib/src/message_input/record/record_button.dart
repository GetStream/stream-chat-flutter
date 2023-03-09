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
  }) {
    return RecordButton(
      onHold: onHold,
      icon: Icons.mic,
    );
  }
  /// Docs
  factory RecordButton.resumeButton({
    required VoidCallback onPressed,
  }) {
    return RecordButton(
      onPressed: onPressed,
      icon: Icons.mic,
    );
  }

  /// Docs
  final VoidCallback? onHold;

  /// Docs
  final VoidCallback? onPressed;

  /// Docs
  final IconData icon;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  double posX = 0;

  //Todo: Fix the position to be above this button
  void showOnPressHint() {
    final entry = OverlayEntry(builder: (context) {
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.8,
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: const Card(
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'You need to hold to record!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    });

    Overlay.of(context).insert(entry);
    Future.delayed(const Duration(seconds: 2)).then((value) => entry.remove());
  }

  void onTap(BuildContext context) {
    if (widget.onPressed != null) {
      widget.onPressed!.call();
    } else {
      showOnPressHint();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = StreamChatTheme.of(context).primaryIconTheme.color;

    return GestureDetector(
      onLongPress: () {
        widget.onHold?.call();
      },
      child: IconButton(
        icon: Icon(
          widget.icon,
          color: color,
        ),
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
