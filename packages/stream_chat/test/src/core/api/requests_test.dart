// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

/// Simple test model that implements ComparableFieldProvider
class TestModel with ComparableFieldProvider {
  const TestModel({
    this.name,
    this.age,
    this.createdAt,
    this.active,
  });

  final String? name;
  final int? age;
  final DateTime? createdAt;
  final bool? active;

  @override
  ComparableField? getComparableField(String sortKey) {
    return switch (sortKey) {
      'name' => ComparableField.fromValue(name),
      'age' => ComparableField.fromValue(age),
      'created_at' => ComparableField.fromValue(createdAt),
      'active' => ComparableField.fromValue(active),
      _ => null,
    };
  }
}

void main() {
  group('src/api/requests', () {
    group('SortOption', () {
      test('serialization', () {
        const option = SortOption.desc('name');
        final j = option.toJson();
        expect(j, {'field': 'name', 'direction': -1});
      });

      test('should create a SortOption with default DESC direction', () {
        const option = SortOption<TestModel>('name');
        expect(option.field, 'name');
        expect(option.direction, SortOption.DESC);
      });

      test('should create a SortOption with ASC direction', () {
        const option = SortOption<TestModel>.asc('age');
        expect(option.field, 'age');
        expect(option.direction, SortOption.ASC);
      });

      test('should create a SortOption with DESC direction', () {
        const option = SortOption<TestModel>.desc('age');
        expect(option.field, 'age');
        expect(option.direction, SortOption.DESC);
      });

      test('should correctly deserialize from JSON', () {
        final json = {'field': 'age', 'direction': 1};
        final option = SortOption<TestModel>.fromJson(json);
        expect(option.field, 'age');
        expect(option.direction, SortOption.ASC);
      });

      test('should compare two objects in descending order', () {
        const option = SortOption<TestModel>.desc('age');
        const a = TestModel(age: 30);
        const b = TestModel(age: 25);

        // In descending order, 30 should come before 25
        expect(option.compare(a, b), lessThan(0));
      });

      test('should compare two objects in ascending order', () {
        const option = SortOption<TestModel>.asc('age');
        const a = TestModel(age: 25);
        const b = TestModel(age: 30);

        // In ascending order, 25 should come before 30
        expect(option.compare(a, b), lessThan(0));
      });

      test('should handle null values correctly', () {
        const option = SortOption<TestModel>.desc('age');
        const a = TestModel(age: null);
        const b = TestModel(age: 25);
        const c = TestModel(age: null);

        // Null values should come after non-null values
        expect(option.compare(a, b), greaterThan(0));
        expect(option.compare(b, a), lessThan(0));

        // Two null values should be equal
        expect(option.compare(a, c), equals(0));
      });

      test('should compare date fields correctly', () {
        const option = SortOption<TestModel>.desc('created_at');
        final now = DateTime.now();
        final earlier = now.subtract(const Duration(days: 1));

        final a = TestModel(createdAt: now);
        final b = TestModel(createdAt: earlier);

        // In descending order, now should come before earlier
        expect(option.compare(a, b), lessThan(0));
      });

      test('should compare boolean fields correctly', () {
        const option = SortOption<TestModel>.desc('active');
        const a = TestModel(active: true);
        const b = TestModel(active: false);
        const c = TestModel(active: true);

        // In descending order, true should come before false
        expect(option.compare(a, b), lessThan(0));
        expect(option.compare(b, a), greaterThan(0));

        // Two true values should be equal
        expect(option.compare(a, c), equals(0));
      });

      test('should handle custom comparator', () {
        // Custom comparator that sorts by name length
        final option = SortOption<TestModel>.desc(
          'name',
          comparator: (a, b) {
            final aLength = a.name?.length ?? 0;
            final bLength = b.name?.length ?? 0;
            return aLength.compareTo(bLength);
          },
        );

        const a = TestModel(name: 'longer_name');
        const b = TestModel(name: 'short');

        // With custom comparator, longer name should come before shorter name
        expect(option.compare(a, b), lessThan(0));
      });
    });

    group('Composite Sorting', () {
      test('should sort list using multiple sort criteria', () {
        final models = [
          const TestModel(name: 'Alice', age: 30),
          const TestModel(name: 'Bob', age: 30),
          const TestModel(name: 'Charlie', age: 25),
          const TestModel(name: 'David', age: 40),
        ];

        // Sort by age (DESC) then name (ASC)
        final sortOptions = <SortOption<TestModel>>[
          const SortOption.desc('age'),
          const SortOption.asc('name'),
        ];

        // Use the compare extension
        models.sort(sortOptions.compare);

        // Expected order: David (40), Alice (30), Bob (30), Charlie (25)
        expect(models[0].name, 'David');
        // Same age as Bob, but name is alphabetically first
        expect(models[1].name, 'Alice');
        // Same age as Alice, but name is alphabetically second
        expect(models[2].name, 'Bob');
        expect(models[3].name, 'Charlie');
      });

      test('should handle null values in multi-sort', () {
        final models = [
          const TestModel(name: 'Alice', age: null),
          const TestModel(name: 'Bob', age: 30),
          const TestModel(name: 'Charlie', age: null),
          const TestModel(name: null, age: 40),
        ];

        // Sort by age (DESC) then name (ASC)
        final sortOptions = <SortOption<TestModel>>[
          const SortOption.desc('age'),
          const SortOption.asc('name'),
        ];

        models.sort(sortOptions.compare);

        // Expected order:
        // 1. null name, age 40
        // 2. Bob, age 30
        // 3. Alice, null age
        // 4. Charlie, null age
        expect(models[0].name, null);
        expect(models[1].name, 'Bob');
        // Null age, but name comes before Charlie alphabetically
        expect(models[2].name, 'Alice');
        // Null age, but name comes after Alice alphabetically
        expect(models[3].name, 'Charlie');
      });

      test('should handle empty sort options', () {
        final models = [
          const TestModel(name: 'Alice', age: 30),
          const TestModel(name: 'Bob', age: 25),
        ];

        // Empty sort options
        final sortOptions = <SortOption<TestModel>>[];

        // Should not change the order
        final originalOrder = [...models];
        models.sort(sortOptions.compare);

        expect(models, equals(originalOrder));
      });

      test('should sort with different data types in sequence', () {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(days: 1));

        final models = [
          TestModel(name: 'Alice', active: true, createdAt: yesterday),
          TestModel(name: 'Bob', active: false, createdAt: now),
          TestModel(name: 'Charlie', active: true, createdAt: now),
        ];

        // Sort by created_at (DESC), active (DESC), then name (ASC)
        final sortOptions = <SortOption<TestModel>>[
          const SortOption.desc('created_at'),
          const SortOption.desc('active'),
          const SortOption.asc('name'),
        ];

        models.sort(sortOptions.compare);

        // Expected order:
        // 1. Charlie - newest and active
        // 2. Bob - newest but not active
        // 3. Alice - older but active
        expect(models[0].name, 'Charlie');
        expect(models[1].name, 'Bob');
        expect(models[2].name, 'Alice');
      });
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
