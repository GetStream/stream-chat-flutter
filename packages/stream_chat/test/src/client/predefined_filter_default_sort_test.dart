import 'package:stream_chat/src/client/predefined_filter_default_sort.dart';
import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:test/test.dart';

void main() {
  test('returns lastUpdated desc when filter is empty', () {
    final sort = defaultChannelStateSortFor(const Filter.empty());

    expect(sort, hasLength(1));
    expect(sort.single.field, equals(ChannelSortKey.lastUpdated));
    expect(sort.single.direction, equals(SortOption.DESC));
  });

  test('returns lastMessageAt desc when raw filter touches last_message_at', () {
    const filter = Filter.raw(
      value: {
        'last_message_at': {r'$gt': '2024-01-01T00:00:00Z'},
      },
    );

    final sort = defaultChannelStateSortFor(filter);

    expect(sort.single.field, equals(ChannelSortKey.lastMessageAt));
    expect(sort.single.direction, equals(SortOption.DESC));
  });

  test(r'returns lastMessageAt desc when last_message_at is nested under $or', () {
    const filter = Filter.raw(
      value: {
        r'$or': [
          {
            'type': {r'$eq': 'messaging'},
          },
          {
            'last_message_at': {r'$gt': '2024-01-01T00:00:00Z'},
          },
        ],
      },
    );

    final sort = defaultChannelStateSortFor(filter);

    expect(sort.single.field, equals(ChannelSortKey.lastMessageAt));
  });

  test('returns lastUpdated desc when filter touches only other fields', () {
    const filter = Filter.raw(
      value: {
        r'$and': [
          {'frozen': false},
          {
            'members': {
              r'$in': ['u1', 'u2'],
            },
          },
        ],
      },
    );

    final sort = defaultChannelStateSortFor(filter);

    expect(sort.single.field, equals(ChannelSortKey.lastUpdated));
  });

  test('returns lastMessageAt desc when typed Filter.and touches last_message_at', () {
    final filter = Filter.and([
      Filter.equal('type', 'messaging'),
      Filter.greater('last_message_at', '2024-01-01T00:00:00Z'),
    ]);

    final sort = defaultChannelStateSortFor(filter);

    expect(sort.single.field, equals(ChannelSortKey.lastMessageAt));
  });
}
