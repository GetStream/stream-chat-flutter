// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/message', () {
    test('should parse json correctly', () {
      final poll = Poll.fromJson(jsonFixture('poll.json'));

      expect(poll.id, '7fd88eb3-fc05-4e89-89af-36c6d8995dda');
      expect(poll.name, 'test');
      expect(poll.description, '');
      expect(poll.votingVisibility, VotingVisibility.public);
      expect(poll.enforceUniqueVote, false);
      expect(poll.maxVotesAllowed, isNull);
      expect(poll.allowUserSuggestedOptions, false);
      expect(poll.allowAnswers, false);
      expect(poll.isClosed, false);
      expect(poll.voteCount, 0);
      expect(poll.answersCount, 0);

      expect(poll.createdAt.toIso8601String(), '2024-04-17T14:46:23.001349Z');
      expect(poll.updatedAt.toIso8601String(), '2024-04-17T14:46:23.001349Z');

      expect(poll.options.length, 1);
      final option = poll.options[0];
      expect(option.id, 'option1');
      expect(option.text, 'option1 text');

      expect(poll.latestVotesByOption, isEmpty);

      expect(poll.ownVotesAndAnswers.length, 1);
      final vote = poll.ownVotesAndAnswers[0];
      expect(vote.id, 'luke_skywalker');
      expect(vote.optionId, 'option1');
      expect(vote.pollId, '7fd88eb3-fc05-4e89-89af-36c6d8995dda');
      expect(vote.createdAt.toIso8601String(), '2022-02-03T15:47:10.148169Z');
      expect(vote.updatedAt.toIso8601String(), '2024-03-18T16:44:45.749718Z');

      // Check createdBy fields
      expect(poll.createdById, 'luke_skywalker');
      expect(poll.createdBy, isNotNull);
    });

    test('should serialize to json correctly', () {
      final poll = Poll(
        id: '7fd88eb3-fc05-4e89-89af-36c6d8995dda',
        name: 'test',
        options: const [
          PollOption(
            text: 'option1 text',
          ),
        ],
      );

      final json = poll.toJson();

      expect(json['id'], '7fd88eb3-fc05-4e89-89af-36c6d8995dda');
      expect(json['name'], 'test');
      expect(json['description'], isNull);
      expect(json['options'], [
        {'text': 'option1 text'},
      ]);
      expect(json['voting_visibility'], 'public');
      expect(json['enforce_unique_vote'], true);
      expect(json['max_votes_allowed'], isNull);
      expect(json['allow_user_suggested_options'], false);
      expect(json['allow_answers'], false);
      expect(json['is_closed'], false);
    });

    group('ComparableFieldProvider', () {
      test('should return ComparableField for poll.id', () {
        final poll = createTestPoll(
          id: 'test-poll-id',
          name: 'Test Poll',
        );

        final field = poll.getComparableField(PollSortKey.id);
        expect(field, isNotNull);
        expect(field!.value, equals('test-poll-id'));
      });

      test('should return ComparableField for poll.name', () {
        final poll = createTestPoll(
          id: 'test-poll-id',
          name: 'Test Poll',
        );

        final field = poll.getComparableField(PollSortKey.name);
        expect(field, isNotNull);
        expect(field!.value, equals('Test Poll'));
      });

      test('should return ComparableField for poll.createdAt', () {
        final createdAt = DateTime(2023, 6, 15);
        final poll = createTestPoll(
          id: 'test-poll-id',
          name: 'Test Poll',
          createdAt: createdAt,
        );

        final field = poll.getComparableField(PollSortKey.createdAt);
        expect(field, isNotNull);
        expect(field!.value, equals(createdAt));
      });

      test('should return ComparableField for poll.updatedAt', () {
        final updatedAt = DateTime(2023, 6, 20);
        final poll = createTestPoll(
          id: 'test-poll-id',
          name: 'Test Poll',
          updatedAt: updatedAt,
        );

        final field = poll.getComparableField(PollSortKey.updatedAt);
        expect(field, isNotNull);
        expect(field!.value, equals(updatedAt));
      });

      test('should return ComparableField for poll.isClosed', () {
        final poll = createTestPoll(
          id: 'test-poll-id',
          name: 'Test Poll',
          isClosed: true,
        );

        final field = poll.getComparableField(PollSortKey.isClosed);
        expect(field, isNotNull);
        expect(field!.value, isTrue);
      });

      test('should return ComparableField for poll.extraData', () {
        final poll = createTestPoll(
          id: 'test-poll-id',
          name: 'Test Poll',
          extraData: {'priority': 5},
        );

        final field = poll.getComparableField('priority');
        expect(field, isNotNull);
        expect(field!.value, equals(5));
      });

      test('should return null for non-existent extraData keys', () {
        final poll = createTestPoll(
          id: 'test-poll-id',
          name: 'Test Poll',
        );

        final field = poll.getComparableField('non_existent_key');
        expect(field, isNull);
      });

      test('should compare two polls correctly using id', () {
        final poll1 = createTestPoll(
          id: 'poll-a',
          name: 'Poll A',
        );

        final poll2 = createTestPoll(
          id: 'poll-b',
          name: 'Poll B',
        );

        final field1 = poll1.getComparableField(PollSortKey.id);
        final field2 = poll2.getComparableField(PollSortKey.id);

        expect(field1!.compareTo(field2!), lessThan(0)); // poll-a < poll-b
        expect(field2.compareTo(field1), greaterThan(0)); // poll-b > poll-a
      });

      test('should compare two polls correctly using name', () {
        final poll1 = createTestPoll(
          id: 'test-poll-1',
          name: 'Apple Poll',
        );

        final poll2 = createTestPoll(
          id: 'test-poll-2',
          name: 'Banana Poll',
        );

        final field1 = poll1.getComparableField(PollSortKey.name);
        final field2 = poll2.getComparableField(PollSortKey.name);

        expect(field1!.compareTo(field2!), lessThan(0)); // Apple < Banana
        expect(field2.compareTo(field1), greaterThan(0)); // Banana > Apple
      });

      test('should compare two polls correctly using createdAt', () {
        final newerPoll = createTestPoll(
          id: 'newer',
          name: 'New Poll',
          createdAt: DateTime(2023, 6, 15),
        );

        final olderPoll = createTestPoll(
          id: 'older',
          name: 'Old Poll',
          createdAt: DateTime(2023, 6, 10),
        );

        final field1 = newerPoll.getComparableField(PollSortKey.createdAt);
        final field2 = olderPoll.getComparableField(PollSortKey.createdAt);

        // More recent > Less recent
        expect(field1!.compareTo(field2!), greaterThan(0));
        // Less recent < More recent
        expect(field2.compareTo(field1), lessThan(0));
      });

      test('should compare two polls correctly using isClosed', () {
        final closedPoll = createTestPoll(
          id: 'closed',
          name: 'Closed Poll',
          isClosed: true,
        );

        final openPoll = createTestPoll(
          id: 'open',
          name: 'Open Poll',
          isClosed: false,
        );

        final field1 = closedPoll.getComparableField(PollSortKey.isClosed);
        final field2 = openPoll.getComparableField(PollSortKey.isClosed);

        expect(field1!.compareTo(field2!), greaterThan(0)); // true > false
        expect(field2.compareTo(field1), lessThan(0)); // false < true
      });

      test('should compare two polls correctly using extraData', () {
        final highPriorityPoll = createTestPoll(
          id: 'high',
          name: 'High Priority Poll',
          extraData: {'priority': 10},
        );

        final lowPriorityPoll = createTestPoll(
          id: 'low',
          name: 'Low Priority Poll',
          extraData: {'priority': 1},
        );

        final field1 = highPriorityPoll.getComparableField('priority');
        final field2 = lowPriorityPoll.getComparableField('priority');

        expect(field1!.compareTo(field2!), greaterThan(0)); // 10 > 1
        expect(field2.compareTo(field1), lessThan(0)); // 1 < 10
      });
    });
  });
}

/// Helper function to create a Poll for testing
Poll createTestPoll({
  String? id,
  required String name,
  String? description,
  List<PollOption>? options,
  VotingVisibility votingVisibility = VotingVisibility.public,
  bool enforceUniqueVote = true,
  int? maxVotesAllowed,
  bool allowUserSuggestedOptions = false,
  bool allowAnswers = false,
  bool isClosed = false,
  DateTime? createdAt,
  DateTime? updatedAt,
  Map<String, Object?>? extraData,
}) {
  return Poll(
    id: id,
    name: name,
    description: description,
    options: options ?? [const PollOption(text: 'Option 1')],
    votingVisibility: votingVisibility,
    enforceUniqueVote: enforceUniqueVote,
    maxVotesAllowed: maxVotesAllowed,
    allowUserSuggestedOptions: allowUserSuggestedOptions,
    allowAnswers: allowAnswers,
    isClosed: isClosed,
    createdAt: createdAt ?? DateTime(2023),
    updatedAt: updatedAt ?? DateTime(2023),
    extraData: extraData ?? {},
  );
}
