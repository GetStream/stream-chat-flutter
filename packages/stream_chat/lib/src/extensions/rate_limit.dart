import 'dart:async';

/// Signature for for the static method [Function.apply].
typedef ApplicableFunction = void Function(
  List<dynamic> positionalArguments, {
  Map<Symbol, dynamic> namedArguments,
});

/// Useful rate limiter extensions for [Function] class.
extension RateLimit on Function {
  /// Converts this into a [debounce] function.
  ApplicableFunction debounced(
    Duration interval, {
    bool leading = false,
    bool trailing = true,
  }) =>
      debounce(this, interval, leading: leading, trailing: trailing);

  /// Converts this into a [throttle] function.
  ApplicableFunction throttled(
    Duration interval, {
    bool trailing = false,
  }) =>
      throttle(this, interval, trailing: trailing);
}

/// Creates a debounced function that delays invoking [func] until
/// after [interval] have elapsed since the last time the debounced function
/// was invoked.
ApplicableFunction debounce(
  Function func,
  Duration interval, {
  bool leading = false,
  bool trailing = true,
}) {
  Timer debounceTimer;
  var emittedLatestAsLeading = false;
  return (
    List<dynamic> positionalArguments, {
    Map<Symbol, dynamic> namedArguments,
  }) {
    debounceTimer?.cancel();
    if (debounceTimer == null && leading) {
      emittedLatestAsLeading = true;
      Function.apply(func, positionalArguments, namedArguments);
    } else {
      emittedLatestAsLeading = false;
    }
    debounceTimer = Timer(interval, () {
      if (trailing && !emittedLatestAsLeading) {
        Function.apply(func, positionalArguments, namedArguments);
      }
      debounceTimer = null;
    });
  };
}

/// Creates a throttled function that only invokes [func] at most once per
/// every [interval]
ApplicableFunction throttle(
  Function func,
  Duration interval, {
  bool trailing = false,
}) {
  ApplicableFunction _throttle(Duration interval) {
    Timer throttleTimer;
    return (
      List<dynamic> positionalArguments, {
      Map<Symbol, dynamic> namedArguments,
    }) {
      if (throttleTimer == null) {
        Function.apply(func, positionalArguments, namedArguments);
        throttleTimer = Timer(interval, () {
          throttleTimer = null;
        });
      }
    };
  }

  ApplicableFunction _throttleTrailing(Duration interval) {
    Timer throttleTimer;
    Function pending;
    var hasPending = false;

    return (
      List<dynamic> positionalArguments, {
      Map<Symbol, dynamic> namedArguments,
    }) {
      void onTimer() {
        if (hasPending) {
          pending();
          throttleTimer = Timer(interval, onTimer);
          hasPending = false;
          pending = null;
        } else {
          throttleTimer = null;
        }
      }

      if (throttleTimer == null) {
        Function.apply(func, positionalArguments, namedArguments);
        throttleTimer = Timer(interval, onTimer);
      } else {
        hasPending = true;
        pending =
            () => Function.apply(func, positionalArguments, namedArguments);
      }
    };
  }

  return trailing ? _throttleTrailing(interval) : _throttle(interval);
}
