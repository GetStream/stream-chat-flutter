import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_list_view/message_list_view_layout.dart';

// Reference implementations of the index arithmetic as it was written inline in
// StreamMessageListView's item, separator and item-key builders. The layout
// type must agree with these for every index, so the extraction cannot silently
// change which widget lands in which slot.
MessageListItemSlot referenceItemSlot(int index, int itemCount) {
  if (index == itemCount - 1) return MessageListItemSlot.parentMessage;
  if (index == itemCount - 2) return MessageListItemSlot.endEdge;
  if (index == itemCount - 3) return MessageListItemSlot.topLoader;
  if (index == 1) return MessageListItemSlot.bottomLoader;
  if (index == 0) return MessageListItemSlot.startEdge;
  return MessageListItemSlot.message;
}

MessageListSeparatorSlot referenceSeparatorSlot(int index, int itemCount) {
  if (index == itemCount - 2) return MessageListSeparatorSlot.threadSeparator;
  if (index == itemCount - 3) return MessageListSeparatorSlot.endEdgeGap;
  if (index == 0) return MessageListSeparatorSlot.startEdgeGap;
  if (index == 1 || index == itemCount - 4) return MessageListSeparatorSlot.loaderGap;
  return MessageListSeparatorSlot.betweenMessages;
}

// Mirrors the original `itemKeyBuilder` closure.
bool referenceHasMessageKey(int index, int itemCount, int messageCount) {
  if (index < 2) return false;
  if (index >= itemCount - 3) return false;
  return index - 2 < messageCount;
}

void main() {
  group('itemCount', () {
    test('reserves five fixed slots around the messages', () {
      expect(const MessageListLayout(messageCount: 0).itemCount, 5);
      expect(const MessageListLayout(messageCount: 1).itemCount, 6);
      expect(const MessageListLayout(messageCount: 10).itemCount, 15);
    });
  });

  group('itemSlotAt', () {
    test('lays out an empty list as fixed slots only', () {
      const layout = MessageListLayout(messageCount: 0);

      expect(
        [for (var i = 0; i < layout.itemCount; i++) layout.itemSlotAt(i)],
        [
          MessageListItemSlot.startEdge,
          MessageListItemSlot.bottomLoader,
          MessageListItemSlot.topLoader,
          MessageListItemSlot.endEdge,
          MessageListItemSlot.parentMessage,
        ],
      );
    });

    test('places messages between the two pagination loaders', () {
      const layout = MessageListLayout(messageCount: 3);

      expect(
        [for (var i = 0; i < layout.itemCount; i++) layout.itemSlotAt(i)],
        [
          MessageListItemSlot.startEdge,
          MessageListItemSlot.bottomLoader,
          MessageListItemSlot.message,
          MessageListItemSlot.message,
          MessageListItemSlot.message,
          MessageListItemSlot.topLoader,
          MessageListItemSlot.endEdge,
          MessageListItemSlot.parentMessage,
        ],
      );
    });

    test('agrees with the original inline arithmetic for every index', () {
      for (var messageCount = 0; messageCount <= 20; messageCount++) {
        final layout = MessageListLayout(messageCount: messageCount);
        for (var i = 0; i < layout.itemCount; i++) {
          expect(
            layout.itemSlotAt(i),
            referenceItemSlot(i, layout.itemCount),
            reason: 'item slot mismatch at index $i of $messageCount messages',
          );
        }
      }
    });

    test('yields exactly messageCount message slots', () {
      for (var messageCount = 0; messageCount <= 20; messageCount++) {
        final layout = MessageListLayout(messageCount: messageCount);
        final messageSlots = [
          for (var i = 0; i < layout.itemCount; i++)
            if (layout.itemSlotAt(i) == MessageListItemSlot.message) i,
        ];

        expect(messageSlots.length, messageCount);
      }
    });
  });

  group('separatorSlotAt', () {
    test('agrees with the original inline arithmetic for every index', () {
      for (var messageCount = 0; messageCount <= 20; messageCount++) {
        final layout = MessageListLayout(messageCount: messageCount);
        // A separated list builds itemCount - 1 separators.
        for (var i = 0; i < layout.itemCount - 1; i++) {
          expect(
            layout.separatorSlotAt(i),
            referenceSeparatorSlot(i, layout.itemCount),
            reason: 'separator slot mismatch at index $i of $messageCount messages',
          );
        }
      }
    });

    test('brackets the messages with loader gaps', () {
      const layout = MessageListLayout(messageCount: 3);

      expect(
        [for (var i = 0; i < layout.itemCount - 1; i++) layout.separatorSlotAt(i)],
        [
          MessageListSeparatorSlot.startEdgeGap,
          MessageListSeparatorSlot.loaderGap,
          MessageListSeparatorSlot.betweenMessages,
          MessageListSeparatorSlot.betweenMessages,
          MessageListSeparatorSlot.loaderGap,
          MessageListSeparatorSlot.endEdgeGap,
          MessageListSeparatorSlot.threadSeparator,
        ],
      );
    });
  });

  group('message index mapping', () {
    test('maps the first message slot to message 0', () {
      const layout = MessageListLayout(messageCount: 5);

      expect(layout.messageIndexAt(2), 0);
      expect(layout.messageIndexAt(6), 4);
    });

    test('itemIndexOfMessage inverts messageIndexAt', () {
      const layout = MessageListLayout(messageCount: 5);

      for (var messageIndex = 0; messageIndex < 5; messageIndex++) {
        final itemIndex = layout.itemIndexOfMessage(messageIndex);
        expect(layout.messageIndexAt(itemIndex), messageIndex);
        expect(layout.itemSlotAt(itemIndex), MessageListItemSlot.message);
      }
    });

    test('message slots resolve to in-range message indices', () {
      for (var messageCount = 0; messageCount <= 20; messageCount++) {
        final layout = MessageListLayout(messageCount: messageCount);
        for (var i = 0; i < layout.itemCount; i++) {
          if (layout.itemSlotAt(i) != MessageListItemSlot.message) continue;

          final messageIndex = layout.messageIndexAt(i);
          expect(messageIndex, greaterThanOrEqualTo(0));
          expect(messageIndex, lessThan(messageCount));
        }
      }
    });

    test('message slots match where the original built an item key', () {
      for (var messageCount = 0; messageCount <= 20; messageCount++) {
        final layout = MessageListLayout(messageCount: messageCount);
        for (var i = 0; i < layout.itemCount; i++) {
          expect(
            layout.itemSlotAt(i) == MessageListItemSlot.message,
            referenceHasMessageKey(i, layout.itemCount, messageCount),
            reason: 'item key mismatch at index $i of $messageCount messages',
          );
        }
      }
    });
  });
}
