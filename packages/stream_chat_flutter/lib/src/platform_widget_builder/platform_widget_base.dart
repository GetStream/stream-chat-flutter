import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:stream_chat_flutter/src/platform_widget_builder/platform_target.dart';

///
typedef PlatformBuilder<T> = T Function(
  BuildContext context,
  //PlatformTarget platform,
);
/*typedef T PlatformIndexBuilder<T>(
  BuildContext context,
  PlatformTarget platform,
  int index,
);*/

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
      return createMobileWidget(context);
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
