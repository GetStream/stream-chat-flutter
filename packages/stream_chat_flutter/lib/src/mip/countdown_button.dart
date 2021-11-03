import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Button for showing visual component of slow mode.
class CountdownButton extends StatelessWidget {

  /// Constructor for creating [CountdownButton].
  const CountdownButton({
    Key? key,
    required this.count,
  }) : super(key: key);

  /// Count of time remaining to show to the user.
  final int count;

  @override
  Widget build(BuildContext context) => Padding(
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
