import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/predefined_filter.dart';
import 'package:test/test.dart';

void main() {
  const filterJson = {
    r'$or': [
      {
        'type': {r'$eq': 'messaging'},
      },
      {
        r'$and': [
          {'frozen': false},
          {
            'members': {
              r'$in': ['user-1', 'user-2'],
            },
          },
        ],
      },
    ],
  };

  final json = {
    'name': 'unread',
    'filter': filterJson,
    'sort': [
      {'field': 'last_message_at', 'direction': -1},
    ],
  };

  test('PredefinedFilter.fromJson parses all fields', () {
    final parsed = PredefinedFilter.fromJson(json);

    expect(parsed.name, 'unread');
    expect(parsed.filter.value, filterJson);
    expect(parsed.sort, hasLength(1));
    expect(parsed.sort!.first.field, 'last_message_at');
    expect(parsed.sort!.first.direction, SortOption.DESC);
  });

  group('effectiveSort', () {
    test('returns the echoed sort when present', () {
      const filter = PredefinedFilter(
        name: 'x',
        filter: Filter.empty(),
        sort: [SortOption<ChannelState>.asc(ChannelSortKey.createdAt)],
      );

      final sort = filter.effectiveSort;

      expect(sort, hasLength(1));
      expect(sort.single.field, equals(ChannelSortKey.createdAt));
      expect(sort.single.direction, equals(SortOption.ASC));
    });

    test(
      'falls back to lastUpdated desc when sort is null and filter is empty',
      () {
        const predefined = PredefinedFilter(name: 'x', filter: Filter.empty());

        final sort = predefined.effectiveSort;

        expect(sort, hasLength(1));
        expect(sort.single.field, equals(ChannelSortKey.lastUpdated));
        expect(sort.single.direction, equals(SortOption.DESC));
      },
    );

    test('falls back to lastMessageAt desc when raw filter '
        'touches last_message_at', () {
      const predefined = PredefinedFilter(
        name: 'x',
        filter: Filter.raw(
          value: {
            'last_message_at': {r'$gt': '2024-01-01T00:00:00Z'},
          },
        ),
      );

      final sort = predefined.effectiveSort;

      expect(sort.single.field, equals(ChannelSortKey.lastMessageAt));
      expect(sort.single.direction, equals(SortOption.DESC));
    });

    test('falls back to lastMessageAt desc when last_message_at '
        r'is nested under $or', () {
      const predefined = PredefinedFilter(
        name: 'x',
        filter: Filter.raw(
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
        ),
      );

      final sort = predefined.effectiveSort;

      expect(sort.single.field, equals(ChannelSortKey.lastMessageAt));
    });

    test(
      'falls back to lastUpdated desc when filter touches only other fields',
      () {
        const predefined = PredefinedFilter(
          name: 'x',
          filter: Filter.raw(
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
          ),
        );

        final sort = predefined.effectiveSort;

        expect(sort.single.field, equals(ChannelSortKey.lastUpdated));
      },
    );

    test('falls back to lastMessageAt desc when typed Filter.and '
        'touches last_message_at', () {
      final predefined = PredefinedFilter(
        name: 'x',
        filter: Filter.and([
          Filter.equal('type', 'messaging'),
          Filter.greater('last_message_at', '2024-01-01T00:00:00Z'),
        ]),
      );

      final sort = predefined.effectiveSort;

      expect(sort.single.field, equals(ChannelSortKey.lastMessageAt));
    });
  });
}
