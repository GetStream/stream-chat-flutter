import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
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

  group('searchQueryLength', () {
    test('returns the autocomplete text length', () {
      expect(searchQueryLength(Filter.autoComplete('name', 'john')), 4);
    });

    test('returns the query text length', () {
      expect(searchQueryLength(Filter.query('name', 'jo')), 2);
    });

    test('returns the longest search text in a compound filter', () {
      final filter = Filter.and([
        Filter.notEqual('id', 'me'),
        Filter.autoComplete('name', 'john'),
        Filter.query('bio', 'developer'),
      ]);

      expect(searchQueryLength(filter), 'developer'.length);
    });

    test('returns null for a filter with no text-search operator', () {
      expect(searchQueryLength(Filter.equal('id', 'user-1')), isNull);
    });

    test('returns null for a null filter', () {
      expect(searchQueryLength(null), isNull);
    });
  });

  group('Filter.merge', () {
    final a = Filter.equal('a', '1');
    final b = Filter.equal('b', '2');
    const Filter? none = null;

    test('returns null when both are null', () {
      expect(none.merge(none), isNull);
    });

    test('returns the other filter when this is null', () {
      expect(none.merge(a), a);
    });

    test('returns this filter when other is null', () {
      expect(a.merge(none), a);
    });

    test('ands two non-null filters', () {
      expect(a.merge(b), Filter.and([a, b]));
    });
  });
}
