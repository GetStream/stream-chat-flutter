import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that shows an empty view when the [StreamScrollView] loads
/// empty data.
class StreamScrollViewEmptyWidget extends StatelessWidget {
  /// Creates a new instance of the [StreamScrollViewEmptyWidget].
  const StreamScrollViewEmptyWidget({
    super.key,
    required this.emptyIcon,
    required this.emptyTitle,
    this.emptyTitleStyle,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// The title of the empty view.
  final Widget emptyTitle;

  /// The style of the title.
  final TextStyle? emptyTitleStyle;

  /// The icon of the empty view.
  final Widget emptyIcon;

  /// The main axis size of the empty view.
  final MainAxisSize mainAxisSize;

  /// The main axis alignment of the empty view.
  final MainAxisAlignment mainAxisAlignment;

  /// The cross axis alignment of the empty view.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    final textTheme = chatThemeData.textTheme;
    final colorTheme = chatThemeData.colorTheme;

    final effectiveTitleStyle = emptyTitleStyle ?? textTheme.headline;

    final icon = IconTheme.merge(
      data: IconThemeData(size: 32, color: colorTheme.textLowEmphasis),
      child: emptyIcon,
    );

    final emptyTitleText = AnimatedDefaultTextStyle(
      style: effectiveTitleStyle,
      duration: kThemeChangeDuration,
      child: emptyTitle,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 40,
      ),
      child: Column(
        spacing: 8,
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [icon, emptyTitleText],
      ),
    );
  }
}
