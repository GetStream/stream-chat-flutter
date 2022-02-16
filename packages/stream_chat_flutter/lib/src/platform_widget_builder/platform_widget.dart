import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/platform_widget_builder/platform_widget_base.dart';

///
class PlatformWidget extends PlatformWidgetBase<Widget, Widget, Widget> {
  ///
  const PlatformWidget({
    Key? key,
    this.desktop,
    this.mobile,
    this.web,
  }) : super(key: key);

  ///
  final PlatformBuilder<Widget?>? mobile;

  ///
  final PlatformBuilder<Widget?>? desktop;

  ///
  final PlatformBuilder<Widget?>? web;

  @override
  Widget createDesktopWidget(BuildContext context) =>
      desktop?.call(context) ?? const SizedBox.shrink();

  @override
  Widget createMobileWidget(BuildContext context) =>
      mobile?.call(context) ?? const SizedBox.shrink();

  @override
  Widget createWebWidget(BuildContext context) =>
      web?.call(context) ?? const SizedBox.shrink();
}
