import 'package:flutter/material.dart';

/// The default size for the icon inside the message input icon button.
const double kDefaultMessageInputIconSize = 32;

/// The default padding around the icon inside the message input icon button.
const double kDefaultMessageInputIconPadding = 4;

/// {@template streamMessageInputIconButton}
/// A customized [IconButton] for the message input.
///
/// This is used to create the send button, command button, and other icon
/// buttons in the message input.
/// {@endtemplate}
class StreamMessageInputIconButton extends StatelessWidget {
  /// {@macro streamMessageInputIconButton}
  const StreamMessageInputIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.disabledColor,
    this.iconSize = kDefaultMessageInputIconSize,
    this.padding = const EdgeInsets.all(kDefaultMessageInputIconPadding),
  });

  /// The icon to display inside the button.
  final Widget icon;

  /// The color to use for the icon inside the button, if the icon is enabled.
  /// Defaults to leaving this up to the [icon] widget.
  final Color? color;

  /// The color to use for the icon inside the button, if the icon is disabled.
  ///
  /// The icon is disabled if [onPressed] is null.
  final Color? disabledColor;

  /// The size of the icon inside the button.
  ///
  /// Defaults to 32.0.
  final double iconSize;

  /// The padding around the button's icon. The entire padded icon will react
  /// to input gestures.
  ///
  /// Defaults to EdgeInsets.zero.
  final EdgeInsetsGeometry padding;

  /// The callback that is called when the button is tapped or otherwise
  /// activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      color: color,
      disabledColor: disabledColor,
      iconSize: iconSize,
      onPressed: onPressed,
      padding: padding,
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: WidgetStateProperty.all(Size.square(iconSize)),
      ),
    );
  }
}
