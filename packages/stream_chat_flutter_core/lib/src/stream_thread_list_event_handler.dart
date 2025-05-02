import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_thread_list_controller.dart';

/// Contains handlers that are called from [StreamThreadListController] for
/// certain [Event]s.
///
/// This class can be mixed in or extended to create custom overrides.
mixin class StreamThreadListEventHandler {
  /// Function which gets called for the event [EventType.threadUpdated].
  ///
  /// This event is fired when a thread is updated.
  ///
  /// By default, this does nothing. Override this method to handle this event.
  void onThreadUpdated(Event event, StreamThreadListController controller) {
    // no-op
  }

  /// Function which gets called for the event [EventType.connectionRecovered].
  ///
  /// This event is fired when the client web-socket connection recovers.
  ///
  /// By default, this refreshes the whole thread list.
  void onConnectionRecovered(
    Event event,
    StreamThreadListController controller,
  ) {
    controller.refresh();
  }

  /// Function which gets called for the event [EventType.reactionNew].
  ///
  ///
  /// This event is fired when a new reaction is added to a message.
  ///
  /// By default, this updates the parent or reply message in the thread list.
  void onReactionNew(
    Event event,
    StreamThreadListController controller,
  ) {
    final message = event.message;
    if (message == null) return;

    _updateParentOrReply(message, controller);
  }

  /// Function which gets called for the event [EventType.reactionUpdated].
  ///
  /// This event is fired when a reaction is updated.
  ///
  /// By default, this updates the parent or reply message in the thread list.
  void onReactionUpdated(
    Event event,
    StreamThreadListController controller,
  ) {
    final message = event.message;
    if (message == null) return;

    _updateParentOrReply(message, controller);
  }

  /// Function which gets called for the event [EventType.reactionDeleted].
  ///
  /// This event is fired when a reaction is deleted.
  ///
  /// By default, this updates the parent or reply message in the thread list.
  void onReactionDeleted(
    Event event,
    StreamThreadListController controller,
  ) {
    final message = event.message;
    if (message == null) return;

    _updateParentOrReply(message, controller);
  }

  /// Function which gets called for the event
  /// [EventType.notificationThreadMessageNew].
  ///
  /// This event is fired when a new message is added to a thread.
  ///
  /// By default, this updates the unread count of the channel.
  void onNotificationThreadMessageNew(
    Event event,
    StreamThreadListController controller,
  ) {
    final message = event.message;
    if (message == null) return;

    final parentMessageId = message.parentId;
    final thread = controller.getThread(parentMessageId: parentMessageId);

    // Thread is not (yet) loaded, just update the state of unseenThreadIds.
    if (thread == null) return controller.addUnseenThreadId(parentMessageId);

    // Loaded thread is already being handled by the [onMessageNew] and
    // [onMessageUpdated] handlers.
    return;
  }

  /// Function which gets called for the event [EventType.messageNew].
  ///
  /// This event is fired when a new message is added.
  ///
  /// By default, this updates the parent or reply message in the thread list.
  void onMessageNew(
    Event event,
    StreamThreadListController controller,
  ) {
    final message = event.message;
    if (message == null) return;

    _updateParentOrReply(message, controller);
  }

  /// Function which gets called for the event [EventType.messageUpdated].
  ///
  /// This event is fired when a message is updated.
  ///
  /// By default, this updates the parent or reply message in the thread list.
  void onMessageUpdated(
    Event event,
    StreamThreadListController controller,
  ) {
    final message = event.message;
    if (message == null) return;

    _updateParentOrReply(message, controller);
  }

  /// Function which gets called for the event [EventType.messageDeleted].
  ///
  /// This event is fired when a message is deleted.
  ///
  /// By default, this updates or deletes the parent/reply message in the
  /// thread list based on the [Event.hardDelete] value.
  void onMessageDeleted(
    Event event,
    StreamThreadListController controller,
  ) {
    final message = event.message;
    if (message == null) return;

    _deleteParentOrReply(
      message,
      controller,
      isHardDelete: event.hardDelete ?? false,
    );
  }

  /// Function which gets called for the event [EventType.channelDeleted].
  ///
  /// This event is fired when a channel is deleted.
  ///
  /// By default, this deletes all threads associated with the channel.
  void onChannelDeleted(
    Event event,
    StreamThreadListController controller,
  ) {
    final channelCid = event.cid ?? event.channel?.cid;
    if (channelCid == null) return;

    return controller.deleteThreadByChannelCid(channelCid: channelCid);
  }

  /// Function which gets called for the event [EventType.channelTruncated].
  ///
  /// This event is fired when a channel is truncated.
  ///
  /// By default, this deletes all threads associated with the channel.
  void onChannelTruncated(
    Event event,
    StreamThreadListController controller,
  ) {
    final channelCid = event.cid ?? event.channel?.cid;
    if (channelCid == null) return;

    return controller.deleteThreadByChannelCid(channelCid: channelCid);
  }

  /// Function which gets called for the event [EventType.messageRead].
  ///
  /// This event is fired when a message is marked as read.
  ///
  /// By default, this updates the read state of the thread.
  void onMessageRead(
    Event event,
    StreamThreadListController controller,
  ) {
    final thread = event.thread;
    if (thread == null) return;

    final user = event.user;
    if (user == null) return;

    final createdAt = event.createdAt;

    return _markThreadAsRead(thread, user, createdAt, controller);
  }

  /// Function which gets called for the event
  /// [EventType.notificationMarkUnread].
  ///
  /// This event is fired when a message is marked as unread.
  ///
  /// By default, this updates the read state of the thread.
  void onNotificationMarkUnread(
    Event event,
    StreamThreadListController controller,
  ) {
    final thread = event.thread;
    if (thread == null) return;

    final user = event.user;
    if (user == null) return;

    final createdAt = event.createdAt;

    return _markThreadAsUnread(thread, user, createdAt, controller);
  }

  /// Function which gets called for the event [EventType.draftUpdated].
  ///
  /// This event is fired when a draft is either created or updated.
  ///
  /// By default, this updates the draft in the thread.
  void onDraftUpdated(
    Event event,
    StreamThreadListController controller,
  ) {
    final draft = event.draft;
    if (draft == null) return;

    final parentMessageId = draft.parentId;
    final thread = controller.getThread(parentMessageId: parentMessageId);
    if (thread == null) return;

    final updatedThread = thread.copyWith(draft: draft);

    controller.updateThread(updatedThread);
  }

  /// Function which gets called for the event [EventType.draftDeleted].
  ///
  /// This event is fired when a draft is deleted.
  ///
  /// By default, this deletes the draft in the thread.
  void onDraftDeleted(
    Event event,
    StreamThreadListController controller,
  ) {
    final draft = event.draft;
    if (draft == null) return;

    final parentMessageId = draft.parentId;
    final thread = controller.getThread(parentMessageId: parentMessageId);
    if (thread == null) return;

    final updatedThread = thread.copyWith(draft: null);

    controller.updateThread(updatedThread);
  }

  void _markThreadAsRead(
    Thread threadInfo,
    User user,
    DateTime createdAt,
    StreamThreadListController controller,
  ) {
    final parentMessageId = threadInfo.parentMessageId;
    final thread = controller.getThread(parentMessageId: parentMessageId);
    if (thread == null) return;

    final updatedThread = thread.markAsReadByUser(user, createdAt);

    controller.updateThread(updatedThread);
  }

  void _markThreadAsUnread(
    Thread threadInfo,
    User user,
    DateTime createdAt,
    StreamThreadListController controller,
  ) {
    final parentMessageId = threadInfo.parentMessageId;
    final thread = controller.getThread(parentMessageId: parentMessageId);
    if (thread == null) return;

    final updatedThread = thread.markAsUnreadByUser(user, createdAt);

    controller.updateThread(updatedThread);
  }

  bool _updateParentOrReply(
    Message message,
    StreamThreadListController controller,
  ) {
    return controller.updateParent(message) || controller.upsertReply(message);
  }

  bool _deleteParentOrReply(
    Message message,
    StreamThreadListController controller, {
    bool isHardDelete = false,
  }) {
    // If the message is hard deleted, and it is a parent message, delete the
    // thread. Otherwise, remove the message from the thread replies.
    if (isHardDelete) {
      final parentMessageId = message.parentId;
      if (parentMessageId == null) {
        return controller.deleteThread(parentMessageId: message.id);
      }

      return controller.deleteReply(message);
    }

    // Otherwise, update the parent or reply message.
    return _updateParentOrReply(message, controller);
  }
}
