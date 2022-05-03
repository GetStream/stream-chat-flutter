import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// A widget that shows an empty view when the [StreamScrollView] loads
/// empty data.
class StreamScrollViewEmptyWidget extends StatelessWidget {
  /// Creates a new instance of the [StreamScrollViewEmptyWidget].
  const StreamScrollViewEmptyWidget({
    Key? key,
    required this.emptyIcon,
    required this.emptyTitle,
    this.emptyTitleStyle,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

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

    final emptyIcon = AnimatedSwitcher(
      duration: kThemeChangeDuration,
      child: this.emptyIcon,
    );

    final emptyTitleText = AnimatedDefaultTextStyle(
      style: emptyTitleStyle ?? chatThemeData.textTheme.headline,
      duration: kThemeChangeDuration,
      child: emptyTitle,
    );

    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        emptyIcon,
        emptyTitleText,
      ],
    );
  }
}
