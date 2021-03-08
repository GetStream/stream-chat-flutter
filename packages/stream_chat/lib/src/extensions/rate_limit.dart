// ignore_for_file: lines_longer_than_80_chars

import 'dart:async' show Timer;
import 'dart:math' as math;

/// Useful rate limiter extensions for [Function] class.
extension RateLimit on Function {
  /// Converts this into a [Debounce] function.
  Debounce debounced(
    Duration wait, {
    bool leading = false,
    bool trailing = true,
    Duration maxWait,
  }) =>
      Debounce(
        this,
        wait,
        leading: leading,
        trailing: trailing,
        maxWait: maxWait,
      );

  /// Converts this into a [Throttle] function.
  Throttle throttled(
    Duration wait, {
    bool leading = true,
    bool trailing = true,
  }) =>
      Throttle(
        this,
        wait,
        leading: leading,
        trailing: trailing,
      );
}

/// TopLevel lambda to create [Debounce] functions.
Debounce debounce(
  Function func,
  Duration wait, {
  bool leading = false,
  bool trailing = true,
  Duration maxWait,
}) =>
    Debounce(
      func,
      wait,
      leading: leading,
      trailing: trailing,
      maxWait: maxWait,
    );

/// TopLevel lambda to create [Throttle] functions.
Throttle throttle(
  Function func,
  Duration wait, {
  bool leading = true,
  bool trailing = true,
}) =>
    Throttle(
      func,
      wait,
      leading: leading,
      trailing: trailing,
    );

/// Creates a debounced function that delays invoking `func` until after `wait`
/// milliseconds have elapsed since the last time the debounced function was
/// invoked. The debounced function comes with a [Debounce.cancel] method to cancel
/// delayed `func` invocations and a [Debounce.flush] method to immediately invoke them.
/// Provide `leading` and/or `trailing` to indicate whether `func` should be
/// invoked on the `leading` and/or `trailing` edge of the `wait` interval.
/// The `func` is invoked with the last arguments provided to the [call]
/// function. Subsequent calls to the debounced function return the result of
/// the last `func` invocation.
///
/// **Note:** If `leading` and `trailing` options are `true`, `func` is
/// invoked on the trailing edge of the timeout only if the debounced function
/// is invoked more than once during the `wait` timeout.
///
/// If `wait` is [Duration.zero] and `leading` is `false`,
/// `func` invocation is deferred until the next tick.
///
/// See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
/// for details over the differences between [Debounce] and [Throttle].
///
/// Some examples:
///
/// Avoid calling costly network calls when user is typing something.
/// ```dart
///   void fetchData(String query) async {
///     final data = api.getData(query);
///     doSomethingWithTheData(data);
///   }
///
///   final debouncedFetchData = Debounce(
///     fetchData,
///     const Duration(milliseconds: 350),
///   );
///
///   void onSearchQueryChanged(query) {
///      debouncedFetchData(query);
///   }
/// ```
///
/// Cancel the trailing debounced invocation.
/// ```dart
///   void dispose() {
///     debounced.cancel();
///   }
/// ```
///
/// Check for pending invocations.
/// ```dart
///   final status = debounced.isPending ? "Pending..." : "Ready";
/// ```
class Debounce {
  /// Creates a new instance of [Debounce].
  Debounce(
    this._func,
    Duration wait, {
    bool leading = false,
    bool trailing = true,
    Duration maxWait,
  })  : _leading = leading,
        _trailing = trailing,
        _wait = wait?.inMilliseconds ?? 0,
        _maxing = maxWait != null {
    if (_maxing) {
      _maxWait = math.max(maxWait.inMilliseconds, _wait);
    }
  }

  final Function _func;
  final bool _leading;
  final bool _trailing;
  final int _wait;
  final bool _maxing;

  int _maxWait;
  List<Object> _lastArgs;
  Map<Symbol, Object> _lastNamedArgs;
  Timer _timer;
  int _lastCallTime;
  Object _result;
  int _lastInvokeTime = 0;

  Object _invokeFunc(int time) {
    final args = _lastArgs;
    final namedArgs = _lastNamedArgs;
    _lastArgs = _lastNamedArgs = null;
    _lastInvokeTime = time;
    return _result = Function.apply(_func, args, namedArgs);
  }

  Timer _startTimer(Function pendingFunc, int wait) =>
      Timer(Duration(milliseconds: wait), pendingFunc);

  bool _shouldInvoke(int time) {
    final timeSinceLastCall = time - (_lastCallTime ?? double.nan);
    final timeSinceLastInvoke = time - _lastInvokeTime;

    // Either this is the first call, activity has stopped and we're at the
    // trailing edge, the system time has gone backwards and we're treating
    // it as the trailing edge, or we've hit the `maxWait` limit.
    return _lastCallTime == null ||
        (timeSinceLastCall >= _wait) ||
        (timeSinceLastCall < 0) ||
        (_maxing && timeSinceLastInvoke >= _maxWait);
  }

  Object _trailingEdge(int time) {
    _timer = null;

    // Only invoke if we have `lastArgs` which means `func` has been
    // debounced at least once.
    if (_trailing && _lastArgs != null) {
      return _invokeFunc(time);
    }
    _lastArgs = _lastNamedArgs = null;
    return _result;
  }

  int _remainingWait(int time) {
    final timeSinceLastCall = time - _lastCallTime;
    final timeSinceLastInvoke = time - _lastInvokeTime;
    final timeWaiting = _wait - timeSinceLastCall;

    return _maxing
        ? math.min(timeWaiting, _maxWait - timeSinceLastInvoke)
        : timeWaiting;
  }

  void _timerExpired() {
    final time = DateTime.now().millisecondsSinceEpoch;
    if (_shouldInvoke(time)) {
      _trailingEdge(time);
    } else {
      // Restart the timer.
      _timer = _startTimer(_timerExpired, _remainingWait(time));
    }
  }

  Object _leadingEdge(int time) {
    // Reset any `maxWait` timer.
    _lastInvokeTime = time;
    // Start the timer for the trailing edge.
    _timer = _startTimer(_timerExpired, _wait);
    // Invoke the leading edge.
    return _leading ? _invokeFunc(time) : _result;
  }

  /// Cancels all the remaining delayed functions.
  void cancel() {
    _timer?.cancel();
    _lastInvokeTime = 0;
    _lastArgs = _lastNamedArgs = _lastCallTime = _timer = null;
  }

  /// Immediately invokes all the remaining delayed functions.
  Object flush() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return _timer == null ? _result : _trailingEdge(now);
  }

  /// True if there are functions remaining to get invoked.
  bool get isPending => _timer != null;

  /// Calls/invokes this class like a function.
  /// Pass [args] and [namedArgs] to be used while invoking [_func].
  Object call(
    List<dynamic> args, {
    Map<Symbol, dynamic> namedArgs,
  }) {
    final time = DateTime.now().millisecondsSinceEpoch;
    final isInvoking = _shouldInvoke(time);

    _lastArgs = args;
    _lastNamedArgs = namedArgs;
    _lastCallTime = time;

    if (isInvoking) {
      if (_timer == null) {
        return _leadingEdge(_lastCallTime);
      }
      if (_maxing) {
        // Handle invocations in a tight loop.
        _timer = _startTimer(_timerExpired, _wait);
        return _invokeFunc(_lastCallTime);
      }
    }
    _timer ??= _startTimer(_timerExpired, _wait);
    return _result;
  }
}

/// Creates a throttled function that only invokes `func` at most once per
/// every `wait` milliseconds. The throttled function comes with a [Throttle.cancel]
/// method to cancel delayed `func` invocations and a [Throttle.flush] method to
/// immediately invoke them. Provide `leading` and/or `trailing` to indicate
/// whether `func` should be invoked on the `leading` and/or `trailing` edge of the `wait` timeout.
/// The `func` is invoked with the last arguments provided to the
/// throttled function. Subsequent calls to the throttled function return the
/// result of the last `func` invocation.
///
/// **Note:** If `leading` and `trailing` options are `true`, `func` is
/// invoked on the trailing edge of the timeout only if the throttled function
/// is invoked more than once during the `wait` timeout.
///
/// If `wait` is [Duration.zero] and `leading` is `false`, `func` invocation is deferred
/// until the next tick.
///
/// See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
/// for details over the differences between [Throttle] and [Debounce].
///
/// Some examples:
///
/// Avoid excessively rebuilding UI progress while uploading data to server.
/// ```dart
///   void updateUI(Data data) {
///     updateProgress(data);
///   }
///
///   final throttledUpdateUI = Throttle(
///     updateUI,
///     const Duration(milliseconds: 350),
///   );
///
///   void onUploadProgressChanged(progress) {
///      throttledUpdateUI(progress);
///   }
/// ```
///
/// Cancel the trailing throttled invocation.
/// ```dart
///   void dispose() {
///     throttled.cancel();
///   }
/// ```
///
/// Check for pending invocations.
/// ```dart
///   final status = throttled.isPending ? "Pending..." : "Ready";
/// ```
class Throttle {
  /// Creates a new instance of [Throttle]
  Throttle(
    Function func,
    Duration wait, {
    bool leading = true,
    bool trailing = true,
  }) : _debounce = Debounce(
          func,
          wait,
          leading: leading,
          trailing: trailing,
          maxWait: wait,
        );

  final Debounce _debounce;

  /// Cancels all the remaining delayed functions.
  void cancel() => _debounce.cancel();

  /// Immediately invokes all the remaining delayed functions.
  Object flush() => _debounce.flush();

  /// True if there are functions remaining to get invoked.
  bool get isPending => _debounce.isPending;

  /// Calls/invokes this class like a function.
  /// Pass [args] and [namedArgs] to be used while invoking `func`.
  Object call(List<dynamic> args, {Map<Symbol, dynamic> namedArgs}) =>
      _debounce.call(args, namedArgs: namedArgs);
}
