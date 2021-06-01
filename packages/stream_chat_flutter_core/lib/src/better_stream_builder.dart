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
  Widget? _child;
  T? _lastEvent;
  StreamSubscription? _subscription;
  Object? _lastError;

  @override
  Widget build(BuildContext context) => _child ?? const Offstage();

  bool _firstTime = true;
  @override
  void didChangeDependencies() {
    if (_firstTime) {
      if (widget.initialData == null && widget.loadingBuilder != null) {
        _child = widget.loadingBuilder!(context);
      } else {
        _onEvent(widget.initialData);
      }
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
    if (_lastError != null && oldWidget.errorBuilder != widget.errorBuilder) {
      _onError(_lastError);
    } else if (oldWidget.builder != widget.builder) {
      _onEvent(_lastEvent);
    }

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
      setState(() {
        _child = widget.errorBuilder!(context, error);
      });
      _lastError = error;
    }
  }

  void _onEvent(event) {
    _lastError = null;
    if (widget.comparator != null
        ? widget.comparator!(_lastEvent, event)
        : event != _lastEvent) {
      setState(() {
        _child = widget.builder(context, event);
      });
      _lastEvent = event;
    }
  }
}
