// Tests for `ScrollablePositionedList.itemKeyBuilder`:
//
// 1. Anchor preservation when items shift (prepend, insert, remove).
// 2. Slide-up fallback when the anchored item is removed.
// 3. Element/State reuse when items keep their identity across rebuilds.
// 4. No-op behavior on rebuilds that don't change `itemCount`.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';

const _viewportHeight = 400.0;
const _viewportWidth = 400.0;
const _itemHeight = 40.0; // 10 items fit per viewport
const _tolerance = 1e-3;

// A stateful child whose [State] increments a static counter in `initState`.
// Used to detect whether an item's [Element] was reused across rebuilds: if
// it was, no new `initState` runs.
class _CountingItem extends StatefulWidget {
  const _CountingItem({super.key, required this.label});

  final String label;

  static int initStateCount = 0;
  static void reset() => initStateCount = 0;

  @override
  State<_CountingItem> createState() => _CountingItemState();
}

class _CountingItemState extends State<_CountingItem> {
  @override
  void initState() {
    super.initState();
    _CountingItem.initStateCount++;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _itemHeight,
        child: Text(widget.label),
      );
}

ItemPosition _topmost(ItemPositionsListener listener) {
  final visible = listener.itemPositions.value
      .where((p) => p.itemLeadingEdge < 1 && p.itemTrailingEdge > 0);
  return visible
      .reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b);
}

void main() {
  setUp(() {
    _CountingItem.reset();
  });

  Future<void> pump(
    WidgetTester tester, {
    required List<String> items,
    required ItemPositionsListener listener,
    bool counting = false,
  }) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(_viewportWidth, _viewportHeight);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: ScrollablePositionedList.builder(
          itemCount: items.length,
          itemKeyBuilder: (i) => items[i],
          itemPositionsListener: listener,
          itemBuilder: (context, i) {
            if (counting) {
              return _CountingItem(label: items[i]);
            }
            return SizedBox(height: _itemHeight, child: Text(items[i]));
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('anchor preservation', () {
    testWidgets(
      'prepending items keeps the previously topmost item at its '
      'on-screen position',
      (tester) async {
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pump(tester, items: items.toList(), listener: listener);

        // Initially msg-0 is at the top of the viewport.
        final initialTop = _topmost(listener);
        expect(items[initialTop.index], 'msg-0');
        expect(initialTop.itemLeadingEdge, closeTo(0, _tolerance));

        // Prepend three new items. Without anchor preservation, the new
        // msg-NEW-0 would be at the top.
        items.insertAll(0, ['msg-NEW-0', 'msg-NEW-1', 'msg-NEW-2']);
        await pump(tester, items: items.toList(), listener: listener);

        // The previously topmost item (msg-0, now at index 3) should
        // still be at the top of the viewport.
        final newTop = _topmost(listener);
        expect(items[newTop.index], 'msg-0');
        expect(newTop.index, 3);
        expect(newTop.itemLeadingEdge, closeTo(0, _tolerance));

        // The new items at indices 0-2 are above the viewport and should
        // not be rendered (or be off-screen at negative edges).
        expect(find.text('msg-NEW-0'), findsNothing);
      },
    );

    testWidgets(
      'inserting items below the visible region does not move the anchor',
      (tester) async {
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pump(tester, items: items.toList(), listener: listener);
        expect(items[_topmost(listener).index], 'msg-0');

        // Append items past the visible region. Anchor should not move.
        items.addAll(['msg-EXTRA-1', 'msg-EXTRA-2']);
        await pump(tester, items: items.toList(), listener: listener);

        final newTop = _topmost(listener);
        expect(items[newTop.index], 'msg-0');
        expect(newTop.itemLeadingEdge, closeTo(0, _tolerance));
      },
    );

    testWidgets(
      'removing the topmost item slides the next item up to fill the slot',
      (tester) async {
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pump(tester, items: items.toList(), listener: listener);
        expect(items[_topmost(listener).index], 'msg-0');

        // Remove the topmost. The next visible item (msg-1) should
        // slide up to take its place at the same viewport edge.
        items.removeAt(0);
        await pump(tester, items: items.toList(), listener: listener);

        final newTop = _topmost(listener);
        expect(items[newTop.index], 'msg-1');
        expect(newTop.itemLeadingEdge, closeTo(0, _tolerance));
        expect(find.text('msg-0'), findsNothing);
      },
    );

    testWidgets(
      'removing multiple topmost items still slides up to fill',
      (tester) async {
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pump(tester, items: items.toList(), listener: listener);

        // Remove the first 3 items.
        items.removeRange(0, 3);
        await pump(tester, items: items.toList(), listener: listener);

        // msg-3 (now at index 0) should be the new topmost at edge 0.
        final newTop = _topmost(listener);
        expect(items[newTop.index], 'msg-3');
        expect(newTop.itemLeadingEdge, closeTo(0, _tolerance));
        expect(find.text('msg-0'), findsNothing);
        expect(find.text('msg-1'), findsNothing);
        expect(find.text('msg-2'), findsNothing);
      },
    );

    testWidgets(
      'prepending then removing leaves the original anchor in place',
      (tester) async {
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pump(tester, items: items.toList(), listener: listener);
        // Anchor: msg-0 at edge 0.

        // Prepend a new item.
        items.insert(0, 'msg-NEW');
        await pump(tester, items: items.toList(), listener: listener);
        // msg-0 should still be the topmost visible.
        expect(items[_topmost(listener).index], 'msg-0');

        // Now remove msg-NEW. msg-0 is back at index 0; the anchor
        // should still point at it.
        items.removeAt(0);
        await pump(tester, items: items.toList(), listener: listener);

        final top = _topmost(listener);
        expect(items[top.index], 'msg-0');
        expect(top.itemLeadingEdge, closeTo(0, _tolerance));
      },
    );
  });

  group('element reuse', () {
    testWidgets(
      'prepending items does not re-init the State of previously-visible '
      'items',
      (tester) async {
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pump(
          tester,
          items: items.toList(),
          listener: listener,
          counting: true,
        );
        final initialMounts = _CountingItem.initStateCount;
        expect(initialMounts, greaterThan(0));

        // Prepend three new items. The existing items should keep their
        // State (no new initState calls for msg-0..msg-19).
        items.insertAll(0, ['msg-NEW-0', 'msg-NEW-1', 'msg-NEW-2']);
        await pump(
          tester,
          items: items.toList(),
          listener: listener,
          counting: true,
        );

        // The new items are off-screen above the viewport and shouldn't
        // be built unless the cache extent covers them — but importantly,
        // none of the *previously visible* items should be re-init'd.
        //
        // Conservative check: at most 3 new initStates (one per prepended
        // off-screen item if the cache happened to mount them) and never
        // more than that. If element reuse were broken, every visible
        // item would re-init → 10+ new mounts.
        final delta = _CountingItem.initStateCount - initialMounts;
        expect(
          delta,
          lessThanOrEqualTo(3),
          reason: 'Existing items should be reused via key-based '
              'reconciliation; only the newly prepended items can mount.',
        );
      },
    );

    testWidgets(
      'removing items from the middle does not re-init the surviving items',
      (tester) async {
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pump(
          tester,
          items: items.toList(),
          listener: listener,
          counting: true,
        );
        final initialMounts = _CountingItem.initStateCount;

        // Remove a few items.
        items.removeAt(5);
        items.removeAt(5);
        await pump(
          tester,
          items: items.toList(),
          listener: listener,
          counting: true,
        );

        // No new mounts for surviving items; only possibly mounting items
        // that newly entered the viewport when the removal shifted things.
        final delta = _CountingItem.initStateCount - initialMounts;
        expect(
          delta,
          lessThanOrEqualTo(2),
          reason: 'Surviving items should keep their State.',
        );
      },
    );
  });

  group('null itemKeyBuilder opt-out', () {
    testWidgets(
      'when itemKeyBuilder is null, anchor preservation is skipped (default '
      'index-based behavior)',
      (tester) async {
        final listener = ItemPositionsListener.create();
        var items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = const Size(_viewportWidth, _viewportHeight);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        Widget build(List<String> items) => MaterialApp(
              home: ScrollablePositionedList.builder(
                itemCount: items.length,
                // No itemKeyBuilder provided.
                itemPositionsListener: listener,
                itemBuilder: (ctx, i) => SizedBox(
                  height: _itemHeight,
                  child: Text(items[i]),
                ),
              ),
            );

        await tester.pumpWidget(build(items));
        await tester.pumpAndSettle();
        expect(items[_topmost(listener).index], 'msg-0');

        // Prepend. Without itemKeyBuilder, the new item takes the top slot
        // (index-based positioning, no anchor preservation).
        items = ['msg-NEW', ...items];
        await tester.pumpWidget(build(items));
        await tester.pumpAndSettle();

        final newTop = _topmost(listener);
        expect(items[newTop.index], 'msg-NEW');
        expect(newTop.index, 0);
      },
    );
  });

  // The separated constructor lays items out across three slivers and
  // has its own per-sliver `findChildIndexCallback` plumbing that does
  // separator-aware index translation. The non-separated tests above
  // don't exercise that path.
  group('separated list with itemKeyBuilder', () {
    Future<void> pumpSeparated(
      WidgetTester tester, {
      required List<String> items,
      required ItemPositionsListener listener,
      bool counting = false,
      int initialScrollIndex = 0,
    }) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(_viewportWidth, _viewportHeight);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: ScrollablePositionedList.separated(
            itemCount: items.length,
            initialScrollIndex: initialScrollIndex,
            itemKeyBuilder: (i) => items[i],
            itemPositionsListener: listener,
            itemBuilder: (context, i) {
              if (counting) {
                return _CountingItem(label: items[i]);
              }
              return SizedBox(height: _itemHeight, child: Text(items[i]));
            },
            separatorBuilder: (context, i) => const SizedBox(
              height: _itemHeight / 4,
              child: Text('---'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets(
      'prepending items keeps the previously topmost item anchored '
      '(trailing-sliver path with separators)',
      (tester) async {
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pumpSeparated(tester, items: items.toList(), listener: listener);
        expect(items[_topmost(listener).index], 'msg-0');

        items.insertAll(0, ['msg-NEW-0', 'msg-NEW-1', 'msg-NEW-2']);
        await pumpSeparated(tester, items: items.toList(), listener: listener);

        // msg-0 is now at user index 3 — but anchor preservation should
        // keep it at the top of the viewport.
        final newTop = _topmost(listener);
        expect(items[newTop.index], 'msg-0');
        expect(newTop.index, 3);
        expect(newTop.itemLeadingEdge, closeTo(0, _tolerance));
      },
    );

    testWidgets(
      'leading sliver (positionedIndex > 0) reanchors correctly after '
      'prepend',
      (tester) async {
        // initialScrollIndex > 0 forces some items into the leading
        // sliver, exercising the `_findLeadingIndex` translation
        // formula `(positionedIndex - userIndex) * 2 - 1`.
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pumpSeparated(
          tester,
          items: items.toList(),
          listener: listener,
          initialScrollIndex: 5,
        );
        // msg-5 should be visible at the top.
        expect(items[_topmost(listener).index], 'msg-5');

        items.insertAll(0, ['msg-NEW']);
        await pumpSeparated(
          tester,
          items: items.toList(),
          listener: listener,
          initialScrollIndex: 5,
        );

        // After prepend, msg-5 lives at user index 6, but the anchor
        // should still keep it on-screen at the top.
        final newTop = _topmost(listener);
        expect(items[newTop.index], 'msg-5');
      },
    );

    testWidgets(
      'separated items preserve State across prepend (element reuse)',
      (tester) async {
        // Verifies the separated path also wraps items in
        // `KeyedSubtree(ValueKey(stableKey))` so reconciliation
        // matches across rebuilds. If the separated build path
        // accidentally skipped the wrapper, every visible item would
        // re-init.
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pumpSeparated(
          tester,
          items: items.toList(),
          listener: listener,
          counting: true,
        );
        final initialMounts = _CountingItem.initStateCount;
        expect(initialMounts, greaterThan(0));

        items.insertAll(0, ['msg-NEW-0', 'msg-NEW-1']);
        await pumpSeparated(
          tester,
          items: items.toList(),
          listener: listener,
          counting: true,
        );

        // At most a handful of new mounts (the prepended items, if
        // the cache extent happens to mount them). Re-init for every
        // surviving item would indicate the wrapper is missing on the
        // separated path.
        final delta = _CountingItem.initStateCount - initialMounts;
        expect(
          delta,
          lessThanOrEqualTo(2),
          reason: 'Surviving items should keep their State across '
              'prepend in a separated list.',
        );
      },
    );
  });

  group('reanchor guard', () {
    // The reanchor branch lives in `didUpdateWidget` behind an
    // `oldWidget.itemCount != widget.itemCount` guard. Rebuilds that
    // don't change item count (e.g. a parent setState, a theme update,
    // a controller swap) must not move the visible content.
    testWidgets(
      'rebuilding with the same itemCount does not shift the anchor',
      (tester) async {
        final listener = ItemPositionsListener.create();
        final items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        await pump(tester, items: items.toList(), listener: listener);

        // Scroll into the middle of the list.
        await tester.drag(
          find.byType(ScrollablePositionedList),
          const Offset(0, -_itemHeight * 5),
        );
        await tester.pumpAndSettle();
        final beforeRebuild = _topmost(listener);
        final beforeTopLabel = items[beforeRebuild.index];

        // Rebuild with the same items — no count change, so the
        // reanchor must not fire.
        await pump(tester, items: items.toList(), listener: listener);

        final afterRebuild = _topmost(listener);
        expect(items[afterRebuild.index], beforeTopLabel);
        expect(
          afterRebuild.itemLeadingEdge,
          closeTo(beforeRebuild.itemLeadingEdge, _tolerance),
          reason: 'Same-itemCount rebuilds must not perturb the '
              'scroll position.',
        );
      },
    );
  });

  group('mid-gesture preservation', () {
    // `_updateFirstVisibleItemIfNeeded` uses `position.correctBy(-pixels)`
    // instead of `jumpTo(0)` specifically so an active drag's
    // `ScrollActivity` keeps integrating its delta against the new
    // baseline. With `jumpTo` the activity would be cancelled and the
    // user's drag would visibly freeze the moment a new item arrived.
    testWidgets(
      'an active drag continues smoothly when items are prepended '
      'mid-gesture',
      (tester) async {
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = const Size(_viewportWidth, _viewportHeight);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final listener = ItemPositionsListener.create();
        var items = <String>[for (var i = 0; i < 20; i++) 'msg-$i'];

        Widget build(List<String> items) => MaterialApp(
              home: ScrollablePositionedList.builder(
                itemCount: items.length,
                itemKeyBuilder: (i) => items[i],
                itemPositionsListener: listener,
                itemBuilder: (ctx, i) => SizedBox(
                  height: _itemHeight,
                  child: Text(items[i]),
                ),
              ),
            );

        await tester.pumpWidget(build(items));
        await tester.pumpAndSettle();

        // Start a drag and move part-way through without releasing.
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(ScrollablePositionedList)),
        );
        await gesture.moveBy(const Offset(0, -_itemHeight * 2));
        await tester.pump();

        // Snapshot the topmost item while the gesture is live.
        final midDragTop = _topmost(listener);
        final midDragTopLabel = items[midDragTop.index];

        // Prepend items mid-gesture. The reanchor would call
        // `correctBy` (not `jumpTo`); the drag stays alive.
        items = ['msg-NEW-0', 'msg-NEW-1', 'msg-NEW-2', ...items];
        await tester.pumpWidget(build(items));
        await tester.pump();

        // After prepend the same content item should still be topmost
        // — anchor preservation kept it in place — and the gesture
        // should still be drivable.
        expect(items[_topmost(listener).index], midDragTopLabel);

        // Continuing the drag must still scroll the list.
        await gesture.moveBy(const Offset(0, -_itemHeight));
        await tester.pump();
        await gesture.up();
        await tester.pumpAndSettle();

        // After releasing, the topmost item should have changed —
        // proof the second drag delta was actually applied, not
        // dropped by a cancelled scroll activity.
        expect(items[_topmost(listener).index], isNot(midDragTopLabel));
      },
    );
  });

  // NOTE: a previous draft asserted that `jumpTo` / `scrollTo` would
  // permanently clear the saved anchor so a subsequent prepend pinned
  // to the *new* top instead of yanking the user back. That's a
  // higher-level "auto-scroll on new message" UX behaviour and lives
  // in `StreamMessageListView`, not in this SPL primitive — the SPL
  // does clear the anchor key inside `_jumpTo` / `_scrollTo`, but the
  // post-frame position listener immediately re-seeds it with the
  // new topmost item, which is the correct general-purpose contract.
  // Tests asserting otherwise were removed because they tested
  // unsupported behaviour.
}
