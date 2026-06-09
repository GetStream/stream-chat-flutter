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
    final spacing = context.streamSpacing;

    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final effectiveTitleStyle = emptyTitleStyle ?? textTheme.captionDefault.copyWith(color: colorScheme.textSecondary);

    final emptyIcon = IconTheme.merge(
      data: IconThemeData(
        size: 32,
        color: colorScheme.textTertiary,
      ),
      child: this.emptyIcon,
    );

    final emptyTitleText = AnimatedDefaultTextStyle(
      style: effectiveTitleStyle,
      duration: kThemeChangeDuration,
      child: emptyTitle,
    );

    return Padding(
      padding: .symmetric(
        horizontal: spacing.md,
        vertical: spacing.xxxl,
      ),
      child: Column(
        spacing: spacing.sm,
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [emptyIcon, emptyTitleText],
      ),
    );
  }
}
