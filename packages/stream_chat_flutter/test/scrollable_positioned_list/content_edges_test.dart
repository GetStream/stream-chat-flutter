// Verifies ItemPosition.contentLeadingEdge / contentTrailingEdge — the
// content-relative edges (measured inside the list's padding) that overlays
// like the floating date divider key off, as distinct from the
// viewport-relative itemLeadingEdge / itemTrailingEdge that scroll mechanics
// use.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';

const screenHeight = 400.0;
const screenWidth = 400.0;
const itemHeight = 40.0;
const itemCount = 500;

Future<ItemPositionsListener> pumpList(
  WidgetTester tester, {
  required EdgeInsets? padding,
  bool reverse = false,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(screenWidth, screenHeight);
  addTearDown(tester.view.reset);

  final positionsListener = ItemPositionsListener.create();
  await tester.pumpWidget(
    MaterialApp(
      home: ScrollablePositionedList.builder(
        itemCount: itemCount,
        reverse: reverse,
        padding: padding,
        itemPositionsListener: positionsListener,
        itemBuilder: (context, index) => SizedBox(height: itemHeight, child: Text('Item $index')),
      ),
    ),
  );
  return positionsListener;
}

ItemPosition positionOf(ItemPositionsListener listener, int index) {
  return listener.itemPositions.value.firstWhere((p) => p.index == index);
}

void main() {
  group('ItemPosition content edges', () {
    testWidgets('are content-relative under a leading inset, while the item edges stay viewport-relative', (
      tester,
    ) async {
      // A 100px top inset in a 400px viewport: item 0 rests flush against the
      // content top, and the content area spans the remaining 300px.
      final listener = await pumpList(tester, padding: const EdgeInsets.only(top: 100));

      // Sanity: item 0 renders below the inset, not at the viewport top.
      expect(tester.getTopLeft(find.text('Item 0')).dy, 100);

      final position = positionOf(listener, 0);

      // Viewport-relative: item 0 sits 100/400 down from the viewport's top.
      expect(position.itemLeadingEdge, closeTo(0.25, 1e-6));
      expect(position.itemTrailingEdge, closeTo(0.35, 1e-6));

      // Content-relative: measured inside the 100px inset (content extent 300),
      // item 0 is flush with the content's leading edge, so it reads 0.
      expect(position.contentLeadingEdge, closeTo(0, 1e-6));
      expect(position.contentTrailingEdge, closeTo(40 / 300, 1e-6));
    });

    testWidgets('equal the viewport edges when the list has no inset', (tester) async {
      final listener = await pumpList(tester, padding: null);

      final positions = listener.itemPositions.value;
      expect(positions, isNotEmpty);
      for (final position in positions) {
        expect(position.contentLeadingEdge, closeTo(position.itemLeadingEdge, 1e-9));
        expect(position.contentTrailingEdge, closeTo(position.itemTrailingEdge, 1e-9));
      }
    });
  });
}
