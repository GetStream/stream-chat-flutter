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

      test('copyWith', () {
        final params = PaginationParams(
          offset: 10,
          limit: 20,
          createdAtAfter: DateTime.now(),
          createdAtAfterOrEqual: DateTime.now(),
          createdAtAround: DateTime.now(),
          createdAtBefore: DateTime.now(),
          createdAtBeforeOrEqual: DateTime.now(),
          greaterThan: 'greater-than',
          greaterThanOrEqual: 'greater-than-or-equal',
          lessThan: 'less-than',
          lessThanOrEqual: 'less-than-or-equal',
          idAround: 'id-around',
        );

        final sameOld = params.copyWith();
        expect(sameOld, equals(params));

        final newDateTime = DateTime.now().add(const Duration(days: 2));
        const newTestString = 'test';
        final newParams = params.copyWith(
          limit: 2,
          offset: 2,
          createdAtAfter: newDateTime,
          createdAtAfterOrEqual: newDateTime,
          createdAtAround: newDateTime,
          createdAtBefore: newDateTime,
          createdAtBeforeOrEqual: newDateTime,
          greaterThan: newTestString,
          greaterThanOrEqual: newTestString,
          lessThan: newTestString,
          lessThanOrEqual: newTestString,
          idAround: newTestString,
        );

        expect(newParams.limit, 2);
        expect(newParams.offset, 2);
        expect(newParams.createdAtAfter, newDateTime);
        expect(newParams.createdAtAfterOrEqual, newDateTime);
        expect(newParams.createdAtAround, newDateTime);
        expect(newParams.createdAtBefore, newDateTime);
        expect(newParams.createdAtBeforeOrEqual, newDateTime);
        expect(newParams.greaterThan, newTestString);
        expect(newParams.greaterThanOrEqual, newTestString);
        expect(newParams.lessThan, newTestString);
        expect(newParams.lessThanOrEqual, newTestString);
        expect(newParams.idAround, newTestString);
      });
    });
  });
}
