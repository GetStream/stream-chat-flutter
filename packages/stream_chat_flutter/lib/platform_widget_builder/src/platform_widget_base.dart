import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';

/// A generic widget builder function.
typedef PlatformBuilder<T> = T Function(
  BuildContext context,
);

/// An abstract class used as a building block for creating [PlatformWidget]s.
///
/// This class broadly covers the platforms by combining Android and iOS
/// together as a "mobile" category, macOS, Windows, and Linux together as a
/// "desktop" category. This is useful is cases where a widget is expected to
/// be the same for the various mobile and desktop categories, and would
/// therefore be tedious to return the same widget more than once for the
/// specified category. This is unlike [DesktopWidgetBase], which more
/// specifically targets the various platforms in the "desktop" category.
///
/// This class utilizes generics to define the types of widgets it expects to
/// build:
/// * M = Mobile
/// * D = Desktop
/// * W = Web
abstract class PlatformWidgetBase<M extends Widget, D extends Widget,
    W extends Widget> extends StatelessWidget {
  /// Builds a [PlatformWidgetBase].
  const PlatformWidgetBase({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      return createMobileWidget(context);
    } else if (platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows ||
        platform == TargetPlatform.linux) {
      return createDesktopWidget(context);
    } else {
      return createWebWidget(context);
    }
  }

  /// Builds a `M` mobile widget.
  M createMobileWidget(BuildContext context);

  /// Builds a `D` desktop widget.
  D createDesktopWidget(BuildContext context);

  /// Builds a `W` web widget.
  W createWebWidget(BuildContext context);
}
