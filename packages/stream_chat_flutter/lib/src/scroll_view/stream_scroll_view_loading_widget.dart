import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart';

/// A widget that is displayed while the [StreamScrollView] is loading.
class StreamScrollViewLoadingWidget extends StatelessWidget {
  /// Creates a new instance of [StreamScrollViewLoadingWidget].
  const StreamScrollViewLoadingWidget({
    super.key,
    this.size = StreamLoadingSpinnerSize.lg,
    @Deprecated('Use size instead') this.height = 42,
    @Deprecated('Use size instead') this.width = 42,
  });

  /// The size of the loading spinner.
  final StreamLoadingSpinnerSize size;

  /// The height of the indicator.
  @Deprecated('Use size instead')
  final double height;

  /// The width of the indicator.
  @Deprecated('Use size instead')
  final double width;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return Padding(
      padding: .symmetric(
        horizontal: spacing.md,
        vertical: spacing.xxxl,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: StreamLoadingSpinner(size: size),
      ),
    );
  }
}
