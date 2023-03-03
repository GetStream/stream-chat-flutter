import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Docs
class OnHoldButton extends StatefulWidget {
  /// Docs
  const OnHoldButton({
    super.key,
    this.onHoldStart,
    this.onHoldStop,
    required this.icon,
  });

  /// Docs
  factory OnHoldButton.audioRecord({
    IconData? icon,
    VoidCallback? onHoldStart,
    VoidCallback? onHoldStop,
  }) {

    return OnHoldButton(
      onHoldStart: onHoldStart,
      onHoldStop: onHoldStop,
      icon: icon ?? Icons.mic,
    );
  }

  /// Docs
  final VoidCallback? onHoldStart;

  /// Docs
  final VoidCallback? onHoldStop;

  /// Docs
  final IconData icon;

  @override
  State<OnHoldButton> createState() => _OnHoldButtonState();
}

class _OnHoldButtonState extends State<OnHoldButton> {
  bool _isHolding = false;
  double posX = 0;

  Future<void> _start(BuildContext context) async {
    widget.onHoldStart?.call();
  }

  Future<void> _stop(BuildContext context) async {
    widget.onHoldStop?.call();
  }

  @override
  Widget build(BuildContext context) {
    final color = StreamChatTheme.of(context).primaryIconTheme.color;

    final gestureDetector = GestureDetector(
      onTapDown: (details) {
        setState(() {
          _isHolding = true;
        });
        _start(context);
      },
      onTapUp: (details) {
        if (_isHolding) {
          _stop(context);
        }
        setState(() {
          _isHolding = false;
        });
      },
      child: Icon(
        widget.icon,
        color: color,
      ),
    );

    return SizedBox(
      height: 30,
      width: 30,
      child: gestureDetector,
    );
  }
}
