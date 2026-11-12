/// The sample app's strings for its scheduled messages screens.
///
/// The SDK's scheduled message widgets take theirs from `Translations`; these
/// are the ones only the sample's screens, sheets, snackbars and dialogs show.
abstract final class ScheduledMessagesStrings {
  static const title = 'Scheduled messages';
  static const emptyDescription = 'Long press the send button in a channel to schedule a message.';
  static const stillSending = 'Still sending. Try again in a moment.';
  static const scheduled = 'Message scheduled';
  static const rescheduled = 'Message rescheduled';
  static const updated = 'Scheduled message updated';
  static const sendingNow = 'Sending message';
  static const copied = 'Message copied';
  static const deleted = 'Scheduled message deleted';
  static const alreadySent = "Already sent. It's in the channel now.";
  static const deleteQuestion = 'Delete scheduled message?';
  static const pickFutureTime = 'Pick a time in the future';
  static const pickEarlierTime = 'Pick an earlier time';
  static const scheduledMessagesDisabled = 'Scheduled messages are turned off';
  static const channelLimitReached = 'Limit reached for this channel';
  static const userLimitReached = 'You have too many scheduled messages';
  static const notEditable = 'This message failed to send';
  static const alreadySending = 'This message is already being sent';
  static const conflict = 'This message just changed. Try again';
  static const alreadySentError = 'This message was already sent';
  static const canceled = 'This message was deleted';
  static const sentOrDeleted = 'This message was already sent or deleted';
  static const commandNotSchedulable = "Commands can't be scheduled";
  static const quotedMessageDeleted = 'The quoted message was deleted';
  static const failedOneNotRemoved = 'Scheduled. Delete the failed copy';

  static String deleteDescription(String? name) => switch (name) {
    final name? => "This message to $name won't be sent. This can't be undone.",
    null => "This message won't be sent. This can't be undone.",
  };
}
