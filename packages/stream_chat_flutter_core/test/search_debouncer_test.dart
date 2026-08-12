import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/search_debouncer.dart';

void main() {
  test('coalesces rapid calls into a single run', () {
    fakeAsync((async) {
      var runCount = 0;
      SearchDebouncer(() => runCount += 1)
        ..call(3)
        ..call(3)
        ..call(3);

      async.elapse(const Duration(milliseconds: 300));
      expect(runCount, 1);

      // No superseded run is left scheduled behind the coalesced one.
      async.elapse(const Duration(seconds: 1));
      expect(runCount, 1);
    });
  });

  test('waits longer for a short query than the standard delay', () {
    fakeAsync((async) {
      var ran = false;
      SearchDebouncer(() => ran = true).call(1);

      // A short (<= 2 char) query uses the 500ms delay, not the 300ms one.
      async.elapse(const Duration(milliseconds: 499));
      expect(ran, isFalse);

      async.elapse(const Duration(milliseconds: 1));
      expect(ran, isTrue);
    });
  });

  test('runs a longer query sooner than a short query', () {
    fakeAsync((async) {
      var shortRan = false;
      var longRan = false;
      SearchDebouncer(() => shortRan = true).call(1);
      SearchDebouncer(() => longRan = true).call(3);

      // The longer query's 300ms delay elapses first.
      async.elapse(const Duration(milliseconds: 300));
      expect(longRan, isTrue);
      expect(shortRan, isFalse);

      // The short query's 500ms delay elapses later.
      async.elapse(const Duration(milliseconds: 200));
      expect(shortRan, isTrue);
    });
  });

  test('cancels the pending short query when a longer query arrives', () {
    fakeAsync((async) {
      var runCount = 0;
      SearchDebouncer(() => runCount += 1)
        ..call(1) // short query: 500ms delay
        ..call(4); // longer query: 300ms delay, supersedes the short one

      async.elapse(const Duration(milliseconds: 300));
      expect(runCount, 1);

      // Past the short query's 500ms window, proving it never runs.
      async.elapse(const Duration(milliseconds: 300));
      expect(runCount, 1);
    });
  });

  test('cancel prevents a pending run', () {
    fakeAsync((async) {
      var ran = false;
      SearchDebouncer(() => ran = true)
        ..call(3)
        ..cancel();

      async.elapse(const Duration(seconds: 1));
      expect(ran, isFalse);
    });
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
}
