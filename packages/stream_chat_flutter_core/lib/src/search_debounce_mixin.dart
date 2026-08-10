import 'package:meta/meta.dart';
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/search_debouncer.dart';

/// Adds query-length-aware, debounced search to a [PagedValueNotifier].
///
/// The mixin owns the [SearchDebouncer] and a load generation counter so a
/// slower, older query can no longer overwrite the results of a newer one.
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
  /// Supplied by the mixing controller; overridden only in tests to make
  /// debounced searches fire deterministically.
  @protected
  SearchDebouncePolicy get debouncePolicy;

  late final _searchDebouncer = SearchDebouncer(doInitialLoad, policy: debouncePolicy);

  int _loadGeneration = 0;

  /// Schedules a debounced reload whose delay adapts to [queryLength].
  ///
  /// Bumps the load generation so any load already in flight is treated as
  /// superseded — its response is discarded and cannot overwrite the results
  /// of the newly scheduled search.
  ///
  /// Moves to a loading state while the search runs, so an active search never
  /// renders stale or empty results as "no results" — mirroring the iOS SDK,
  /// whose controller reports a fetching state until the query resolves.
  @internal
  void debouncedSearch(int queryLength) {
    _loadGeneration += 1;
    value = PagedValue<Key, Value>.loading();
    _searchDebouncer(queryLength);
  }

  /// Whether a debounced search has been scheduled but has not run yet.
  ///
  /// Guard [PagedValueNotifier.doInitialLoad] with this so an immediate load
  /// (e.g. the one a list view triggers when it first mounts) does not bypass
  /// the debounce — the scheduled search performs the load instead.
  @internal
  bool get hasPendingSearch => _searchDebouncer.isActive;

  /// Cancels any pending search, invalidates in-flight loads, and clears the
  /// current results.
  ///
  /// Consider calling this when the search input is emptied, so results for an
  /// abandoned query are neither shown nor repopulated by a late response. A
  /// subsequent [debouncedSearch] shows a loading state rather than this empty
  /// list, so the next search does not briefly render as "no results".
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
  /// before applying the result, so a page in flight when a newer search (or
  /// [clearResults]) arrives is discarded instead of repopulating stale items.
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
