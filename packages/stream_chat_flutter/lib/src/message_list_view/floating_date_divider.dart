import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/mlv_utils.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
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
    @Deprecated('No longer used, Will be removed in future versions.')
    this.isThreadConversation = false,
    this.dateDividerBuilder,
  });

  /// true if this is a thread conversation
  @Deprecated('No longer used, Will be removed in future versions.')
  final bool isThreadConversation;

  /// A [ValueListenable] that provides the positions of items in the list view.
  final ValueListenable<Iterable<ItemPosition>> itemPositionListener;

  /// Whether the list is reversed or not.
  final bool reverse;

  /// The list of messages which are displayed in the list view.
  final List<Message> messages;

  /// The total number of items in the list view, including special items like
  /// loaders, headers, and footers.
  final int itemCount;

  /// A optional builder function that creates a widget to display the date
  /// divider.
  ///
  /// If provided, this function will be called with the date of the message
  /// to create the date divider widget.
  final Widget Function(DateTime)? dateDividerBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: itemPositionListener,
      builder: (context, positions, child) {
        if (positions.isEmpty || messages.isEmpty) {
          return const Empty();
        }

        final index = switch (reverse) {
          true => getBottomElementIndex(positions),
          false => getTopElementIndex(positions),
        };

        if (index == null) return const Empty();
        if (!_isValidMessageIndex(index)) return const Empty();

        // Offset the index to account for two extra items
        // (loader and footer) at the bottom of the ListView.
        final message = messages.elementAtOrNull(index - 2);
        if (message == null) return const Empty();

        if (dateDividerBuilder case final builder?) {
          return builder.call(message.createdAt.toLocal());
        }

        return StreamDateDivider(dateTime: message.createdAt.toLocal());
      },
    );
  }

  // Returns True if the item index is a valid message index and not one of the
  // special items (like header, footer, loaders, etc.).
  bool _isValidMessageIndex(int index) {
    if (index == itemCount - 1) return false; // Parent Message
    if (index == itemCount - 2) return false; // Header Builder
    if (index == itemCount - 3) return false; // Top Loader Builder
    if (index == 1) return false; // Bottom Loader Builder
    if (index == 0) return false; // Footer Builder

    return true;
  }
}
