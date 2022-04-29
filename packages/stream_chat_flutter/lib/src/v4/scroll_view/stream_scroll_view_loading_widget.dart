import 'package:flutter/material.dart';

/// A widget that is displayed while the [StreamScrollView] is loading.
class StreamScrollViewLoadingWidget extends StatelessWidget {
  /// Creates a new instance of [StreamScrollViewLoadingWidget].
  const StreamScrollViewLoadingWidget({
    Key? key,
    this.height = 42,
    this.width = 42,
  }) : super(key: key);

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
