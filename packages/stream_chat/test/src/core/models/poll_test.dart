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

    group('PollSortField', () {
      test('id orders alphabetically', () {
        expectOrders(
          PollSortField.id,
          createTestPoll(id: 'a-poll', name: 'A'),
          createTestPoll(id: 'b-poll', name: 'B'),
        );
      });

      test('name orders alphabetically, folded', () {
        expectOrders(
          PollSortField.name,
          createTestPoll(name: 'apples'),
          createTestPoll(name: 'Bananas'),
        );
      });

      test('createdAt orders older polls first', () {
        expectOrders(
          PollSortField.createdAt,
          createTestPoll(name: 'older', createdAt: DateTime(2023, 6, 10)),
          createTestPoll(name: 'newer', createdAt: DateTime(2023, 6, 15)),
        );
      });

      test('updatedAt orders older polls first', () {
        expectOrders(
          PollSortField.updatedAt,
          createTestPoll(name: 'older', updatedAt: DateTime(2023, 6, 10)),
          createTestPoll(name: 'newer', updatedAt: DateTime(2023, 6, 15)),
        );
      });

      test('isClosed orders open polls first', () {
        expectOrders(
          PollSortField.isClosed,
          createTestPoll(name: 'open', isClosed: false),
          createTestPoll(name: 'closed', isClosed: true),
        );
      });

      test('a custom field orders by the poll extra data', () {
        expectOrders(
          PollSortField.custom('priority'),
          createTestPoll(name: 'low', extraData: const {'priority': 1}),
          createTestPoll(name: 'high', extraData: const {'priority': 10}),
        );
      });

      test('a custom field the poll does not carry orders nothing', () {
        expectOrdersNothing(
          PollSortField.custom('non_existent_key'),
          createTestPoll(name: 'plain'),
        );
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
