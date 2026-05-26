import 'dart:async';

import 'package:flutter/widgets.dart';

/// A more efficient [StreamBuilder]
/// It requires [initialData] and will rebuild
/// only when the new data is different than the current data
/// The [comparator] is used to check if the new data is different
class BetterStreamBuilder<T extends Object> extends StatefulWidget {
  /// Creates a new BetterStreamBuilder
  const BetterStreamBuilder({
    required this.stream,
    required this.builder,
    this.initialData,
    this.noDataBuilder,
    this.errorBuilder,
    this.comparator,
    super.key,
  });

  /// The stream to listen to
  final Stream<T?>? stream;

  /// The initial data available
  final T? initialData;

  /// Comparator used to check if the new data is different than the last one.
  /// Runs on every emission, must handle null on either side. Defaults to `==`.
  final bool Function(T?, T?)? comparator;

  /// Builder that builds based on the new snapshot
  final Widget Function(BuildContext context, T data) builder;

  /// Builder that builds when the data is null
  final Widget Function(BuildContext context)? noDataBuilder;

  /// Builder used when there is an error
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  @override
  _BetterStreamBuilderState createState() => _BetterStreamBuilderState<T>();
}

class _BetterStreamBuilderState<T extends Object> extends State<BetterStreamBuilder<T>> {
  T? _lastEvent;
  Object? _lastError;
  StreamSubscription<T?>? _subscription;

  @override
  void initState() {
    super.initState();
    _lastEvent = widget.initialData;
    _subscription = widget.stream?.listen(_onEvent, onError: _onError);
  }

  @override
  void didUpdateWidget(covariant BetterStreamBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      // Avoid rendering the previous stream's last value before the new
      // stream's first emission lands.
      _lastEvent = widget.initialData;
      _lastError = null;

      _subscription?.cancel();
      _subscription = widget.stream?.listen(_onEvent, onError: _onError);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = _lastError;
    if (error != null) {
      final errorBuilder = widget.errorBuilder;
      if (errorBuilder != null) {
        return errorBuilder(context, error);
      }
    }
    final event = _lastEvent;
    if (event == null) {
      return widget.noDataBuilder?.call(context) ?? const SizedBox.shrink();
    }
    return widget.builder(context, event);
  }

  void _onEvent(T? event) {
    if (!mounted) return;
    final wasErrored = _lastError != null;
    final isEqual = widget.comparator?.call(_lastEvent, event) ?? event == _lastEvent;
    if (isEqual && !wasErrored) return;

    _lastError = null;
    if (!isEqual) _lastEvent = event;
    setState(() {}); // ignore: no-empty-block
  }

  void _onError(Object error, StackTrace stackTrace) {
    if (!mounted) return;

    if (error == _lastError) return;
    _lastError = error;

    if (widget.errorBuilder == null) {
      // No errorBuilder → log so the failure isn't completely silent.
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'stream_chat_flutter_core',
          context: ErrorDescription(
            'while listening to a BetterStreamBuilder stream',
          ),
        ),
      );
      return;
    }

    setState(() {}); // ignore: no-empty-block
  }
}
