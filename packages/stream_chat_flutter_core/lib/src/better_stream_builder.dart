import 'dart:async';

import 'package:flutter/widgets.dart';

/// A more efficient [StreamBuilder]
/// It requires [initialData] and will rebuild
/// only when the new data is different than the current data
/// The [comparator] is used to check if the new data is different
class BetterStreamBuilder<T> extends StatefulWidget {
  /// Creates a new BetterStreamBuilder
  const BetterStreamBuilder({
    required this.stream,
    required this.initialData,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.comparator,
    Key? key,
  }) : super(key: key);

  /// The stream to listen to
  final Stream<T>? stream;

  /// The initial data available
  final T initialData;

  /// Comparator used to check if the new data is different than the last one
  final bool Function(T?, T?)? comparator;

  /// Builder that builds based on the new snapshot
  final Widget Function(BuildContext context, T data) builder;

  /// Builder that builds when the data is null
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Builder used when there is an error
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  @override
  _BetterStreamBuilderState createState() => _BetterStreamBuilderState<T>();
}

class _BetterStreamBuilderState<T> extends State<BetterStreamBuilder<T>> {
  T? _lastEvent;
  StreamSubscription? _subscription;
  Object? _lastError;

  @override
  Widget build(BuildContext context) {
    if (_lastError != null) {
      return widget.errorBuilder!(context, _lastError!);
    }

    if (_lastEvent == null) {
      return widget.loadingBuilder?.call(context) ?? const Offstage();
    }
    return widget.builder(context, _lastEvent ?? widget.initialData);
  }

  @override
  void initState() {
    _lastEvent = widget.initialData;
    _subscription = widget.stream?.listen(
      _onEvent,
      onError: _onError,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BetterStreamBuilder<T> oldWidget) {
    if (oldWidget.stream != widget.stream) {
      _subscription?.cancel();
      _subscription = widget.stream?.listen(
        _onEvent,
        onError: _onError,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _onError(error) {
    if (widget.errorBuilder != null && error != _lastError) {
      if (mounted) {
        setState(() {});
      }
      _lastError = error;
    }
  }

  void _onEvent(T event) {
    _lastError = null;
    final isEqual =
        widget.comparator?.call(_lastEvent, event) ?? event == _lastEvent;
    if (!isEqual) {
      if (mounted) {
        setState(() {});
      }
      _lastEvent = event;
    }
  }
}
