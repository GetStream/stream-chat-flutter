import 'dart:async';

import 'package:flutter/widgets.dart';

class BetterStreamBuilder<T> extends StatefulWidget {
  const BetterStreamBuilder({
    required this.stream,
    required this.initialData,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.comparator,
    Key? key,
  }) : super(key: key);

  final Stream<T>? stream;
  final T initialData;
  final bool Function(T?, T)? comparator;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context)? loadingBuilder;
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

  bool _firstTime = true;
  @override
  void didChangeDependencies() {
    if (_firstTime) {
      _lastEvent = widget.initialData;
      _subscription = widget.stream?.listen(
        _onEvent,
        onError: _onError,
      );
      _firstTime = false;
    }
    super.didChangeDependencies();
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
    final isEqual = widget.comparator != null
        ? widget.comparator!(_lastEvent, event)
        : event == _lastEvent;
    if (!isEqual) {
      if (mounted) {
        setState(() {});
      }
      _lastEvent = event;
    }
  }
}
