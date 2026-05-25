import 'package:collection/collection.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Determines at which point in the [MessageListView] the initial index should
/// be.
int getInitialIndex(
  int? initialScrollIndex,
  StreamChannelState channelState,
  bool Function(Message)? messageFilter, {
  String? messageId,
}) {
  if (initialScrollIndex != null) return initialScrollIndex;

  final channel = channelState.channel;
  final currentUser = channel.client.state.currentUser;
  if (currentUser == null) return 0;

  final messages = [
    ...channelState.channel.state!.messages.where(messageFilter ?? defaultMessageFilter(currentUser.id)),
  ].reversed.toList(growable: false);

  // Return the target message index if available.
  final targetMessageId = messageId ?? channelState.initialMessageId;
  if (targetMessageId != null) {
    final targetMessageIndex = messages.indexWhere(
      (it) => it.id == targetMessageId,
    );

    if (targetMessageIndex != -1) return targetMessageIndex + 2;
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

/// Computes the [StreamMessageStackPosition] for [message] based on its
/// [previous] and [next] neighbors in the message list.
///
/// A new group starts when:
/// - The neighbor is null (first/last message)
/// - The sender changes
/// - The timestamps fall in different calendar minutes
/// - The neighbor is a system, ephemeral, or error message
StreamMessageStackPosition computeStackPosition({
  required Message message,
  Message? previous,
  Message? next,
}) {
  final isFirst = _isGroupBoundary(message, previous);
  final isLast = _isGroupBoundary(message, next);

  return switch ((isFirst, isLast)) {
    (true, true) => StreamMessageStackPosition.single,
    (true, false) => StreamMessageStackPosition.top,
    (false, false) => StreamMessageStackPosition.middle,
    (false, true) => StreamMessageStackPosition.bottom,
  };
}

bool _isGroupBoundary(Message message, Message? neighbor) {
  if (neighbor == null) return true;
  if (message.user?.id != neighbor.user?.id) return true;
  if (neighbor.isSystem || neighbor.isEphemeral || neighbor.isError) return true;

  final createdAt = message.createdAt.toLocal();
  final neighborCreatedAt = neighbor.createdAt.toLocal();
  if (!createdAt.isSame(neighborCreatedAt, unit: .minute)) return true;

  return false;
}

/// Returns the [StreamMessageContentKind] for [message] based on its text,
/// attachments, poll, and quoted reply.
///
/// The result is [StreamMessageContentKind.singleAttachment] when:
/// - There is no text and no quoted reply
/// - There is exactly one attachment or a poll
///
/// The result is [StreamMessageContentKind.jumbomoji] when:
/// - There is no quoted reply, no poll, and no attachments
/// - The text contains only 1-3 emoji graphemes
StreamMessageContentKind resolveContentKind(Message message) {
  final hasText = message.text?.isNotEmpty == true;
  final hasQuote = message.quotedMessage != null;
  final hasPoll = message.poll != null;
  final hasSharedLocation = message.sharedLocation != null;
  final attachmentCount = message.attachments.length;

  if (!hasText && !hasQuote && (hasPoll || hasSharedLocation || attachmentCount == 1)) {
    return .singleAttachment;
  }

  if (!hasQuote && attachmentCount == 0) {
    final emojiCount = StreamMessageText.emojiCount(message.text);
    if (emojiCount != null && emojiCount <= 3) return .jumbomoji;
  }

  return .standard;
}
