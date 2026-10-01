import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../utils/window_size_class.dart';

/// A layout that places [primary] and [secondary] side by side, separated by a
/// divider.
///
/// When a fold or hinge divides the window into a left and a right side, each
/// pane fills one side, easing into place as the fold appears or disappears.
/// Each pane keeps only the safe-area insets on its outer edges. Assumes it
/// fills the window.
class SplitView extends StatelessWidget {
  const SplitView({
    super.key,
    required this.primary,
    required this.secondary,
    this.primaryWidth = 320.0,
  });

  /// The leading pane.
  final Widget primary;

  /// The trailing pane, which fills the width [primary] leaves.
  final Widget secondary;

  /// The width of [primary] while no fold or hinge divides the window.
  final double primaryWidth;

  // The width of the line between the panes.
  static const _dividerWidth = 1.0;

  // How long the panes take to settle when a fold starts or stops dividing
  // the window.
  static const _foldTransitionDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    final (targetPrimaryWidth, dividerWidth) = switch (_verticalFold(mediaQuery)) {
      final fold? => (isLtr ? fold.left : mediaQuery.size.width - fold.right, math.max(fold.width, _dividerWidth)),
      null => (primaryWidth, _dividerWidth),
    };

    return TweenAnimationBuilder<double>(
      tween: Tween(end: targetPrimaryWidth),
      duration: mediaQuery.disableAnimations ? Duration.zero : _foldTransitionDuration,
      curve: Curves.easeInOut,
      builder: (context, primaryPaneWidth, _) => _buildPanes(
        context,
        mediaQuery: mediaQuery,
        primaryPaneWidth: primaryPaneWidth,
        dividerWidth: dividerWidth,
      ),
    );
  }

  Widget _buildPanes(
    BuildContext context, {
    required MediaQueryData mediaQuery,
    required double primaryPaneWidth,
    required double dividerWidth,
  }) {
    final colorScheme = context.streamColorScheme;
    final Size(:width, :height) = mediaQuery.size;
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    // Each pane's area on the window, which the insets and folds are relative to.
    final secondaryPaneWidth = width - primaryPaneWidth - dividerWidth;
    final primaryPane = Rect.fromLTWH(isLtr ? 0 : width - primaryPaneWidth, 0, primaryPaneWidth, height);
    final secondaryPane = Rect.fromLTWH(isLtr ? width - secondaryPaneWidth : 0, 0, secondaryPaneWidth, height);

    return Row(
      children: [
        SizedBox(
          width: primaryPaneWidth,
          child: MediaQuery(
            data: mediaQuery.removeDisplayFeatures(primaryPane),
            child: primary,
          ),
        ),
        VerticalDivider(
          width: dividerWidth,
          thickness: _dividerWidth,
          color: colorScheme.borderSubtle,
        ),
        Expanded(
          child: MediaQuery(
            data: mediaQuery.removeDisplayFeatures(secondaryPane),
            child: secondary,
          ),
        ),
      ],
    );
  }
}

// The fold or hinge that divides the window into a left and a right side, if any.
Rect? _verticalFold(MediaQueryData mediaQuery) {
  final Size(:width, :height) = mediaQuery.size;
  return DisplayFeatureSubScreen.avoidBounds(mediaQuery).firstWhereOrNull(
    (it) => it.top <= 0 && it.bottom >= height && it.left > 0 && it.right < width,
  );
}

/// A split view that shows [primary] beside [secondary] on a
/// [WindowWidthClass.expanded] window, and only [secondary] otherwise.
///
/// Both panes also need a window that is at least [WindowHeightClass.medium],
/// so a phone in landscape shows one pane at a time.
///
/// [secondary] is the navigator for the trailing pane, and its root page is an
/// [AdaptiveSplitViewRoot]. While only [secondary] is shown, that root page
/// shows [primary], so both panes keep their state as the window changes size. Its
/// pages are [AdaptiveSplitViewPage]s, which swap in place beside [primary].
///
/// ```dart
/// ShellRoute(
///   builder: (context, state, child) {
///     return AdaptiveSplitView(primary: const ChannelListPage(), secondary: child);
///   },
///   routes: [
///     GoRoute(
///       path: '/channels',
///       pageBuilder: (context, state) {
///         return AdaptiveSplitViewPage<void>(
///           key: state.pageKey,
///           child: const AdaptiveSplitViewRoot(placeholder: ChannelPlaceholderPage()),
///         );
///       },
///       routes: [/* The routes that open in the trailing pane. */],
///     ),
///   ],
/// )
/// ```
class AdaptiveSplitView extends StatefulWidget {
  const AdaptiveSplitView({
    super.key,
    required this.primary,
    required this.secondary,
    this.drawer,
  });

  /// The leading pane, such as a list.
  final Widget primary;

  /// The navigator for the trailing pane.
  final Widget secondary;

  /// A panel that slides in over both panes while they are shown side by side.
  ///
  /// Typically a [Drawer], opened with [openDrawerOf]. While only the navigator
  /// is shown, the pages in it can host a drawer of their own.
  final Widget? drawer;

  /// Whether the nearest [AdaptiveSplitView] shows both panes.
  ///
  /// Returns `false` when there is no [AdaptiveSplitView] above [context]. The
  /// widget that owns [context] rebuilds only when the split view expands or
  /// collapses.
  static bool isExpandedOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AdaptiveSplitViewScope>();
    return scope?.isExpanded ?? false;
  }

  /// Opens the [drawer] of the nearest [AdaptiveSplitView] above [context].
  ///
  /// Does nothing when that split view shows one pane or has no [drawer].
  static void openDrawerOf(BuildContext context) {
    final state = context.findAncestorStateOfType<_AdaptiveSplitViewState>();
    state?._drawerKey.currentState?.open();
  }

  @override
  State<AdaptiveSplitView> createState() => _AdaptiveSplitViewState();
}

class _AdaptiveSplitViewState extends State<AdaptiveSplitView> {
  // Moves the primary pane between the leading pane and the root page.
  final _primaryKey = GlobalKey(debugLabel: 'AdaptiveSplitView.primary');

  // Opens and closes the drawer that spans both panes.
  final _drawerKey = GlobalKey<DrawerControllerState>(debugLabel: 'AdaptiveSplitView.drawer');

  @override
  Widget build(BuildContext context) {
    final sizeClass = WindowSizeClass.of(context);
    final isExpanded = sizeClass.width.isAtLeast(.expanded) && sizeClass.height.isAtLeast(.medium);

    return _AdaptiveSplitViewScope(
      isExpanded: isExpanded,
      primaryKey: _primaryKey,
      primary: widget.primary,
      child: switch (isExpanded) {
        true => _buildSplit(),
        false => widget.secondary,
      },
    );
  }

  Widget _buildSplit() {
    final split = SplitView(
      primary: KeyedSubtree(key: _primaryKey, child: widget.primary),
      secondary: widget.secondary,
    );

    final drawer = widget.drawer;
    if (drawer == null) return split;

    final isLtr = Directionality.of(context) == TextDirection.ltr;

    return Stack(
      fit: .expand,
      children: [
        split,
        // The drawer only reaches the leading edge, so it keeps only that edge's inset.
        MediaQuery.removePadding(
          context: context,
          removeLeft: !isLtr,
          removeRight: isLtr,
          child: DrawerController(
            key: _drawerKey,
            alignment: .start,
            child: drawer,
          ),
        ),
      ],
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
/// Shows the split view's primary pane while only the navigator is shown, and
/// [placeholder] while both panes are shown.
class AdaptiveSplitViewRoot extends StatelessWidget {
  const AdaptiveSplitViewRoot({
    super.key,
    required this.placeholder,
  });

  /// The widget that fills the trailing pane while nothing is open in it.
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    final scope = _AdaptiveSplitViewScope.of(context);
    if (scope.isExpanded) return placeholder;

    return KeyedSubtree(key: scope.primaryKey, child: scope.primary);
  }
}

/// A page for the navigator of an [AdaptiveSplitView]'s trailing pane.
///
/// Swaps in without a transition while both panes are shown, and uses the
/// platform's page transition when only the navigator is.
class AdaptiveSplitViewPage<T> extends Page<T> {
  const AdaptiveSplitViewPage({
    super.key,
    super.name,
    required this.child,
  });

  /// The content of the page.
  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) => _AdaptiveSplitViewPageRoute<T>(page: this);
}

class _AdaptiveSplitViewPageRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  _AdaptiveSplitViewPageRoute({required AdaptiveSplitViewPage<T> page}) : super(settings: page);

  AdaptiveSplitViewPage<T> get _page => settings as AdaptiveSplitViewPage<T>;

  @override
  Widget buildContent(BuildContext context) => _page.child;

  @override
  bool get maintainState => true;

  @override
  bool get fullscreenDialog => false;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (AdaptiveSplitView.isExpandedOf(context)) return child;
    return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}
