import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/search_query_length.dart';

void main() {
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
}
