import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/converter/sort_order_converter.dart';

void main() {
  const converter = ChannelStateSortOrderConverter();

  test('non-empty SortOrder round-trips unchanged', () {
    const original = <SortOption<ChannelState>>[
      SortOption<ChannelState>.desc(ChannelSortKey.pinnedAt),
      SortOption<ChannelState>.asc(ChannelSortKey.createdAt),
    ];

    final decoded = converter.fromSql(converter.toSql(original));

    expect(decoded.length, original.length);
    for (var i = 0; i < original.length; i++) {
      expect(decoded[i].field, original[i].field);
      expect(decoded[i].direction, original[i].direction);
    }
  });

  test('empty SortOrder round-trips as empty', () {
    final decoded = converter.fromSql(converter.toSql(const []));
    expect(decoded, isEmpty);
  });
}
