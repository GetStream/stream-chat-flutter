import 'package:meta/meta.dart';
import 'package:rate_limiter/rate_limiter.dart';

/// A query-length-aware debouncer for search input.
///
/// Short, low-selectivity queries (of at most [_shortQueryMaxLength]
/// characters) wait longer before triggering a search, reducing load on the
/// backend; longer, more selective queries use the standard delay.
///
/// Backed by two [Debounce] functions — one per delay — because a [Debounce]'s
/// wait is fixed at construction. Each call runs the debouncer for the matching
/// query length and cancels the other so only a single search is scheduled.
@internal
class SearchDebouncer {
  /// Creates a [SearchDebouncer] that runs [onSearch] after the
  /// length-dependent delay elapses.
  SearchDebouncer(Function onSearch)
    : _shortQuery = debounce(onSearch, _shortQueryDelay),
      _longQuery = debounce(onSearch, _defaultDelay);

  // Queries of at most this many characters are low-selectivity and use the
  // longer [_shortQueryDelay]; anything longer uses [_defaultDelay].
  static const _shortQueryMaxLength = 2;
  static const _shortQueryDelay = Duration(milliseconds: 500);
  static const _defaultDelay = Duration(milliseconds: 300);

  final Debounce _shortQuery;
  final Debounce _longQuery;

  /// Whether a debounced search is scheduled but has not run yet.
  bool get isActive => _shortQuery.isPending || _longQuery.isPending;

  /// Schedules a debounced search for a query of [queryLength], cancelling any
  /// search pending in the other length bucket.
  void call(int queryLength) {
    if (queryLength <= _shortQueryMaxLength) {
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
