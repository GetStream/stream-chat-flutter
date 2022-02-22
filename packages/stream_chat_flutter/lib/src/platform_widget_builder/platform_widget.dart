import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/platform_widget_builder/platform_widget_base.dart';

/// A widget that will only be built for the specific Platforms:
///
/// See [PlatformWidgetBuilder] for more.
class PlatformWidget extends PlatformWidgetBase<Widget, Widget, Widget> {
  /// Builds a [PlatformWidget].
  const PlatformWidget({
    Key? key,
    this.desktop,
    this.mobile,
    this.web,
  }) : super(key: key);

  /// The mobile widget to build.
  final PlatformBuilder<Widget?>? mobile;

  /// The desktop widget to build.
  final PlatformBuilder<Widget?>? desktop;

  /// The web widget to build.
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
