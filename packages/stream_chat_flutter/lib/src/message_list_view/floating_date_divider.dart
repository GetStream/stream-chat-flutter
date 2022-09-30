import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/mlv_utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template floatingDateDivider}
/// Not intended for use outside of [MessageListView].
/// {@endtemplate}
class FloatingDateDivider extends StatelessWidget {
  /// {@macro floatingDateDivider}
  const FloatingDateDivider({
    super.key,
    required this.itemPositionListener,
    required this.reverse,
    required this.messages,
    required this.itemCount,
    this.isThreadConversation = false,
    this.dateDividerBuilder,
  });

  /// true if this is a thread conversation
  final bool isThreadConversation;

  // ignore: public_member_api_docs
  final ItemPositionsListener itemPositionListener;

  // ignore: public_member_api_docs
  final bool reverse;

  // ignore: public_member_api_docs
  final List<Message> messages;

  // ignore: public_member_api_docs
  final int itemCount;

  // ignore: public_member_api_docs
  final Widget Function(DateTime)? dateDividerBuilder;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: BetterStreamBuilder<Iterable<ItemPosition>>(
        initialData: itemPositionListener.itemPositions.value,
        stream: valueListenableToStreamAdapter(
          itemPositionListener.itemPositions,
        ),
        comparator: (a, b) {
          if (a == null || b == null) {
            return false;
          }
          if (reverse) {
            final aTop = getTopElementIndex(a);
            final bTop = getTopElementIndex(b);
            return aTop == bTop;
          } else {
            final aBottom = getBottomElementIndex(a);
            final bBottom = getBottomElementIndex(b);
            return aBottom == bBottom;
          }
        },
        builder: (context, values) {
          if (values.isEmpty || messages.isEmpty) {
            return const Offstage();
          }

          int? index;
          if (reverse) {
            index = getTopElementIndex(values);
          } else {
            index = getBottomElementIndex(values);
          }

          if ((index == null) ||
              (!isThreadConversation && index == itemCount - 2) ||
              (isThreadConversation && index == itemCount - 1)) {
            return const Offstage();
          }

          if (index <= 2 || index >= itemCount - 3) {
            if (reverse) {
              index = itemCount - 4;
            } else {
              index = 2;
            }
          }

          final message = messages[index - 2];
          return dateDividerBuilder != null
              ? dateDividerBuilder!(message.createdAt.toLocal())
              : StreamDateDivider(dateTime: message.createdAt.toLocal());
        },
      ),
    );
  }
}
