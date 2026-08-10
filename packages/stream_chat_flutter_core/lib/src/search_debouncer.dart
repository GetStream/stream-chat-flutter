import 'package:meta/meta.dart';
import 'package:rate_limiter/rate_limiter.dart';

/// A query-length-aware debounce policy for search input.
///
/// Short, low-selectivity queries (of at most [shortQueryMaxLength] characters)
/// wait [shortQueryDelay] before triggering a search, reducing load on the
/// backend; longer, more selective queries use [defaultDelay].
@internal
class SearchDebouncePolicy {
  /// Creates a policy with the standard length-based delays.
  const SearchDebouncePolicy({
    this.shortQueryMaxLength = 2,
    this.shortQueryDelay = const Duration(milliseconds: 500),
    this.defaultDelay = const Duration(milliseconds: 300),
  });

  /// Creates a policy that applies a single [delay] to every query length.
  const SearchDebouncePolicy.constant(Duration delay)
    : shortQueryMaxLength = 0,
      shortQueryDelay = delay,
      defaultDelay = delay;

  /// Queries of at most this many characters use [shortQueryDelay].
  final int shortQueryMaxLength;

  /// The delay applied to short, low-selectivity queries.
  final Duration shortQueryDelay;

  /// The delay applied to longer, more selective queries.
  final Duration defaultDelay;
}

/// A query-length-aware debouncer for search input, driven by a
/// [SearchDebouncePolicy].
///
/// Backed by two [Debounce] functions — one per delay — because a [Debounce]'s
/// wait is fixed at construction. Each call runs the debouncer for the matching
/// query length and cancels the other so only a single search is scheduled.
@internal
class SearchDebouncer {
  /// Creates a [SearchDebouncer] that runs [onSearch] after the delay [policy]
  /// selects for the query length elapses.
  SearchDebouncer(
    Function onSearch, {
    SearchDebouncePolicy policy = const SearchDebouncePolicy(),
  }) : _policy = policy,
       _shortQuery = debounce(onSearch, policy.shortQueryDelay),
       _longQuery = debounce(onSearch, policy.defaultDelay);

  final SearchDebouncePolicy _policy;
  final Debounce _shortQuery;
  final Debounce _longQuery;

  /// Whether a debounced search is scheduled but has not run yet.
  bool get isActive => _shortQuery.isPending || _longQuery.isPending;

  /// Schedules a debounced search for a query of [queryLength], cancelling any
  /// search pending in the other length bucket.
  void call(int queryLength) {
    if (queryLength <= _policy.shortQueryMaxLength) {
      _longQuery.cancel();
      _shortQuery();
    } else {
      _shortQuery.cancel();
      _longQuery();
    }
  }

  /// Cancels any pending debounced search.
  void cancel() {
    _shortQuery.cancel();
    _longQuery.cancel();
  }
}
