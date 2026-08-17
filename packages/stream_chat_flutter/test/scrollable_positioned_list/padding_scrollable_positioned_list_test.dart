// Verifies ScrollablePositionedList handles `padding` the same way a plain
// ListView (BoxScrollView) does — in particular, auto-consuming
// `MediaQuery.padding` when `padding` is null.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';

const screenHeight = 400.0;
const screenWidth = 400.0;
const itemHeight = screenHeight / 10.0;
const itemCount = 500;

Future<void> pumpList(
  WidgetTester tester, {
  required EdgeInsets? padding,
  EdgeInsets mediaPadding = EdgeInsets.zero,
  bool reverse = false,
  int initialScrollIndex = 0,
  double initialAlignment = 0.0,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(screenWidth, screenHeight);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(padding: mediaPadding, viewPadding: mediaPadding),
          child: ScrollablePositionedList.builder(
            itemCount: itemCount,
            reverse: reverse,
            padding: padding,
            initialScrollIndex: initialScrollIndex,
            initialAlignment: initialAlignment,
            itemBuilder: (context, index) => SizedBox(height: itemHeight, child: Text('Item $index')),
          ),
        ),
      ),
    ),
  );
}

// The concrete padding on every SliverPadding SPL emits, in tree order
// (leading?, center, trailing?). ListView emits exactly one.
List<EdgeInsets> sliverPaddings(WidgetTester tester) {
  return tester
      .widgetList<SliverPadding>(find.byType(SliverPadding))
      .map((w) => w.padding.resolve(TextDirection.ltr))
      .toList();
}

// A plain ListView pumped identically, used as the parity oracle.
Future<double> listViewFirstItemTop(
  WidgetTester tester, {
  required EdgeInsets? padding,
  EdgeInsets mediaPadding = EdgeInsets.zero,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(screenWidth, screenHeight);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(padding: mediaPadding, viewPadding: mediaPadding),
          child: ListView.builder(
            itemCount: itemCount,
            padding: padding,
            itemBuilder: (context, index) => SizedBox(height: itemHeight, child: Text('LV $index')),
          ),
        ),
      ),
    ),
  );
  return tester.getTopLeft(find.text('LV 0')).dy;
}

void main() {
  group('ScrollablePositionedList padding parity with ListView', () {
    testWidgets('null padding auto-consumes MediaQuery.padding.top (like ListView)', (tester) async {
      await pumpList(tester, padding: null, mediaPadding: const EdgeInsets.only(top: 50, bottom: 30));
      // First item rests below the top MediaQuery inset, not at y = 0.
      expect(tester.getTopLeft(find.text('Item 0')).dy, 50);
    });

    testWidgets('reversed: null padding auto-consumes MediaQuery.padding.bottom', (tester) async {
      await pumpList(tester, reverse: true, padding: null, mediaPadding: const EdgeInsets.only(bottom: 30));
      // Item 0 sits at the visual bottom of a reversed list; it clears the inset.
      expect(tester.getBottomLeft(find.text('Item 0')).dy, screenHeight - 30);
    });

    testWidgets('matches a plain ListView for the same null-padding + MediaQuery', (tester) async {
      await pumpList(tester, padding: null, mediaPadding: const EdgeInsets.only(top: 44));
      final splTop = tester.getTopLeft(find.text('Item 0')).dy;

      final lvTop = await listViewFirstItemTop(tester, padding: null, mediaPadding: const EdgeInsets.only(top: 44));

      expect(splTop, lvTop);
    });

    testWidgets('explicit padding is used verbatim and ignores MediaQuery', (tester) async {
      await pumpList(tester, padding: const EdgeInsets.only(top: 100), mediaPadding: const EdgeInsets.only(top: 50));
      expect(tester.getTopLeft(find.text('Item 0')).dy, 100);
    });

    testWidgets('reversed + explicit bottom padding: newest item (0) clears the bottom', (tester) async {
      // Mirrors the message list: reverse:true, explicit padding. Item 0 (newest)
      // sits at the visual bottom and must clear the composer inset.
      await pumpList(tester, reverse: true, padding: const EdgeInsets.only(bottom: 100));
      expect(tester.getBottomLeft(find.text('Item 0')).dy, screenHeight - 100);
    });

    testWidgets('no padding and no MediaQuery inset keeps the first item at the top', (tester) async {
      await pumpList(tester, padding: null);
      expect(tester.getTopLeft(find.text('Item 0')).dy, 0);
    });
  });

  // SPL splits its padding across up to three slivers (leading / center /
  // trailing) because of its centre anchor. These verify the auto-consumed
  // inset is distributed so each edge is applied EXACTLY once — matching what
  // ListView does with its single SliverPadding, regardless of anchor position.
  group('3-sliver split places each edge inset exactly once', () {
    const mq = EdgeInsets.only(top: 50, bottom: 30);

    testWidgets('anchor at first item: center owns top, trailing owns bottom', (tester) async {
      await pumpList(tester, padding: null, mediaPadding: mq, initialScrollIndex: 0);
      // No leading sliver (nothing before index 0): center(item 0) + trailing.
      expect(sliverPaddings(tester), const [
        EdgeInsets.only(top: 50), // center, isFirst -> owns top
        EdgeInsets.only(bottom: 30), // trailing -> owns bottom
      ]);
    });

    testWidgets('anchor in the middle: leading owns top, center owns neither, trailing owns bottom', (tester) async {
      // Interior anchor at mid-alignment keeps all three slivers on-screen/in-cache.
      await pumpList(tester, padding: null, mediaPadding: mq, initialScrollIndex: 3, initialAlignment: 0.5);
      expect(sliverPaddings(tester), const [
        EdgeInsets.only(top: 50), // leading -> owns top
        EdgeInsets.zero, // center, neither first nor last -> no double inset
        EdgeInsets.only(bottom: 30), // trailing -> owns bottom
      ]);
    });

    testWidgets('anchor at last item: leading owns top, center owns bottom', (tester) async {
      // Anchor the last item mid-viewport so both it (center) and the leading sliver stay mounted.
      await pumpList(tester, padding: null, mediaPadding: mq, initialScrollIndex: itemCount - 1, initialAlignment: 0.5);
      // No trailing sliver (nothing after the last index): leading + center(last).
      expect(sliverPaddings(tester), const [
        EdgeInsets.only(top: 50), // leading -> owns top
        EdgeInsets.only(bottom: 30), // center, isLast -> owns bottom
      ]);
    });

    testWidgets('aggregate (first sliver top + last sliver bottom) equals ListView single SliverPadding', (
      tester,
    ) async {
      // ListView oracle: one SliverPadding carrying the whole main-axis inset.
      tester.view
        ..devicePixelRatio = 1.0
        ..physicalSize = const Size(screenWidth, screenHeight);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(padding: mq, viewPadding: mq),
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) => SizedBox(height: itemHeight, child: Text('LV $index')),
              ),
            ),
          ),
        ),
      );
      final lvPad = sliverPaddings(tester).single;
      expect(lvPad, mq);

      // SPL with an interior anchor: top from the first sliver, bottom from the last.
      await pumpList(tester, padding: null, mediaPadding: mq, initialScrollIndex: 3, initialAlignment: 0.5);
      final splPads = sliverPaddings(tester);
      final aggregate = EdgeInsets.only(top: splPads.first.top, bottom: splPads.last.bottom);
      expect(aggregate, lvPad);
    });
  });
}
