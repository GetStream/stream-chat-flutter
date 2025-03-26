import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/giphy_ephemeral_message.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/utils/typedefs.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamEphemeralMessage}
/// Shows an ephemeral message in a [MessageWidget].
/// {@endtemplate}
class StreamEphemeralMessage extends StatelessWidget {
  /// {@macro streamEphemeralMessage}
  const StreamEphemeralMessage({
    super.key,
    required this.message,
    this.onMessageTap,
  });

  /// The underlying [Message] object which this widget represents.
  final Message message;

  /// The action to perform when tapping on the message.
  final OnMessageTap? onMessageTap;

  @override
  Widget build(BuildContext context) {
    final streamChannel = StreamChannel.of(context);

    // If the message is a giphy command, we will show the giphy ephemeral
    // message instead.
    final isGiphy = message.command == 'giphy';
    if (isGiphy) {
      return Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: switch (onMessageTap) {
            final onTap? => () => onTap(message),
            _ => null,
          },
          child: GiphyEphemeralMessage(
            message: message,
            onActionPressed: (name, value) {
              streamChannel.channel.sendAction(
                message,
                {name: value},
              );
            },
          ),
        ),
      );
    }

    // Assert if the message is not handled.
    assert(true, 'Ephemeral message not handled, Please add a handler');

    // Show nothing if we don't know how to handle the message.
    return const Empty();
  }
}
