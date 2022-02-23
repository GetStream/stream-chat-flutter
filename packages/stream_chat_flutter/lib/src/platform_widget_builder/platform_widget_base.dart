import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A generic widget builder function.
typedef PlatformBuilder<T> = T Function(
  BuildContext context,
);

/// An abstract class used as a building block for creating [PlatformWidget]s.
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return createWebWidget(context);
    } else if (Platform.isAndroid || Platform.isIOS) {
      return createMobileWidget(context);
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return createDesktopWidget(context);
    }

    return throw UnsupportedError(
      'This platform is not supported: $defaultTargetPlatform',
    );
  }

  /// Builds a `M` mobile widget.
  M createMobileWidget(BuildContext context);

  /// Builds a `D` desktop widget.
  D createDesktopWidget(BuildContext context);

  /// Builds a `W` web widget.
  W createWebWidget(BuildContext context);
}