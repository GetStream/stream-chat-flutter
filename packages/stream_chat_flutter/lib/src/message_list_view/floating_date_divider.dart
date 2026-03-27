import 'dart:math';

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
    this.fadeNearInlineDivider = true,
    this.dateDividerBuilder,
  });

  /// Viewport-fraction over which the floating divider fades out
  static const _fadeRange = 0.05;

  /// A [ValueListenable] that provides the positions of items in the list view.
  final ValueListenable<Iterable<ItemPosition>> itemPositionListener;

  /// Whether the list is reversed or not.
  final bool reverse;

  /// The list of messages which are displayed in the list view.
  final List<Message> messages;

  /// The total number of items in the list view, including special items like
  /// loaders, headers, and footers.
  final int itemCount;

  /// Whether this divider fades out when an inline date divider for the same
  /// date approaches it in the viewport.
  ///
  /// Defaults to true.
  final bool fadeNearInlineDivider;

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
        final messageIndex = index - 2;
        final message = messages.elementAtOrNull(messageIndex);
        if (message == null) return const Empty();

        final divider = switch (dateDividerBuilder) {
          final builder? => builder.call(message.createdAt.toLocal()),
          _ => StreamDateDivider(dateTime: message.createdAt.toLocal()),
        };

        if (!fadeNearInlineDivider) return divider;

        final opacity = _floatingDividerOpacity(
          positions,
          index,
          messageIndex,
        );

        if (opacity <= 0) return const Empty();
        if (opacity >= 1) return divider;

        return Opacity(opacity: opacity, child: divider);
      },
    );
  }

  double _floatingDividerOpacity(
    Iterable<ItemPosition> positions,
    int itemIndex,
    int messageIndex,
  ) {
    final messageDate = messages[messageIndex].createdAt.toLocal();

    final bool hasDateDividerAbove;
    final bool hasDateDividerBelow;

    if (reverse) {
      hasDateDividerAbove =
          messageIndex >= messages.length - 1 ||
          !_isSameDay(
            messageDate,
            messages[messageIndex + 1].createdAt.toLocal(),
          );
      hasDateDividerBelow =
          messageIndex > 0 &&
          !_isSameDay(
            messageDate,
            messages[messageIndex - 1].createdAt.toLocal(),
          );
    } else {
      hasDateDividerAbove =
          messageIndex > 0 &&
          !_isSameDay(
            messageDate,
            messages[messageIndex - 1].createdAt.toLocal(),
          );
      hasDateDividerBelow =
          messageIndex < messages.length - 1 &&
          !_isSameDay(
            messageDate,
            messages[messageIndex + 1].createdAt.toLocal(),
          );
    }

    if (!hasDateDividerAbove && !hasDateDividerBelow) return 1;

    for (final p in positions) {
      if (p.index != itemIndex) continue;

      var opacity = 1.0;

      if (reverse) {
        // Fade as the inline divider ABOVE becomes visible
        // (trailing edge = top of item, 1.0 = viewport top).
        if (hasDateDividerAbove && p.itemTrailingEdge < 1) {
          opacity = clampDouble(
            (p.itemTrailingEdge - (1.0 - _fadeRange)) / _fadeRange,
            0,
            1,
          );
        }

        // Fade as the inline divider BELOW approaches the viewport top
        // (leading edge = bottom of item, approaching 1.0).
        if (hasDateDividerBelow) {
          final t = clampDouble(
            ((1.0 - _fadeRange) - p.itemLeadingEdge) / _fadeRange,
            0,
            1,
          );
          opacity = min(opacity, t);
        }
      } else {
        // Fade as the inline divider ABOVE becomes visible
        // (leading edge = top of item, 0.0 = viewport top).
        if (hasDateDividerAbove && p.itemLeadingEdge > 0) {
          opacity = clampDouble(
            (_fadeRange - p.itemLeadingEdge) / _fadeRange,
            0,
            1,
          );
        }

        // Fade as the inline divider BELOW approaches the viewport top
        // (trailing edge = bottom of item, approaching 0.0).
        if (hasDateDividerBelow) {
          final t = clampDouble(
            (p.itemTrailingEdge - _fadeRange) / _fadeRange,
            0,
            1,
          );
          opacity = min(opacity, t);
        }
      }

      return opacity;
    }

    return 1;
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
