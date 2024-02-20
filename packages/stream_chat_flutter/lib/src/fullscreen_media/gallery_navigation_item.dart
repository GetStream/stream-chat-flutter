import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/platform_widget_builder/src/platform_widget_builder.dart';

/// A widget for desktop and web users to be able to navigate left and right
/// through a gallery of images.
class GalleryNavigationItem extends StatelessWidget {
  /// Builds a [GalleryNavigationItem].
  const GalleryNavigationItem({
    super.key,
    required this.icon,
    this.iconSize = 48,
    required this.onPressed,
    required this.opacityAnimation,
    this.left,
    this.right,
  });

  /// The icon to display.
  final Widget icon;

  /// The size of the icon.
  ///
  /// Defaults to 48.
  final double iconSize;

  /// The callback to perform when the button is clicked.
  final VoidCallback onPressed;

  /// The animation for showing & hiding this widget.
  final ValueListenable<bool> opacityAnimation;

  /// The left-hand placement of the button.
  final double? left;

  /// The right-hand placement of the button.
  final double? right;

  @override
  Widget build(BuildContext context) {
    return PlatformWidgetBuilder(
      desktop: (_, child) => child,
      web: (_, child) => child,
      child: Positioned(
        left: left,
        right: right,
        top: MediaQuery.of(context).size.height / 2,
        child: ValueListenableBuilder<bool>(
          valueListenable: opacityAnimation,
          builder: (context, shouldShow, child) {
            return AnimatedOpacity(
              opacity: shouldShow ? 1 : 0,
              duration: kThemeAnimationDuration,
              child: child,
            );
          },
          child: Material(
            color: Colors.transparent,
            type: MaterialType.circle,
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              icon: icon,
              iconSize: iconSize,
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
