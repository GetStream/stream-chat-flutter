import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../stream_chat_flutter.dart';
import '../misc/empty_widget.dart';
import 'mlv_utils.dart';

/// {@template floatingDateDivider}
/// A date divider pinned to the top of a [StreamMessageListView].
///
/// It labels the day of the message at the top of the visible content, and is
/// hidden while the top of the list is not a message. It fades out as an
/// inline date divider for a neighboring day reaches the top, unless
/// [fadeNearInlineDivider] is false.
///
/// Not intended for use outside of [StreamMessageListView].
/// {@endtemplate}
class FloatingDateDivider extends StatefulWidget {
  /// {@macro floatingDateDivider}
  const FloatingDateDivider({
    super.key,
    required this.itemPositionListener,
    required this.reverse,
    required this.messageAt,
    this.fadeNearInlineDivider = true,
    this.dateDividerBuilder,
  });

  /// The source of the list's item positions.
  ///
  /// The positions decide which message this divider labels.
  final ValueListenable<Iterable<ItemPosition>> itemPositionListener;

  /// Whether the list lays its items out from the bottom of the viewport up.
  final bool reverse;

  /// The lookup for the message shown by the list item at an index.
  ///
  /// Returns null for an item that is not a message, such as a loader.
  final Message? Function(int index) messageAt;

  /// Whether this divider fades out near an inline date divider.
  ///
  /// This divider fades as an inline date divider for a neighboring day
  /// reaches the top of the visible content.
  ///
  /// Defaults to true.
  final bool fadeNearInlineDivider;

  /// The builder for the date widget this divider shows.
  ///
  /// Called with the start of the day this divider labels.
  ///
  /// When null, a [StreamDateDivider] is shown.
  final Widget Function(DateTime)? dateDividerBuilder;

  @override
  State<FloatingDateDivider> createState() => _FloatingDateDividerState();
}

class _FloatingDateDividerState extends State<FloatingDateDivider> {
  // The fraction of the viewport over which this divider fades out.
  static const _fadeExtent = 0.05;

  // The day and opacity this divider shows, or null while it is hidden.
  ({DateTime day, double opacity})? _label;

  @override
  void initState() {
    super.initState();
    widget.itemPositionListener.addListener(_handlePositionsChanged);
    _label = _resolveLabel();
  }

  @override
  void didUpdateWidget(FloatingDateDivider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemPositionListener != oldWidget.itemPositionListener) {
      oldWidget.itemPositionListener.removeListener(_handlePositionsChanged);
      widget.itemPositionListener.addListener(_handlePositionsChanged);
    }
    _label = _resolveLabel();
  }

  // Rebuilds this divider when new positions change its label.
  //
  // The list republishes its positions after every frame it lays out, so
  // positions that only scroll a message of the same day to the top must not
  // rebuild it.
  void _handlePositionsChanged() {
    final label = _resolveLabel();
    if (label == _label) return;

    setState(() => _label = label);
  }

  // The label for the message at the top of the visible content.
  //
  // Null when the top of the list is not a message, or when an inline date
  // divider has hidden this one.
  ({DateTime day, double opacity})? _resolveLabel() {
    final position = _resolveTopPosition();
    if (position == null) return null;

    final message = widget.messageAt(position.index);
    if (message == null) return null;

    final day = _dayOf(message);
    if (!widget.fadeNearInlineDivider) return (day: day, opacity: 1.0);

    final opacity = _resolveOpacity(position, day: day);
    if (opacity <= 0.0) return null;

    return (day: day, opacity: opacity);
  }

  // The position of the item at the top of the visible content.
  //
  // Null when no laid-out item reaches it.
  ItemPosition? _resolveTopPosition() {
    final positions = widget.itemPositionListener.value;
    final index = switch (widget.reverse) {
      true => getBottomElementIndex(positions),
      false => getTopElementIndex(positions),
    };
    if (index == null) return null;

    return positions.firstWhere((position) => position.index == index);
  }

  // The opacity of this divider over the message at [position].
  //
  // An inline date divider sits above that message when it is the first of
  // its day, and below it when the next message starts a new day. This divider
  // fades out as either one comes within [_fadeExtent] of the content top.
  double _resolveOpacity(ItemPosition position, {required DateTime day}) {
    final index = position.index;
    final messageAbove = widget.messageAt(widget.reverse ? index + 1 : index - 1);
    final messageBelow = widget.messageAt(widget.reverse ? index - 1 : index + 1);

    // The oldest message of a reversed list has a date divider above it too.
    final hasDividerAbove = switch (messageAbove) {
      final above? => _dayOf(above) != day,
      null => widget.reverse,
    };
    final hasDividerBelow = switch (messageBelow) {
      final below? => _dayOf(below) != day,
      null => false,
    };

    final top = _topOf(position);
    final opacityAbove = hasDividerAbove && top > 0.0 ? _opacityAt(_fadeExtent - top) : 1.0;
    if (!hasDividerBelow) return opacityAbove;

    return math.min(opacityAbove, _opacityAt(_bottomOf(position) - _fadeExtent));
  }

  // The top edge of the item at [position].
  //
  // Measured as a fraction of the viewport, down from the top of the visible
  // content.
  double _topOf(ItemPosition position) {
    if (widget.reverse) return 1.0 - (position.contentTrailingEdge ?? position.itemTrailingEdge);
    return position.contentLeadingEdge ?? position.itemLeadingEdge;
  }

  // The bottom edge of the item at [position].
  //
  // Measured like [_topOf].
  double _bottomOf(ItemPosition position) {
    if (widget.reverse) return 1.0 - (position.contentLeadingEdge ?? position.itemLeadingEdge);
    return position.contentTrailingEdge ?? position.itemTrailingEdge;
  }

  // The start of the day [message] was sent, in local time.
  static DateTime _dayOf(Message message) {
    final createdAt = message.createdAt.toLocal();
    return DateTime(createdAt.year, createdAt.month, createdAt.day);
  }

  // The opacity for [distance] left before the fade ends.
  //
  // Opaque at [_fadeExtent] or more, and transparent at 0 or less.
  static double _opacityAt(double distance) => clampDouble(distance / _fadeExtent, 0, 1);

  @override
  Widget build(BuildContext context) {
    final label = _label;
    if (label == null) return const Empty();

    final divider = switch (widget.dateDividerBuilder) {
      final builder? => builder(label.day),
      _ => StreamDateDivider(dateTime: label.day),
    };

    return Opacity(opacity: label.opacity, child: divider);
  }

  @override
  void dispose() {
    widget.itemPositionListener.removeListener(_handlePositionsChanged);
    super.dispose();
  }
}
