import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';

/// A generic widget builder function.
typedef PlatformBuilder<T> = T Function(
  BuildContext context,
);

/// An abstract class used as a building block for creating
/// [DesktopPlatformWidget]s.
///
/// This class is similar to [PlatformWidgetBase], which broadly covers
/// the platform categories; it combines the desktop platforms into a single
/// "desktop" target, for the purpose of returning the same widget one time
/// for all platforms in that category. [DesktopWidgetBase] differs in that
/// it more specifically targets each platform in the "desktop" category.
///
/// This class utilizes generics to define the types of widgets it expects to
/// build:
/// * M = macOS
/// * W = Windows
/// * L = Linux
abstract class DesktopWidgetBase<M extends Widget, W extends Widget,
    L extends Widget> extends StatelessWidget {
  /// Builds a [DesktopWidgetBase].
  const DesktopWidgetBase({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.macOS) {
      return createMacosWidget(context);
    } else if (platform == TargetPlatform.windows) {
      return createWindowsWidget(context);
    } else if (platform == TargetPlatform.linux) {
      return createLinuxWidget(context);
    }

    return throw UnsupportedError(
      'This platform is not supported: $defaultTargetPlatform',
    );
  }

  /// Builds a `M` macOS widget.
  M createMacosWidget(BuildContext context);

  /// Builds a `W` Windows widget.
  W createWindowsWidget(BuildContext context);

  /// Builds a `L` Linux widget.
  L createLinuxWidget(BuildContext context);
}
