// ignore_for_file: avoid_redundant_argument_values

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:test/test.dart';

/// Simple test model that implements ComparableFieldProvider
class TestModel extends Equatable implements ComparableFieldProvider {
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
  List<Object?> get props => [name, age, createdAt, active];

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

/// Helper to compare sorted lists cleanly
void expectSorted<T extends ComparableFieldProvider>(
  List<T> input,
  List<SortOption<T>> sortOptions,
  List<T> expectedOrder,
) {
  final sorted = input.sorted(sortOptions.compare);
  expect(sorted, equals(expectedOrder));
}

void main() {
  group('SortOption basics', () {
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
  });

  group('SortOption single field', () {
    test('should compare two objects in descending order', () {
      const option = SortOption<TestModel>.desc('age');
      const a = TestModel(age: 30);
      const b = TestModel(age: 25);
      expect(option.compare(a, b), lessThan(0));
    });

    test('should compare two objects in ascending order', () {
      const option = SortOption<TestModel>.asc('age');
      const a = TestModel(age: 25);
      const b = TestModel(age: 30);
      expect(option.compare(a, b), lessThan(0));
    });

    test('should handle null values correctly (default nullOrdering)', () {
      const option = SortOption<TestModel>.desc('age');
      const a = TestModel(age: null);
      const b = TestModel(age: 25);
      const c = TestModel(age: null);

      expect(option.compare(a, b), lessThan(0));
      expect(option.compare(b, a), greaterThan(0));
      expect(option.compare(a, c), equals(0));
    });

    test('should compare date fields correctly', () {
      const option = SortOption<TestModel>.desc('created_at');
      final now = DateTime.now();
      final earlier = now.subtract(const Duration(days: 1));

      final a = TestModel(createdAt: now);
      final b = TestModel(createdAt: earlier);

      expect(option.compare(a, b), lessThan(0));
    });

    test('should compare boolean fields correctly', () {
      const option = SortOption<TestModel>.desc('active');
      const a = TestModel(active: true);
      const b = TestModel(active: false);
      const c = TestModel(active: true);

      expect(option.compare(a, b), lessThan(0));
      expect(option.compare(b, a), greaterThan(0));
      expect(option.compare(a, c), equals(0));
    });

    test('should handle custom comparator', () {
      final option = SortOption<TestModel>.desc(
        'name',
        comparator: (a, b) {
          final aLength = a.name?.length ?? 0;
          final bLength = b.name?.length ?? 0;
          return bLength.compareTo(aLength);
        },
      );

      const a = TestModel(name: 'longer_name');
      const b = TestModel(name: 'short');

      expect(option.compare(a, b), lessThan(0));
    });

    test('should respect explicit nullOrdering=nullsLast on DESC', () {
      final models = [
        const TestModel(age: null),
        const TestModel(age: 40),
        const TestModel(age: 30),
      ];

      final sortOptions = <SortOption<TestModel>>[
        const SortOption.desc('age', nullOrdering: NullOrdering.nullsLast),
      ];

      expectSorted(models, sortOptions, [
        const TestModel(age: 40),
        const TestModel(age: 30),
        const TestModel(age: null),
      ]);
    });

    test('should respect explicit nullOrdering=nullsFirst on ASC', () {
      final models = [
        const TestModel(name: 'Bob'),
        const TestModel(name: null),
        const TestModel(name: 'Alice'),
      ];

      final sortOptions = <SortOption<TestModel>>[
        const SortOption.asc('name', nullOrdering: NullOrdering.nullsFirst),
      ];

      expectSorted(models, sortOptions, [
        const TestModel(name: null),
        const TestModel(name: 'Alice'),
        const TestModel(name: 'Bob'),
      ]);
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

      final sortOptions = <SortOption<TestModel>>[
        const SortOption.desc('age'),
        const SortOption.asc('name'),
      ];

      expectSorted(models, sortOptions, [
        const TestModel(name: 'David', age: 40),
        const TestModel(name: 'Alice', age: 30),
        const TestModel(name: 'Bob', age: 30),
        const TestModel(name: 'Charlie', age: 25),
      ]);
    });

    test('should handle null values in multi-sort', () {
      final models = [
        const TestModel(name: 'Alice', age: null),
        const TestModel(name: 'Bob', age: 30),
        const TestModel(name: 'Charlie', age: null),
        const TestModel(name: null, age: 40),
      ];

      final sortOptions = <SortOption<TestModel>>[
        const SortOption.desc('age'),
        const SortOption.asc('name'),
      ];

      expectSorted(models, sortOptions, [
        const TestModel(name: 'Alice', age: null),
        const TestModel(name: 'Charlie', age: null),
        const TestModel(name: null, age: 40),
        const TestModel(name: 'Bob', age: 30),
      ]);
    });

    test('should handle empty sort options', () {
      final models = [
        const TestModel(name: 'Alice', age: 30),
        const TestModel(name: 'Bob', age: 25),
      ];

      final sortOptions = <SortOption<TestModel>>[];

      expectSorted(models, sortOptions, [
        const TestModel(name: 'Alice', age: 30),
        const TestModel(name: 'Bob', age: 25),
      ]);
    });

    test('should sort with different data types in sequence', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final models = [
        TestModel(name: 'Alice', active: true, createdAt: yesterday),
        TestModel(name: 'Bob', active: false, createdAt: now),
        TestModel(name: 'Charlie', active: true, createdAt: now),
      ];

      final sortOptions = <SortOption<TestModel>>[
        const SortOption.desc('created_at'),
        const SortOption.desc('active'),
        const SortOption.asc('name'),
      ];

      expectSorted(models, sortOptions, [
        TestModel(name: 'Charlie', active: true, createdAt: now),
        TestModel(name: 'Bob', active: false, createdAt: now),
        TestModel(name: 'Alice', active: true, createdAt: yesterday),
      ]);
    });

    test('should sort by second field when primary field values are equal', () {
      final models = [
        const TestModel(name: 'Charlie', age: 30),
        const TestModel(name: 'Bob', age: 30),
        const TestModel(name: 'Alice', age: 30),
      ];

      final sortOptions = <SortOption<TestModel>>[
        const SortOption.desc('age'),
        const SortOption.asc('name'),
      ];

      expectSorted(models, sortOptions, [
        const TestModel(name: 'Alice', age: 30),
        const TestModel(name: 'Bob', age: 30),
        const TestModel(name: 'Charlie', age: 30),
      ]);
    });

    test('should handle all fields null gracefully', () {
      final models = [
        const TestModel(name: null, age: null),
        const TestModel(name: null, age: null),
      ];

      final sortOptions = <SortOption<TestModel>>[
        const SortOption.desc('age'),
        const SortOption.asc('name'),
      ];

      expectSorted(models, sortOptions, [
        const TestModel(name: null, age: null),
        const TestModel(name: null, age: null),
      ]);
    });

    test('should handle mixed nulls in tie-breaker field', () {
      final models = [
        const TestModel(name: 'Alice', age: null),
        const TestModel(name: null, age: null),
        const TestModel(name: 'Bob', age: null),
      ];

      final sortOptions = <SortOption<TestModel>>[
        const SortOption.desc('age'),
        const SortOption.asc('name'),
      ];

      expectSorted(models, sortOptions, [
        const TestModel(name: 'Alice', age: null),
        const TestModel(name: 'Bob', age: null),
        const TestModel(name: null, age: null),
      ]);
    });
  });
}
