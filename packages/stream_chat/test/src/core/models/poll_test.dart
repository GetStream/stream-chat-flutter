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

    test('parses the server translations of the name and description', () {
      final poll = Poll.fromJson({
        ...jsonFixture('poll.json'),
        'name_i18n': const {'language': 'en', 'nl_text': 'toets'},
        'description_i18n': const {'language': 'en', 'nl_text': 'omschrijving'},
      });

      expect(poll.nameI18n, {'language': 'en', 'nl_text': 'toets'});
      expect(poll.descriptionI18n, {'language': 'en', 'nl_text': 'omschrijving'});
    });

    test('parses the server translation of an option', () {
      final poll = Poll.fromJson({
        ...jsonFixture('poll.json'),
        'options': const [
          {
            'id': 'option1',
            'text': 'option1 text',
            'text_i18n': {'language': 'en', 'nl_text': 'optie1 tekst'},
          },
        ],
      });

      expect(poll.options.single.textI18n, {'language': 'en', 'nl_text': 'optie1 tekst'});
    });

    test('parses the server translation of an answer', () {
      final poll = Poll.fromJson({
        ...jsonFixture('poll.json'),
        'latest_answers': const [
          {
            'id': 'answer1',
            'answer_text': 'great',
            'answer_text_i18n': {'language': 'en', 'nl_text': 'geweldig'},
          },
        ],
      });

      expect(poll.latestAnswers.single.answerTextI18n, {'language': 'en', 'nl_text': 'geweldig'});
    });

    test('keeps the server translations out of the extra data', () {
      final poll = Poll.fromJson({
        ...jsonFixture('poll.json'),
        'name_i18n': const {'language': 'en', 'nl_text': 'toets'},
        'description_i18n': const {'language': 'en', 'nl_text': 'omschrijving'},
      });

      expect(poll.extraData, isNot(contains('name_i18n')));
      expect(poll.extraData, isNot(contains('description_i18n')));
    });

    test('does not send the server translations back when serialized', () {
      final poll = Poll(
        name: 'test',
        nameI18n: const {'language': 'en', 'nl_text': 'toets'},
        descriptionI18n: const {'language': 'en', 'nl_text': 'omschrijving'},
        options: const [
          PollOption(text: 'option1 text', textI18n: {'language': 'en', 'nl_text': 'optie1 tekst'}),
        ],
      );

      final json = poll.toJson();

      expect(json, isNot(contains('name_i18n')));
      expect(json, isNot(contains('description_i18n')));
    });

    test('keeps the server translation of an option out of its extra data', () {
      final option = PollOption.fromJson(const {
        'id': 'option1',
        'text': 'option1 text',
        'text_i18n': {'language': 'en', 'nl_text': 'optie1 tekst'},
      });

      expect(option.extraData, isNot(contains('text_i18n')));
    });

    test('PollOption.toJson leaves out the server translation', () {
      const option = PollOption(
        id: 'option1',
        text: 'option1 text',
        textI18n: {'language': 'en', 'nl_text': 'optie1 tekst'},
      );

      expect(option.toJson(), isNot(contains('text_i18n')));
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
