import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/voting_visibility.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('Poll generates an id when none is given', () {
    final first = Poll(name: 'Lunch?', options: const []);
    final second = Poll(name: 'Lunch?', options: const []);

    expect(first.id, isNotEmpty);
    expect(first.id, isNot(second.id));
  });

  test('Poll compares its custom data for equality', () {
    final poll = createTestPoll(id: 'poll-id', name: 'Lunch?', extraData: const {'topic': 'food'});

    expect(poll, poll.copyWith(extraData: const {'topic': 'food'}));
    expect(poll, isNot(poll.copyWith(extraData: const {'topic': 'drinks'})));
  });

  test('Poll.copyWith can clear the vote limit', () {
    final poll = createTestPoll(name: 'Lunch?', maxVotesAllowed: 2);

    expect(poll.copyWith(maxVotesAllowed: null).maxVotesAllowed, isNull);
  });

  test('Poll.latestVotes holds the latest votes of every option', () {
    final pizza = _vote(id: 'v1', optionId: 'pizza');
    final sushi = _vote(id: 'v2', optionId: 'sushi');
    final poll = createTestPoll(name: 'Lunch?').copyWith(
      latestVotesByOption: {
        'pizza': [pizza],
        'sushi': [sushi],
      },
    );

    expect(poll.latestVotes, unorderedEquals([pizza, sushi]));
  });

  test('Poll.ownVotes leaves out the answers of the current user', () {
    final vote = _vote(id: 'v1', optionId: 'pizza');
    final answer = _vote(id: 'a1', answerText: 'Anything');
    final poll = createTestPoll(name: 'Lunch?').copyWith(ownVotesAndAnswers: [vote, answer]);

    expect(poll.ownVotes, [vote]);
  });

  test('Poll.ownAnswers leaves out the votes of the current user', () {
    final vote = _vote(id: 'v1', optionId: 'pizza');
    final answer = _vote(id: 'a1', answerText: 'Anything');
    final poll = createTestPoll(name: 'Lunch?').copyWith(ownVotesAndAnswers: [vote, answer]);

    expect(poll.ownAnswers, [answer]);
  });

  test('PollFilterField.votingVisibility reads the visibility value', () {
    final poll = createTestPoll(name: 'Lunch?', votingVisibility: VotingVisibility.anonymous);

    expect(PollFilterField.votingVisibility.value(poll), 'anonymous');
  });

  test('PollSortField.id orders alphabetically', () {
    expectOrders(
      PollSortField.id,
      createTestPoll(id: 'a-poll', name: 'A'),
      createTestPoll(id: 'b-poll', name: 'B'),
    );
  });

  test('PollSortField.name orders alphabetically, folded', () {
    expectOrders(
      PollSortField.name,
      createTestPoll(name: 'apples'),
      createTestPoll(name: 'Bananas'),
    );
  });

  test('PollSortField.createdAt orders older polls first', () {
    expectOrders(
      PollSortField.createdAt,
      createTestPoll(name: 'older', createdAt: DateTime(2023, 6, 10)),
      createTestPoll(name: 'newer', createdAt: DateTime(2023, 6, 15)),
    );
  });

  test('PollSortField.updatedAt orders older polls first', () {
    expectOrders(
      PollSortField.updatedAt,
      createTestPoll(name: 'older', updatedAt: DateTime(2023, 6, 10)),
      createTestPoll(name: 'newer', updatedAt: DateTime(2023, 6, 15)),
    );
  });

  test('PollSortField.isClosed orders open polls first', () {
    expectOrders(
      PollSortField.isClosed,
      createTestPoll(name: 'open'),
      createTestPoll(name: 'closed', isClosed: true),
    );
  });
}

PollVote _vote({required String id, String? optionId, String? answerText}) => PollVote(
  id: id,
  optionId: optionId,
  answerText: answerText,
  createdAt: DateTime.utc(2024),
  updatedAt: DateTime.utc(2024),
);

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
