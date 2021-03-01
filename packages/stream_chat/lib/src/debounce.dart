import 'dart:async';

import 'package:meta/meta.dart';

/// Map of timeouts being debounced
Map<Function, Timer> timeouts = {};

/// Runs a function avoiding calling it too many times in a [timeoutMS] window
void debounce({
  @required Duration timeout,
  @required Function target,
  @required List arguments,
}) {
  if (timeouts.containsKey(target)) {
    timeouts[target].cancel();
  }

  final timer = Timer(timeout, () {
    Function.apply(target, arguments);
  });

  timeouts[target] = timer;
}
