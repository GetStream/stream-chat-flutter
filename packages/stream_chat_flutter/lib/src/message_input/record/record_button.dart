import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template AudioLoadingMessage}
/// Button to start and resume recording. The business logic of recording is
/// not provided by this button, just the UI and the logic to hold to start.
/// The logic of the recording must be provided of using methods onHold and
/// onPressed.
/// {@endtemplate}
class RecordButton extends StatefulWidget {
  /// {@macro AudioLoadingMessage}
  const RecordButton({
    super.key,
    required this.icon,
    this.onHold,
    this.onPressed,
  });

  /// Creates the button to start the recording.
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

  /// Creates the button to resume the recording.
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

  /// Callback for holding the button.
  final VoidCallback? onHold;

  /// Callback for pressing the button.
  final VoidCallback? onPressed;

  /// Icon of the button.
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
