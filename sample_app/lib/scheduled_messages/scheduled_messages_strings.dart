/// The sample app's strings for its scheduled messages screens.
///
/// The SDK's scheduled message widgets take theirs from `Translations`; these
/// are the ones only the sample's screens, sheets, snackbars and dialogs show.
abstract final class ScheduledMessagesStrings {
  static const title = 'Scheduled messages';
  static const scheduled = 'Message scheduled';
  static const updated = 'Scheduled message updated';
  static const sendingNow = 'Sending message';
  static const copied = 'Message copied';
  static const deleted = 'Scheduled message deleted';
  static const alreadySent = "Already sent. It's in the channel now.";
  static const deleteQuestion = 'Delete scheduled message?';
  static const scheduleMessage = 'Schedule message';
  static const rescheduleMessage = 'Reschedule message';
  static const editScheduledMessage = 'Edit scheduled message';
  static const messageHint = 'Message';
  static const date = 'Date';
  static const time = 'Time';
  static const pickFutureTime = 'Pick a time in the future';
  static const pickEarlierTime = 'Pick an earlier time';
  static const scheduledMessagesDisabled = 'Scheduled messages are turned off for this app';
  static const channelLimitReached = 'This channel has too many scheduled messages';
  static const userLimitReached = 'You have too many scheduled messages';
  static const notEditable = 'This message failed to send';
  static const alreadySending = 'This message is already being sent';
  static const conflict = 'This message just changed. Try again';
  static const alreadySentError = 'This message was already sent';
  static const canceled = 'This message was deleted';
  static const sentOrDeleted = 'This message was already sent or deleted';

  static String deleteDescription(String name) => "This message to $name won't be sent. This can't be undone.";

  static String messageTo(String name) => 'Message to $name';

  static String pickWithinDays(int days) => 'Pick a time within the next $days days';

  static String sentInTimeZone(String zone) => 'Sent in your time zone ($zone)';
}
