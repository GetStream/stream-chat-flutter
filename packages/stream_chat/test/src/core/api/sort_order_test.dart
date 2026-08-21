// ignore_for_file: avoid_redundant_argument_values

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/member.dart';
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

    test('should default pinnedAt and lastMessageAt to nullsLast in both directions', () {
      const sortKeys = [ChannelSortKey.pinnedAt, ChannelSortKey.lastMessageAt];
      for (final key in sortKeys) {
        expect(SortOption<ChannelState>.desc(key).nullOrdering, NullOrdering.nullsLast, reason: '$key desc');
        expect(SortOption<ChannelState>.asc(key).nullOrdering, NullOrdering.nullsLast, reason: '$key asc');
      }
    });

    test('should let an explicit nullOrdering override the default', () {
      const option = SortOption<ChannelState>.desc(
        ChannelSortKey.pinnedAt,
        nullOrdering: NullOrdering.nullsFirst,
      );
      expect(option.nullOrdering, NullOrdering.nullsFirst);
    });

    test('should resolve field defaults when deserialized from json', () {
      final pinnedAt = SortOption<ChannelState>.fromJson({'field': 'pinned_at', 'direction': -1});
      final lastMessageAt = SortOption<ChannelState>.fromJson({'field': 'last_message_at', 'direction': -1});
      final lastUpdated = SortOption<ChannelState>.fromJson({'field': 'last_updated', 'direction': -1});

      expect(pinnedAt.nullOrdering, NullOrdering.nullsLast);
      expect(lastMessageAt.nullOrdering, NullOrdering.nullsLast);
      expect(lastUpdated.nullOrdering, NullOrdering.nullsFirst);
    });
  });

  group('Channel sort server parity', () {
    final createdAt = DateTime.utc(2026, 1, 1);

    ChannelState channelState(String id, {DateTime? pinnedAt, DateTime? lastMessageAt}) {
      return ChannelState(
        channel: ChannelModel(
          id: id,
          type: 'messaging',
          createdAt: createdAt,
          lastMessageAt: lastMessageAt,
        ),
        membership: Member(userId: 'me', pinnedAt: pinnedAt),
      );
    }

    List<String> idsOf(List<ChannelState> states) => states.map((it) => it.channel!.id).toList();

    test('should keep pinned channels on top when sorting by pinnedAt desc', () {
      final channels = [
        channelState('unpinned-recent', lastMessageAt: createdAt.add(const Duration(days: 5))),
        channelState('pinned-old', pinnedAt: createdAt.add(const Duration(days: 1))),
        channelState('unpinned-older', lastMessageAt: createdAt.add(const Duration(days: 4))),
        channelState('pinned-new', pinnedAt: createdAt.add(const Duration(days: 2))),
      ];

      const sort = [
        SortOption<ChannelState>.desc(ChannelSortKey.pinnedAt),
        SortOption<ChannelState>.desc(ChannelSortKey.lastUpdated),
      ];

      expect(idsOf(channels.sorted(sort.compare)), [
        'pinned-new',
        'pinned-old',
        'unpinned-recent',
        'unpinned-older',
      ]);
    });

    test('should keep pinned channels on top when sorting by pinnedAt asc', () {
      final channels = [
        channelState('unpinned', lastMessageAt: createdAt.add(const Duration(days: 5))),
        channelState('pinned-new', pinnedAt: createdAt.add(const Duration(days: 2))),
        channelState('pinned-old', pinnedAt: createdAt.add(const Duration(days: 1))),
      ];

      const sort = [SortOption<ChannelState>.asc(ChannelSortKey.pinnedAt)];

      expect(idsOf(channels.sorted(sort.compare)), ['pinned-old', 'pinned-new', 'unpinned']);
    });

    test('should keep channels without messages at the bottom when sorting by lastMessageAt desc', () {
      final channels = [
        channelState('no-messages'),
        channelState('newest', lastMessageAt: createdAt.add(const Duration(days: 5))),
        channelState('oldest', lastMessageAt: createdAt.add(const Duration(days: 1))),
      ];

      const sort = [SortOption<ChannelState>.desc(ChannelSortKey.lastMessageAt)];

      expect(idsOf(channels.sorted(sort.compare)), ['newest', 'oldest', 'no-messages']);
    });

    test('should keep nulls first for other fields when sorting desc', () {
      final channels = [
        ChannelState(
          channel: ChannelModel(
            id: 'red-team',
            type: 'messaging',
            createdAt: createdAt,
            extraData: const {'team': 'red'},
          ),
        ),
        ChannelState(
          channel: ChannelModel(id: 'no-team', type: 'messaging', createdAt: createdAt),
        ),
      ];

      const sort = [SortOption<ChannelState>.desc('team')];

      expect(idsOf(channels.sorted(sort.compare)), ['no-team', 'red-team']);
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

      expect(option.compare(a, b), greaterThan(0));
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
