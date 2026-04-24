import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that is displayed when a [StreamScrollView] encounters an error
/// while loading the initial items.
class StreamScrollViewErrorWidget extends StatelessWidget {
  /// Creates a new instance of the [StreamScrollViewErrorWidget].
  const StreamScrollViewErrorWidget({
    super.key,
    this.errorTitle,
    this.errorTitleStyle,
    this.errorIcon,
    this.retryButtonText,
    this.retryButtonTextStyle,
    required this.onRetryPressed,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// The title of the error.
  final Widget? errorTitle;

  /// The style of the title.
  final TextStyle? errorTitleStyle;

  /// The icon to display when the list shows error.
  final Widget? errorIcon;

  /// The text to display in the retry button.
  final Widget? retryButtonText;

  /// The style of the retryButtonText.
  final TextStyle? retryButtonTextStyle;

  /// The callback to invoke when the user taps on the retry button.
  final VoidCallback onRetryPressed;

  /// The main axis size of the error view.
  final MainAxisSize mainAxisSize;

  /// The main axis alignment of the error view.
  final MainAxisAlignment mainAxisAlignment;

  /// The cross axis alignment of the error view.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;

    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final errorIcon = IconTheme.merge(
      data: IconThemeData(size: 32, color: colorScheme.textTertiary),
      child: this.errorIcon ?? Icon(icons.exclamationCircle),
    );

    final effectiveStyle = errorTitleStyle ?? textTheme.captionDefault.copyWith(color: colorScheme.textSecondary);
    final emptyTitleText = AnimatedDefaultTextStyle(
      style: effectiveStyle,
      duration: kThemeChangeDuration,
      child: errorTitle ?? Text(context.translations.genericErrorText),
    );

    final retryButton = StreamButton(
      size: .medium,
      type: .outline,
      style: .secondary,
      onPressed: onRetryPressed,
      child: Text(context.translations.retryLabel),
    );

    return Padding(
      padding: .symmetric(
        horizontal: spacing.md,
        vertical: spacing.xxxl,
      ),
      child: Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          errorIcon,
          SizedBox(height: spacing.xs),
          emptyTitleText,
          SizedBox(height: spacing.md),
          retryButton,
        ],
      ),
    );
  }
}
