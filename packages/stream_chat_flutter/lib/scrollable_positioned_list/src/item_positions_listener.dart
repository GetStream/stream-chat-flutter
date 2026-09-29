// Copyright 2019 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'item_positions_notifier.dart';
import 'scrollable_positioned_list.dart';

/// Provides a listenable iterable of [itemPositions] of items that are on
/// screen and their locations.
abstract class ItemPositionsListener {
  /// Creates an [ItemPositionsListener] that can be used by a
  /// [ScrollablePositionedList] to return the current position of items.
  factory ItemPositionsListener.create() => ItemPositionsNotifier();

  /// The position of items that are at least partially visible in the viewport.
  ValueListenable<Iterable<ItemPosition>> get itemPositions;
}

/// Position information for an item in the list.
class ItemPosition {
  /// Create an [ItemPosition].
  const ItemPosition({
    required this.index,
    required this.itemLeadingEdge,
    required this.itemTrailingEdge,
    this.contentLeadingEdge,
    this.contentTrailingEdge,
  });

  /// Index of the item.
  final int index;

  /// Distance in proportion of the viewport's main axis length from the leading
  /// edge of the viewport to the leading edge of the item.
  ///
  /// May be negative if the item is partially visible.
  final double itemLeadingEdge;

  /// Distance in proportion of the viewport's main axis length from the leading
  /// edge of the viewport to the trailing edge of the item.
  ///
  /// May be greater than one if the item is partially visible.
  final double itemTrailingEdge;

  /// Distance in proportion of the visible content's main axis length from the
  /// leading edge of that content to the leading edge of the item.
  ///
  /// The visible content is the area inside the list's padding, so prefer this
  /// over [itemLeadingEdge] when positioning an overlay within that area.
  ///
  /// Equal to [itemLeadingEdge] when the list has no inset.
  final double? contentLeadingEdge;

  /// Distance in proportion of the visible content's main axis length from the
  /// leading edge of that content to the trailing edge of the item.
  ///
  /// See [contentLeadingEdge].
  final double? contentTrailingEdge;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemPosition &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          itemLeadingEdge == other.itemLeadingEdge &&
          itemTrailingEdge == other.itemTrailingEdge &&
          contentLeadingEdge == other.contentLeadingEdge &&
          contentTrailingEdge == other.contentTrailingEdge;

  @override
  int get hashCode => Object.hash(
    index,
    itemLeadingEdge,
    itemTrailingEdge,
    contentLeadingEdge,
    contentTrailingEdge,
  );

  @override
  String toString() =>
      '''ItemPosition(index: $index, itemLeadingEdge: $itemLeadingEdge, itemTrailingEdge: $itemTrailingEdge, contentLeadingEdge: $contentLeadingEdge, contentTrailingEdge: $contentTrailingEdge)''';
}
