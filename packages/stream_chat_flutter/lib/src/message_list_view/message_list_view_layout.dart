import 'package:flutter/foundation.dart';

/// The role a single item index plays in [MessageListLayout].
enum MessageListItemSlot {
  /// The widget at the list's leading edge.
  ///
  /// This is the footer for a reversed list and the header otherwise.
  startEdge,

  /// The pagination loading indicator nearest the list's leading edge.
  bottomLoader,

  /// A message from the loaded messages.
  ///
  /// Use [MessageListLayout.messageIndexAt] to resolve the message position.
  message,

  /// The pagination loading indicator nearest the list's trailing edge.
  topLoader,

  /// The widget at the list's trailing edge.
  ///
  /// This is the header for a reversed list and the footer otherwise.
  endEdge,

  /// The parent message of the thread being displayed, if any.
  parentMessage,
}

/// The role a single separator index plays in [MessageListLayout].
enum MessageListSeparatorSlot {
  /// The gap adjoining [MessageListItemSlot.startEdge].
  startEdgeGap,

  /// The gap adjoining one of the pagination loading indicators.
  loaderGap,

  /// The separator between two adjacent messages.
  betweenMessages,

  /// The gap adjoining [MessageListItemSlot.endEdge].
  endEdgeGap,

  /// The separator introducing [MessageListItemSlot.parentMessage].
  threadSeparator,
}

/// Maps the item and separator indices of the message list's scroll view onto
/// the role each index plays.
///
/// The scroll view interleaves the loaded messages with five fixed slots — a
/// header, a footer, a pagination loading indicator at either end and the
/// thread's parent message. This type is the single place that knows how those
/// slots are laid out, so index arithmetic is not repeated across the item,
/// separator and item-key builders.
@immutable
final class MessageListLayout {
  /// Creates a layout for a list holding [messageCount] messages.
  const MessageListLayout({required this.messageCount});

  /// The number of loaded messages in the list.
  final int messageCount;

  /// The number of fixed slots surrounding the messages: a header, a footer, a
  /// pagination loading indicator at either end and the thread parent message.
  static const fixedSlotCount = 5;

  /// The item index of the first message, past the leading edge widget and the
  /// pagination loading indicator that precede it.
  static const firstMessageItemIndex = 2;

  /// The total number of items in the scroll view.
  int get itemCount => messageCount + fixedSlotCount;

  /// The item index of the thread parent message, which occupies the final slot
  /// and lives outside the loaded messages.
  int get parentMessageIndex => itemCount - 1;

  /// The role of the item at [index].
  MessageListItemSlot itemSlotAt(int index) => switch (index) {
    _ when index == itemCount - 1 => MessageListItemSlot.parentMessage,
    _ when index == itemCount - 2 => MessageListItemSlot.endEdge,
    _ when index == itemCount - 3 => MessageListItemSlot.topLoader,
    1 => MessageListItemSlot.bottomLoader,
    0 => MessageListItemSlot.startEdge,
    _ => MessageListItemSlot.message,
  };

  /// The role of the separator at [index].
  MessageListSeparatorSlot separatorSlotAt(int index) => switch (index) {
    _ when index == itemCount - 2 => MessageListSeparatorSlot.threadSeparator,
    _ when index == itemCount - 3 => MessageListSeparatorSlot.endEdgeGap,
    0 => MessageListSeparatorSlot.startEdgeGap,
    1 => MessageListSeparatorSlot.loaderGap,
    _ when index == itemCount - 4 => MessageListSeparatorSlot.loaderGap,
    _ => MessageListSeparatorSlot.betweenMessages,
  };

  /// The position in the loaded messages of the message shown at item [index].
  ///
  /// Only meaningful when [itemSlotAt] returns [MessageListItemSlot.message].
  int messageIndexAt(int index) => index - firstMessageItemIndex;

  /// The item index at which the message at [messageIndex] is shown.
  ///
  /// This is the inverse of [messageIndexAt].
  int itemIndexOfMessage(int messageIndex) => messageIndex + firstMessageItemIndex;

  @override
  bool operator ==(Object other) => other is MessageListLayout && other.messageCount == messageCount;

  @override
  int get hashCode => messageCount.hashCode;
}
