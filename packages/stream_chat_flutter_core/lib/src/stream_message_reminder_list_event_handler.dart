import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_message_reminder_list_controller.dart';

/// Contains handlers that are called from [StreamMessageReminderListController]
/// for certain [Event]s.
///
/// This class can be mixed in or extended to create custom overrides.
mixin class StreamMessageReminderListEventHandler {
  /// Function which gets called for the event [EventType.connectionRecovered].
  ///
  /// This event is fired when the client web-socket connection recovers.
  ///
  /// By default, this does nothing and can be overridden to perform
  /// custom actions, such as refreshing the list of reminders.
  void onConnectionRecovered(
    Event event,
    StreamMessageReminderListController controller,
  ) {
    // no-op
  }

  /// Function which gets called for the event
  /// [EventType.messageReminderUpdated].
  ///
  /// This event is fired when a message reminder is updated.
  ///
  /// By default, this updates the reminder in the list.
  void onMessageReminderCreated(
    Event event,
    StreamMessageReminderListController controller,
  ) {
    final reminder = event.reminder;
    if (reminder == null) return;

    controller.updateReminder(reminder);
  }

  /// Function which gets called for the event
  /// [EventType.messageReminderUpdated].
  ///
  /// This event is fired when a message reminder is updated.
  ///
  /// By default, this updates the reminder in the list.
  void onMessageReminderUpdated(
    Event event,
    StreamMessageReminderListController controller,
  ) {
    final reminder = event.reminder;
    if (reminder == null) return;

    controller.updateReminder(reminder);
  }

  /// Function which gets called for the event
  /// [EventType.messageReminderDeleted].
  ///
  /// This event is fired when a message reminder is deleted.
  ///
  /// By default, this removes the reminder from the list.
  void onMessageReminderDeleted(
    Event event,
    StreamMessageReminderListController controller,
  ) {
    final reminder = event.reminder;
    if (reminder == null) return;

    controller.deleteReminder(reminder);
  }

  /// Function which gets called for the event
  /// [EventType.notificationReminderDue].
  ///
  /// This event is fired when a message reminder crosses its due time.
  ///
  /// By default, this updates the reminder in the list.
  void onMessageReminderDue(
    Event event,
    StreamMessageReminderListController controller,
  ) {
    return onMessageReminderUpdated(event, controller);
  }
}
