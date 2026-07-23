import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Exposes the active page index of the enclosing `StreamFullScreenMedia`
/// gallery to descendants.
///
/// Per-page widgets that need to react when their page is no longer
/// visible — e.g. video players that pause themselves while off-screen —
/// read [activeIndex] from this scope and compare it against their own
/// page index.
///
/// {@tool snippet}
///
/// ```dart
/// final scope = FullScreenMediaScope.maybeOf(context);
/// final isActive = scope == null || scope.activeIndex.value == myPageIndex;
/// ```
/// {@end-tool}
class FullScreenMediaScope extends InheritedWidget {
  /// Creates a [FullScreenMediaScope].
  const FullScreenMediaScope({
    super.key,
    required this.activeIndex,
    required super.child,
  });

  /// The active page index of the enclosing gallery.
  final ValueListenable<int> activeIndex;

  /// Returns the [FullScreenMediaScope] of the nearest enclosing
  /// `StreamFullScreenMedia`, or `null` if there isn't one.
  ///
  /// Prefer [of] when the absence of the scope is a programmer error.
  static FullScreenMediaScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FullScreenMediaScope>();
  }

  /// Returns the [FullScreenMediaScope] of the nearest enclosing
  /// `StreamFullScreenMedia`.
  ///
  /// Throws a [FlutterError] when no scope is in scope — typically because
  /// the calling widget is rendered outside the gallery's page tree.
  /// Use [maybeOf] when the absence is a recoverable case.
  static FullScreenMediaScope of(BuildContext context) {
    final scope = maybeOf(context);
    if (scope != null) return scope;

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'FullScreenMediaScope.of() called with a context that does not '
        'contain a StreamFullScreenMedia.',
      ),
      ErrorDescription(
        'No StreamFullScreenMedia ancestor could be found starting from '
        'the context that was passed to FullScreenMediaScope.of(). This '
        'usually means the caller is being built outside the page tree '
        'owned by the gallery, or the context predates the '
        'StreamFullScreenMedia itself.',
      ),
      ErrorHint(
        'Make sure to only call FullScreenMediaScope.of() from a widget '
        'that is a descendant of a StreamFullScreenMedia, or use '
        'FullScreenMediaScope.maybeOf() instead.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  @override
  bool updateShouldNotify(FullScreenMediaScope oldWidget) =>
      activeIndex != oldWidget.activeIndex;
}
