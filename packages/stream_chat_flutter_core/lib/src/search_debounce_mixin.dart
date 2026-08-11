import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/search_debouncer.dart';

/// Adds query-length-aware, debounced search to a [PagedValueNotifier].
///
/// Owns a [SearchDebouncer] and a load generation counter so a slower, older
/// query can no longer overwrite the results of a newer one.
///
/// Mixers call [debouncedSearch] from their own `search` method, and guard
/// their [PagedValueNotifier.doInitialLoad] with [beginLoad] and [isStale]
/// before applying a result:
///
/// ```dart
/// Future<void> doInitialLoad() async {
///   if (hasPendingSearch) return;
///   final generation = beginLoad();
///   try {
///     final response = await _fetch();
///     if (isStale(generation)) return;
///     value = PagedValue(items: response.items);
///   } on StreamChatError catch (error) {
///     if (isStale(generation)) return;
///     value = PagedValue.error(error);
///   }
/// }
/// ```
mixin SearchDebounceMixin<Key, Value> on PagedValueNotifier<Key, Value> {
  /// The policy driving [debouncedSearch]'s length-based delays.
  ///
  /// Override to tune the delays for a particular list.
  @protected
  SearchDebouncePolicy get debouncePolicy => const SearchDebouncePolicy();
  late final _searchDebouncer = SearchDebouncer(doInitialLoad, policy: debouncePolicy);

  int _loadGeneration = 0;

  /// Schedules a reload, debounced by [queryLength]. A null [queryLength] — a
  /// query with no debounce-able text — reloads immediately.
  ///
  /// Bumps the load generation so any load already in flight is superseded: its
  /// response is discarded and cannot overwrite the newly scheduled search.
  /// Also moves to a loading state, so an active search is not represented by
  /// stale or empty results until it resolves.
  @internal
  void debouncedSearch(int? queryLength) {
    _loadGeneration += 1;
    value = PagedValue<Key, Value>.loading();
    if (queryLength == null) {
      _searchDebouncer.cancel();
      unawaited(doInitialLoad());
      return;
    }
    _searchDebouncer(queryLength);
  }

  /// Whether a debounced search has been scheduled but has not run yet.
  ///
  /// Guard [PagedValueNotifier.doInitialLoad] with this so an immediate load
  /// does not bypass the debounce — the scheduled search performs the load
  /// instead.
  @internal
  bool get hasPendingSearch => _searchDebouncer.isActive;

  /// Cancels any pending search, invalidates in-flight loads, and clears the
  /// current results.
  ///
  /// Consider calling this when the search query is cleared.
  void clearResults() {
    _searchDebouncer.cancel();
    // Bump the generation so an already-running load is treated as superseded
    // and cannot repopulate the cleared results when its response arrives.
    _loadGeneration += 1;
    value = PagedValue<Key, Value>(items: []);
  }

  /// Marks the start of an initial load and returns its generation token.
  ///
  /// Pass the token to [isStale] before applying the load's result.
  @internal
  int beginLoad() => _loadGeneration += 1;

  /// The current load generation, without starting a new one.
  ///
  /// Capture this at the start of a paged `loadMore` and pass it to [isStale]
  /// before applying the result.
  @internal
  int get loadGeneration => _loadGeneration;

  /// Whether the load identified by [generation] has been superseded by a
  /// newer one, in which case its result should be discarded.
  @internal
  bool isStale(int generation) => generation != _loadGeneration;

  /// Cancels any pending debounced search before disposing the notifier.
  @override
  void dispose() {
    _searchDebouncer.cancel();
    super.dispose();
  }
}
