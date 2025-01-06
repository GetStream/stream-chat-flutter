import 'package:collection/collection.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Determines at which point in the [MessageListView] the initial index should
/// be.
int getInitialIndex(
  int? initialScrollIndex,
  StreamChannelState channelState,
  bool Function(Message)? messageFilter,
  Read? read,
) {
  if (initialScrollIndex != null) {
    return initialScrollIndex;
  }

  final messages = channelState.channel.state!.messages
      .where(messageFilter ??
          defaultMessageFilter(
            channelState.channel.client.state.currentUser!.id,
          ))
      .toList(growable: false);

  if (channelState.initialMessageId != null) {
    final totalMessages = messages.length;
    final messageIndex =
        messages.indexWhere((e) => e.id == channelState.initialMessageId);
    final index = totalMessages - messageIndex;
    if (index != 0) return index + 1;
    return index;
  }

  if (read != null) {
    final oldestUnreadMessage = messages.firstWhereOrNull(
      (it) =>
          it.user?.id != channelState.channel.client.state.currentUser?.id &&
          it.createdAt.compareTo(read.lastRead) > 0,
    );

    if (oldestUnreadMessage != null) {
      final oldestUnreadMessageIndex = messages.indexOf(oldestUnreadMessage);
      final index = messages.length - oldestUnreadMessageIndex;
      return index + 1;
    }
  }

  return 0;
}

/// Gets the index of the top element in the viewport.
int? getTopElementIndex(Iterable<ItemPosition> values) {
  final inView = values.where((position) => position.itemTrailingEdge > 0);
  if (inView.isEmpty) return null;

  return inView.reduce((min, position) {
    return position.itemTrailingEdge < min.itemTrailingEdge ? position : min;
  }).index;
}

/// Gets the index of the bottom element in the viewport.
int? getBottomElementIndex(Iterable<ItemPosition> values) {
  final inView = values.where((position) => position.itemLeadingEdge < 1);
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

  return element.itemLeadingEdge > 0 || element.itemTrailingEdge < 1;
}

/// Returns true if the message is the initial message.
bool isInitialMessage(String id, StreamChannelState? channelState) {
  return channelState!.initialMessageId == id;
}
