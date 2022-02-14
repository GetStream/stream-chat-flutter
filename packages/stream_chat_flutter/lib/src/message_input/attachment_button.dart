import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class AttachmentButton extends StatelessWidget {
  const AttachmentButton({
    Key? key,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: StreamSvgIcon.attach(
          color: color,
        ),
        padding: const EdgeInsets.all(0),
        constraints: const BoxConstraints.tightFor(
          height: 24,
          width: 24,
        ),
        splashRadius: 24,
        onPressed: onPressed,
      );
}
