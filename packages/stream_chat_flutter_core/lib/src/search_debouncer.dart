import 'package:meta/meta.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:stream_chat/stream_chat.dart' show Filter;

// The wire operators of the text-search filters — the only ones a user types
// into incrementally. Read from the LLC [Filter] so they stay in sync with it
// rather than being hardcoded.
final _autoCompleteOperator = Filter.autoComplete('', '').operator;
final _queryOperator = Filter.query('', '').operator;

/// The length of the search text in [filter], or `null` when it holds none.
///
/// Only the text-search operators (`$autocomplete`, `$q`) count; a filter built
/// around them is debounced by the longest such text, even when nested inside a
/// compound filter. Anything else returns `null`, meaning "not a text search"
/// — an exact-match lookup, for example, should reload immediately rather than
/// wait for the debounce.
@internal
int? searchQueryLength(Filter? filter) {
  if (filter == null) return null;

  final value = filter.value;
  final isTextSearch = filter.operator == _autoCompleteOperator || filter.operator == _queryOperator;
  if (isTextSearch && value is String) return value.length;

  if (value is Iterable<Filter>) {
    int? longest;
    for (final nested in value) {
      final length = searchQueryLength(nested);
      if (length != null && (longest == null || length > longest)) longest = length;
    }
    return longest;
  }

  return null;
}

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
