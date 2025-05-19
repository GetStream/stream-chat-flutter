import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// Shows a modal dialog with customized transitions and backdrop effects.
///
/// This function is a wrapper around [showGeneralDialog] that provides
/// a consistent look and feel for message-related modals in Stream Chat.
///
/// Returns a [Future] that resolves to the value passed to [Navigator.pop]
/// when the dialog is closed.
Future<T?> showStreamMessageModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool useSafeArea = true,
  bool barrierDismissible = true,
  String? barrierLabel,
  Color? barrierColor,
  Duration transitionDuration = const Duration(milliseconds: 300),
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
        CurvedAnimation(parent: animation, curve: Curves.easeInOutBack),
      );

      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: ScaleTransition(scale: scaleAnimation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      final pageChild = Builder(builder: builder);

      var dialog = capturedThemes.wrap(pageChild);
      if (useSafeArea) dialog = SafeArea(child: dialog);
      return dialog;
    },
  );
}

/// {@template streamMessageModal}
/// A customized modal widget for displaying message-related content.
///
/// This widget provides a consistent container for message actions and other
/// message-related modal content. It handles layout, animation, and keyboard
/// adjustments automatically.
///
/// The modal can contain a header (optional) and content section (required),
/// and will adjust its position when the keyboard appears.
/// {@endtemplate}
class StreamMessageModal extends StatelessWidget {
  /// Creates a Stream message modal.
  ///
  /// The [contentBuilder] parameter is required to build the main content
  /// of the modal. The [headerBuilder] is optional and can be used to add
  /// a header above the main content.
  const StreamMessageModal({
    super.key,
    this.spacing = 8.0,
    this.headerBuilder,
    required this.contentBuilder,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.insetPadding = const EdgeInsets.all(8),
    this.alignment = Alignment.center,
  });

  /// Vertical spacing between header and content sections.
  final double spacing;

  /// Optional builder for the header section of the modal.
  final WidgetBuilder? headerBuilder;

  /// Required builder for the main content of the modal.
  final WidgetBuilder contentBuilder;

  /// The duration of the animation to show when the system keyboard intrudes
  /// into the space that the modal is placed in.
  ///
  /// Defaults to 100 milliseconds.
  final Duration insetAnimationDuration;

  /// The curve to use for the animation shown when the system keyboard intrudes
  /// into the space that the modal is placed in.
  ///
  /// Defaults to [Curves.decelerate].
  final Curve insetAnimationCurve;

  /// The amount of padding added to [MediaQueryData.viewInsets] on the outside
  /// of the modal. This defines the minimum space between the screen's edges
  /// and the modal.
  ///
  /// Defaults to `EdgeInsets.zero`.
  final EdgeInsets insetPadding;

  /// How to align the [StreamMessageModal].
  ///
  /// Defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final effectivePadding = MediaQuery.viewInsetsOf(context) + insetPadding;

    final child = Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            spacing: spacing,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: alignment.toCrossAxisAlignment(),
            children: [
              if (headerBuilder case final builder?) builder(context),
              contentBuilder(context),
            ],
          ),
        ),
      ),
    );

    return AnimatedPadding(
      padding: effectivePadding,
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: child,
      ),
    );
  }
}

/// Extension to convert [AlignmentGeometry] to the corresponding
/// [CrossAxisAlignment].
extension ColumnAlignmentExtension on AlignmentGeometry {
  /// Converts an [AlignmentGeometry] to the most appropriate
  /// [CrossAxisAlignment] value.
  CrossAxisAlignment toCrossAxisAlignment() {
    return switch (this) {
      // Center alignments
      Alignment.topCenter => CrossAxisAlignment.start,
      Alignment.center => CrossAxisAlignment.center,
      Alignment.bottomCenter => CrossAxisAlignment.center,
      AlignmentDirectional.topCenter => CrossAxisAlignment.start,
      AlignmentDirectional.center => CrossAxisAlignment.center,
      AlignmentDirectional.bottomCenter => CrossAxisAlignment.center,
      // Left alignments
      Alignment.topLeft => CrossAxisAlignment.start,
      Alignment.centerLeft => CrossAxisAlignment.start,
      Alignment.bottomLeft => CrossAxisAlignment.end,
      AlignmentDirectional.topStart => CrossAxisAlignment.start,
      AlignmentDirectional.centerStart => CrossAxisAlignment.start,
      AlignmentDirectional.bottomStart => CrossAxisAlignment.end,
      // Right alignments
      Alignment.topRight => CrossAxisAlignment.start,
      Alignment.centerRight => CrossAxisAlignment.end,
      Alignment.bottomRight => CrossAxisAlignment.end,
      AlignmentDirectional.topEnd => CrossAxisAlignment.start,
      AlignmentDirectional.centerEnd => CrossAxisAlignment.end,
      AlignmentDirectional.bottomEnd => CrossAxisAlignment.end,
      // Fallback
      _ => CrossAxisAlignment.center,
    };
  }
}
