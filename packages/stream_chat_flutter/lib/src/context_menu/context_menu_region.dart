import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Signature for a function that builds a context menu widget.
///
/// The function receives the [BuildContext] and the [Offset] where
/// the menu should appear.
typedef ContextMenuBuilder =
    Widget Function(
      BuildContext context,
      Offset offset,
    );

/// Displays a custom context menu as a general dialog.
///
/// The [contextMenuBuilder] is used to construct the contents of the
/// context menu, typically positioned based on the triggering gesture.
///
/// The dialog can be customized using parameters such as [barrierColor],
/// [barrierLabel], [transitionDuration], [transitionBuilder], etc.
///
/// Returns a [Future] that resolves when the menu is dismissed.
Future<T?> showContextMenu<T>({
  required BuildContext context,
  required WidgetBuilder contextMenuBuilder,
  String? barrierLabel,
  Color? barrierColor,
  Duration transitionDuration = const Duration(milliseconds: 150),
  RouteTransitionsBuilder? transitionBuilder,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) async {
  assert(debugCheckHasMaterialLocalizations(context), '');
  final localizations = MaterialLocalizations.of(context);

  final capturedThemes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(context, rootNavigator: useRootNavigator).context,
  );

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    transitionDuration: transitionDuration,
    barrierColor: barrierColor ?? Colors.transparent,
    barrierLabel: barrierLabel ?? localizations.modalBarrierDismissLabel,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      if (transitionBuilder case final builder?) {
        return builder(context, animation, secondaryAnimation, child);
      }

      final fadeAnimation = CurveTween(curve: const Interval(0, 0.3));

      return FadeTransition(
        opacity: fadeAnimation.animate(animation),
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      final pageChild = Builder(builder: contextMenuBuilder);
      return capturedThemes.wrap(pageChild);
    },
  );
}

/// A widget that provides a region for showing a context menu.
///
/// When the user performs a long-press (on touch devices) or right-click
/// (on desktop/web), a custom context menu is displayed at the gesture location.
class ContextMenuRegion extends StatefulWidget {
  /// Creates a [ContextMenuRegion].
  ///
  /// The [child] is the widget wrapped by this region. When a gesture is
  /// detected on it, the [contextMenuBuilder] is used to construct the menu.
  const ContextMenuRegion({
    super.key,
    required this.child,
    required this.contextMenuBuilder,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Called to build the context menu when the gesture is triggered.
  ///
  /// The builder is given the [BuildContext] and the [Offset] of the gesture.
  final ContextMenuBuilder contextMenuBuilder;

  @override
  State<ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<ContextMenuRegion> {
  @override
  void initState() {
    super.initState();
    // Prevent the browser's native context menu on web.
    if (CurrentPlatform.isWeb) BrowserContextMenu.disableContextMenu();
  }

  @override
  void dispose() {
    // Restore browser context menu behavior.
    if (CurrentPlatform.isWeb) BrowserContextMenu.enableContextMenu();
    super.dispose();
  }

  Future<void> _showContextMenu(BuildContext context, Offset position) async {
    print('ContextMenuRegion: Showing context menu at $position');
    await showContextMenu(
      context: context,
      contextMenuBuilder: (context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: (it) => _showContextMenu(context, it.globalPosition),
      onSecondaryTapUp: (it) => _showContextMenu(context, it.globalPosition),
      child: widget.child,
    );
  }
}
