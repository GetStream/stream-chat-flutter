import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_chat/src/core/models/banned_user.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/draft.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/message_reminder.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/thread.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/string_sort_normalizer.dart';
import 'package:stream_core/stream_core.dart'
    show CompositeComparator, NullOrdering, Sort, SortField, SortFieldValueGetter, Standard;
import 'package:test/test.dart';

class TestModel extends Equatable {
  const TestModel({
    this.name,
    this.age,
    this.createdAt,
    this.active,
    this.tag,
  });

  final String? name;
  final int? age;
  final DateTime? createdAt;
  final bool? active;
  final Object? tag;

  @override
  List<Object?> get props => [name, age, createdAt, active, tag];
}

class TestSort extends Sort<TestModel> {
  const TestSort.asc(
    TestSortField super.field, {
    super.nullOrdering = NullOrdering.nullsLast,
  }) : super.asc();

  const TestSort.desc(
    TestSortField super.field, {
    super.nullOrdering = NullOrdering.nullsFirst,
  }) : super.desc();
}

class TestSortField extends SortField<TestModel> {
  TestSortField(String remote, this.value) : super(remote, value);

  final SortFieldValueGetter<TestModel, Object> value;

  static final name = TestSortField('name', (it) => it.name?.let(normalizeStringForSort));
  static final age = TestSortField('age', (it) => it.age);
  static final createdAt = TestSortField('created_at', (it) => it.createdAt);
  static final active = TestSortField('active', (it) => it.active);

  // An arbitrary object, to prove an unorderable value does not throw.
  static final tag = TestSortField('tag', (it) => it.tag);

  // A field that projects onto something orderable, which is what replaces the
  // custom comparator the old `SortOption` accepted.
  static final nameLength = TestSortField('name_length', (it) => it.name?.length);
}

/// Helper to compare sorted lists cleanly
void expectSorted<T extends Object>(
  List<T> input,
  List<Sort<T>> sort,
  List<T> expectedOrder,
) {
  final sorted = input.sorted(sort.compare);
  expect(sorted, equals(expectedOrder));
}

void main() {
  group('StreamSortField basics', () {
    test('a sort serializes to its field name and direction', () {
      final sort = Sort.desc(TestSortField.name);
      expect(sort.toJson(), {'field': 'name', 'direction': -1});
    });

    test('should build an ascending sort', () {
      final sort = Sort.asc(TestSortField.age);
      expect(sort.field.remote, 'age');
      expect(sort.direction.value, 1);
    });

    test('should build a descending sort', () {
      final sort = Sort.desc(TestSortField.age);
      expect(sort.field.remote, 'age');
      expect(sort.direction.value, -1);
    });

    test('should default nulls last ascending and nulls first descending', () {
      expect(Sort.asc(TestSortField.age).nullOrdering, NullOrdering.nullsLast);
      expect(Sort.desc(TestSortField.age).nullOrdering, NullOrdering.nullsFirst);
    });

    test('should keep pinnedAt and lastMessageAt nulls last in both directions', () {
      for (final field in [ChannelSortField.pinnedAt, ChannelSortField.lastMessageAt]) {
        expect(ChannelSort.asc(field).nullOrdering, NullOrdering.nullsLast, reason: field.remote);
        expect(ChannelSort.desc(field).nullOrdering, NullOrdering.nullsLast, reason: field.remote);
      }
    });

    test('a hand-built field for a pinned name is ordered the same way', () {
      // The rule keys on the remote name, which is what the API keys on, so a
      // field the SDK did not declare still gets nulls last.
      final byHand = ChannelSortField('pinned_at', (it) => it.membership?.pinnedAt);
      expect(ChannelSort.desc(byHand).nullOrdering, NullOrdering.nullsLast);
    });

    test('should let an explicit nullOrdering override the field and the direction', () {
      final channel = ChannelSort.desc(
        ChannelSortField.pinnedAt,
        nullOrdering: NullOrdering.nullsFirst,
      );
      expect(channel.nullOrdering, NullOrdering.nullsFirst);

      final test = TestSort.asc(TestSortField.age, nullOrdering: NullOrdering.nullsFirst);
      expect(test.nullOrdering, NullOrdering.nullsFirst);
    });

    test("building a sort without ChannelSort loses the field's null ordering", () {
      // `ChannelSort` is what reads `nullOrdering` off the field, so a bare
      // `Sort.desc` falls back to the direction's default.
      expect(ChannelSort.desc(ChannelSortField.pinnedAt).nullOrdering, NullOrdering.nullsLast);
      expect(Sort.desc(ChannelSortField.pinnedAt).nullOrdering, NullOrdering.nullsFirst);
    });

    test('`fromRemote` resolves every declared field', () {
      // Listed here rather than read off the registry, so a field left out of
      // the lookup fails instead of quietly resolving to a custom one.
      final declared = [
        ChannelSortField.lastUpdated,
        ChannelSortField.cid,
        ChannelSortField.createdAt,
        ChannelSortField.updatedAt,
        ChannelSortField.lastMessageAt,
        ChannelSortField.memberCount,
        ChannelSortField.hasUnread,
        ChannelSortField.unreadCount,
        ChannelSortField.pinnedAt,
      ];

      for (final field in declared) {
        expect(ChannelSortField.fromRemote(field.remote), same(field), reason: field.remote);
      }
    });

    test('`fromRemote` falls back to a field the API added and the SDK has not', () {
      // A channel key with no typed property deserializes into extraData,
      // which is where the custom fallback looks — so the sort still works.
      ChannelState channelWith(Object? value) => ChannelState.fromJson({
        'channel': {
          'cid': 'messaging:a',
          'id': 'a',
          'type': 'messaging',
          'created_at': '2026-01-01T00:00:00.000Z',
          'updated_at': '2026-01-01T00:00:00.000Z',
          'some_new_api_field': value,
        },
      });

      final sort = [ChannelSort.desc(ChannelSortField.fromRemote('some_new_api_field'))];

      expect(sort.first.field.remote, 'some_new_api_field');
      expect(sort.compare(channelWith(9), channelWith(1)), lessThan(0));
    });

    test('`fromRemote` cannot reach a field the SDK models but has not declared', () {
      // The counterpart, and the reason the declared set has to keep up with
      // the model: a typed property's value never reaches extraData, so the
      // fallback finds nothing and orders the two as equal. The query still
      // carries the right field name.
      ChannelState channelWith(int memberCount) => ChannelState.fromJson({
        'channel': {
          'cid': 'messaging:a',
          'id': 'a',
          'type': 'messaging',
          'created_at': '2026-01-01T00:00:00.000Z',
          'updated_at': '2026-01-01T00:00:00.000Z',
          'member_count': memberCount,
        },
      });

      final asCustom = [ChannelSort.desc(ChannelSortField.custom('member_count'))];
      expect(asCustom.compare(channelWith(50), channelWith(100)), 0);

      final declared = [ChannelSort.desc(ChannelSortField.memberCount)];
      expect(declared.compare(channelWith(50), channelWith(100)), greaterThan(0));
    });

    test('`fromRemote` should resolve declared fields and fall back to a custom one', () {
      expect(ChannelSortField.fromRemote('pinned_at'), same(ChannelSortField.pinnedAt));
      expect(ChannelSortField.fromRemote('last_updated'), same(ChannelSortField.lastUpdated));

      final custom = ChannelSortField.fromRemote('team');
      expect(custom.remote, 'team');
    });
  });

  group('registry surface', () {
    // Every remote name here was checked against the backend's
    // `mq.TableConfig` for its resource and against the JS client's sort
    // types. A field the server rejects fails the request at runtime with
    // "sorting by X is not allowed", which no other test would catch, so the
    // sets are pinned.
    void expectRemotes(List<SortField<Object>> fields, Set<String> expected) {
      expect(fields.map((it) => it.remote).toSet(), expected);
    }

    test('channel fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          ChannelSortField.lastUpdated,
          ChannelSortField.cid,
          ChannelSortField.createdAt,
          ChannelSortField.updatedAt,
          ChannelSortField.lastMessageAt,
          ChannelSortField.memberCount,
          ChannelSortField.hasUnread,
          ChannelSortField.unreadCount,
          ChannelSortField.pinnedAt,
        ],
        {
          'last_updated',
          'cid',
          'created_at',
          'updated_at',
          'last_message_at',
          'member_count',
          'has_unread',
          'unread_count',
          'pinned_at',
        },
      );
    });

    test('message search fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          MessageSearchSortField.id,
          MessageSearchSortField.createdAt,
          MessageSearchSortField.updatedAt,
          MessageSearchSortField.text,
          MessageSearchSortField.type,
          MessageSearchSortField.parentId,
          MessageSearchSortField.replyCount,
          MessageSearchSortField.pinned,
          MessageSearchSortField.relevance,
        ],
        {
          'id',
          'created_at',
          'updated_at',
          'text',
          'type',
          'parent_id',
          'reply_count',
          'pinned',
          'relevance',
        },
      );
    });

    test('user fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          UserSortField.id,
          UserSortField.createdAt,
          UserSortField.updatedAt,
          UserSortField.name,
          UserSortField.role,
          UserSortField.banned,
          UserSortField.lastActive,
          UserSortField.language,
        ],
        {
          'id',
          'created_at',
          'updated_at',
          'name',
          'role',
          'banned',
          'last_active',
          'language',
        },
      );
    });

    test('member fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          MemberSortField.createdAt,
          MemberSortField.userId,
          MemberSortField.name,
          MemberSortField.channelRole,
          MemberSortField.updatedAt,
        ],
        {'created_at', 'user_id', 'name', 'channel_role', 'updated_at'},
      );
    });

    test('thread fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          ThreadSortField.lastMessageAt,
          ThreadSortField.createdAt,
          ThreadSortField.updatedAt,
          ThreadSortField.replyCount,
          ThreadSortField.participantCount,
          ThreadSortField.activeParticipantCount,
          ThreadSortField.parentMessageId,
          ThreadSortField.hasUnread,
        ],
        {
          'last_message_at',
          'created_at',
          'updated_at',
          'reply_count',
          'participant_count',
          'active_participant_count',
          'parent_message_id',
          'has_unread',
        },
      );
    });

    test('reminder fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          MessageReminderSortField.channelCid,
          MessageReminderSortField.remindAt,
          MessageReminderSortField.createdAt,
          MessageReminderSortField.messageId,
        ],
        {'channel_cid', 'remind_at', 'created_at', 'message_id'},
      );
    });

    test('poll fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          PollSortField.id,
          PollSortField.name,
          PollSortField.createdAt,
          PollSortField.updatedAt,
          PollSortField.isClosed,
        ],
        {'id', 'name', 'created_at', 'updated_at', 'is_closed'},
      );
    });

    test('poll vote fields carry the wire names the API accepts', () {
      expectRemotes(
        [
          PollVoteSortField.id,
          PollVoteSortField.createdAt,
          PollVoteSortField.updatedAt,
        ],
        {'id', 'created_at', 'updated_at'},
      );
    });

    test('a custom field exists only where the API accepts one', () {
      // Mirrors `CustomFieldName` on each resource's `mq.TableConfig`. Calling
      // one the API does not accept fails the request at runtime.
      expect(ChannelSortField.custom('x').remote, 'x');
      expect(MessageSearchSortField.custom('x').remote, 'x');
      expect(UserSortField.custom('x').remote, 'x');
      expect(PollSortField.custom('x').remote, 'x');
      expect(MemberSortField.custom('x').remote, 'x');
      expect(ThreadSortField.custom('x').remote, 'x');
    });

    test('draft, reaction and banned user sort on created_at only', () {
      expectRemotes([DraftSortField.createdAt], {'created_at'});
      expectRemotes([ReactionSortField.createdAt], {'created_at'});
      expectRemotes([BannedUserSortField.createdAt], {'created_at'});
    });
  });

  group('server-parity value folding', () {
    // Regression: https://github.com/GetStream/stream-chat-flutter/issues/2601
    // The reporter observed lowercase-starting names and non-ASCII names
    // (Polish `Ł`, Norwegian `Ø`) getting pushed to the end of a list sorted
    // by name, because the comparator was a raw codepoint compare.
    test('should fold string values so name sorts match the server', () {
      final models = ['Zara', 'jhon', 'Łukasz', 'Øystein', 'Adam', 'Marek'].map(
        (it) => TestModel(name: it),
      );

      final sorted = models.sorted([Sort.asc(TestSortField.name)].compare);

      expect(sorted.map((it) => it.name), [
        'Adam',
        'jhon',
        'Łukasz',
        'Marek',
        'Øystein',
        'Zara',
      ]);
    });

    test('should compare mixed numeric types correctly', () {
      // A field can hand back either, and `10` must not order before or
      // after `10.0`.
      final sort = [TestSort.asc(TestSortField.tag)];

      expect(sort.compare(const TestModel(tag: 10), const TestModel(tag: 10.0)), 0);
      expect(sort.compare(const TestModel(tag: 10), const TestModel(tag: 10.5)), lessThan(0));
    });

    test('should treat unorderable values as equal rather than throwing', () {
      const a = TestModel(tag: Object());
      const b = TestModel(tag: Object());

      expect([Sort.asc(TestSortField.tag)].compare(a, b), 0);
    });

    test('should treat values of different types as equal rather than throwing', () {
      const a = TestModel(tag: 'a string');
      const b = TestModel(tag: 42);

      expect([Sort.asc(TestSortField.tag)].compare(a, b), 0);
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

      final sort = [
        ChannelSort.desc(ChannelSortField.pinnedAt),
        ChannelSort.desc(ChannelSortField.lastUpdated),
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

      final sort = [ChannelSort.asc(ChannelSortField.pinnedAt)];

      expect(idsOf(channels.sorted(sort.compare)), ['pinned-old', 'pinned-new', 'unpinned']);
    });

    test('should keep channels without messages at the bottom when sorting by lastMessageAt desc', () {
      final channels = [
        channelState('no-messages'),
        channelState('newest', lastMessageAt: createdAt.add(const Duration(days: 5))),
        channelState('oldest', lastMessageAt: createdAt.add(const Duration(days: 1))),
      ];

      final sort = [ChannelSort.desc(ChannelSortField.lastMessageAt)];

      expect(idsOf(channels.sorted(sort.compare)), ['newest', 'oldest', 'no-messages']);
    });

    test('should keep channels without messages at the bottom when sorting by lastMessageAt asc', () {
      // `last_message_at` ascending relies on the API leaving the direction
      // bare, which Postgres orders nulls last.
      final channels = [
        channelState('no-messages'),
        channelState('oldest', lastMessageAt: createdAt.add(const Duration(days: 1))),
        channelState('newest', lastMessageAt: createdAt.add(const Duration(days: 5))),
      ];

      final sort = [ChannelSort.asc(ChannelSortField.lastMessageAt)];

      expect(idsOf(channels.sorted(sort.compare)), ['oldest', 'newest', 'no-messages']);
    });

    test('should keep nulls last for other fields when sorting asc', () {
      // A field with no pinned ordering follows the direction's default, which
      // matches the bare `ASC` the API emits for it.
      final channels = [
        ChannelState(
          channel: ChannelModel(id: 'no-team', type: 'messaging', createdAt: createdAt),
        ),
        ChannelState(
          channel: ChannelModel(
            id: 'red-team',
            type: 'messaging',
            createdAt: createdAt,
            extraData: const {'team': 'red'},
          ),
        ),
      ];

      final sort = [ChannelSort.asc(ChannelSortField.custom('team'))];

      expect(idsOf(channels.sorted(sort.compare)), ['red-team', 'no-team']);
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

      final sort = [ChannelSort.desc(ChannelSortField.custom('team'))];

      expect(idsOf(channels.sorted(sort.compare)), ['no-team', 'red-team']);
    });
  });

  group('single field', () {
    test('should compare two objects in descending order', () {
      final sort = [Sort.desc(TestSortField.age)];
      const a = TestModel(age: 30);
      const b = TestModel(age: 25);
      expect(sort.compare(a, b), lessThan(0));
    });

    test('should compare two objects in ascending order', () {
      final sort = [Sort.asc(TestSortField.age)];
      const a = TestModel(age: 25);
      const b = TestModel(age: 30);
      expect(sort.compare(a, b), lessThan(0));
    });

    test('should handle null values correctly (default nullOrdering)', () {
      final sort = [Sort.desc(TestSortField.age)];
      const a = TestModel(age: null);
      const b = TestModel(age: 25);
      const c = TestModel(age: null);

      expect(sort.compare(a, b), lessThan(0));
      expect(sort.compare(b, a), greaterThan(0));
      expect(sort.compare(a, c), equals(0));
    });

    test('should compare date fields correctly', () {
      final sort = [Sort.desc(TestSortField.createdAt)];
      final now = DateTime.now();
      final earlier = now.subtract(const Duration(days: 1));

      final a = TestModel(createdAt: now);
      final b = TestModel(createdAt: earlier);

      expect(sort.compare(a, b), lessThan(0));
    });

    test('should compare boolean fields correctly', () {
      final sort = [Sort.desc(TestSortField.active)];
      const a = TestModel(active: true);
      const b = TestModel(active: false);
      const c = TestModel(active: true);

      expect(sort.compare(a, b), lessThan(0));
      expect(sort.compare(b, a), greaterThan(0));
      expect(sort.compare(a, c), equals(0));
    });

    test('should order by whatever the extractor projects onto', () {
      final sort = [Sort.desc(TestSortField.nameLength)];

      const a = TestModel(name: 'longer_name');
      const b = TestModel(name: 'short');

      expect(sort.compare(a, b), lessThan(0));
    });

    test('should respect explicit nullOrdering=nullsLast on DESC', () {
      final models = [
        const TestModel(age: null),
        const TestModel(age: 40),
        const TestModel(age: 30),
      ];

      final sort = [Sort.desc(TestSortField.age, nullOrdering: NullOrdering.nullsLast)];

      expectSorted(models, sort, [
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

      final sort = [Sort.asc(TestSortField.name, nullOrdering: NullOrdering.nullsFirst)];

      expectSorted(models, sort, [
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

      final sort = [Sort.desc(TestSortField.age), Sort.asc(TestSortField.name)];

      expectSorted(models, sort, [
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

      final sort = [Sort.desc(TestSortField.age), Sort.asc(TestSortField.name)];

      expectSorted(models, sort, [
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

      expectSorted(models, <Sort<TestModel>>[], [
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

      final sort = [
        Sort.desc(TestSortField.createdAt),
        Sort.desc(TestSortField.active),
        Sort.asc(TestSortField.name),
      ];

      expectSorted(models, sort, [
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

      final sort = [Sort.desc(TestSortField.age), Sort.asc(TestSortField.name)];

      expectSorted(models, sort, [
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

      final sort = [Sort.desc(TestSortField.age), Sort.asc(TestSortField.name)];

      expectSorted(models, sort, [
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

      final sort = [Sort.desc(TestSortField.age), Sort.asc(TestSortField.name)];

      expectSorted(models, sort, [
        const TestModel(name: 'Alice', age: null),
        const TestModel(name: 'Bob', age: null),
        const TestModel(name: null, age: null),
      ]);
    });
  });
}
