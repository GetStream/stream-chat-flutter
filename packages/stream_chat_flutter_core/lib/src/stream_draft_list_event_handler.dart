import 'package:stream_chat/stream_chat.dart';
import 'stream_draft_list_controller.dart';

/// Contains handlers that are called from [StreamDraftListController] for
/// certain events.
///
/// This class can be mixed in or extended to create custom overrides.
mixin class StreamDraftListEventHandler {
  /// Function which gets called for the event [EventType.connectionRecovered].
  ///
  /// This event is fired when the client web-socket connection recovers.
  ///
  /// By default, this refreshes the whole draft list.
  void onConnectionRecovered(
    ConnectionRecoveredEvent event,
    StreamDraftListController controller,
  ) {
    controller.refresh();
  }

  /// Function which gets called for the event [EventType.threadUpdated].
  ///
  /// This event is fired when a thread is updated.
  ///
  /// By default, this does nothing. Override this method to handle this event.
  void onDraftUpdated(
    DraftUpdatedEvent event,
    StreamDraftListController controller,
  ) {
    final draft = event.draft;
    if (draft == null) return;

    controller.updateDraft(draft);
  }

  /// Function which gets called for the event [EventType.draftDeleted].
  ///
  /// This event is fired when a draft is deleted.
  ///
  /// By default, this does nothing. Override this method to handle this event.
  void onDraftDeleted(
    DraftDeletedEvent event,
    StreamDraftListController controller,
  ) {
    final draft = event.draft;
    if (draft == null) return;

    controller.deleteDraft(draft);
  }
}
