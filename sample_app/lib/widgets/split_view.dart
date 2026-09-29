import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../utils/window_size_class.dart';

/// Lays out [primary] and [secondary] side by side, separated by a divider.
///
/// Each pane keeps only the safe-area insets on its outer edges.
class SplitView extends StatelessWidget {
  const SplitView({
    super.key,
    required this.primary,
    required this.secondary,
    this.primaryWidth = 320,
  });

  /// The leading pane.
  final Widget primary;

  /// The trailing pane, which fills the width [primary] leaves.
  final Widget secondary;

  /// The width of [primary].
  final double primaryWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    return Row(
      children: [
        SizedBox(
          width: primaryWidth,
          child: MediaQuery.removePadding(
            context: context,
            removeLeft: !isLtr,
            removeRight: isLtr,
            child: primary,
          ),
        ),
        VerticalDivider(width: 1, thickness: 1, color: colorScheme.borderSubtle),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeLeft: isLtr,
            removeRight: !isLtr,
            child: secondary,
          ),
        ),
      ],
    );
  }
}

/// Shows [primary] beside [secondary] on a regular window, and only
/// [secondary] on a compact one.
///
/// [secondary] is the navigator for the trailing pane, and its root page is an
/// [AdaptiveSplitViewRoot]. On a compact window that root page shows
/// [primary], so both panes keep their state as the window changes size.
class AdaptiveSplitView extends StatefulWidget {
  const AdaptiveSplitView({
    super.key,
    required this.primary,
    required this.secondary,
  });

  /// The leading pane, such as a list.
  final Widget primary;

  /// The navigator for the trailing pane.
  final Widget secondary;

  @override
  State<AdaptiveSplitView> createState() => _AdaptiveSplitViewState();
}

class _AdaptiveSplitViewState extends State<AdaptiveSplitView> {
  // Moves the primary pane between the leading pane and the root page.
  final _primaryKey = GlobalKey(debugLabel: 'AdaptiveSplitView.primary');

  @override
  Widget build(BuildContext context) {
    final isExpanded = WindowSizeClass.of(context) == .regular;

    return _AdaptiveSplitViewScope(
      isExpanded: isExpanded,
      primaryKey: _primaryKey,
      primary: widget.primary,
      child: switch (isExpanded) {
        true => SplitView(
          primary: KeyedSubtree(key: _primaryKey, child: widget.primary),
          secondary: widget.secondary,
        ),
        false => widget.secondary,
      },
    );
  }
}

class _AdaptiveSplitViewScope extends InheritedWidget {
  const _AdaptiveSplitViewScope({
    required this.isExpanded,
    required this.primaryKey,
    required this.primary,
    required super.child,
  });

  final bool isExpanded;
  final GlobalKey primaryKey;
  final Widget primary;

  static _AdaptiveSplitViewScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AdaptiveSplitViewScope>();
    assert(scope != null, 'No AdaptiveSplitView found in context.');
    return scope!;
  }

  @override
  bool updateShouldNotify(_AdaptiveSplitViewScope oldWidget) {
    return isExpanded != oldWidget.isExpanded || primary != oldWidget.primary;
  }
}

/// The root page of an [AdaptiveSplitView]'s navigator.
///
/// Shows the split view's primary pane on a compact window, and [placeholder]
/// while both panes are shown.
class AdaptiveSplitViewRoot extends StatelessWidget {
  const AdaptiveSplitViewRoot({
    super.key,
    required this.placeholder,
  });

  /// Fills the trailing pane while nothing is open in it.
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    final scope = _AdaptiveSplitViewScope.of(context);
    if (scope.isExpanded) return placeholder;

    return KeyedSubtree(key: scope.primaryKey, child: scope.primary);
  }
}
