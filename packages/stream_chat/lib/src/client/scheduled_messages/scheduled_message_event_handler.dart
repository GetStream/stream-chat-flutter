import '../../core/models/event.dart';
import '../../event_type.dart';
import 'scheduled_message_list_state.dart';

/// A handler that applies scheduled message events to a
/// [ScheduledMessageListStateNotifier].
class ScheduledMessageEventHandler {
  /// Creates a handler applying events to [state].
  const ScheduledMessageEventHandler({required this.state});

  /// The state the events are applied to.
  final ScheduledMessageListStateNotifier state;

  /// Applies [event] to [state].
  void handleEvent(Event event) {
    // A scheduled message shows the latest copy of the message it quotes.
    if (event.type == EventType.messageUpdated || event.type == EventType.messageDeleted) {
      final message = event.message;
      if (message != null) state.onQuotedMessageUpdated(message);
      return;
    }

    final scheduledMessage = event.scheduledMessage;
    if (scheduledMessage == null) return;

    final type = event.type;
    if (type == EventType.scheduledMessageCreated ||
        type == EventType.scheduledMessageUpdated ||
        type == EventType.scheduledMessageFailed) {
      return state.onScheduledMessageUpserted(scheduledMessage);
    }

    if (type == EventType.scheduledMessageSent || type == EventType.scheduledMessageDeleted) {
      return state.onScheduledMessageRemoved(scheduledMessage.id);
    }
  }
}
