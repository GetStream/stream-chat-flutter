import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

///
typedef PlatformBuilder<T> = T Function(
  BuildContext context,
);

///
abstract class PlatformWidgetBase<M extends Widget, D extends Widget,
    W extends Widget> extends StatelessWidget {
  ///
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

  ///
  M createMobileWidget(BuildContext context);

  ///
  D createDesktopWidget(BuildContext context);

  ///
  W createWebWidget(BuildContext context);
}
