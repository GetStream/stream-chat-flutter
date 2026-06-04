import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that exposes a [State] of type [T] to descendants for
/// O(1) ancestor lookup.
///
/// Use this to back the `static of(BuildContext)` accessor of a
/// [StatefulWidget] that wants to expose its [State] to descendants without
/// the per-call cost of [BuildContext.findAncestorStateOfType], which walks
/// the element tree on every call.
///
/// {@tool snippet}
///
/// Inside the widget's state, wrap the subtree in a [StreamScope] and define
/// `of` / `maybeOf` that read it back:
///
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
///   static MyWidgetState of(BuildContext context) =>
///       StreamScope.of<MyWidgetState>(context);
///
///   static MyWidgetState? maybeOf(BuildContext context) =>
///       StreamScope.maybeOf<MyWidgetState>(context);
/// }
///
/// class MyWidgetState extends State<MyWidget> {
///   @override
///   Widget build(BuildContext context) {
///     // [T] is inferred from `state: this`, no need to spell it out.
///     return StreamScope(state: this, child: widget.child);
///   }
/// }
/// ```
/// {@end-tool}
///
/// [updateShouldNotify] returns `false`: lookups are intended as a dependency
/// -free pointer to the enclosing [State], and the [State] identity is stable
/// for the life of the element. Consumers that need to react to data exposed
/// by the [State] should subscribe to its streams or notifiers explicitly.
class StreamScope<T extends State> extends InheritedWidget {
  /// Creates a [StreamScope] exposing [state] to descendants.
  const StreamScope({
    super.key,
    required this.state,
    required super.child,
  });

  /// The [State] exposed to descendants.
  final T state;

  /// Returns the [State] of type [T] from the closest enclosing [StreamScope].
  ///
  /// Throws a [FlutterError] if no matching [StreamScope] is found.
  static T of<T extends State>(BuildContext context) {
    final result = maybeOf<T>(context);
    if (result != null) return result;

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'StreamScope.of<$T>() called with a context that does not contain a '
        'StreamScope<$T>.',
      ),
      ErrorDescription(
        'No StreamScope<$T> ancestor could be found starting from the context '
        'that was passed to StreamScope.of<$T>().',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Returns the [State] of type [T] from the closest enclosing [StreamScope],
  /// or `null` if there isn't one.
  ///
  /// This is a pure lookup — the calling element is **not** registered as a
  /// dependent, so the [State] identity must not change for the life of the
  /// scope (it doesn't, since [State.build] returns the same scope every
  /// frame). If consumers need to react to data exposed by the [State], they
  /// should subscribe to its streams or notifiers explicitly.
  static T? maybeOf<T extends State>(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<StreamScope<T>>();
    final scope = element?.widget as StreamScope<T>?;
    return scope?.state;
  }

  @override
  bool updateShouldNotify(StreamScope<T> oldWidget) => false;
}
