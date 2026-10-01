import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../../stream_chat_flutter.dart';
import '../message_status_labels.dart';

/// Displays the sending status of a message, including attachment upload
/// progress and sent/delivered/read indicators.
///
/// While attachments are still uploading, a textual progress label is shown.
/// Once the message is fully sent, an icon indicates whether it has been
/// sent, delivered, or read.
///
/// This widget is typically used inside [StreamMessageFooter] and is only
/// shown for messages sent by the current user.
///
/// See also:
///
///  * [StreamSendingIndicator], which renders the sent/delivered/read icon.
///  * [StreamMessageFooter], which hosts this widget.
class StreamMessageSendingStatus extends StatelessWidget {
  /// Creates a sending status widget for the given [message].
  const StreamMessageSendingStatus({
    super.key,
    required this.message,
  });

  /// The message whose sending status to display.
  final Message message;

  @override
  Widget build(BuildContext context) {
    // Shared with the row announcement, so the progress a reader sees and the
    // progress a screen reader hears are the same number.
    if (attachmentUploadProgressLabel(context.translations, message) case final label?) {
      return Text(label);
    }

    final channel = StreamChannel.maybeOf(context)?.channel;

    // Previews sit on the modal scrim, where neither the accent-colored read
    // receipt nor the muted sent/delivered icon has enough contrast, so both
    // fall back to the on-scrim color.
    final iconColor = switch (core.StreamMessageLayout.presentationOf(context)) {
      .preview => context.streamColorScheme.textOnAccent,
      .standard => null,
    };

    // The channel state stream is the same object on every build, unlike a
    // stream mapped from it, so a rebuild keeps its subscription; the
    // comparator skips read events that leave this message's status as is.
    return BetterStreamBuilder<ChannelState>(
      stream: channel?.state?.channelStateStream,
      initialData: channel?.state?.channelState,
      comparator: (previous, next) => _statusOf(previous) == _statusOf(next),
      builder: (context, channelState) {
        // Read state is null until the channel is watched.
        if (channelState.read == null) return const SizedBox.shrink();
        final (:isMessageRead, :isMessageDelivered) = _statusOf(channelState);

        return StreamSendingIndicator(
          message: message,
          isMessageRead: isMessageRead,
          isMessageDelivered: isMessageDelivered,
          color: iconColor,
        );
      },
    );
  }

  ({bool isMessageRead, bool isMessageDelivered}) _statusOf(ChannelState? channelState) {
    final reads = channelState?.read ?? const <Read>[];
    return (
      isMessageRead: reads.readsOf(message: message).isNotEmpty,
      isMessageDelivered: reads.deliveriesOf(message: message).isNotEmpty,
    );
  }
}
