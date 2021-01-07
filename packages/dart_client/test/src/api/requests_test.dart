import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';

void main() {
  group('src/api/requests', () {
    test('SortOption', () {
      final option = SortOption('name');
      final j = option.toJson();
      expect(j, {'field': 'name', 'direction': -1});
    });

    test('PaginationParams', () {
      final option = PaginationParams();
      final j = option.toJson();
      expect(j, {'limit': 10});
    });
  });
}
