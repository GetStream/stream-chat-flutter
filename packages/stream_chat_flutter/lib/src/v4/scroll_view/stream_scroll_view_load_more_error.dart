import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';

/// A tile that is used to display the error indicator when
/// loading more items fails.
class StreamScrollViewLoadMoreError extends StatelessWidget {
  /// Creates a new instance of [StreamScrollViewLoadMoreError.list].
  const StreamScrollViewLoadMoreError.list({
    Key? key,
    this.error,
    this.errorStyle,
    this.errorIcon,
    this.backgroundColor,
    required this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : _isList = true,
        super(key: key);

  /// Creates a new instance of [StreamScrollViewLoadMoreError.grid].
  const StreamScrollViewLoadMoreError.grid({
    Key? key,
    this.error,
    this.errorStyle,
    this.errorIcon,
    this.backgroundColor,
    required this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : _isList = false,
        super(key: key);

  /// The error message to display.
  final Widget? error;

  /// The style of the error message.
  final TextStyle? errorStyle;

  /// The icon to display next to the message.
  final Widget? errorIcon;

  /// The background color of the error message.
  final Color? backgroundColor;

  /// The callback to invoke when the user taps on the error indicator.
  final GestureTapCallback onTap;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry padding;

  /// The main axis size of the error view.
  final MainAxisSize mainAxisSize;

  /// The main axis alignment of the error view.
  final MainAxisAlignment mainAxisAlignment;

  /// The cross axis alignment of the error view.
  final CrossAxisAlignment crossAxisAlignment;

  final bool _isList;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    final errorText = AnimatedDefaultTextStyle(
      style: errorStyle ?? theme.textTheme.body.copyWith(color: Colors.white),
      duration: kThemeChangeDuration,
      child: error ?? const SizedBox(),
    );

    final errorIcon = AnimatedSwitcher(
      duration: kThemeChangeDuration,
      child: this.errorIcon ?? StreamSvgIcon.retry(color: Colors.white),
    );

    final backgroundColor = this.backgroundColor ??
        theme.colorTheme.textLowEmphasis.withOpacity(0.9);

    final children = [errorText, errorIcon];

    return InkWell(
      onTap: onTap,
      child: Container(
        color: backgroundColor,
        child: Padding(
          padding: padding,
          child: _isList
              ? Row(
                  mainAxisSize: mainAxisSize,
                  mainAxisAlignment: mainAxisAlignment,
                  crossAxisAlignment: crossAxisAlignment,
                  children: children,
                )
              : Column(
                  mainAxisSize: mainAxisSize,
                  mainAxisAlignment: mainAxisAlignment,
                  crossAxisAlignment: crossAxisAlignment,
                  children: children,
                ),
        ),
      ),
    );
  }
}
