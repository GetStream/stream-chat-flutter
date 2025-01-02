import 'package:collection/collection.dart';
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

    return _updateParentOrReply(message, controller);
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

    return _updateParentOrReply(message, controller);
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

    return _updateParentOrReply(message, controller);
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

    return _updateParentOrReply(message, controller);
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

    return _updateParentOrReply(message, controller);
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

    return _deleteParentOrReply(
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

    return controller.updateThread(updatedThread);
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

    return controller.updateThread(updatedThread);
  }

  void _updateParentOrReply(
    Message message,
    StreamThreadListController controller,
  ) {
    // If the message is a parent message, update the thread.
    final thread = controller.getThread(parentMessageId: message.id);
    if (thread != null) {
      final updatedThread = thread.updateParent(message);
      return controller.updateThread(updatedThread);
    }

    // Otherwise, if the message is a reply, upsert it in the thread.
    final parentMessageId = message.parentId;
    final parentThread = controller.getThread(parentMessageId: parentMessageId);
    if (parentThread != null) {
      final updatedThread = parentThread.upsertReply(message);
      return controller.updateThread(updatedThread);
    }
  }

  void _deleteParentOrReply(
    Message message,
    StreamThreadListController controller, {
    bool isHardDelete = false,
  }) {
    // If the message is hard deleted, and it is a parent message, delete the
    // thread. Otherwise, remove the message from the thread replies.
    if (isHardDelete) {
      final parentMessageId = message.parentId;
      if (parentMessageId == null) {
        return controller.deleteThread(parentMessageId: parentMessageId);
      }

      return controller.deleteReply(message);
    }

    // Otherwise, update the parent or reply message.
    return _updateParentOrReply(message, controller);
  }
}

/// Extension on [StreamThreadListController] that contains utility methods
/// to update the threads list.
extension StreamThreadListEventHandlerExtension on StreamThreadListController {
  /// Updates the parent message of a thread.
  ///
  /// Returns `true` if matching parent message was found and was updated,
  /// `false` otherwise.
  void updateParent(Message parent) {
    final thread = getThread(parentMessageId: parent.id);
    if (thread == null) return; // No thread found for the message.

    final updatedThread = thread.updateParent(parent);

    return updateThread(updatedThread);
  }

  /// Deletes the given [reply] from the appropriate thread.
  void deleteReply(Message reply) {
    final thread = getThread(parentMessageId: reply.parentId);
    if (thread == null) return; // No thread found for the message.

    final updatedThread = thread.deleteReply(reply);

    return updateThread(updatedThread);
  }

  /// Inserts/updates the given [reply] into the appropriate thread.
  void upsertReply(Message reply) {
    final thread = getThread(parentMessageId: reply.parentId);
    if (thread == null) return; // No thread found for the message.

    final updatedThread = thread.upsertReply(reply);

    return updateThread(updatedThread);
  }
}

extension on Thread {
  /// Updates the parent message of a Thread.
  Thread updateParent(Message parent) {
    // Skip update if [parent] is not related to this Thread.
    if (parentMessageId != parent.id) return this;

    return copyWith(
      parentMessage: parent,
      deletedAt: parent.deletedAt,
      updatedAt: parent.updatedAt,
    );
  }

  /// Inserts a new [reply] (or updates and existing one) into the Thread.
  Thread upsertReply(Message reply) {
    // Skip update if [reply] is not related to this Thread.
    if (parentMessageId != reply.parentId) return this;

    final updatedReplies = _upsertMessageInList(reply, latestReplies);
    final isInsert = updatedReplies.length > latestReplies.length;
    final sortedUpdatedReplies = updatedReplies.sortedBy(
      (it) => it.localCreatedAt ?? it.createdAt,
    );

    final lastMessage = sortedUpdatedReplies.lastOrNull;
    final lastMessageAt = lastMessage?.localCreatedAt ?? lastMessage?.createdAt;

    // Update read counts (+1 for each non-sender of the message).
    final updatedRead = isInsert ? _updateReadCounts(read, reply) : read;

    return copyWith(
      updatedAt: lastMessageAt,
      lastMessageAt: lastMessageAt,
      latestReplies: sortedUpdatedReplies,
      read: updatedRead,
    );
  }

  Thread deleteReply(Message reply) {
    // Skip update if [reply] is not related to this Thread.
    if (parentMessageId != reply.parentId) return this;

    final updatedReplies = latestReplies.where((it) => it.id != reply.id);
    final sortedUpdatedReplies = updatedReplies.sortedBy(
      (it) => it.localCreatedAt ?? it.createdAt,
    );

    final lastMessage = sortedUpdatedReplies.lastOrNull;
    final lastMessageAt = lastMessage?.localCreatedAt ?? lastMessage?.createdAt;

    return copyWith(
      updatedAt: lastMessageAt,
      lastMessageAt: lastMessageAt,
      latestReplies: sortedUpdatedReplies,
    );
  }

  /// Marks the given thread as read by the given [user].
  Thread markAsReadByUser(User user, DateTime createdAt) {
    final updatedRead = read?.map((read) {
      if (read.user.id == user.id) {
        return read.copyWith(
          user: user,
          unreadMessages: 0,
          lastRead: createdAt,
        );
      }
      return read;
    }).toList();

    return copyWith(read: updatedRead);
  }

  /// Marks the given thread as unread by the given [user].
  Thread markAsUnreadByUser(User user, DateTime createdAt) {
    final updatedRead = read?.map((read) {
      if (read.user.id == user.id) {
        return read.copyWith(
          user: user,
          // Update this value to what the backend returns (when implemented)
          unreadMessages: read.unreadMessages + 1,
          lastRead: createdAt,
        );
      }
      return read;
    }).toList();

    return copyWith(read: updatedRead);
  }

  List<Message> _upsertMessageInList(
    Message newMessage,
    List<Message> messages,
  ) {
    // Insert if message is not present in the list.
    if (messages.none((it) => it.id == newMessage.id)) {
      return [...messages, newMessage];
    }

    // Otherwise, update the message.
    return [
      ...messages.map((message) {
        if (message.id == newMessage.id) return newMessage;
        return message;
      }),
    ];
  }

  List<Read>? _updateReadCounts(List<Read>? read, Message reply) {
    return read?.map((userRead) {
      // Skip the sender of the message.
      if (userRead.user.id == reply.user?.id) return userRead;
      // Increment the unread count for the non-sender.
      return userRead.copyWith(unreadMessages: userRead.unreadMessages + 1);
    }).toList();
  }
}
