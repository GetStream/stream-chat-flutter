import 'package:flutter/material.dart';

/// A simple wrapper around Flutter's [SafeArea] widget.
///
/// [SimpleSafeArea] provides a convenient way to avoid system intrusions
/// (such as notches, status bars, and navigation bars) on all or specific sides.
/// By default, all sides are enabled. Use [SimpleSafeArea.only] to specify sides.
///
/// See also:
///  - [SafeArea], which this widget wraps.
///
class SimpleSafeArea extends StatelessWidget {
  /// Creates a [SimpleSafeArea] that avoids system intrusions either on all
  /// sides or none.
  const SimpleSafeArea({
    super.key,
    bool? enabled,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
    required this.child,
  })  : left = enabled ?? true,
        top = enabled ?? true,
        right = enabled ?? true,
        bottom = enabled ?? true;

  /// Creates a [SimpleSafeArea] that avoids system intrusions only on the
  /// specified sides.
  const SimpleSafeArea.only({
    super.key,
    this.left = false,
    this.top = false,
    this.right = false,
    this.bottom = false,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
    required this.child,
  });

  /// Whether to avoid system intrusions on the left.
  final bool left;

  /// Whether to avoid system intrusions at the top of the screen, typically the
  /// system status bar.
  final bool top;

  /// Whether to avoid system intrusions on the right.
  final bool right;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  final bool bottom;

  /// This minimum padding to apply.
  ///
  /// The greater of the minimum insets and the media padding will be applied.
  final EdgeInsets minimum;

  /// Specifies whether the [SafeArea] should maintain the bottom
  /// [MediaQueryData.viewPadding] instead of the bottom [MediaQueryData.padding],
  /// defaults to false.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// SafeArea, the padding can be maintained below the obstruction rather than
  /// being consumed. This can be helpful in cases where your layout contains
  /// flexible widgets, which could visibly move when opening a software
  /// keyboard due to the change in the padding value. Setting this to true will
  /// avoid the UI shift.
  final bool maintainBottomViewPadding;

  /// The widget below this widget in the tree.
  ///
  /// The padding on the [MediaQuery] for the [child] will be suitably adjusted
  /// to zero out any sides that were avoided by this widget.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}
