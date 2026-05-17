// Tests for `UnboundedRenderViewport`'s **fit-anchor** fallback — the
// layout-time pinning that activates when total content extent is less
// than the viewport extent.
//
// `initialAlignment` is meant to position a target item within a
// *scrollable* list. When content fits inside the viewport there's
// nothing to scroll, and centering (or otherwise pushing items into
// the middle) leaves an empty strip that reads as a layout bug. The
// viewport falls back to a "fit anchor" that pins content against the
// axis-leading edge — the bottom of the screen with `reverse: true`
// (chat), the top with `reverse: false`.
//
// This is a distinct concept from the mutation-time **anchor
// preservation** tested in `item_key_builder_test.dart`. Both involve
// the word "anchor" but solve different problems:
//
//   * fit anchor: layout-time, only when content < viewport, pins to
//     leading edge regardless of `initialAlignment`.
//   * anchor preservation: mutation-time, scrolls to keep the
//     previously-topmost item on screen across data changes.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';

const _viewportHeight = 600.0;
const _viewportWidth = 400.0;
const _itemHeight = 40.0;
const _tolerance = 1e-3;

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required int itemCount,
    required double initialAlignment,
    required bool reverse,
    int initialScrollIndex = 0,
    ItemPositionsListener? listener,
  }) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(_viewportWidth, _viewportHeight);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: ScrollablePositionedList.builder(
          itemCount: itemCount,
          reverse: reverse,
          initialScrollIndex: initialScrollIndex,
          initialAlignment: initialAlignment,
          itemPositionsListener: listener,
          itemBuilder: (context, i) => SizedBox(
            height: _itemHeight,
            child: Text('item-$i'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('short content with reverse: true', () {
    testWidgets(
      'two items + alignment 0.5 pin to the bottom of the viewport',
      (tester) async {
        await pump(
          tester,
          itemCount: 2,
          initialAlignment: 0.5,
          reverse: true,
        );

        // Without the fit-anchor fallback, item 0 would render at
        // `viewport * 0.5` from the axis-leading edge (mid-screen with
        // reverse=true). With it, item 0 sits flush against the bottom
        // of the viewport; item 1 sits just above it.
        expect(
          tester.getBottomRight(find.text('item-0')).dy,
          closeTo(_viewportHeight, _tolerance),
        );
        expect(
          tester.getTopLeft(find.text('item-0')).dy,
          closeTo(_viewportHeight - _itemHeight, _tolerance),
        );
        expect(
          tester.getBottomRight(find.text('item-1')).dy,
          closeTo(_viewportHeight - _itemHeight, _tolerance),
        );
      },
    );

    testWidgets(
      'two items + alignment 1.0 still pin to the bottom',
      (tester) async {
        await pump(
          tester,
          itemCount: 2,
          initialAlignment: 1,
          reverse: true,
        );

        expect(
          tester.getBottomRight(find.text('item-0')).dy,
          closeTo(_viewportHeight, _tolerance),
        );
      },
    );

    testWidgets(
      'leading + center fits: all content pins to the bottom',
      (tester) async {
        // initialScrollIndex=1 → user-index 0 lives in the leading sliver.
        await pump(
          tester,
          itemCount: 2,
          initialAlignment: 0.5,
          reverse: true,
          initialScrollIndex: 1,
        );

        // Item 0 (leading sliver, newest in a chat) flush against the
        // bottom; item 1 (center, the unread target) directly above.
        expect(
          tester.getBottomRight(find.text('item-0')).dy,
          closeTo(_viewportHeight, _tolerance),
        );
        expect(
          tester.getBottomRight(find.text('item-1')).dy,
          closeTo(_viewportHeight - _itemHeight, _tolerance),
        );
      },
    );

    testWidgets(
      'long content keeps scrolling enabled (no fit-anchor override)',
      (tester) async {
        // 100 items × 40px = 4000px ≫ 600px viewport. Content overflows
        // so the fit-anchor branch must not fire — the user must still
        // be able to scroll. We verify by reading the scroll bounds:
        // with the override accidentally on, max == min and scrolling
        // would be locked.
        final listener = ItemPositionsListener.create();
        await pump(
          tester,
          itemCount: 100,
          initialAlignment: 0.5,
          reverse: true,
          listener: listener,
        );

        final scrollable = tester.widget<Scrollable>(find.byType(Scrollable));
        final position = scrollable.controller!.position;
        expect(
          position.maxScrollExtent - position.minScrollExtent,
          greaterThan(0),
          reason: 'long-content list must remain scrollable',
        );
      },
    );
  });

  group('short content with reverse: false', () {
    testWidgets(
      'two items + alignment 0.5 pin to the top',
      (tester) async {
        await pump(
          tester,
          itemCount: 2,
          initialAlignment: 0.5,
          reverse: false,
        );

        // For a forward (non-reversed) list, "axis-leading edge" is the
        // top — content above the viewport's vertical center, not below.
        expect(
          tester.getTopLeft(find.text('item-0')).dy,
          closeTo(0, _tolerance),
        );
        expect(
          tester.getBottomRight(find.text('item-1')).dy,
          closeTo(2 * _itemHeight, _tolerance),
        );
      },
    );
  });
}
