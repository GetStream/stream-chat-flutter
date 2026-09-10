import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/predefined_filter.dart';
import 'package:stream_core/stream_core.dart' show SortDirection;
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
    expect(parsed.filter.toJson(), filterJson);
    expect(parsed.sort, hasLength(1));
    expect(parsed.sort!.first.field.remote, 'last_message_at');
    expect(parsed.sort!.first.direction, SortDirection.desc);
  });

  group('sort direction', () {
    PredefinedFilter parseWithDirection(Object? direction) {
      return PredefinedFilter.fromJson({
        'name': 'unread',
        'filter': <String, Object?>{},
        'sort': [
          {'field': 'last_message_at', 'direction': direction},
        ],
      });
    }

    test('-1 parses as descending', () {
      expect(parseWithDirection(-1).sort!.single.direction, SortDirection.desc);
    });

    test('1 parses as ascending', () {
      expect(parseWithDirection(1).sort!.single.direction, SortDirection.asc);
    });

    test('anything else parses as ascending, as the server reads it', () {
      // The API treats a direction other than -1 as ascending — see
      // `ToSortParameter` and `isAscending := sortValue.Direction != -1`.
      expect(parseWithDirection(0).sort!.single.direction, SortDirection.asc);
    });

    test('a field the SDK does not model still resolves', () {
      final parsed = PredefinedFilter.fromJson({
        'name': 'unread',
        'filter': <String, Object?>{},
        'sort': [
          {'field': 'some_custom_field', 'direction': -1},
        ],
      });

      expect(parsed.sort!.single.field.remote, 'some_custom_field');
      expect(parsed.sort!.single.direction, SortDirection.desc);
    });
  });

  group('effectiveSort', () {
    test('returns the echoed sort when present', () {
      final filter = PredefinedFilter(
        name: 'x',
        filter: const ChannelFilter.raw({}),
        sort: [ChannelSort.asc(ChannelSortField.createdAt)],
      );

      final sort = filter.effectiveSort;

      expect(sort, hasLength(1));
      expect(sort.single.field.remote, equals(ChannelSortField.createdAt.remote));
      expect(sort.single.direction, equals(SortDirection.asc));
    });

    test('falls back to lastUpdated desc when sort is null and filter is empty', () {
      const predefined = PredefinedFilter(name: 'x', filter: ChannelFilter.raw({}));

      final sort = predefined.effectiveSort;

      expect(sort, hasLength(1));
      expect(sort.single.field.remote, equals(ChannelSortField.lastUpdated.remote));
      expect(sort.single.direction, equals(SortDirection.desc));
    });

    test('falls back to lastMessageAt desc when raw filter touches last_message_at', () {
      const predefined = PredefinedFilter(
        name: 'x',
        filter: ChannelFilter.raw(
          {
            'last_message_at': {r'$gt': '2024-01-01T00:00:00Z'},
          },
        ),
      );

      final sort = predefined.effectiveSort;

      expect(sort.single.field.remote, equals(ChannelSortField.lastMessageAt.remote));
      expect(sort.single.direction, equals(SortDirection.desc));
    });

    test(r'falls back to lastMessageAt desc when last_message_at is nested under $or', () {
      const predefined = PredefinedFilter(
        name: 'x',
        filter: ChannelFilter.raw(
          {
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

      expect(sort.single.field.remote, equals(ChannelSortField.lastMessageAt.remote));
    });

    test('falls back to lastUpdated desc when filter touches only other fields', () {
      const predefined = PredefinedFilter(
        name: 'x',
        filter: ChannelFilter.raw(
          {
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

      expect(sort.single.field.remote, equals(ChannelSortField.lastUpdated.remote));
    });

    test('falls back to lastMessageAt desc when typed Filter.and touches last_message_at', () {
      final predefined = PredefinedFilter(
        name: 'x',
        filter: ChannelFilter.and([
          ChannelFilter.equal(ChannelFilterField.type, 'messaging'),
          ChannelFilter.greater(ChannelFilterField.lastMessageAt, '2024-01-01T00:00:00Z'),
        ]),
      );

      final sort = predefined.effectiveSort;

      expect(sort.single.field.remote, equals(ChannelSortField.lastMessageAt.remote));
    });
  });
}
