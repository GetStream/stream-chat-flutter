import 'dart:math' as math;

/// Splits a list of bind parameters into chunks safe for a single
/// `WHERE col IN (?, ?, ...)` SQLite statement.
///
/// SQLite enforces `SQLITE_MAX_VARIABLE_NUMBER` (default 999 on the Android
/// build shipped via `sqlite3_flutter_libs`) on the number of `?` placeholders
/// per statement. Each id in the list becomes one placeholder, so an
/// unbounded id list would fail the query outright with
/// `too many SQL variables`. Callers that batch-load related rows by id
/// must run one SELECT per chunk and merge the results in Dart. The default
/// chunk size of 900 leaves headroom for any other bound parameters that
/// share the same statement (for example a `AND userId = ?` filter).
Iterable<List<T>> chunked<T>(List<T> input, [int size = 900]) sync* {
  for (var i = 0; i < input.length; i += size) {
    yield input.sublist(i, math.min(i + size, input.length));
  }
}
