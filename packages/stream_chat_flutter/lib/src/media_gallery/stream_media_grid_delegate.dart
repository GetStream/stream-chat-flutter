import 'package:flutter/rendering.dart';

/// Lays out a media grid's square tiles, with more tiles per row as the grid
/// gets wider.
///
/// The grid has 3 tiles per row when narrower than 600, 4 when narrower than
/// 840, and 6 otherwise, and the tiles share the width between them.
class StreamMediaGridDelegate extends SliverGridDelegate {
  /// Creates a delegate for a media grid with the given spacing between tiles.
  const StreamMediaGridDelegate({
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  }) : assert(mainAxisSpacing >= 0, 'mainAxisSpacing must not be negative.'),
       assert(crossAxisSpacing >= 0, 'crossAxisSpacing must not be negative.');

  /// The number of logical pixels between each tile along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each tile along the cross axis.
  final double crossAxisSpacing;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final crossAxisExtent = constraints.crossAxisExtent;
    final crossAxisCount = switch (crossAxisExtent) {
      < 600 => 3, // A phone or a foldable's outer display, with the design's 3 tiles per row.
      < 840 => 4, // A foldable or tablet in portrait. Even, so the tiles split evenly at a fold.
      _ => 6, // A foldable or tablet in landscape. Even, so the tiles split evenly at a fold.
    };

    final delegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
    );

    return delegate.getLayout(constraints);
  }

  @override
  bool shouldRelayout(StreamMediaGridDelegate oldDelegate) {
    return oldDelegate.mainAxisSpacing != mainAxisSpacing || oldDelegate.crossAxisSpacing != crossAxisSpacing;
  }
}
