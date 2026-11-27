import '../../event_type.dart';
import '../../ws/events/event.dart';
import 'scheduled_message_list_state.dart';

/// A handler that applies the server's events to a
/// [ScheduledMessageListStateNotifier].
class ScheduledMessageEventHandler {
  /// Creates a handler applying events to [state].
  const ScheduledMessageEventHandler({required this.state});

  /// The state the events are applied to.
  final ScheduledMessageListStateNotifier state;

  /// Applies [event] to [state].
  void handleEvent(Event event) {
    // A scheduled message shows the latest copy of the message it quotes.
    if (event.type case EventType.messageUpdated || EventType.messageDeleted) {
      final message = event.message;
      if (message == null) return;

      return state.onQuotedMessageUpdated(message);
    }

    final scheduledMessage = event.scheduledMessage;
    if (scheduledMessage == null) return;

    if (event.type == EventType.scheduledMessageCreated) {
      return state.onScheduledMessageUpserted(scheduledMessage);
    }

    if (event.type == EventType.scheduledMessageUpdated) {
      return state.onScheduledMessageUpserted(scheduledMessage);
    }

    if (event.type == EventType.scheduledMessageFailed) {
      return state.onScheduledMessageUpserted(scheduledMessage);
    }

    if (event.type == EventType.scheduledMessageSent) {
      return state.onScheduledMessageRemoved(scheduledMessage.id);
    }

    if (event.type == EventType.scheduledMessageDeleted) {
      return state.onScheduledMessageRemoved(scheduledMessage.id);
    }
  }
}
