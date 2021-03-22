import 'package:test/test.dart';
import 'package:stream_chat/stream_chat.dart';

void main() {
  group('src/api/requests', () {
    test('SortOption', () {
      const option = SortOption('name');
      final j = option.toJson();
      expect(j, {'field': 'name', 'direction': -1});
    });

    test('PaginationParams', () {
      const option = PaginationParams();
      final j = option.toJson();
      expect(j, {'limit': 10, 'offset': 0});
    });
  });
}
