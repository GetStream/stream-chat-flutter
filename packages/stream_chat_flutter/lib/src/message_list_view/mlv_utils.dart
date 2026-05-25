import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Determines at which point in the [MessageListView] the initial index should
/// be.
int getInitialIndex(
  int? initialScrollIndex,
  StreamChannelState channelState,
  bool Function(Message)? messageFilter,
) {
  if (initialScrollIndex != null) return initialScrollIndex;

  final channel = channelState.channel;
  final currentUser = channel.client.state.currentUser;
  if (currentUser == null) return 0;

  final messages = [
    ...channelState.channel.state!.messages
        .where(messageFilter ?? defaultMessageFilter(currentUser.id))
  ].reversed.toList(growable: false);

  // Return the initial message index if available.
  if (channelState.initialMessageId case final initialMessageId?) {
    final initialMessageIndex = messages.indexWhere(
      (it) => it.id == initialMessageId,
    );

    if (initialMessageIndex != -1) return initialMessageIndex + 2;
  }

  // Otherwise, return the first unread message index if available.
  if (channelState.getFirstUnreadMessage() case final firstUnreadMessage?) {
    final firstUnreadMessageIndex = messages.indexWhere(
      (it) => it.id == firstUnreadMessage.id,
    );

    if (firstUnreadMessageIndex != -1) return firstUnreadMessageIndex + 2;
  }

  return 0;
}

/// Gets the index of the top element in the viewport.
int? getTopElementIndex(Iterable<ItemPosition> values) {
  final inView = values.where((position) {
    if (position.itemLeadingEdge == position.itemTrailingEdge) {
      // If the item's leading and trailing edges are the same, it means the
      // item isn't actually rendering anything in the viewport.
      return false;
    }

    return position.itemTrailingEdge > 0;
  });

  if (inView.isEmpty) return null;
  return inView.reduce((min, position) {
    return position.itemTrailingEdge < min.itemTrailingEdge ? position : min;
  }).index;
}

/// Gets the index of the bottom element in the viewport.
int? getBottomElementIndex(Iterable<ItemPosition> values) {
  final inView = values.where((position) {
    if (position.itemLeadingEdge == position.itemTrailingEdge) {
      // If the item's leading and trailing edges are the same, it means the
      // item isn't actually rendering anything in the viewport.
      return false;
    }

    return position.itemLeadingEdge < 1;
  });

  if (inView.isEmpty) return null;
  return inView.reduce((max, position) {
    return position.itemLeadingEdge > max.itemLeadingEdge ? position : max;
  }).index;
}

/// Returns true if the element at [index] is at least partially visible in the
/// viewport.
///
/// Optionally, pass [fullyVisible] as true to check if the element is fully
/// visible in the viewport.
bool isElementAtIndexVisible(
  Iterable<ItemPosition> values, {
  required int index,
  bool fullyVisible = false,
}) {
  final element = values.firstWhereOrNull((it) => it.index == index);
  if (element == null) return false;

  if (fullyVisible) {
    return element.itemLeadingEdge >= 0 && element.itemTrailingEdge <= 1;
  }

  return element.itemTrailingEdge > 0 && element.itemLeadingEdge < 1;
}

/// Returns true if the message is the initial message.
bool isInitialMessage(String id, StreamChannelState? channelState) {
  return channelState!.initialMessageId == id;
}

/// Stream helpers for observing newly arrived messages on a channel,
/// either in the main message list or scoped to a thread.
extension NewMessageStreamX on ChannelClientState {
  // True when [candidate] represents a newer tail message than
  // [previous].
  //
  // A new arrival requires both a different id *and* a strictly later
  // [Message.createdAt], so edits, reactions, and reorderings are
  // ignored.
  bool _isNewTailArrival(Message candidate, Message? previous) {
    if (previous == null) return true;
    return candidate.id != previous.id &&
        candidate.createdAt.isAfter(previous.createdAt);
  }

  /// A stream that emits each newly arrived bottom message in
  /// [messages].
  ///
  /// Fires for every upstream that grows the list, including
  /// server-confirmed `message.new` events, optimistic local sends,
  /// and any other update that appends to the tail.
  ///
  /// A new arrival is detected when the bottom message's id changes
  /// **and** its [Message.createdAt] is strictly after the previously
  /// observed tail. Edits, reactions, tail deletions, and pruning are
  /// therefore ignored.
  ///
  /// Gated on [isUpToDate]: while the channel is loaded around a
  /// historic message the stream stays silent, and the first emission
  /// after the gate re-opens re-seeds the baseline without yielding.
  Stream<Message> get newMessageStream async* {
    var wasUpToDate = isUpToDate;
    var lastSeen = wasUpToDate ? messages.lastOrNull : null;

    await for (final updated in messagesStream) {
      if (!isUpToDate) {
        wasUpToDate = false;
        lastSeen = null;
        continue;
      }

      // Re-seed without yielding: the gate just re-opened, the next
      // emission is a wholesale window replacement, not an arrival.
      if (!wasUpToDate) {
        wasUpToDate = true;
        lastSeen = updated.lastOrNull;
        continue;
      }

      final newLast = updated.lastOrNull;
      if (newLast == null) {
        lastSeen = null;
        continue;
      }

      final isNewArrival = _isNewTailArrival(newLast, lastSeen);
      lastSeen = newLast;
      if (!isNewArrival) continue;
      yield newLast;
    }
  }

  /// A stream that emits each newly arrived reply at the bottom of
  /// the thread identified by [parentMessageId].
  ///
  /// Fires for every upstream that grows the thread, including
  /// server-confirmed replies, optimistic local sends, and any other
  /// update that appends to the tail of [threads].
  ///
  /// A new arrival is detected when the bottom reply's id changes
  /// **and** its [Message.createdAt] is strictly after the previously
  /// observed tail. Edits, reactions, tail deletions, and pruning are
  /// therefore ignored.
  ///
  /// Threads load lazily, so the stream stays silent until [threads]
  /// carries replies for [parentMessageId]; that first snapshot seeds
  /// the baseline without yielding.
  Stream<Message> newThreadMessageStream(String parentMessageId) async* {
    final threadMessages =
        threadsStream.mapNotNull((it) => it[parentMessageId]);

    var lastSeen = threads[parentMessageId]?.lastOrNull;
    await for (final updated in threadMessages) {
      final newLast = updated.lastOrNull;
      if (newLast == null) {
        lastSeen = null;
        continue;
      }

      final isNewArrival = _isNewTailArrival(newLast, lastSeen);
      lastSeen = newLast;
      if (!isNewArrival) continue;
      yield newLast;
    }
  }
}
