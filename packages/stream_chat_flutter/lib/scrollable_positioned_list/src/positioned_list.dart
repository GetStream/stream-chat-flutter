// Copyright 2019 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:collection' show HashMap;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/element_registry.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/indexed_key.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/item_positions_listener.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/item_positions_notifier.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/scroll_view.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/wrapping.dart';

/// A list of widgets similar to [ListView], except scroll control
/// and position reporting is based on index rather than pixel offset.
///
/// [PositionedList] lays out children in the same way as [ListView].
///
/// The list can be displayed with the item at [positionIndex] positioned at a
/// particular [alignment].  See [ItemScrollController.jumpTo] for an
/// explanation of alignment.
///
/// All other parameters are the same as specified in [ListView].
class PositionedList extends StatefulWidget {
  /// Create a [PositionedList].
  const PositionedList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.itemKeyBuilder,
    this.controller,
    this.itemPositionsNotifier,
    this.positionedIndex = 0,
    this.alignment = 0,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
    this.cacheExtent,
    this.semanticChildCount,
    this.addSemanticIndexes = true,
    this.addRepaintBoundaries = true,
    this.addAutomaticKeepAlives = true,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  }) : assert(
          (positionedIndex == 0) || (positionedIndex < itemCount),
          'positionedIndex must be 0 or a value less than itemCount',
        );

  /// Number of items the [itemBuilder] can produce.
  final int itemCount;

  /// Called to build children for the list with
  /// 0 <= index < itemCount.
  final IndexedWidgetBuilder itemBuilder;

  /// If not null, called to build separators for between each item in the list.
  /// Called with 0 <= index < itemCount - 1.
  final IndexedWidgetBuilder? separatorBuilder;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  final ScrollController? controller;

  /// Notifier that reports the items laid out in the list after each frame.
  final ItemPositionsNotifier? itemPositionsNotifier;

  /// Index of an item to initially align to a position within the viewport
  /// defined by [alignment].
  final int positionedIndex;

  /// Determines where the leading edge of the item at [positionedIndex]
  /// should be placed.
  ///
  /// See [ItemScrollController.jumpTo] for an explanation of alignment.
  final double alignment;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether the view scrolls in the reading direction.
  ///
  /// Defaults to false.
  ///
  /// See [ScrollView.reverse].
  final bool reverse;

  /// {@template flutter.widgets.scroll_view.shrinkWrap}
  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  ///  Defaults to false.
  ///
  /// See [ScrollView.shrinkWrap].
  /// {@endtemplate}
  final bool shrinkWrap;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// See [ScrollView.physics].
  final ScrollPhysics? physics;

  /// {@macro flutter.widgets.scrollable.cacheExtent}
  final double? cacheExtent;

  /// The number of children that will contribute semantic information.
  ///
  /// See [ScrollView.semanticChildCount] for more information.
  final int? semanticChildCount;

  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// See [SliverChildBuilderDelegate.addSemanticIndexes].
  final bool addSemanticIndexes;

  /// The amount of space by which to inset the children.
  final EdgeInsets? padding;

  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// See [SliverChildBuilderDelegate.addRepaintBoundaries].
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// See [SliverChildBuilderDelegate.addAutomaticKeepAlives].
  final bool addAutomaticKeepAlives;

  /// Returns a stable identifier for the item at [index], or `null` for
  /// items that don't have one (headers, loaders, separators).
  ///
  /// When non-null, [PositionedList] wraps each item in a
  /// `KeyedSubtree(key: ValueKey(itemKeyBuilder(i)))` so the framework's
  /// reconciliation matches Elements across rebuilds by identity
  /// instead of by sliver-index position. It also provides each
  /// underlying sliver with a `findChildIndexCallback` derived from
  /// this map, so prepending or reordering items reuses existing
  /// Elements + State (animation controllers, video playback,
  /// expand/collapse state, etc.) rather than disposing and recreating
  /// them.
  final Object? Function(int index)? itemKeyBuilder;

  /// Defines how this [ScrollView] will dismiss the keyboard automatically.
  ///
  /// See [ScrollView.keyboardDismissBehavior].
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  State<StatefulWidget> createState() => _PositionedListState();
}

class _PositionedListState extends State<PositionedList> {
  final Key _centerKey = UniqueKey();

  final registeredElements = ValueNotifier<Set<Element>?>(null);
  late final ScrollController scrollController;

  bool updateScheduled = false;

  /// Reverse lookup from [PositionedList.itemKeyBuilder] results to the
  /// user-space index, used by the three per-sliver
  /// `findChildIndexCallback`s to answer Flutter's "which slot does this
  /// Key belong to?" question in O(1) so [SliverChildBuilderDelegate]
  /// can recycle the matching [Element] (and its [State]) instead of
  /// disposing and rebuilding it.
  ///
  /// Bounded to a sliding window around the first-visible item — see
  /// [_rebuildKeyIndexMap]. Items outside the window are "unknown" and
  /// the callback returns null for them (Flutter then builds a fresh
  /// element, same as if the key were missing entirely).
  ///
  /// Using a [HashMap] (rather than the `<Object, int>{}` literal,
  /// which builds a `LinkedHashMap`) drops the insertion-order metadata
  /// every entry would otherwise carry. Insertion order is irrelevant
  /// here — we only need O(1) get — so the lighter container is a
  /// strict win on both lookup speed and memory.
  ///
  /// The same instance is reused across rebuilds: each cache miss
  /// [Map.clear]s and refills, instead of allocating a fresh map and
  /// stranding the old one for the GC.
  final HashMap<Object, int> _keyToIndexMap = HashMap<Object, int>();

  /// The active map is bounded to a sliding window of items around the
  /// first-visible index, rather than the full [PositionedList.itemCount].
  /// The window's start is anchored at `windowSize * (firstVisible /
  /// windowSize)` and padded by `extraItemCount` on each side. Result:
  /// the active map holds ~230 entries regardless of total list length,
  /// and the window only relocates when the first-visible item crosses
  /// a `windowSize`-item bucket boundary — small scroll deltas don't
  /// invalidate the map.
  static const int _slidingWindowSize = 30;
  static const int _extraItemCount = 100;

  /// Sentinels for the most recently built map. `_cachedItemCount = -1`
  /// guarantees a build on first call.
  int _cachedItemCount = -1;
  int _cachedRangeStart = 0;
  int _cachedRangeEnd = 0;

  @override
  void initState() {
    super.initState();
    scrollController = widget.controller ?? ScrollController();
    scrollController.addListener(_schedulePositionNotificationUpdate);
    _schedulePositionNotificationUpdate();
  }

  @override
  void dispose() {
    scrollController.removeListener(_schedulePositionNotificationUpdate);
    super.dispose();
  }

  @override
  void didUpdateWidget(PositionedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _schedulePositionNotificationUpdate();
  }

  /// Returns the minimum user-index currently in view. Read from
  /// [PositionedList.itemPositionsNotifier] (which the SPL maintains
  /// post-layout). Defaults to 0 before the first layout completes.
  int _firstVisibleIndex() {
    final positions = widget.itemPositionsNotifier?.itemPositions.value;
    if (positions == null || positions.isEmpty) return 0;
    var minIdx = positions.first.index;
    for (final p in positions) {
      if (p.index < minIdx) minIdx = p.index;
    }
    return minIdx;
  }

  /// Builds (or reuses) the [_keyToIndexMap] for the current sliding
  /// window. Skips the rebuild when neither the window nor
  /// [PositionedList.itemCount] has changed — the common case for
  /// parent-driven rebuilds that don't touch the item set (theme
  /// switches, focus changes, etc.).
  void _rebuildKeyIndexMap() {
    final keyBuilder = widget.itemKeyBuilder;
    if (keyBuilder == null) {
      if (_keyToIndexMap.isNotEmpty) _keyToIndexMap.clear();
      _cachedItemCount = 0;
      _cachedRangeStart = 0;
      _cachedRangeEnd = 0;
      return;
    }

    // Sliding window anchored at a bucket boundary so scrolling within
    // a single bucket reuses the map; only crossings trigger relocation.
    final firstVisible = _firstVisibleIndex();
    final bucket = (firstVisible ~/ _slidingWindowSize) * _slidingWindowSize;
    final start = (bucket - _extraItemCount).clamp(0, widget.itemCount);
    final end = (bucket + _slidingWindowSize + _extraItemCount)
        .clamp(0, widget.itemCount);

    if (start == _cachedRangeStart &&
        end == _cachedRangeEnd &&
        widget.itemCount == _cachedItemCount) {
      return;
    }

    // Reuse the [HashMap] across rebuilds — clear and refill rather
    // than allocate a new instance per cache miss.
    _keyToIndexMap.clear();
    for (var i = start; i < end; i++) {
      final key = keyBuilder(i);
      if (key != null) _keyToIndexMap[key] = i;
    }
    _cachedRangeStart = start;
    _cachedRangeEnd = end;
    _cachedItemCount = widget.itemCount;
  }

  /// Extracts the user-space stable key from [key] and looks it up in
  /// [_keyToIndexMap]. Returns the user index, or `null` if not a known
  /// keyed item.
  ///
  /// Flutter passes us the unwrapped child key — the outermost we put on
  /// the item, which is the [IndexedKey] from [_buildItem]. We unwrap one
  /// more layer to get our [ValueKey] (when keyed via `itemKeyBuilder`).
  int? _userIndexFromKey(Key key) {
    Key? inner;
    if (key is IndexedKey) {
      inner = key.key;
    } else {
      inner = key;
    }
    if (inner is ValueKey) {
      final raw = inner.value;
      if (raw is Object) return _keyToIndexMap[raw];
    }
    return null;
  }

  /// `findChildIndexCallback` for the leading sliver. Items live in
  /// descending user-index order; with separators, items are at odd
  /// sliver-indices.
  int? _findLeadingIndex(Key key) {
    final userIndex = _userIndexFromKey(key);
    if (userIndex == null) return null;
    if (userIndex < 0 || userIndex >= widget.positionedIndex) return null;
    return widget.separatorBuilder == null
        ? widget.positionedIndex - userIndex - 1
        : (widget.positionedIndex - userIndex) * 2 - 1;
  }

  /// `findChildIndexCallback` for the center sliver. Holds exactly one
  /// child — the item at [PositionedList.positionedIndex].
  int? _findCenterIndex(Key key) {
    final userIndex = _userIndexFromKey(key);
    if (userIndex == null) return null;
    if (userIndex != widget.positionedIndex) return null;
    return 0;
  }

  /// `findChildIndexCallback` for the trailing sliver. Items live in
  /// ascending user-index order starting at `positionedIndex + 1`; with
  /// separators, items are at odd sliver-indices and the leading slot
  /// (sliver-index 0) is a separator.
  int? _findTrailingIndex(Key key) {
    final userIndex = _userIndexFromKey(key);
    if (userIndex == null) return null;
    if (userIndex <= widget.positionedIndex || userIndex >= widget.itemCount)
      return null;
    return widget.separatorBuilder == null
        ? userIndex - widget.positionedIndex - 1
        : (userIndex - widget.positionedIndex) * 2 - 1;
  }

  @override
  Widget build(BuildContext context) {
    _rebuildKeyIndexMap();
    return RegistryWidget(
      elementNotifier: registeredElements,
      child: UnboundedCustomScrollView(
        anchor: widget.alignment,
        center: _centerKey,
        controller: scrollController,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        cacheExtent: widget.cacheExtent,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        semanticChildCount: widget.semanticChildCount ?? widget.itemCount,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        slivers: <Widget>[
          if (widget.positionedIndex > 0)
            SliverPadding(
              padding: _leadingSliverPadding,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => widget.separatorBuilder == null
                      ? _buildItem(widget.positionedIndex - (index + 1))
                      : _buildSeparatedListElement(
                          widget.positionedIndex * 2 - (index + 1),
                        ),
                  childCount: widget.separatorBuilder == null
                      ? widget.positionedIndex
                      : widget.positionedIndex * 2,
                  addSemanticIndexes: false,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  findChildIndexCallback: _findLeadingIndex,
                ),
              ),
            ),
          SliverPadding(
            key: _centerKey,
            padding: _centerSliverPadding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => widget.separatorBuilder == null
                    ? _buildItem(index + widget.positionedIndex)
                    : _buildSeparatedListElement(
                        index + widget.positionedIndex * 2,
                      ),
                childCount: widget.itemCount != 0 ? 1 : 0,
                addSemanticIndexes: false,
                addRepaintBoundaries: widget.addRepaintBoundaries,
                addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                findChildIndexCallback: _findCenterIndex,
              ),
            ),
          ),
          if (widget.positionedIndex >= 0 &&
              widget.positionedIndex < widget.itemCount - 1)
            SliverPadding(
              padding: _trailingSliverPadding,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => widget.separatorBuilder == null
                      ? _buildItem(index + widget.positionedIndex + 1)
                      : _buildSeparatedListElement(
                          index + widget.positionedIndex * 2 + 1,
                        ),
                  childCount: widget.separatorBuilder == null
                      ? widget.itemCount - widget.positionedIndex - 1
                      : 2 * (widget.itemCount - widget.positionedIndex - 1),
                  addSemanticIndexes: false,
                  addRepaintBoundaries: widget.addRepaintBoundaries,
                  addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                  findChildIndexCallback: _findTrailingIndex,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSeparatedListElement(int index) {
    if (index.isEven) {
      return _buildItem(index ~/ 2);
    } else {
      return widget.separatorBuilder!(context, index ~/ 2);
    }
  }

  Widget _buildItem(int index) {
    final builtChild = widget.itemBuilder(context, index);

    // When `itemKeyBuilder` is provided, assign a stable framework Key derived
    // from it. The resulting [IndexedKey] delegates `==` to this inner
    // [ValueKey], so the framework's reconciliation reuses the existing
    // [Element] when an item shifts position — preserving its [State]
    // (animation controllers, video playback, expand/collapse, etc.).
    //
    // Falls back to the user's own widget key when `itemKeyBuilder` returns
    // null (e.g. headers, loaders, separators that don't need
    // cross-rebuild identity).
    final stableKey = widget.itemKeyBuilder?.call(index);
    final child = stableKey != null
        ? KeyedSubtree(key: ValueKey<Object>(stableKey), child: builtChild)
        : builtChild;

    return RegisteredElementWidget(
      key: IndexedKey(child.key, index),
      child: widget.addSemanticIndexes
          ? IndexedSemantics(index: index, child: child)
          : child,
    );
  }

  EdgeInsets get _leadingSliverPadding =>
      (widget.scrollDirection == Axis.vertical
          ? widget.reverse
              ? widget.padding?.copyWith(top: 0)
              : widget.padding?.copyWith(bottom: 0)
          : widget.reverse
              ? widget.padding?.copyWith(left: 0)
              : widget.padding?.copyWith(right: 0)) ??
      EdgeInsets.zero;

  EdgeInsets get _centerSliverPadding => widget.scrollDirection == Axis.vertical
      ? widget.reverse
          ? widget.padding?.copyWith(
                top: widget.positionedIndex == widget.itemCount - 1
                    ? widget.padding!.top
                    : 0,
                bottom:
                    widget.positionedIndex == 0 ? widget.padding!.bottom : 0,
              ) ??
              EdgeInsets.zero
          : widget.padding?.copyWith(
                top: widget.positionedIndex == 0 ? widget.padding!.top : 0,
                bottom: widget.positionedIndex == widget.itemCount - 1
                    ? widget.padding!.bottom
                    : 0,
              ) ??
              EdgeInsets.zero
      : widget.reverse
          ? widget.padding?.copyWith(
                left: widget.positionedIndex == widget.itemCount - 1
                    ? widget.padding!.left
                    : 0,
                right: widget.positionedIndex == 0 ? widget.padding!.right : 0,
              ) ??
              EdgeInsets.zero
          : widget.padding?.copyWith(
                left: widget.positionedIndex == 0 ? widget.padding!.left : 0,
                right: widget.positionedIndex == widget.itemCount - 1
                    ? widget.padding!.right
                    : 0,
              ) ??
              EdgeInsets.zero;

  EdgeInsets get _trailingSliverPadding =>
      widget.scrollDirection == Axis.vertical
          ? widget.reverse
              ? widget.padding?.copyWith(bottom: 0) ?? EdgeInsets.zero
              : widget.padding?.copyWith(top: 0) ?? EdgeInsets.zero
          : widget.reverse
              ? widget.padding?.copyWith(right: 0) ?? EdgeInsets.zero
              : widget.padding?.copyWith(left: 0) ?? EdgeInsets.zero;

  void _schedulePositionNotificationUpdate() {
    if (!updateScheduled) {
      updateScheduled = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final elements = registeredElements.value;
        if (elements == null) {
          updateScheduled = false;
          return;
        }
        final positions = <ItemPosition>[];
        RenderViewportBase? viewport;
        for (final element in elements) {
          final box = element.renderObject! as RenderBox;
          viewport ??= RenderAbstractViewport.of(box) as RenderViewportBase?;
          var anchor = 0.0;
          if (viewport is RenderViewport) {
            anchor = viewport.anchor;
          }

          if (viewport is CustomRenderViewport) {
            anchor = viewport.anchor;
          }

          final key = element.widget.key! as IndexedKey;
          // Skip this element if `box` has never been laid out, isn't
          // currently attached to the viewport's render tree, or sits in
          // a sliver that doesn't have a current scroll offset for it.
          //
          // The third case is the subtle one: a [RenderBox] can be
          // [attached] (alive in the pipeline) yet not part of its
          // parent sliver's live children — e.g. when it's kept alive but
          // sits outside the cache extent, or transiently during a
          // sliver reorganization triggered by anchor preservation. In
          // that state [RenderSliver.childScrollOffset] returns `null`,
          // and Flutter's [RenderViewportBase.getOffsetToReveal] asserts
          // non-null on the result. Guard with try/catch so a transient
          // unreachable child doesn't kill the entire position update;
          // the next layout will surface them.
          if (!box.hasSize) continue;
          if (!box.attached) continue;
          try {
            if (widget.scrollDirection == Axis.vertical) {
              final reveal = viewport!.getOffsetToReveal(box, 0).offset;
              if (!reveal.isFinite) continue;
              final itemOffset = reveal -
                  viewport.offset.pixels +
                  anchor * viewport.size.height;
              positions.add(ItemPosition(
                index: key.index,
                itemLeadingEdge: itemOffset.round() /
                    scrollController.position.viewportDimension,
                itemTrailingEdge: (itemOffset + box.size.height).round() /
                    scrollController.position.viewportDimension,
              ));
            } else {
              final itemOffset =
                  box.localToGlobal(Offset.zero, ancestor: viewport).dx;
              if (!itemOffset.isFinite) continue;
              positions.add(ItemPosition(
                index: key.index,
                itemLeadingEdge: (widget.reverse
                            ? scrollController.position.viewportDimension -
                                (itemOffset + box.size.width)
                            : itemOffset)
                        .round() /
                    scrollController.position.viewportDimension,
                itemTrailingEdge: (widget.reverse
                            ? scrollController.position.viewportDimension -
                                itemOffset
                            : (itemOffset + box.size.width))
                        .round() /
                    scrollController.position.viewportDimension,
              ));
            }
          } on TypeError catch (_) {
            // Specifically the null-check failure inside
            // `getOffsetToReveal` → `childScrollOffset` described above.
            // Narrowed to `TypeError` so any other genuine bug still
            // surfaces.
            continue;
          }
        }
        widget.itemPositionsNotifier?.itemPositions.value = positions;
        updateScheduled = false;
      });
    }
  }
}
