import 'package:stream_chat/stream_chat.dart';

import 'stream_scheduled_message_list_controller.dart';

/// Contains handlers that are called from
/// [StreamScheduledMessageListController] for certain [Event]s.
///
/// This class can be mixed in or extended to create custom overrides.
mixin class StreamScheduledMessageListEventHandler {
  /// Function which gets called for the event [EventType.connectionRecovered].
  ///
  /// This event is fired when the client web-socket connection recovers.
  ///
  /// By default, this loads the list again, keeping the current items until
  /// the new ones arrive.
  void onConnectionRecovered(
    Event event,
    StreamScheduledMessageListController controller,
  ) {
    controller.refresh(resetValue: false);
  }

  /// Function which gets called for the event
  /// [EventType.scheduledMessageCreated].
  ///
  /// This event is fired when a message is scheduled.
  ///
  /// By default, this adds the scheduled message to the list.
  void onScheduledMessageCreated(
    Event event,
    StreamScheduledMessageListController controller,
  ) {
    final scheduledMessage = event.scheduledMessage;
    if (scheduledMessage == null) return;

    controller.updateScheduledMessage(scheduledMessage);
  }

  /// Function which gets called for the event
  /// [EventType.scheduledMessageUpdated].
  ///
  /// This event is fired when a scheduled message is edited, rescheduled or
  /// starts sending.
  ///
  /// By default, this updates the scheduled message in the list.
  void onScheduledMessageUpdated(
    Event event,
    StreamScheduledMessageListController controller,
  ) {
    final scheduledMessage = event.scheduledMessage;
    if (scheduledMessage == null) return;

    controller.updateScheduledMessage(scheduledMessage);
  }

  /// Function which gets called for the event
  /// [EventType.scheduledMessageFailed].
  ///
  /// This event is fired when a scheduled message could not be sent.
  ///
  /// By default, this updates the scheduled message in the list.
  void onScheduledMessageFailed(
    Event event,
    StreamScheduledMessageListController controller,
  ) {
    final scheduledMessage = event.scheduledMessage;
    if (scheduledMessage == null) return;

    controller.updateScheduledMessage(scheduledMessage);
  }

  /// Function which gets called for the event
  /// [EventType.scheduledMessageSent].
  ///
  /// This event is fired when a scheduled message is sent.
  ///
  /// By default, this removes the scheduled message from the list.
  void onScheduledMessageSent(
    Event event,
    StreamScheduledMessageListController controller,
  ) {
    final scheduledMessage = event.scheduledMessage;
    if (scheduledMessage == null) return;

    controller.deleteScheduledMessage(scheduledMessage);
  }

  /// Function which gets called for the event
  /// [EventType.scheduledMessageDeleted].
  ///
  /// This event is fired when a scheduled message is deleted.
  ///
  /// By default, this removes the scheduled message from the list.
  void onScheduledMessageDeleted(
    Event event,
    StreamScheduledMessageListController controller,
  ) {
    final scheduledMessage = event.scheduledMessage;
    if (scheduledMessage == null) return;

    controller.deleteScheduledMessage(scheduledMessage);
  }
}
