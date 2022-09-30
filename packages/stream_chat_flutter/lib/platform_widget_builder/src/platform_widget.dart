import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/platform_widget_builder/src/platform_widget_base.dart';

/// A widget that will only be built for the specific Platforms:
///
/// See [PlatformWidgetBuilder] and [PlatformWidgetBase] for more.
///
/// Also see: [DesktopWidget] and [DesktopWidgetBase].
class PlatformWidget extends PlatformWidgetBase<Widget, Widget, Widget> {
  /// Builds a [PlatformWidget].
  const PlatformWidget({
    super.key,
    this.desktop,
    this.mobile,
    this.web,
  });

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
