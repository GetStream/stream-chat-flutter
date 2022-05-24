import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template countdownButton}
/// Shows the countdown to when the user can send another message.
/// {@endtemplate}
class CountdownButton extends StatelessWidget {
  /// {@macro countdownButton}
  const CountdownButton({
    super.key,
    required this.count,
  });

  /// The countdown, in seconds.
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: StreamChatTheme.of(context).colorTheme.disabled,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          height: 24,
          width: 24,
          child: Center(
            child: Text('$count'),
          ),
        ),
      ),
    );
  }
}
