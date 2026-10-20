import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('StreamPhotoGallery defaults to 4 tiles per row on a 669-wide grid', () {
    final controller = StreamPhotoGalleryController();
    addTearDown(controller.dispose);

    final gallery = StreamPhotoGallery(controller: controller);

    final layout = gallery.gridDelegate.getLayout(_verticalConstraints(crossAxisExtent: 669));
    expect((layout as SliverGridRegularTileLayout).crossAxisCount, 4);
  });
}

SliverConstraints _verticalConstraints({required double crossAxisExtent}) {
  return SliverConstraints(
    axisDirection: AxisDirection.down,
    growthDirection: GrowthDirection.forward,
    userScrollDirection: ScrollDirection.idle,
    scrollOffset: 0,
    precedingScrollExtent: 0,
    overlap: 0,
    remainingPaintExtent: 800,
    crossAxisExtent: crossAxisExtent,
    crossAxisDirection: AxisDirection.right,
    viewportMainAxisExtent: 800,
    remainingCacheExtent: 800,
    cacheOrigin: 0,
  );
}
