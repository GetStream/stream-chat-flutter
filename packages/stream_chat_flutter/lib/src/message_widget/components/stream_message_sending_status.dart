import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../../stream_chat_flutter.dart';

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
    final attachments = message.attachments;

    final hasNonUrlAttachments = attachments.any((it) => it.type != AttachmentType.urlPreview);

    if (hasNonUrlAttachments && message.state.isOutgoing) {
      final attachments = message.attachments;

      final totalAttachments = attachments.length;
      final uploadedCount = attachments.where((it) => it.uploadState.isSuccess).length;

      if (uploadedCount < totalAttachments) {
        return Text(
          context.translations.attachmentsUploadProgressText(
            total: totalAttachments,
            completed: uploadedCount,
          ),
        );
      }
    }

    final channel = StreamChannel.maybeOf(context)?.channel;

    // Previews sit on the modal scrim, where neither the accent-colored read
    // receipt nor the muted sent/delivered icon has enough contrast, so both
    // fall back to the on-scrim color.
    final iconColor = switch (core.StreamMessageLayout.presentationOf(context)) {
      .preview => context.streamColorScheme.textOnAccent,
      .standard => null,
    };

    return BetterStreamBuilder<List<Read>>(
      stream: channel?.state?.readStream,
      initialData: channel?.state?.read,
      builder: (context, data) {
        final readList = data.readsOf(message: message);
        final isMessageRead = readList.isNotEmpty;

        final deliveriesList = data.deliveriesOf(message: message);
        final isMessageDelivered = deliveriesList.isNotEmpty;

        return StreamSendingIndicator(
          message: message,
          isMessageRead: isMessageRead,
          isMessageDelivered: isMessageDelivered,
          color: iconColor,
        );
      },
    );
  }
}
