import 'package:stream_chat/src/core/api/sort_order.dart';
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
}
