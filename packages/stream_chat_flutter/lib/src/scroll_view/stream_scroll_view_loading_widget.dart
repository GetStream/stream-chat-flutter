import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// A widget that is displayed while the [StreamScrollView] is loading.
class StreamScrollViewLoadingWidget extends StatelessWidget {
  /// Creates a new instance of [StreamScrollViewLoadingWidget].
  const StreamScrollViewLoadingWidget({
    super.key,
    this.height = 42,
    this.width = 42,
  });

  /// The height of the indicator.
  final double height;

  /// The width of the indicator.
  final double width;

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 40,
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation<Color>(colorTheme.accentPrimary),
        ),
      ),
    );
  }
}
