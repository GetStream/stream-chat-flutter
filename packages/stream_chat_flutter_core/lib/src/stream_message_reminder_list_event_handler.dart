import 'package:stream_chat/stream_chat.dart';
import 'stream_message_reminder_list_controller.dart';

/// Contains handlers that are called from [StreamMessageReminderListController]
/// for certain events.
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
    ConnectionRecoveredEvent event,
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
    ReminderCreatedEvent event,
    StreamMessageReminderListController controller,
  ) {
    final reminder = event.reminder;

    controller.updateReminder(reminder);
  }

  /// Function which gets called for the event
  /// [EventType.messageReminderUpdated].
  ///
  /// This event is fired when a message reminder is updated.
  ///
  /// By default, this updates the reminder in the list.
  void onMessageReminderUpdated(
    ReminderUpdatedEvent event,
    StreamMessageReminderListController controller,
  ) {
    final reminder = event.reminder;

    controller.updateReminder(reminder);
  }

  /// Function which gets called for the event
  /// [EventType.messageReminderDeleted].
  ///
  /// This event is fired when a message reminder is deleted.
  ///
  /// By default, this removes the reminder from the list.
  void onMessageReminderDeleted(
    ReminderDeletedEvent event,
    StreamMessageReminderListController controller,
  ) {
    final reminder = event.reminder;

    controller.deleteReminder(reminder);
  }

  /// Function which gets called for the event
  /// [EventType.notificationReminderDue].
  ///
  /// This event is fired when a message reminder crosses its due time.
  ///
  /// By default, this updates the reminder in the list.
  void onMessageReminderDue(
    NotificationReminderDueEvent event,
    StreamMessageReminderListController controller,
  ) {
    final updated = ReminderUpdatedEvent(
      cid: event.cid,
      messageId: event.messageId,
      parentId: event.parentId,
      reminder: event.reminder,
      userId: event.userId,
      createdAt: event.createdAt,
      custom: event.custom,
    );

    return onMessageReminderUpdated(updated, controller);
  }
}
