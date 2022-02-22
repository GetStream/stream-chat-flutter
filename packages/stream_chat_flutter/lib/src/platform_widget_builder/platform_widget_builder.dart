import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/platform_widget_builder/platform_widget.dart';

///
typedef PlatformTargetBuilder = Widget? Function(
  BuildContext context,
  Widget? child,
)?;

///
class PlatformWidgetBuilder extends StatelessWidget {
  ///
  const PlatformWidgetBuilder({
    Key? key,
    this.child,
    this.mobile,
    this.desktop,
    this.web,
  }) : super(key: key);

  ///
  final Widget? child;

  ///
  final PlatformTargetBuilder? mobile;

  ///
  final PlatformTargetBuilder? desktop;

  ///
  final PlatformTargetBuilder? web;

  @override
  Widget build(BuildContext context) => PlatformWidget(
        desktop: (context) => desktop?.call(context, child),
        mobile: (context) => mobile?.call(context, child),
        web: (context) => web?.call(context, child),
      );
}
