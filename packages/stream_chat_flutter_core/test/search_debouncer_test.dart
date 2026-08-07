import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/src/search_debouncer.dart';

void main() {
  test('coalesces rapid calls into a single run', () async {
    var runCount = 0;
    final firstRun = Completer<void>();
    final debouncer = SearchDebouncer(() {
      runCount += 1;
      if (!firstRun.isCompleted) firstRun.complete();
    });
    addTearDown(debouncer.cancel);

    debouncer(3);
    debouncer(3);
    debouncer(3);

    await firstRun.future;
    // Give any erroneously-scheduled extra runs time to fire.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(runCount, 1);
  });

  test('waits longer for a short query than the standard delay', () async {
    var ran = false;
    final debouncer = SearchDebouncer(() => ran = true)..call(1);
    addTearDown(debouncer.cancel);

    // A short (<= 2 char) query uses a 500ms delay; well past the 300ms
    // standard delay it must still be pending, since timers never fire early.
    await Future<void>.delayed(const Duration(milliseconds: 350));

    expect(ran, isFalse);
  });

  test('runs a longer query sooner than a short query', () async {
    final shortRan = Completer<void>();
    final longRan = Completer<void>();
    final shortQuery = SearchDebouncer(shortRan.complete)..call(1);
    final longQuery = SearchDebouncer(longRan.complete)..call(3);
    addTearDown(shortQuery.cancel);
    addTearDown(longQuery.cancel);

    // The longer query's 300ms delay elapses first; the short query's 500ms
    // delay is still pending, since timers never fire early.
    await longRan.future;
    expect(shortRan.isCompleted, isFalse);
  });

  test('cancels the pending short query when a longer query arrives', () async {
    var runCount = 0;
    final firstRun = Completer<void>();
    final debouncer = SearchDebouncer(() {
      runCount += 1;
      if (!firstRun.isCompleted) firstRun.complete();
    });
    addTearDown(debouncer.cancel);

    debouncer(1); // short query: 500ms delay
    debouncer(4); // longer query: 300ms delay, supersedes the short one

    await firstRun.future;
    // Wait past the short query's 500ms window to prove it never runs.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    expect(runCount, 1);
  });

  test('cancel prevents a pending run', () async {
    var ran = false;
    final debouncer = SearchDebouncer(() => ran = true)..call(3);
    addTearDown(debouncer.cancel);

    debouncer.cancel();
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(ran, isFalse);
  });
}
