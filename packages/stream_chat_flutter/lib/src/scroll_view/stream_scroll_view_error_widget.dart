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
    this.errorSubtitle,
    this.errorSubtitleStyle,
    this.errorIcon,
    this.retryButtonText,
    this.retryButtonTextStyle,
    required this.onRetryPressed,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// The title of the error.
  ///
  /// Defaults to a generic localized error title.
  final Widget? errorTitle;

  /// The style of the title.
  final TextStyle? errorTitleStyle;

  /// An optional supporting description shown below the title.
  ///
  /// When no [errorTitle] is supplied, this defaults to a generic localized
  /// description so the out-of-the-box error state matches the design.
  final Widget? errorSubtitle;

  /// The style of the subtitle.
  final TextStyle? errorSubtitleStyle;

  /// The icon to display when the list shows error.
  final Widget? errorIcon;

  /// The text to display in the retry button.
  ///
  /// Defaults to a localized "Try Again" label.
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
    final translations = context.translations;

    final icon = IconTheme.merge(
      data: IconThemeData(size: 32, color: colorScheme.textTertiary),
      child: errorIcon ?? Icon(icons.exclamationCircle),
    );

    final effectiveErrorTitle = errorTitle ?? Text(translations.genericErrorTitle);
    // The generic subtitle only pairs with the generic title, not a custom one.
    final resolvedSubtitle = errorSubtitle ?? (errorTitle == null ? Text(translations.genericErrorDescription) : null);
    final effectiveTitleStyle = errorTitleStyle ?? textTheme.headingSm.copyWith(color: colorScheme.textPrimary);
    final effectiveSubtitleStyle =
        errorSubtitleStyle ?? textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary);
    final effectiveRetryButtonText = retryButtonText ?? Text(translations.tryAgainLabel);

    final title = AnimatedDefaultTextStyle(
      style: effectiveTitleStyle,
      textAlign: TextAlign.center,
      duration: kThemeChangeDuration,
      child: effectiveErrorTitle,
    );

    Widget? subtitle;
    if (resolvedSubtitle != null) {
      subtitle = Padding(
        padding: .only(top: spacing.xs),
        child: AnimatedDefaultTextStyle(
          style: effectiveSubtitleStyle,
          textAlign: TextAlign.center,
          duration: kThemeChangeDuration,
          child: resolvedSubtitle,
        ),
      );
    }

    final retryButton = StreamButton(
      size: .medium,
      type: .outline,
      style: .secondary,
      onPressed: onRetryPressed,
      child: effectiveRetryButtonText,
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
          icon,
          SizedBox(height: spacing.sm),
          title,
          ?subtitle,
          SizedBox(height: spacing.md),
          retryButton,
        ],
      ),
    );
  }
}
