// TODO(perf-migration): once `stream_chat` adopts `stream_core`, delete this
// file and import equivalents from
// `package:stream_core/src/utils/list_extensions.dart`. The signatures below
// mirror `stream_core`'s so the migration is a one-line import swap. The
// two-pointer `merge` here is a runtime optimization; `stream_core` does
// keyed-map-merge-and-sort. Both produce the same result for sorted inputs.

import 'package:collection/collection.dart';

/// Useful extension functions for sorted [List]s.
extension SortedListX<T extends Object> on List<T> {
  /// Inserts [element] into this sorted list at the correct position.
  ///
  /// Stable: equal elements land after existing ones. O(1) append/prepend
  /// fast paths cover the steady state (new messages / paginated history);
  /// otherwise O(log n) upper-bound binary search + O(n) splice.
  List<T> sortedInsert(T element, {required Comparator<T> compare}) {
    if (isEmpty) return [element];
    if (compare(last, element) <= 0) return [...this, element];
    if (compare(first, element) > 0) return [element, ...this];

    final index = _upperBound(this, element, compare);
    return [...this]..insert(index, element);
  }

  /// Inserts or replaces [element] in this sorted list by [key].
  ///
  /// Replaces in place when the replacement sorts to the same position;
  /// otherwise removes the old and re-inserts via [sortedInsert].
  List<T> sortedUpsert<K>(
    T element, {
    required K Function(T item) key,
    T Function(T original, T updated)? update,
    required Comparator<T> compare,
  }) {
    final elementKey = key(element);
    final index = indexWhere((it) => key(it) == elementKey);
    return sortedUpsertAt(
      index,
      element,
      compare: compare,
      update: update,
    );
  }

  /// Like [sortedUpsert] but with the existing-element index pre-supplied by
  /// the caller — useful when the caller already has the index from another
  /// scan (e.g. an `oldMessage` lookup in the same code path). Avoids the
  /// duplicate O(N) `indexWhere` that [sortedUpsert] would otherwise run.
  ///
  /// Pass `-1` for [existingIndex] when no matching element exists.
  List<T> sortedUpsertAt(
    int existingIndex,
    T element, {
    required Comparator<T> compare,
    T Function(T original, T updated)? update,
  }) {
    if (existingIndex == -1) return sortedInsert(element, compare: compare);

    final original = this[existingIndex];
    final resolved = update != null ? update(original, element) : element;

    // Replace in place when sort position is unchanged.
    if (compare(original, resolved) == 0) {
      final result = [...this];
      result[existingIndex] = resolved;
      return result;
    }

    final removed = [...this]..removeAt(existingIndex);
    return removed.sortedInsert(resolved, compare: compare);
  }

  /// Merges this list with [other] via an O(N+M) two-pointer pass, with
  /// duplicates deduplicated by [key].
  ///
  /// The keyset of [other] takes precedence: any element of this list whose
  /// key appears in [other] is dropped, and the [other] copy (optionally
  /// passed through [update]) is emitted in its place. The output preserves
  /// [compare] order.
  ///
  /// The receiver must already be sorted by [compare] (state classes that
  /// hold sorted lists maintain this as an invariant). [other] is sorted
  /// internally before the walk, so callers can pass it in any order.
  ///
  /// Returns the receiver unchanged (same reference) when [other] is null,
  /// empty, or identical to this list — the identity short-circuit fires
  /// before any sorting work is done.
  List<T> mergeSorted<K>(
    Iterable<T>? other, {
    required K Function(T item) key,
    required Comparator<T> compare,
    T Function(T original, T updated)? update,
  }) {
    if (other == null) return this;
    if (identical(other, this)) return this;
    if (other.isEmpty) return this;

    T resolve(T original, T updated) {
      if (update != null) return update(original, updated);
      return updated;
    }

    final otherList = other is List<T> ? other : other.toList(growable: false);
    final sortedOther = otherList.sorted(compare);
    return _mergeSortedTwoPointer(this, sortedOther, key, compare, resolve);
  }
}

// Two-pointer merge of two pre-sorted lists. O(N + M), with duplicates
// (matched by [key]) resolved via [resolve].
List<T> _mergeSortedTwoPointer<T, K>(
  List<T> a,
  List<T> b,
  K Function(T item) key,
  Comparator<T> compare,
  T Function(T original, T updated) resolve,
) {
  // Keyset of `b` for O(1) dedup detection while walking `a`, plus a
  // key→item lookup against `a` so we can resolve duplicates as we emit
  // items from `b`.
  final bKeys = <K>{for (final item in b) key(item)};
  final aByKey = <K, T>{for (final item in a) key(item): item};

  final result = <T>[];
  var i = 0;
  var j = 0;
  while (i < a.length && j < b.length) {
    final ai = a[i];
    if (bKeys.contains(key(ai))) {
      i++;
      continue;
    }
    final bj = b[j];
    if (compare(ai, bj) <= 0) {
      result.add(ai);
      i++;
    } else {
      final original = aByKey[key(bj)];
      result.add(original != null ? resolve(original, bj) : bj);
      j++;
    }
  }
  while (i < a.length) {
    final ai = a[i++];
    if (!bKeys.contains(key(ai))) result.add(ai);
  }
  while (j < b.length) {
    final bj = b[j++];
    final original = aByKey[key(bj)];
    result.add(original != null ? resolve(original, bj) : bj);
  }
  return result;
}

// Upper-bound binary search — yields stable insertion (equals land after
// existing entries).
int _upperBound<T>(List<T> list, T element, Comparator<T> compare) {
  var start = 0;
  var end = list.length;
  while (start < end) {
    final mid = start + ((end - start) >> 1);
    if (compare(list[mid], element) <= 0) {
      start = mid + 1;
    } else {
      end = mid;
    }
  }
  return start;
}

/// Useful extension functions for [Iterable].
extension IterableMergeX<T extends Object> on Iterable<T> {
  /// Merges this iterable with [other], deduplicating by [key].
  ///
  /// Uses an O(N+M) keyed-map merge. The result is returned in insertion
  /// order — items from this iterable first, new items from [other] last.
  /// Duplicate keys within a single input collapse to the last occurrence.
  /// Cross-list duplicates are resolved via [update] (defaults to
  /// preferring the element from [other]).
  ///
  /// Output is **not** sorted. If you need a sorted result and both inputs
  /// are pre-sorted, use [SortedListX.mergeSorted] instead.
  ///
  /// Returns the receiver unchanged (same reference) when [other] is null,
  /// empty, or identical to this iterable.
  Iterable<T> merge<K>(
    Iterable<T>? other, {
    required K Function(T item) key,
    T Function(T original, T updated)? update,
  }) {
    if (other == null) return this;
    if (identical(other, this)) return this;
    if (other.isEmpty) return this;

    T resolve(T original, T updated) {
      if (update != null) return update(original, updated);
      return updated;
    }

    final itemMap = {for (final item in this) key(item): item};
    for (final item in other) {
      itemMap.update(
        key(item),
        (original) => resolve(original, item),
        ifAbsent: () => item,
      );
    }
    return itemMap.values;
  }

  /// Merges this iterable with [other], where [other] is an iterable of a
  /// **different type** [V].
  ///
  /// Each item from [other] is converted to [T] via [value]; if [value]
  /// returns `null`, that item is skipped. Useful for merging DTOs into a
  /// model collection, or for projecting a nested field from a parent type
  /// (e.g. merging `Message.sharedLocation` into a list of `Location`).
  ///
  /// Uses an O(N+M) keyed-map merge. The result is returned in insertion
  /// order — items from this iterable first, new items from [other] last.
  /// Cross-list duplicates are resolved via [update].
  ///
  /// Returns the receiver unchanged (same reference) when [other] is null
  /// or empty.
  Iterable<T> mergeFrom<K, V>(
    Iterable<V>? other, {
    required K Function(T item) key,
    required T? Function(V item) value,
    required T Function(T original, T updated) update,
  }) {
    if (other == null) return this;
    if (other.isEmpty) return this;

    final itemMap = {for (final item in this) key(item): item};
    for (final otherItem in other) {
      final item = value(otherItem);
      if (item == null) continue;
      itemMap.update(
        key(item),
        (original) => update(original, item),
        ifAbsent: () => item,
      );
    }
    return itemMap.values;
  }
}

/// Useful extension functions for [List].
extension ListX<T extends Object> on List<T> {
  /// Returns a new list with elements matching [test] replaced by [update].
  ///
  /// Returns the receiver unchanged (same reference) when nothing matches —
  /// safe to use in stream pipelines that rely on reference equality to skip
  /// work.
  List<T> updateIf(
    bool Function(T item) test,
    T Function(T item) update,
  ) {
    List<T>? result;
    for (var i = 0; i < length; i++) {
      final item = this[i];
      if (test(item)) {
        result ??= [...this];
        result[i] = update(item);
      }
    }
    return result ?? this;
  }
}
