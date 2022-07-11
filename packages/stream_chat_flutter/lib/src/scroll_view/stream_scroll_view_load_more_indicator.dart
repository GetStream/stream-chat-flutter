import 'package:flutter/material.dart';

/// A widget that shows a loading indicator when the user is near the bottom of
/// the list.
class StreamScrollViewLoadMoreIndicator extends StatelessWidget {
  /// Creates a new instance of [StreamScrollViewLoadMoreIndicator].
  const StreamScrollViewLoadMoreIndicator({
    super.key,
    this.height = 16,
    this.width = 16,
  });

  /// The height of the indicator.
  final double height;

  /// The width of the indicator.
  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        width: width,
        child: const CircularProgressIndicator.adaptive(),
      );
}
