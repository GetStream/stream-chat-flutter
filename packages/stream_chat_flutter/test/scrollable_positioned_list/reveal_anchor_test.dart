// Tests for anchor-aware `getOffsetToReveal` on the SPL viewports.
//
// `RenderViewportBase.getOffsetToReveal` resolves a target into the
// viewport's scroll-offset space and hands that value back as the
// `offset.pixels` to move to. That conversion assumes scroll offset 0
// sits at the viewport's leading edge — true only when `anchor` is 0.
// The SPL viewports place it at `mainAxisExtent * anchor - pixels`, and
// their `anchor` is deliberately unbounded (anchor preservation folds
// accumulated scroll pixels into it as the list paginates).
//
// Anything that reveals a descendant therefore used to jump the list by
// `anchor * mainAxisExtent`. The user-visible symptom was a channel
// teleporting several screens when a message's selectable text moved the
// selection and `RenderEditable.showOnScreen` fired.
//
// See https://github.com/GetStream/stream-chat-flutter/issues/2862.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';

const _viewportHeight = 600.0;
const _viewportWidth = 400.0;
const _itemHeight = 40.0;
const _itemCount = 500;
const _positionedIndex = 100;

/// A large, out-of-`[0, 1]` anchor — the state the list reaches once anchor
/// preservation has folded scroll pixels into the alignment a few times.
const _anchor = 3.0;

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required bool reverse,
    bool selectableItems = false,
  }) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(_viewportWidth, _viewportHeight);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = ItemScrollController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScrollablePositionedList.builder(
            itemCount: _itemCount,
            reverse: reverse,
            itemScrollController: controller,
            itemBuilder: (context, i) => SizedBox(
              key: ValueKey('item-$i'),
              height: _itemHeight,
              child: selectableItems ? SelectableText('item-$i') : Text('item-$i'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    controller.jumpTo(index: _positionedIndex, alignment: _anchor);
    await tester.pumpAndSettle();
  }

  ScrollPosition positionOf(WidgetTester tester) =>
      tester.state<ScrollableState>(find.byType(Scrollable).first).position;

  /// Distance from the viewport's leading edge to [item]'s leading edge,
  /// along the scroll axis.
  double leadingEdgeOf(WidgetTester tester, Finder item, {required bool reverse}) {
    final rect = tester.getRect(item);
    return reverse ? _viewportHeight - rect.bottom : rect.top;
  }

  /// An on-screen item that is a few rows in from the leading edge, so a
  /// reveal is expected to scroll by a known, non-zero amount.
  Finder itemInsideViewport(WidgetTester tester, {required bool reverse}) {
    final candidates =
        tester
            .widgetList<SizedBox>(find.byType(SizedBox))
            .map((w) => w.key)
            .whereType<ValueKey<String>>()
            .map(find.byKey)
            .where((f) {
              final edge = leadingEdgeOf(tester, f, reverse: reverse);
              return edge > 0 && edge < _viewportHeight - _itemHeight;
            })
            .toList()
          ..sort(
            (a, b) => leadingEdgeOf(tester, a, reverse: reverse).compareTo(leadingEdgeOf(tester, b, reverse: reverse)),
          );
    expect(candidates, isNotEmpty, reason: 'need an on-screen item to reveal');
    return candidates[candidates.length ~/ 2];
  }

  for (final reverse in [false, true]) {
    group('reverse: $reverse', () {
      testWidgets('ensureVisible moves by exactly the on-screen offset', (tester) async {
        await pump(tester, reverse: reverse);

        final target = itemInsideViewport(tester, reverse: reverse);
        final expectedDelta = leadingEdgeOf(tester, target, reverse: reverse);
        final before = positionOf(tester).pixels;

        await Scrollable.ensureVisible(tester.element(target));
        await tester.pumpAndSettle();

        expect(
          positionOf(tester).pixels - before,
          // `pixels` grows along the axis direction, so revealing an item
          // that sits `expectedDelta` past the leading edge always moves it
          // forward by that much — regardless of `reverse`.
          closeTo(expectedDelta, 1),
          reason:
              'reveal must not add anchor * viewportDimension '
              '(${_anchor * _viewportHeight}px) to the scroll offset',
        );
        expect(
          leadingEdgeOf(tester, target, reverse: reverse),
          closeTo(0, 1),
          reason: 'the revealed item should sit at the leading edge',
        );
      });

      testWidgets('a second ensureVisible on the same item is a no-op', (tester) async {
        await pump(tester, reverse: reverse);

        final target = itemInsideViewport(tester, reverse: reverse);
        await Scrollable.ensureVisible(tester.element(target));
        await tester.pumpAndSettle();

        final settled = positionOf(tester).pixels;
        await Scrollable.ensureVisible(tester.element(target));
        await tester.pumpAndSettle();

        expect(positionOf(tester).pixels, closeTo(settled, 1));
      });
    });
  }

  testWidgets('selecting text in a message does not scroll the list', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    await pump(tester, reverse: true, selectableItems: true);

    final target = itemInsideViewport(tester, reverse: true);
    final before = positionOf(tester).pixels;

    // Drag-select across the text. On macOS this reports
    // `SelectionChangedCause.drag`, which makes `EditableText` call
    // `bringIntoView` -> `RenderEditable.showOnScreen`.
    final start = tester.getCenter(target) - const Offset(30, 0);
    final gesture = await tester.startGesture(start, kind: PointerDeviceKind.mouse);
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveTo(start + const Offset(50, 0));
    await tester.pumpAndSettle();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(positionOf(tester).pixels, closeTo(before, 1));
    debugDefaultTargetPlatformOverride = null;
  });
}
