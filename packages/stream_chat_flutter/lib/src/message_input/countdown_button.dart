import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/stream_message_input_icon_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Button for showing visual component of slow mode.
class StreamCountdownButton extends StatelessWidget {
  /// Constructor for creating [StreamCountdownButton].
  const StreamCountdownButton({
    super.key,
    required this.count,
  });

  /// The amount of time remaining until the user can send a message again.
  /// Measured in seconds.
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultMessageInputIconPadding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: StreamChatTheme.of(context).colorTheme.disabled,
        ),
        child: SizedBox.square(
          dimension: kDefaultMessageInputIconSize,
          child: Center(child: Text('$count')),
        ),
      ),
    );
  }
}
