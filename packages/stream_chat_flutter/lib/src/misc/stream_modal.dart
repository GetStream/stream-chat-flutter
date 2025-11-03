import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// Shows a modal dialog with customized transitions and backdrop effects.
///
/// This function is a wrapper around [showGeneralDialog] that provides
/// a consistent look and feel for modals in Stream Chat.
///
/// Returns a [Future] that resolves to the value passed to [Navigator.pop]
/// when the dialog is closed.
Future<T?> showStreamDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String? barrierLabel,
  Color? barrierColor,
  Duration transitionDuration = const Duration(milliseconds: 335),
  RouteTransitionsBuilder? transitionBuilder,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  assert(debugCheckHasMaterialLocalizations(context), '');
  final localizations = MaterialLocalizations.of(context);

  final theme = StreamChatTheme.of(context);
  final colorTheme = theme.colorTheme;

  final capturedThemes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(context, rootNavigator: useRootNavigator).context,
  );

  return showGeneralDialog(
    context: context,
    useRootNavigator: useRootNavigator,
    anchorPoint: anchorPoint,
    routeSettings: routeSettings,
    transitionDuration: transitionDuration,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? colorTheme.overlay,
    barrierLabel: barrierLabel ?? localizations.modalBarrierDismissLabel,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final sigma = 10 * animation.value;
      final scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
      );

      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: ScaleTransition(scale: scaleAnimation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      final pageChild = Builder(builder: builder);
      return capturedThemes.wrap(pageChild);
    },
  );
}
