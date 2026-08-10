import 'package:meta/meta.dart';
import 'package:stream_chat/stream_chat.dart';

// Wire operators of the text-search filters (`Filter.autoComplete` and
// `Filter.query`) — the only ones a user types into incrementally.
const _autoCompleteOperator = r'$autocomplete';
const _queryOperator = r'$q';

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
