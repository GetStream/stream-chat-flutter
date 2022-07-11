import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/platform_widget_builder/src/platform_widget.dart';

/// A widget-building function that includes the child widget.
typedef PlatformTargetBuilder = Widget? Function(
  BuildContext context,
  Widget? child,
)?;

/// A widget that utilizes [PlatformTargetBuilder]s to build different widgets
/// for each specified platform.
///
/// In the following real-world example, only the `mobile` builder is used
/// to ensure the child widget is only built for Android and iOS:
/// ```
/// PlatformWidgetBuilder(
///   mobile: (context, child) => _buildFilePickerSection(),
/// ),
/// ```
class PlatformWidgetBuilder extends StatelessWidget {
  /// Builds a [PlatformWidgetBuilder].
  const PlatformWidgetBuilder({
    super.key,
    this.child,
    this.mobile,
    this.desktop,
    this.web,
  });

  /// The child widget.
  final Widget? child;

  /// The widget to build for mobile platforms.
  final PlatformTargetBuilder? mobile;

  /// The widget to build for desktop platforms.
  final PlatformTargetBuilder? desktop;

  /// The widget to build for web platforms.
  final PlatformTargetBuilder? web;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      desktop: (context) => desktop?.call(context, child),
      mobile: (context) => mobile?.call(context, child),
      web: (context) => web?.call(context, child),
    );
  }
}
