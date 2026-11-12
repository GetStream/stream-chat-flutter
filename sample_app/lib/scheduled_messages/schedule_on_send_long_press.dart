import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_messages_utils.dart';

/// Schedules the composer's message when its send button is long-pressed.
///
/// Opens the schedule sheet, schedules the message for the picked time, and
/// clears the composer once it is scheduled. Does nothing when the channel
/// doesn't allow scheduling, or while an attachment uploads.
Future<void> scheduleOnSendLongPress(
  BuildContext context,
  StreamMessageComposerController controller,
) async {
  final channel = StreamChannel.of(context).channel;
  if (!channel.canScheduleMessage) return;

  final message = controller.value;
  final isUploaded = message.attachments.every((it) => it.uploadState.isSuccess);
  if (!isUploaded) return;

  final messenger = StreamSnackbarMessenger.of(context);
  final fallback = context.translations.scheduleMessageError;

  final scheduledAt = await showStreamScheduleMessageSheet(
    context: context,
    channel: channel,
    message: message,
  );
  if (scheduledAt == null) return;

  try {
    await _schedule(channel, message, scheduledAt);
    controller.reset();
  } catch (error) {
    final description = describeScheduleError(error, fallback: fallback);
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
  }
}

// A failure that leaves the message listed as failed counts as scheduled, so
// it can be retried from the scheduled messages instead of scheduled twice.
// Any other failure keeps the message in the composer.
Future<void> _schedule(Channel channel, Message message, DateTime scheduledAt) async {
  try {
    await channel.scheduleMessage(message, scheduledAt: scheduledAt);
  } on StreamChatNetworkError catch (error) {
    final isAlreadySent = error.scheduledMessageErrorReason == .scheduledMessageAlreadySent;
    if (!error.isRetriable && !isAlreadySent) rethrow;
  }
}
