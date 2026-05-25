// Copyright 2019 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/item_positions_listener.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/item_positions_notifier.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/positioned_list.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/post_mount_callback.dart';

/// Number of screens to scroll when scrolling a long distance.
const int _screenScrollCount = 2;

/// A scrollable list of widgets similar to [ListView], except scroll control
/// and position reporting is based on index rather than pixel offset.
///
/// [ScrollablePositionedList] lays out children in the same way as [ListView].
///
/// The list can be displayed with the item at [initialScrollIndex] positioned
/// at a particular [initialAlignment].
///
/// The [itemScrollController] can be used to scroll or jump to particular items
/// in the list.  The [itemPositionsNotifier] can be used to get a list of items
/// currently laid out by the list.
///
/// All other parameters are the same as specified in [ListView].
class ScrollablePositionedList extends StatefulWidget {
  /// Create a [ScrollablePositionedList] whose items are provided by
  /// [itemBuilder].
  const ScrollablePositionedList.builder({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.itemKeyBuilder,
    this.itemScrollController,
    this.shrinkWrap = false,
    ItemPositionsListener? itemPositionsListener,
    this.initialScrollIndex = 0,
    this.initialAlignment = 0,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.physics,
    this.semanticChildCount,
    this.padding,
    this.addSemanticIndexes = true,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.minCacheExtent,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  }) : itemPositionsNotifier = itemPositionsListener as ItemPositionsNotifier?,
       separatorBuilder = null;

  /// Create a [ScrollablePositionedList] whose items are provided by
  /// [itemBuilder] and separators provided by [separatorBuilder].
  const ScrollablePositionedList.separated({
    required this.itemCount,
    required this.itemBuilder,
    required IndexedWidgetBuilder this.separatorBuilder,
    super.key,
    this.itemKeyBuilder,
    this.itemScrollController,
    this.shrinkWrap = false,
    ItemPositionsListener? itemPositionsListener,
    this.initialScrollIndex = 0,
    this.initialAlignment = 0,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.physics,
    this.semanticChildCount,
    this.padding,
    this.addSemanticIndexes = true,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.minCacheExtent,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  }) : itemPositionsNotifier = itemPositionsListener as ItemPositionsNotifier?;

  /// Number of items the [itemBuilder] can produce.
  final int itemCount;

  /// Called to build children for the list with
  /// 0 <= index < itemCount.
  final IndexedWidgetBuilder itemBuilder;

  /// Called to build separators for between each item in the list.
  /// Called with 0 <= index < itemCount - 1.
  final IndexedWidgetBuilder? separatorBuilder;

  /// Controller for jumping or scrolling to an item.
  final ItemScrollController? itemScrollController;

  /// Notifier that reports the items laid out in the list after each frame.
  final ItemPositionsNotifier? itemPositionsNotifier;

  /// Index of an item to initially align within the viewport.
  final int initialScrollIndex;

  /// Determines where the leading edge of the item at [initialScrollIndex]
  /// should be placed.
  ///
  /// See [ItemScrollController.jumpTo] for an explanation of alignment.
  final double initialAlignment;

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

  /// The number of children that will contribute semantic information.
  ///
  /// See [ScrollView.semanticChildCount] for more information.
  final int? semanticChildCount;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// See [SliverChildBuilderDelegate.addSemanticIndexes].
  final bool addSemanticIndexes;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// See [SliverChildBuilderDelegate.addAutomaticKeepAlives].
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// See [SliverChildBuilderDelegate.addRepaintBoundaries].
  final bool addRepaintBoundaries;

  /// The minimum cache extent used by the underlying scroll lists.
  /// See [ScrollView.cacheExtent].
  ///
  /// Note that the [ScrollablePositionedList] uses two lists to simulate long
  /// scrolls, so using the [ScrollController.scrollTo] method may result
  /// in builds of widgets that would otherwise already be built in the
  /// cache extent.
  final double? minCacheExtent;

  /// Optional stable identifier for the item at [index].
  ///
  /// When non-null, [ScrollablePositionedList] uses the key for two
  /// things:
  ///
  /// * **Anchor preservation.** The list tracks the key of the visually
  ///   topmost item; if that key ends up at a different index in the
  ///   next build, the internal scroll target is updated so the same
  ///   content stays at the same screen position — no remount, no
  ///   flicker, no separate scroll animation.
  ///
  /// * **Element reuse.** The keyed item's [Element] (and its
  ///   [State]) is reused across rebuilds when it shifts position,
  ///   preserving things like animation controllers, video playback,
  ///   and expand/collapse state.
  ///
  /// Return `null` for items that don't have a meaningful stable
  /// identity (e.g. headers, footers, loaders).
  final Object? Function(int index)? itemKeyBuilder;

  /// Defines how this [ScrollView] will dismiss the keyboard automatically.
  ///
  /// See [ScrollView.keyboardDismissBehavior].
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  State<StatefulWidget> createState() => _ScrollablePositionedListState();
}

const Curve _kDefaultScrollCurve = Curves.fastOutSlowIn;
const Duration _kDefaultScrollDuration = Duration(milliseconds: 400);

/// Controller to jump or scroll to a particular position in a
/// [ScrollablePositionedList].
class ItemScrollController {
  /// Whether any ScrollablePositionedList objects are attached this object.
  ///
  /// If `false`, then [jumpTo] and [scrollTo] must not be called.
  bool get isAttached => _scrollableListState != null;

  /// Whether the underlying scrollable is currently in motion — a
  /// user drag, ballistic activity following a drag, or an in-flight
  /// programmatic [scrollTo] animation. Mirrors Compose's
  /// `LazyListState.isScrollInProgress` 1:1.
  ///
  /// Returns `false` while the controller is unattached or before the
  /// underlying [ScrollPosition] has been laid out for the first
  /// time. Safe to read synchronously from event handlers.
  bool get isScrolling => _scrollableListState?._isScrolling ?? false;

  /// [Listenable] that notifies whenever [isScrolling] flips. Useful
  /// for callers that want to react to scroll-state transitions
  /// (e.g. "re-enable auto-scroll once the user's gesture has
  /// settled"); reading the bool synchronously via [isScrolling] is
  /// enough for one-shot checks at the moment an event fires.
  ///
  /// Returns a no-op listenable while the controller is unattached,
  /// so callers can register a listener at any time without a null
  /// check.
  Listenable get isScrollingListenable => _scrollableListState?._isScrollingListenable ?? const _NoopListenable();

  _ScrollablePositionedListState? _scrollableListState;

  /// Immediately, without animation, reconfigure the list so that the item at
  /// [index]'s leading edge is at the given [alignment].
  ///
  /// The [alignment] specifies the desired position for the leading edge of the
  /// item.  The [alignment] is expected to be a value in the range \[0.0, 1.0\]
  /// and represents a proportion along the main axis of the viewport.
  ///
  /// For a vertically scrolling view that is not reversed:
  /// * 0 aligns the top edge of the item with the top edge of the view.
  /// * 1 aligns the top edge of the item with the bottom of the view.
  /// * 0.5 aligns the top edge of the item with the center of the view.
  ///
  /// For a horizontally scrolling view that is not reversed:
  /// * 0 aligns the left edge of the item with the left edge of the view
  /// * 1 aligns the left edge of the item with the right edge of the view.
  /// * 0.5 aligns the left edge of the item with the center of the view.
  void jumpTo({required int index, double alignment = 0}) {
    _scrollableListState!._jumpTo(index: index, alignment: alignment);
  }

  /// Animate the list over [duration] using the given [curve] such that the
  /// item at [index] ends up with its leading edge at the given [alignment].
  /// See [jumpTo] for an explanation of alignment.
  ///
  /// The [duration] must be greater than 0; otherwise, use [jumpTo].
  ///
  /// When item position is not available, because it's too far, the scroll
  /// is composed into three phases:
  ///
  ///  1. The currently displayed list view starts scrolling.
  ///  2. Another list view, which scrolls with the same speed, fades over the
  ///     first one and shows items that are close to the scroll target.
  ///  3. The second list view scrolls and stops on the target.
  ///
  /// The [opacityAnimationWeights] can be used to apply custom weights to these
  /// three stages of this animation. The default weights, `[40, 20, 40]`, are
  /// good with default [Curves.linear].  Different weights might be better for
  /// other cases.  For example, if you use [Curves.easeOut], consider setting
  /// [opacityAnimationWeights] to `[20, 20, 60]`.
  ///
  /// See [TweenSequenceItem.weight] for more info.
  Future<void> scrollTo({
    required int index,
    double alignment = 0,
    Duration duration = _kDefaultScrollDuration,
    Curve curve = _kDefaultScrollCurve,
    List<double> opacityAnimationWeights = const [40, 20, 40],
  }) {
    assert(
      _scrollableListState != null,
      '''ScrollController must be attached to a ScrollablePositionedList to scroll.''',
    );
    assert(
      opacityAnimationWeights.length == 3,
      'opacityAnimationWeights must have exactly three elements.',
    );
    assert(duration > Duration.zero, 'Duration must be greater than zero.');
    return _scrollableListState!._scrollTo(
      index: index,
      alignment: alignment,
      duration: duration,
      curve: curve,
      opacityAnimationWeights: opacityAnimationWeights,
    );
  }

  void _attach(_ScrollablePositionedListState scrollableListState) {
    assert(
      _scrollableListState == null,
      '''ScrollController must not be attached to multiple ScrollablePositionedLists.''',
    );
    _scrollableListState = scrollableListState;
  }

  void _detach() {
    _scrollableListState = null;
  }
}

class _ScrollablePositionedListState extends State<ScrollablePositionedList> with TickerProviderStateMixin {
  /// Details for the primary (active) [ListView].
  _ListDisplayDetails primary = _ListDisplayDetails(const ValueKey('Ping'));

  /// Details for the secondary (transitional) [ListView] that is temporarily
  /// shown when scrolling a long distance.
  _ListDisplayDetails secondary = _ListDisplayDetails(const ValueKey('Pong'));

  final opacity = ProxyAnimation(const AlwaysStoppedAnimation<double>(0));

  void Function() startAnimationCallback = () {};

  bool _isTransitioning = false;

  AnimationController? _animationController;

  // --- Anchor preservation snapshot ---------------------------------
  //
  // These four fields together describe "where the first visible item
  // was at the end of the last layout." They're captured by
  // [_updatePositions] every time the position-listener fires, and
  // read by [_updateFirstVisibleItemIfNeeded] when [didUpdateWidget]
  // sees the item count change. Together they implement the same
  // behaviour that Compose's `LazyListState` does internally: when
  // items are prepended/removed, the SPL re-targets so the same
  // content stays at the same screen position.
  //
  // Cleared by [_jumpTo] and [_scrollTo] so anchor preservation gets
  // out of the way of an explicit position change. The next
  // [_updatePositions] tick captures a fresh snapshot at the new
  // position.

  /// Identity of the topmost visible item at the end of the most
  /// recent layout. `null` before the first layout, after an explicit
  /// jump/scroll, or when the topmost item has no [itemKeyBuilder]
  /// key.
  Object? _lastKnownFirstItemKey;

  /// Index of the topmost visible item at the end of the most recent
  /// layout. Used as the fallback re-target when
  /// [_lastKnownFirstItemKey] can't be found in the current item list
  /// (i.e. the item it pointed at was removed) — whatever is at this
  /// index in the new list becomes the new first visible, producing
  /// the natural "slide up to fill" feel after a deletion.
  int _lastKnownFirstItemIndex = 0;

  /// `itemLeadingEdge` fraction of the topmost visible item at the end
  /// of the most recent layout. Reapplied to [primary.alignment] in
  /// the reanchor so the saved item lands at the same screen fraction
  /// in the next layout.
  double _firstVisibleItemAlignment = 0;

  /// `primary.scrollController.position.pixels` at the time
  /// [_firstVisibleItemAlignment] was recorded. The reanchor folds
  /// `(currentPixels − this) / viewport` into the alignment so drag
  /// and fling deltas accumulated since the last settled layout are
  /// reflected in the new alignment — i.e. the user's in-progress
  /// gesture survives an item-count change without snapping back.
  double _firstVisibleItemAlignmentAtPixels = 0;

  /// Aggregates the underlying [ScrollPosition.isScrollingNotifier] of
  /// the active controller into a stable [Listenable] that survives
  /// the primary/secondary swap on a long-distance `scrollTo`.
  ///
  /// Surfaced publicly via [ItemScrollController.isScrolling] and
  /// [ItemScrollController.isScrollingListenable] so consumers can
  /// reach Compose's `isScrollInProgress` semantics without listening
  /// to bubbling scroll notifications.
  final ValueNotifier<bool> _isScrollingListenable = ValueNotifier(false);
  bool get _isScrolling => _isScrollingListenable.value;

  /// The [ScrollPosition.isScrollingNotifier] we're currently
  /// subscribed to. Tracked so we can detach when the position or
  /// primary controller changes.
  ValueListenable<bool>? _subscribedScrollingNotifier;

  @override
  void initState() {
    super.initState();
    final initialPosition = PageStorage.of(context).readState(context);
    primary
      ..target = initialPosition?.index ?? widget.initialScrollIndex
      ..alignment = initialPosition?.itemLeadingEdge ?? widget.initialAlignment;
    if (widget.itemCount > 0 && primary.target > widget.itemCount - 1) {
      primary.target = widget.itemCount - 1;
    }
    widget.itemScrollController?._attach(this);
    primary.itemPositionsNotifier.itemPositions.addListener(_updatePositions);
    secondary.itemPositionsNotifier.itemPositions.addListener(_updatePositions);
    // The primary controller doesn't attach to its `ScrollPosition`
    // until the first build; defer the isScrolling subscription until
    // a position exists.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bindIsScrollingNotifier();
    });
  }

  /// (Re)subscribe to the current primary controller's
  /// `isScrollingNotifier`. Called on first frame and on
  /// primary/secondary swap.
  void _bindIsScrollingNotifier() {
    if (!mounted) return;
    final controller = primary.scrollController;
    if (!controller.hasClients) return;
    final newNotifier = controller.position.isScrollingNotifier;
    if (identical(newNotifier, _subscribedScrollingNotifier)) return;
    _subscribedScrollingNotifier?.removeListener(_onIsScrollingChanged);
    _subscribedScrollingNotifier = newNotifier;
    _subscribedScrollingNotifier!.addListener(_onIsScrollingChanged);
    _onIsScrollingChanged();
  }

  void _onIsScrollingChanged() {
    final value = _subscribedScrollingNotifier?.value ?? false;
    if (_isScrollingListenable.value != value) {
      _isScrollingListenable.value = value;
    }
  }

  @override
  void deactivate() {
    widget.itemScrollController?._detach();
    super.deactivate();
  }

  @override
  void dispose() {
    primary.itemPositionsNotifier.itemPositions.removeListener(_updatePositions);
    secondary.itemPositionsNotifier.itemPositions.removeListener(_updatePositions);
    _subscribedScrollingNotifier?.removeListener(_onIsScrollingChanged);
    _isScrollingListenable.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ScrollablePositionedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemScrollController?._scrollableListState == this) {
      oldWidget.itemScrollController?._detach();
    }
    if (widget.itemScrollController?._scrollableListState != this) {
      widget.itemScrollController?._detach();
      widget.itemScrollController?._attach(this);
    }

    if (widget.itemCount == 0) {
      primary.target = 0;
      secondary.target = 0;
    } else {
      if (primary.target > widget.itemCount - 1) {
        primary.target = widget.itemCount - 1;
      }
      if (secondary.target > widget.itemCount - 1) {
        secondary.target = widget.itemCount - 1;
      }
      // Anchor preservation. Only fires when the item set actually
      // changed (different count), so it doesn't interfere with
      // ordinary user scrolling on rebuilds that don't touch the list.
      if (widget.itemCount != oldWidget.itemCount) {
        _updateFirstVisibleItemIfNeeded();
      }
    }
  }

  /// Looks up the new index of [_lastKnownFirstItemKey] in the current
  /// item list. Falls back to [_lastKnownFirstItemIndex] when the key is
  /// no longer present so the slot vacated by the removed item is taken
  /// by whatever item is at that numerical position now — the natural
  /// "slide up to fill" behaviour after a deletion.
  ///
  /// Callers must ensure [_lastKnownFirstItemKey] is non-null and
  /// `widget.itemCount > 0`; see [_updateFirstVisibleItemIfNeeded].
  int _findFirstVisibleItemIndex(Object? Function(int) keyBuilder) {
    final savedKey = _lastKnownFirstItemKey!;
    final savedIndex = _lastKnownFirstItemIndex;
    // Fast path: same key still at the same index. Skips the O(N) scan
    // in the common case where items haven't shifted.
    if (savedIndex < widget.itemCount && keyBuilder(savedIndex) == savedKey) {
      return savedIndex;
    }
    // Full key→index scan.
    for (var i = 0; i < widget.itemCount; i++) {
      if (keyBuilder(i) == savedKey) return i;
    }
    // Key is gone — preserve the index slot.
    return savedIndex.clamp(0, widget.itemCount - 1);
  }

  /// Re-targets the list so the previously topmost visible item stays at
  /// the same screen position after the list mutates — even mid-gesture,
  /// when the user has dragged or flung past the point
  /// [_updatePositions] last captured.
  ///
  /// When the saved key is still present the anchor moves with it. When
  /// the key is gone the saved index is preserved; whatever item is now
  /// at that index becomes the new first visible, which produces a
  /// natural slide-up effect after a deletion.
  ///
  /// Two adjustments that the [PositionedList] (target + alignment +
  /// pixels) layout model requires on top of the index lookup:
  ///
  /// 1. The saved alignment corresponds to
  ///    [_firstVisibleItemAlignmentAtPixels]. If the user has dragged
  ///    since, [primary.scrollController.position.pixels] has moved but
  ///    the saved alignment has not. We fold the pixel delta into the
  ///    alignment so the new value reflects what the user *currently*
  ///    sees — drag and fling deltas included. Without this every
  ///    reanchor would silently revert the user's in-progress scroll
  ///    and the list would feel locked in place.
  ///
  /// 2. The scroll offset is brought to zero via
  ///    [ScrollPosition.correctBy], not [ScrollController.jumpTo].
  ///    `correctBy` mutates `pixels` directly without firing `goIdle()`
  ///    or dispatching scroll notifications, so an in-flight
  ///    `DragScrollActivity` or `BallisticScrollActivity` keeps
  ///    integrating its delta against the new baseline instead of
  ///    being cancelled.
  void _updateFirstVisibleItemIfNeeded() {
    final keyBuilder = widget.itemKeyBuilder;
    if (keyBuilder == null || _lastKnownFirstItemKey == null) return;

    final newIndex = _findFirstVisibleItemIndex(keyBuilder);

    final hasClients = primary.scrollController.hasClients;
    final position = hasClients ? primary.scrollController.position : null;
    final pixels = position?.pixels ?? 0.0;
    final viewport = position?.viewportDimension ?? 0.0;
    final pixelDelta = pixels - _firstVisibleItemAlignmentAtPixels;
    final currentAlignment = viewport > 0
        ? _firstVisibleItemAlignment - pixelDelta / viewport
        : _firstVisibleItemAlignment;

    if (newIndex == primary.target && primary.alignment == currentAlignment && pixels == 0) {
      return;
    }
    primary
      ..target = newIndex
      ..alignment = currentAlignment;
    if (hasClients && pixels != 0) {
      position!.correctBy(-pixels);
    }
    // The reanchor itself moves the pixel baseline to 0; record that
    // alongside the (now-applied) anchor so subsequent reanchors that
    // fire before the next layout compute deltas against the right
    // starting point.
    _firstVisibleItemAlignmentAtPixels = 0;
    _lastKnownFirstItemIndex = newIndex;
    _firstVisibleItemAlignment = currentAlignment;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cacheExtent = _cacheExtent(constraints);
        return GestureDetector(
          onPanDown: (_) => _stopScroll(canceled: true),
          excludeFromSemantics: true,
          child: Stack(
            children: <Widget>[
              PostMountCallback(
                key: primary.key,
                callback: startAnimationCallback,
                child: FadeTransition(
                  opacity: ReverseAnimation(opacity),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (_) => _isTransitioning,
                    child: PositionedList(
                      itemBuilder: widget.itemBuilder,
                      separatorBuilder: widget.separatorBuilder,
                      itemCount: widget.itemCount,
                      positionedIndex: primary.target,
                      controller: primary.scrollController,
                      itemPositionsNotifier: primary.itemPositionsNotifier,
                      scrollDirection: widget.scrollDirection,
                      reverse: widget.reverse,
                      cacheExtent: cacheExtent,
                      alignment: primary.alignment,
                      physics: widget.physics,
                      shrinkWrap: widget.shrinkWrap,
                      addSemanticIndexes: widget.addSemanticIndexes,
                      semanticChildCount: widget.semanticChildCount,
                      padding: widget.padding,
                      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                      addRepaintBoundaries: widget.addRepaintBoundaries,
                      itemKeyBuilder: widget.itemKeyBuilder,
                      keyboardDismissBehavior: widget.keyboardDismissBehavior,
                    ),
                  ),
                ),
              ),
              if (_isTransitioning)
                PostMountCallback(
                  key: secondary.key,
                  callback: startAnimationCallback,
                  child: FadeTransition(
                    opacity: opacity,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (_) => false,
                      child: PositionedList(
                        itemBuilder: widget.itemBuilder,
                        separatorBuilder: widget.separatorBuilder,
                        itemCount: widget.itemCount,
                        itemPositionsNotifier: secondary.itemPositionsNotifier,
                        positionedIndex: secondary.target,
                        controller: secondary.scrollController,
                        scrollDirection: widget.scrollDirection,
                        reverse: widget.reverse,
                        cacheExtent: cacheExtent,
                        alignment: secondary.alignment,
                        physics: widget.physics,
                        shrinkWrap: widget.shrinkWrap,
                        addSemanticIndexes: widget.addSemanticIndexes,
                        semanticChildCount: widget.semanticChildCount,
                        padding: widget.padding,
                        addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                        addRepaintBoundaries: widget.addRepaintBoundaries,
                        itemKeyBuilder: widget.itemKeyBuilder,
                        keyboardDismissBehavior: widget.keyboardDismissBehavior,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  double _cacheExtent(BoxConstraints constraints) => max(
    (widget.scrollDirection == Axis.vertical ? constraints.maxHeight : constraints.maxWidth) * _screenScrollCount,
    widget.minCacheExtent ?? 0,
  );

  /// Pixels of [widget.padding] on the leading side of the scroll
  /// axis. Direction-aware: resolves [EdgeInsetsDirectional] against
  /// [Directionality] for horizontal axes.
  double _resolveLeadingPadding() {
    final geometry = widget.padding;
    if (geometry == null) return 0;
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final resolved = geometry.resolve(textDirection);
    if (widget.scrollDirection == Axis.vertical) {
      return widget.reverse ? resolved.bottom : resolved.top;
    }
    final axisDirectionIsRight = (textDirection == TextDirection.ltr) ^ widget.reverse;
    return axisDirectionIsRight ? resolved.left : resolved.right;
  }

  /// Adjustment for `_startScroll`'s target so the leading-end item
  /// lands at the content-area edge (Compose semantic). Only applies
  /// when the center sliver carries the leading padding — for other
  /// indices SPL's pre-existing math is preserved.
  double _resolveLeadingEndPaddingAdjust({required int index, required double alignment}) {
    if (alignment != 0) return 0;
    final isAtLeadingEnd = widget.reverse ? index == 0 : index == widget.itemCount - 1;
    if (!isAtLeadingEnd) return 0;
    return _resolveLeadingPadding();
  }

  void _jumpTo({required int index, required double alignment}) {
    _stopScroll(canceled: true);
    if (index > widget.itemCount - 1) {
      index = widget.itemCount - 1;
    }
    // Invalidate the anchor-preservation snapshot. Otherwise any
    // `didUpdateWidget` racing in between this jump and the next
    // position-listener tick (very common when items are arriving at
    // ≥50/s, since the listener can't tick faster than the frame rate)
    // would call `_updateFirstVisibleItemIfNeeded`, read the stale
    // bookmark, and overwrite the target we just set. With the key
    // cleared, that path early-returns; the next layout's
    // `_updatePositions` will capture fresh state.
    _lastKnownFirstItemKey = null;
    setState(() {
      primary.scrollController.jumpTo(0);
      primary
        ..target = index
        ..alignment = alignment;
    });
  }

  Future<void> _scrollTo({
    required int index,
    required double alignment,
    required Duration duration,
    Curve curve = Curves.linear,
    required List<double> opacityAnimationWeights,
  }) async {
    if (index > widget.itemCount - 1) {
      index = widget.itemCount - 1;
    }
    // Invalidate the anchor-preservation snapshot for the same reason
    // as in [_jumpTo]: an explicit scroll is the user (or app)
    // overriding the implicit anchor, so the saved "topmost" key from
    // the previous layout is no longer meaningful. Without this, an
    // incoming `didUpdateWidget` mid-animation (or right after it
    // finishes) would call `_updateFirstVisibleItemIfNeeded`, read
    // the stale key, and yank the target back to wherever the old
    // anchor lived. The next [_updatePositions] tick after the scroll
    // settles will capture fresh state.
    _lastKnownFirstItemKey = null;
    if (_isTransitioning) {
      final scrollCompleter = Completer<void>();
      _stopScroll(canceled: true);
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await _startScroll(
          index: index,
          alignment: alignment,
          duration: duration,
          curve: curve,
          opacityAnimationWeights: opacityAnimationWeights,
        );
        scrollCompleter.complete();
      });
      await scrollCompleter.future;
    } else {
      await _startScroll(
        index: index,
        alignment: alignment,
        duration: duration,
        curve: curve,
        opacityAnimationWeights: opacityAnimationWeights,
      );
    }
  }

  Future<void> _startScroll({
    required int index,
    required double alignment,
    required Duration duration,
    Curve curve = Curves.linear,
    required List<double> opacityAnimationWeights,
  }) async {
    final direction = index > primary.target ? 1 : -1;
    final itemPosition = primary.itemPositionsNotifier.itemPositions.value.firstWhereOrNull(
      (ItemPosition itemPosition) => itemPosition.index == index,
    );
    if (itemPosition != null) {
      // Scroll directly.
      final viewport = primary.scrollController.position.viewportDimension;
      final localScrollAmount = itemPosition.itemLeadingEdge * viewport;
      // `itemLeadingEdge` comes from `getOffsetToReveal`, which is
      // geometric and padding-blind. Subtract `leadingPadding` so the
      // target lands at the content-area edge (Compose semantic).
      final paddingAdjust = _resolveLeadingEndPaddingAdjust(index: index, alignment: alignment);
      await primary.scrollController.animateTo(
        primary.scrollController.offset + localScrollAmount - alignment * viewport - paddingAdjust,
        duration: duration,
        curve: curve,
      );
    } else {
      final scrollAmount = _screenScrollCount * primary.scrollController.position.viewportDimension;
      final startCompleter = Completer<void>();
      final endCompleter = Completer<void>();
      startAnimationCallback = () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          startAnimationCallback = () {};
          _animationController?.dispose();
          _animationController = AnimationController(vsync: this, duration: duration)..forward();
          opacity.parent = _opacityAnimation(opacityAnimationWeights).animate(_animationController!);
          secondary.scrollController.jumpTo(
            -direction *
                (_screenScrollCount * primary.scrollController.position.viewportDimension -
                    alignment * secondary.scrollController.position.viewportDimension),
          );

          startCompleter.complete(
            primary.scrollController.animateTo(
              primary.scrollController.offset + direction * scrollAmount,
              duration: duration,
              curve: curve,
            ),
          );
          endCompleter.complete(secondary.scrollController.animateTo(0, duration: duration, curve: curve));
        });
      };
      setState(() {
        // TODO: _startScroll can be re-entrant, which invalidates this assert.
        // assert(!_isTransitioning);
        secondary
          ..target = index
          ..alignment = alignment;
        _isTransitioning = true;
      });
      await Future.wait<void>([startCompleter.future, endCompleter.future]);
      _stopScroll();
    }
  }

  void _stopScroll({bool canceled = false}) {
    if (!_isTransitioning) {
      return;
    }

    if (canceled) {
      if (primary.scrollController.hasClients) {
        primary.scrollController.jumpTo(primary.scrollController.offset);
      }
      if (secondary.scrollController.hasClients) {
        secondary.scrollController.jumpTo(secondary.scrollController.offset);
      }
    }

    if (mounted) {
      setState(() {
        if (opacity.value >= 0.5) {
          // Secondary [ListView] is more visible than the primary; make it the
          // new primary.
          final temp = primary;
          primary = secondary;
          secondary = temp;
        }
        _isTransitioning = false;
        opacity.parent = const AlwaysStoppedAnimation<double>(0);
      });
      // After a primary/secondary swap, the active controller's
      // `isScrollingNotifier` is different — re-subscribe.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _bindIsScrollingNotifier();
      });
    }
  }

  Animatable<double> _opacityAnimation(List<double> opacityAnimationWeights) {
    const startOpacity = 0.0;
    const endOpacity = 1.0;
    return TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(startOpacity),
        weight: opacityAnimationWeights[0],
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: startOpacity, end: endOpacity),
        weight: opacityAnimationWeights[1],
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(endOpacity),
        weight: opacityAnimationWeights[2],
      ),
    ]);
  }

  void _updatePositions() {
    final itemPositions = primary.itemPositionsNotifier.itemPositions.value.where(
      (ItemPosition position) => position.itemLeadingEdge < 1 && position.itemTrailingEdge > 0,
    );
    if (itemPositions.isNotEmpty) {
      // The visually topmost item — smallest `itemLeadingEdge` along the
      // scroll axis.
      final topmost = itemPositions.reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b);
      PageStorage.of(context).writeState(context, topmost);

      // Capture the topmost item's identity + position so the next
      // reanchor can preserve it across an item-set change. Skipped when
      // [widget.itemKeyBuilder] is null.
      final keyBuilder = widget.itemKeyBuilder;
      if (keyBuilder != null) {
        final key = keyBuilder(topmost.index);
        if (key != null) {
          _lastKnownFirstItemKey = key;
          _lastKnownFirstItemIndex = topmost.index;
          _firstVisibleItemAlignment = topmost.itemLeadingEdge;
          _firstVisibleItemAlignmentAtPixels = primary.scrollController.hasClients
              ? primary.scrollController.position.pixels
              : 0.0;
        }
      }
    }
    widget.itemPositionsNotifier?.itemPositions.value = itemPositions;
  }
}

class _ListDisplayDetails {
  _ListDisplayDetails(this.key);

  final itemPositionsNotifier = ItemPositionsNotifier();
  final scrollController = ScrollController(keepScrollOffset: false);

  /// The index of the item to scroll to.
  int target = 0;

  /// The desired alignment for [target].
  ///
  /// See [ItemScrollController.jumpTo] for an explanation of alignment.
  double alignment = 0;

  final Key key;
}

/// Returned by [ItemScrollController.isScrollingListenable] when the
/// controller isn't attached to a list yet. Notifies no listeners and
/// holds no state — callers can register a listener safely, it just
/// never fires until [ItemScrollController._attach] runs and the real
/// notifier takes its place.
class _NoopListenable extends Listenable {
  const _NoopListenable();

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}
