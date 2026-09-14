import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_chat/src/core/models/banned_user.dart';
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
  group('sort construction and field resolution', () {
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
          UserSortField.teams,
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
          'teams',
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
      // Declared where the resource's `mq.TableConfig` leaves sort validation
      // open. Poll and thread queries pin their sort to whole combinations of
      // declared fields, so neither offers one — a custom field there would
      // fail the request at runtime.
      expect(ChannelSortField.custom('x').remote, 'x');
      expect(MessageSearchSortField.custom('x').remote, 'x');
      expect(UserSortField.custom('x').remote, 'x');
      expect(MemberSortField.custom('x').remote, 'x');
    });

    test('draft, reaction and banned user sort on created_at only', () {
      expectRemotes([DraftSortField.createdAt], {'created_at'});
      expectRemotes([ReactionSortField.createdAt], {'created_at'});
      expectRemotes([BannedUserSortField.createdAt], {'created_at'});
    });

    test('every default sort is the ordering its query already has', () {
      // Pinned against the server's own default for each resource, because a
      // `defaultSort` that disagrees reorders a list for no reason and costs a
      // query it did not need. Each entry is that resource's `DefaultSort()`
      // in the backend, or the fallback its query builder appends.
      expect(
        <String, List<Sort<Object>>>{
          'channel': ChannelSort.defaultSort,
          'user': UserSort.defaultSort,
          'member': MemberSort.defaultSort,
          'draft': DraftSort.defaultSort,
          'reminder': MessageReminderSort.defaultSort,
          'poll': PollSort.defaultSort,
          'poll_vote': PollVoteSort.defaultSort,
          'reaction': ReactionSort.defaultSort,
        }.map((k, v) => MapEntry(k, v.map((it) => it.toJson()).toList())),
        {
          'channel': [
            {'field': 'last_updated', 'direction': -1},
          ],
          'user': [
            {'field': 'created_at', 'direction': -1},
          ],
          'member': [
            {'field': 'created_at', 'direction': 1},
          ],
          'draft': [
            {'field': 'created_at', 'direction': -1},
          ],
          'reminder': [
            {'field': 'remind_at', 'direction': 1},
          ],
          'poll': [
            {'field': 'created_at', 'direction': 1},
          ],
          'poll_vote': [
            {'field': 'created_at', 'direction': 1},
          ],
          'reaction': [
            {'field': 'created_at', 'direction': -1},
          ],
        },
      );
    });
  });
}
