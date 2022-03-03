import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Shows the countdown to when the user can send another message.
class CountdownButton extends StatelessWidget {
  /// Builds a [CountdownButton].
  const CountdownButton({
    Key? key,
    required this.count,
  }) : super(key: key);

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