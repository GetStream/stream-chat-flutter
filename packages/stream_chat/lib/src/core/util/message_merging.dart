import 'package:stream_chat/src/core/models/location.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/util/list_extensions.dart';

/// Provides the merge and removal operations reconciling incoming messages
/// with the locally-held channel state collections.
///
/// Every operation is pure: it computes a new collection from the given
/// inputs without reading or writing any state.
class MessageMerging {
  const MessageMerging._();

  /// The default `update` strategy for the merge operations: merges the
  /// incoming [updated] into the locally-known [original] via
  /// [Message.updateWith], preserving enrichment the server may strip on
  /// partial payloads.
  static Message mergeUpdate(Message original, Message updated) => original.updateWith(updated);

  /// The replacing `update` strategy: takes the incoming [updated] as-is.
  /// Used by local rollback paths.
  static Message replaceUpdate(Message _, Message updated) => updated;

  /// Compares [a] and [b] by their [Message.createdAt].
  static int sortByCreatedAt(Message a, Message b) => a.createdAt.compareTo(b.createdAt);

  /// Merges the live locations carried by [toMerge] into [existing].
  ///
  /// Locations are keyed by (userId, channelCid, createdByDeviceId); an
  /// incoming message's [Message.sharedLocation] replaces the existing entry
  /// with the same key. Locations that are expired or whose attached message
  /// is deleted are dropped from the result.
  static Iterable<Location> mergeActiveLocations({
    required Iterable<Location> existing,
    required Iterable<Message> toMerge,
  }) {
    if (toMerge.isEmpty) return existing;

    final mergedLocations = existing.mergeFrom(
      toMerge,
      key: (it) => (it.userId, it.channelCid, it.createdByDeviceId),
      value: (message) => message.sharedLocation,
      update: (original, updated) => updated,
    );

    final toUpdateMap = {for (final m in toMerge) m.id: m};
    final updatedLocations = mergedLocations.where((it) {
      // Remove the location if it's expired.
      if (it.isExpired) return false;

      final updatedMessage = toUpdateMap[it.messageId];
      // Remove the location if the attached message is deleted.
      if (updatedMessage?.isDeleted == true) return false;

      return true;
    });

    return updatedLocations;
  }

  /// Merges [toMerge] into the [existing] pinned messages, keeping only
  /// messages that are still valid pins (see [pinIsValid]).
  static Iterable<Message> mergePinnedMessages({
    required Iterable<Message> existing,
    required Iterable<Message> toMerge,
    Message Function(Message original, Message updated) update = mergeUpdate,
  }) {
    return mergeMessages(
      existing: existing,
      toMerge: toMerge,
      update: update,
    ).where(pinIsValid);
  }

  /// Merges [toMerge] into [existing], returning a list sorted by
  /// [Message.createdAt].
  ///
  /// [update] decides whether each pair is reconciled (default — see
  /// [mergeUpdate]) or replaced ([replaceUpdate], used by local rollback
  /// paths that don't want enrichment fallback to keep optimistic values).
  ///
  /// [upsert] controls whether ids not already in [existing] are inserted.
  /// Event-driven paths (`message.updated`, `message.deleted` soft) pass
  /// `upsert: false` so an out-of-window message isn't dropped into a gap
  /// between the loaded slice and history the client hasn't paged in yet.
  static Iterable<Message> mergeMessages({
    required Iterable<Message> existing,
    required Iterable<Message> toMerge,
    Message Function(Message original, Message updated) update = mergeUpdate,
    bool upsert = true,
  }) {
    if (toMerge.isEmpty) return existing;

    final existingList = existing is List<Message> ? existing : existing.toList();
    var toMergeList = toMerge is List<Message> ? toMerge : toMerge.toList();

    // Single-message fast path. The hot ingest path (server echoes, edits,
    // reactions, read receipts) always lands here, and `lastIndexWhere` +
    // `sortedUpsertAt` skips the O(N) keymap build that the two-pointer
    // merge would otherwise do up front.
    if (toMergeList.length == 1) {
      final message = toMergeList.first;
      final oldIndex = existingList.lastIndexWhere((it) => it.id == message.id);

      // upsert: false — skip update if message is not loaded
      if (oldIndex == -1 && !upsert) return existingList;

      final resolved = oldIndex == -1 ? message : update(existingList[oldIndex], message);

      final mergedMessages = existingList.sortedUpsertAt(
        oldIndex,
        resolved,
        update: update,
        compare: sortByCreatedAt,
      );

      // Non-delete updates can't change what embedded quotedMessage copies
      // should display, so we can skip the rewrite entirely.
      if (!resolved.isDeleted) return mergedMessages;

      return mergedMessages.updateIf(
        (it) => it.quotedMessageId == resolved.id,
        (it) => it.copyWith(quotedMessage: resolved),
      );
    }

    // upsert: false - skip messages not loaded in the window
    if (!upsert) {
      final existingIds = {for (final m in existingList) m.id};
      toMergeList = toMergeList.where((m) => existingIds.contains(m.id)).toList();
      if (toMergeList.isEmpty) return existingList;
    }

    // Batch path: receiver (`existingList`) is maintained sorted as a
    // state invariant; `mergeSorted` sorts `toMergeList` internally and
    // returns a sorted result.
    final mergedMessages = existingList.mergeSorted(
      toMergeList,
      key: (message) => message.id,
      update: update,
      compare: sortByCreatedAt,
    );

    // Refresh embedded `quotedMessage` refs only for messages quoting an
    // incoming message that is now deleted. `updateIf` returns the same
    // list reference when nothing matches, so steady-state allocates
    // nothing for this step.
    final deletedIds = toMergeList.where((m) => m.isDeleted).map((m) => m.id).toSet();
    if (deletedIds.isEmpty) return mergedMessages;

    final mergedById = {for (final m in mergedMessages) m.id: m};
    return mergedMessages.updateIf(
      (it) => deletedIds.contains(it.quotedMessageId),
      (it) => it.copyWith(quotedMessage: mergedById[it.quotedMessageId]),
    );
  }

  /// Merges [toMerge] into the [existing] threads map, returning the updated
  /// map, or [existing] as-is when [toMerge] carries no thread replies.
  ///
  /// Replies are grouped by their parent id so each thread merge only sees
  /// its own messages. With [upsert] `false`, replies to threads not present
  /// in [existing] are dropped instead of creating the thread entry.
  static Map<String, List<Message>> mergeThreadMessages({
    required Map<String, List<Message>> existing,
    required Iterable<Message> toMerge,
    Message Function(Message original, Message updated) update = mergeUpdate,
    bool upsert = true,
  }) {
    if (toMerge.isEmpty) return existing;

    // Group messages by parentId so each thread merge only sees its own
    // replies — passing the full batch to every thread would leak replies
    // across thread boundaries (the merge dedups by id, not by parentId).
    final messagesByThread = <String, List<Message>>{};
    for (final m in toMerge) {
      if (m.parentId case final parentId?) (messagesByThread[parentId] ??= []).add(m);
    }

    // If there are no affected threads, return early.
    if (messagesByThread.isEmpty) return existing;

    final updatedThreads = {...existing};
    for (final MapEntry(key: thread, :value) in messagesByThread.entries) {
      final existingThreadMessages = updatedThreads[thread];

      // Don't create a phantom entry for a thread that wasn't loaded: with
      // `upsert: false` an out-of-window reply is dropped, so there's nothing
      // to merge. Writing it back would make `threads.containsKey(parentId)`
      // report a thread that was never paged in.
      if (existingThreadMessages == null && !upsert) continue;

      final threadMessages = existingThreadMessages ?? <Message>[];
      final updatedThreadMessages = mergeMessages(
        existing: threadMessages,
        toMerge: value,
        update: update,
        upsert: upsert,
      );

      // Update the thread with the modified message list.
      updatedThreads[thread] = updatedThreadMessages.toList();
    }

    return updatedThreads;
  }

  /// Removes from [existing] the locations attached to any message in
  /// [toRemove].
  static Iterable<Location> removeActiveLocations({
    required Iterable<Location> existing,
    required Iterable<Message> toRemove,
  }) {
    if (toRemove.isEmpty) return existing;

    final toRemoveIds = toRemove.map((m) => m.id).toSet();
    final updatedLocations = existing.where(
      // Remove the location if its attached message is in the toRemove list.
      (it) => !toRemoveIds.contains(it.messageId),
    );

    return updatedLocations;
  }

  /// Removes [toRemove] from the [existing] pinned messages, keeping only
  /// messages that are still valid pins (see [pinIsValid]).
  static Iterable<Message> removePinnedMessages({
    required Iterable<Message> existing,
    required Iterable<Message> toRemove,
  }) {
    return removeMessages(
      existing: existing,
      toRemove: toRemove,
    ).where(pinIsValid);
  }

  /// Removes [toRemove] from [existing], clearing the quoted-message
  /// reference of any remaining message that quotes a removed one.
  static Iterable<Message> removeMessages({
    required Iterable<Message> existing,
    required Iterable<Message> toRemove,
  }) {
    if (toRemove.isEmpty) return existing;

    final toRemoveIds = toRemove.map((m) => m.id).toSet();
    final updatedMessages = existing
        .where((it) {
          // Remove the message if it's in the toRemove list.
          return !toRemoveIds.contains(it.id);
        })
        .map((it) {
          // Continue if the message doesn't quote any of the deleted messages.
          if (!toRemoveIds.contains(it.quotedMessageId)) return it;

          // Setting it to null will remove the quoted message from the message.
          return it.copyWith(quotedMessageId: null, quotedMessage: null);
        });

    return updatedMessages;
  }

  /// Removes [toRemove] from the [existing] threads map, returning the
  /// updated map, or [existing] as-is when [toRemove] carries no thread
  /// replies.
  ///
  /// Thread entries left with no messages are dropped from the map.
  static Map<String, List<Message>> removeThreadMessages({
    required Map<String, List<Message>> existing,
    required Iterable<Message> toRemove,
  }) {
    if (toRemove.isEmpty) return existing;

    final affectedThreads = {...toRemove.map((it) => it.parentId).nonNulls};
    // If there are no affected threads, return early.
    if (affectedThreads.isEmpty) return existing;

    final updatedThreads = {...existing};
    for (final thread in affectedThreads) {
      final threadMessages = updatedThreads[thread];
      // Continue if the thread doesn't exist.
      if (threadMessages == null) continue;

      // Remove the deleted message from the thread messages and reference from
      // other messages quoting it.
      final updatedThreadMessages = removeMessages(
        existing: threadMessages,
        toRemove: toRemove,
      );

      // If there are no more messages in the thread, remove the thread entry.
      if (updatedThreadMessages.isEmpty) {
        updatedThreads.remove(thread);
        continue;
      }

      // Otherwise, update the thread with the modified message list.
      updatedThreads[thread] = updatedThreadMessages.toList();
    }

    return updatedThreads;
  }

  /// Whether the [message] is shown in the channel message list.
  ///
  /// Non-thread messages always are; thread replies only when explicitly
  /// marked to also show in the channel.
  static bool isShownInChannel(Message message) {
    // Non-thread messages are always shown in the channel.
    if (message.parentId == null) return true;

    // Thread messages are only shown if explicitly marked.
    return message.showInChannel == true;
  }

  /// Whether the [message] represents a currently valid pin.
  ///
  /// Returns `false` if the message is deleted, not pinned, or its
  /// [Message.pinExpires] has passed.
  static bool pinIsValid(Message message) {
    // If the message is deleted, the pin is not valid.
    if (message.isDeleted) return false;

    // If the message is not pinned, it's not valid.
    if (message.pinned != true) return false;

    // If there's no expiration, the pin is valid.
    final pinExpires = message.pinExpires;
    if (pinExpires == null) return true;

    // If there's an expiration, check if it's still valid.
    return pinExpires.isAfter(DateTime.now());
  }
}
