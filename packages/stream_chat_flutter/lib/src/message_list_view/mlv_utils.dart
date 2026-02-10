import 'package:collection/collection.dart';
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
    ...channelState.channel.state!.messages.where(messageFilter ?? defaultMessageFilter(currentUser.id)),
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
