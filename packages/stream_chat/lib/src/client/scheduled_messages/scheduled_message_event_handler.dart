import '../../core/models/events/chat_event.dart';
import '../../core/models/events/scheduled_message_events.dart';
import 'scheduled_message_list_state.dart';

/// A handler that applies scheduled message events to a
/// [ScheduledMessageListStateNotifier].
class ScheduledMessageEventHandler {
  /// Creates a handler applying events to [state].
  const ScheduledMessageEventHandler({required this.state});

  /// The state the events are applied to.
  final ScheduledMessageListStateNotifier state;

  /// Applies [event] to [state].
  void handleEvent(ChatEvent event) {
    switch (event) {
      case ScheduledMessageCreatedEvent(:final scheduledMessage?):
      case ScheduledMessageUpdatedEvent(:final scheduledMessage?):
      case ScheduledMessageFailedEvent(:final scheduledMessage?):
        return state.onScheduledMessageUpserted(scheduledMessage);
      case ScheduledMessageSentEvent(:final scheduledMessage?):
      case ScheduledMessageDeletedEvent(:final scheduledMessage?):
        return state.onScheduledMessageRemoved(scheduledMessage.id);
    }
  }
}
