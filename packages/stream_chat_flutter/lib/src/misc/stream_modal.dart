import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
  final colorScheme = context.streamColorScheme;

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
    barrierColor: barrierColor ?? colorScheme.backgroundOverlayLight,
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
      final pageChild = Portal(child: Builder(builder: builder));
      return StreamChatTheme(data: theme, child: capturedThemes.wrap(pageChild));
    },
  );
}
