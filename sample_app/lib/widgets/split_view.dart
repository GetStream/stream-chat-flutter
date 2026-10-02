import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show objectRuntimeType;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../utils/window_size_class.dart';

/// A layout that places [primary] and [secondary] side by side, separated by a
/// divider that people can drag to resize the panes.
///
/// When a fold or hinge divides the window into a left and a right side, each
/// pane fills one side, easing into place as the fold appears or disappears,
/// and the divider can't be dragged. Each pane keeps only the safe-area insets
/// on its outer edges. Assumes it fills the window.
class SplitView extends StatefulWidget {
  const SplitView({
    super.key,
    required this.primary,
    required this.secondary,
    this.primaryConstraints = const SplitPaneConstraints(minWidth: 280, initialWidth: 320, maxWidth: 420),
    this.secondaryConstraints = const SplitPaneConstraints(minWidth: 360),
  });

  /// The leading pane.
  final Widget primary;

  /// The trailing pane, which fills the width [primary] leaves.
  final Widget secondary;

  /// The widths [primary] starts at and can be resized within.
  final SplitPaneConstraints primaryConstraints;

  /// The widths [secondary] starts at and can be resized within.
  ///
  /// Its [SplitPaneConstraints.minWidth] wins over [primaryConstraints] on a
  /// window too narrow for both.
  final SplitPaneConstraints secondaryConstraints;

  @override
  State<SplitView> createState() => _SplitViewState();
}

/// The widths a [SplitView] pane starts at and can be resized within.
@immutable
class SplitPaneConstraints {
  const SplitPaneConstraints({
    this.minWidth = 0.0,
    this.initialWidth,
    this.maxWidth = double.infinity,
  }) : assert(0 <= minWidth && minWidth <= maxWidth, 'minWidth must be between 0 and maxWidth.'),
       assert(
         initialWidth == null || (minWidth <= initialWidth && initialWidth <= maxWidth),
         'initialWidth must be between minWidth and maxWidth.',
       );

  /// The narrowest people can make the pane.
  final double minWidth;

  /// The width of the pane until people resize it.
  ///
  /// When both panes have one, the leading pane's wins. When neither does,
  /// the leading pane starts at its narrowest.
  final double? initialWidth;

  /// The widest people can make the pane.
  final double maxWidth;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SplitPaneConstraints &&
        other.minWidth == minWidth &&
        other.initialWidth == initialWidth &&
        other.maxWidth == maxWidth;
  }

  @override
  int get hashCode => Object.hash(minWidth, initialWidth, maxWidth);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'SplitPaneConstraints')}'
        '(minWidth: $minWidth, initialWidth: $initialWidth, maxWidth: $maxWidth)';
  }
}

class _SplitViewState extends State<SplitView> {
  // The width of the line between the panes.
  static const _dividerWidth = 1.0;

  // How far one keyboard or screen reader step resizes the panes.
  static const _resizeStep = 20.0;

  // How long the panes take to settle when a fold starts or stops dividing
  // the window, or a keyboard or screen reader step resizes them.
  static const _transitionDuration = Duration(milliseconds: 200);

  // The width people resized [SplitView.primary] to, if they have.
  double? _resizedPrimaryWidth;

  // Whether people are dragging the divider, which the panes follow without easing.
  var _isDragging = false;

  // The range people can resize [SplitView.primary] within on a window [width]
  // wide, where both panes' constraints hold.
  ({double min, double max}) _primaryWidthRange(double width) {
    final SplitView(:primaryConstraints, :secondaryConstraints) = widget;
    final available = width - _dividerWidth;
    final max = math.min(primaryConstraints.maxWidth, available - secondaryConstraints.minWidth);
    final min = math.max(primaryConstraints.minWidth, available - secondaryConstraints.maxWidth);
    return (min: math.min(min, max), max: max);
  }

  // The width of [SplitView.primary] on a window [width] wide.
  double _primaryWidth(double width) {
    final SplitView(:primaryConstraints, :secondaryConstraints) = widget;
    final range = _primaryWidthRange(width);
    final initialWidth = switch ((primaryConstraints.initialWidth, secondaryConstraints.initialWidth)) {
      (final primary?, _) => primary,
      (null, final secondary?) => width - _dividerWidth - secondary,
      (null, null) => range.min,
    };
    return (_resizedPrimaryWidth ?? initialWidth).clamp(range.min, range.max);
  }

  void _resizeBy(double delta, double width) {
    final range = _primaryWidthRange(width);
    setState(() => _resizedPrimaryWidth = (_primaryWidth(width) + delta).clamp(range.min, range.max));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    final fold = _verticalFold(mediaQuery);
    final range = _primaryWidthRange(width);
    final primaryWidth = switch (fold) {
      final fold? => isLtr ? fold.left : width - fold.right,
      null => _primaryWidth(width),
    };
    final dividerWidth = math.max(fold?.width ?? 0, _dividerWidth);

    // Builds the same tree with or without a fold, so the panes ease between the two.
    return Stack(
      fit: .expand,
      children: [
        _buildAnimatedPanes(mediaQuery, primaryWidth, dividerWidth),
        if (fold == null)
          PositionedDirectional(
            top: 0,
            bottom: 0,
            start: primaryWidth + (_dividerWidth - _SplitViewDivider.hitWidth) / 2,
            width: _SplitViewDivider.hitWidth,
            child: _SplitViewDivider(
              primaryWidth: primaryWidth,
              minPrimaryWidth: range.min,
              maxPrimaryWidth: range.max,
              windowWidth: width,
              step: _resizeStep,
              onResizeStart: () => setState(() => _isDragging = true),
              onResize: (delta) => _resizeBy(delta, width),
              onResizeEnd: () => setState(() => _isDragging = false),
              onStep: (delta) => _resizeBy(delta, width),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedPanes(MediaQueryData mediaQuery, double primaryWidth, double dividerWidth) {
    final animate = !_isDragging && !mediaQuery.disableAnimations;

    return TweenAnimationBuilder<double>(
      tween: Tween(end: primaryWidth),
      duration: animate ? _transitionDuration : Duration.zero,
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
            child: widget.primary,
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
            child: widget.secondary,
          ),
        ),
      ],
    );
  }
}

// The area around the line between a split view's panes that people drag, or
// step with the arrow keys or a screen reader, to resize them.
class _SplitViewDivider extends StatefulWidget {
  const _SplitViewDivider({
    required this.primaryWidth,
    required this.minPrimaryWidth,
    required this.maxPrimaryWidth,
    required this.windowWidth,
    required this.step,
    required this.onResizeStart,
    required this.onResize,
    required this.onResizeEnd,
    required this.onStep,
  });

  // The width of the area, centered on the line, that responds to a drag.
  static const hitWidth = 44.0;

  final double primaryWidth;
  final double minPrimaryWidth;
  final double maxPrimaryWidth;
  final double windowWidth;
  final double step;

  final VoidCallback onResizeStart;

  // Called with how far the primary pane grows, negative when it shrinks.
  final ValueChanged<double> onResize;
  final VoidCallback onResizeEnd;

  // Called with how far one step grows the primary pane, negative when it shrinks.
  final ValueChanged<double> onStep;

  @override
  State<_SplitViewDivider> createState() => _SplitViewDividerState();
}

class _SplitViewDividerState extends State<_SplitViewDivider> {
  var _isFocused = false;

  bool get _canGrow => widget.primaryWidth < widget.maxPrimaryWidth;
  bool get _canShrink => widget.primaryWidth > widget.minPrimaryWidth;

  String _describe(double primaryWidth) => '${(primaryWidth / widget.windowWidth * 100).round()}%';

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event, bool isLtr) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;

    final direction = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowRight => isLtr ? 1 : -1,
      LogicalKeyboardKey.arrowLeft => isLtr ? -1 : 1,
      _ => null,
    };
    if (direction == null) return KeyEventResult.ignored;

    widget.onStep(direction * widget.step);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    final direction = isLtr ? 1.0 : -1.0;

    final grown = math.min(widget.primaryWidth + widget.step, widget.maxPrimaryWidth);
    final shrunk = math.max(widget.primaryWidth - widget.step, widget.minPrimaryWidth);

    return Semantics(
      slider: true,
      label: 'Channel list width',
      value: _describe(widget.primaryWidth),
      increasedValue: _canGrow ? _describe(grown) : null,
      decreasedValue: _canShrink ? _describe(shrunk) : null,
      onIncrease: _canGrow ? () => widget.onStep(widget.step) : null,
      onDecrease: _canShrink ? () => widget.onStep(-widget.step) : null,
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        onKeyEvent: (node, event) => _handleKeyEvent(node, event, isLtr),
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          // Leaves taps near the line to the panes beneath it.
          hitTestBehavior: HitTestBehavior.translucent,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: (_) => widget.onResizeStart(),
            onHorizontalDragUpdate: (details) => widget.onResize(details.primaryDelta! * direction),
            onHorizontalDragEnd: (_) => widget.onResizeEnd(),
            onHorizontalDragCancel: widget.onResizeEnd,
            // Marks the line while it has keyboard focus.
            child: Center(
              child: SizedBox(
                width: 2,
                child: ColoredBox(color: _isFocused ? colorScheme.borderFocus : Colors.transparent),
              ),
            ),
          ),
        ),
      ),
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
