import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_messages_utils.dart';

/// Schedules the composer's message when its send button is long-pressed.
///
/// Opens the schedule sheet and schedules the message for the picked time.
/// The composer is cleared right away, as it is when a message is sent, and
/// gets the message back only when it is refused before it is listed. Does
/// nothing when the channel doesn't allow scheduling.
Future<void> scheduleOnSendLongPress(
  BuildContext context,
  StreamMessageComposerController controller,
) async {
  final channel = StreamChannel.of(context).channel;
  if (!channel.canScheduleMessage) return;

  final message = controller.value;
  final messenger = StreamSnackbarMessenger.of(context);
  final fallback = context.translations.scheduleMessageError;

  final scheduledAt = await showStreamScheduleMessageSheet(
    context: context,
    channel: channel,
    message: message,
  );
  if (scheduledAt == null) return;

  // The next message gets an ID of its own, as the scheduled one took this
  // one's.
  controller.reset();
  final cleared = controller.value;

  try {
    await channel.scheduleMessage(message, scheduledAt: scheduledAt);
  } catch (error) {
    // Its failure is shown on the scheduled messages, to retry from there.
    if (_isListedOnFailure(error)) return;

    // Unless something was typed since, the composer gets it back to fix.
    final isUntouched = controller.value == cleared;
    if (_isRefusedBeforeListed(error) && isUntouched) controller.value = message;

    showScheduleError(messenger, error, fallback: fallback);
  }
}

// Whether the message stays listed as failed after [error], or was sent.
bool _isListedOnFailure(Object error) {
  if (error is! StreamChatNetworkError) return false;
  if (error.scheduledMessageErrorReason == .scheduledMessageAlreadySent) return true;
  return error.isRetriable;
}

// Whether [error] refused the message before it was listed, or stopped
// listing it, so only the composer still has it.
bool _isRefusedBeforeListed(Object error) {
  return switch (error) {
    ArgumentError() || StateError() || ScheduledMessageRefusedError() => true,
    StreamChatNetworkError(:final isRetriable) => !isRetriable,
    _ => false,
  };
}
