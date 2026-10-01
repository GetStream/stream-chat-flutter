import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Future<void> _pumpGallery(WidgetTester tester, {required double width, required StreamMediaGallery gallery}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = Size(width, 800);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(MaterialApp(home: gallery));
}

int _tilesPerRow(WidgetTester tester) {
  final grid = tester.widget<GridView>(find.byType(GridView));
  final sliver = tester.renderObject<RenderSliverGrid>(find.byType(SliverGrid, skipOffstage: false));
  final layout = grid.gridDelegate.getLayout(sliver.constraints) as SliverGridRegularTileLayout;
  return layout.crossAxisCount;
}

void main() {
  for (final (width, tilesPerRow) in [(402.0, 3), (669.0, 4), (867.0, 6)]) {
    testWidgets('StreamMediaGallery shows $tilesPerRow tiles per row when $width wide', (tester) async {
      await _pumpGallery(
        tester,
        width: width,
        gallery: StreamMediaGallery(attachments: const []),
      );

      expect(_tilesPerRow(tester), tilesPerRow);
    });
  }

  testWidgets('StreamMediaGallery keeps the given crossAxisCount at any width', (tester) async {
    await _pumpGallery(
      tester,
      width: 867,
      // ignore: deprecated_member_use_from_same_package
      gallery: StreamMediaGallery(attachments: const [], crossAxisCount: 2),
    );

    expect(_tilesPerRow(tester), 2);
  });

  testWidgets('StreamMediaGallery lays out its tiles with the given gridDelegate', (tester) async {
    const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5);

    await _pumpGallery(
      tester,
      width: 402,
      gallery: StreamMediaGallery(attachments: const [], gridDelegate: gridDelegate),
    );

    expect(tester.widget<GridView>(find.byType(GridView)).gridDelegate, same(gridDelegate));
  });
}
