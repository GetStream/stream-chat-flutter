import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/platform_widget_builder/src/desktop_widget.dart';

/// A widget-building function that includes the child widget.
typedef DesktopTargetBuilder = Widget? Function(
  BuildContext context,
  Widget? child,
)?;

/// A widget that utilizes [DesktopWidgetBuilder]s to build different widgets
/// for each specified desktop platform.
///
/// Usage:
/// ```
/// DesktopWidgetBuilder(
///   macOS: (context, child) => MacosWidget(),
///   windows: (context, child) => WindowsWidget(),
///   linux: (context, child) => LinuxWidget(),
/// ),
/// ```
class DesktopWidgetBuilder extends StatelessWidget {
  /// Builds a [DesktopWidgetBuilder].
  const DesktopWidgetBuilder({
    super.key,
    this.child,
    this.macOS,
    this.windows,
    this.linux,
  });

  /// The child widget.
  final Widget? child;

  /// The widget to build for macOS.
  final DesktopTargetBuilder? macOS;

  /// The widget to build for windows.
  final DesktopTargetBuilder? windows;

  /// The widget to build for linux.
  final DesktopTargetBuilder? linux;

  @override
  Widget build(BuildContext context) {
    return DesktopWidget(
      macOS: (context) => macOS?.call(context, child),
      windows: (context) => windows?.call(context, child),
      linux: (context) => linux?.call(context, child),
    );
  }
}
