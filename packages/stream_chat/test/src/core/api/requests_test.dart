import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  group('src/api/requests', () {
    test('SortOption', () {
      const option = SortOption('name');
      final j = option.toJson();
      expect(j, {'field': 'name', 'direction': -1});
    });

    group('PaginationParams', () {
      test('default', () {
        const option = PaginationParams();
        final j = option.toJson();
        expect(j, containsPair('limit', 10));
      });

      test(
        'should throw if non-zero `offset` and `next` both are provided',
        () {
          try {
            PaginationParams(offset: 10, next: 'next-message-id');
          } catch (e) {
            expect(e, isA<AssertionError>());
          }
        },
      );
    });
  });
}
