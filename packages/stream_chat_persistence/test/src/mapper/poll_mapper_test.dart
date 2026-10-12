import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/poll_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  test('toPoll should map entity into Poll', () {
    final currentUser = User(id: 'curr-user', name: 'Current User');
    final latestVotesByOption = {
      'option-1': [
        for (var i = 0; i < 5; i++)
          PollVote(
            userId: 'user-$i',
            user: User(id: 'user-$i', name: 'User $i'),
            optionId: 'option-1',
            createdAt: DateTime.now(),
          ),
      ],
      'option-2': [
        for (var i = 0; i < 2; i++)
          PollVote(
            userId: 'user-$i',
            user: User(id: 'user-$i', name: 'User $i'),
            optionId: 'option-2',
            createdAt: DateTime.now(),
          ),
      ],
      'option-3': [
        PollVote(
          user: currentUser,
          userId: currentUser.id,
          optionId: 'option-3',
          createdAt: DateTime.now(),
        ),
      ],
    };
    final voteCountsByOption = latestVotesByOption.map(
      (key, value) => MapEntry(key, value.length),
    );
    final latestAnswers = [
      PollVote(
        user: currentUser,
        userId: currentUser.id,
        answerText: 'I also like yellow',
        createdAt: DateTime.now(),
      ),
    ];
    final entity = PollEntity(
      id: 'poll-1',
      name: 'testQuestion',
      createdById: currentUser.id,
      votingVisibility: VotingVisibility.public,
      allowUserSuggestedOptions: true,
      options: const [
        PollOption(id: 'option-1', text: 'Red'),
        PollOption(id: 'option-2', text: 'Blue'),
        PollOption(id: 'option-3', text: 'Green'),
      ].map(jsonEncode).toList(),
      voteCount: voteCountsByOption.values.reduce((a, b) => a + b),
      voteCountsByOption: voteCountsByOption,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      enforceUniqueVote: false,
      isClosed: false,
      allowAnswers: true,
      answersCount: latestAnswers.length,
      extraData: {'test_extra_data': 'extraData'},
    );
    final poll = entity.toPoll(
      createdBy: currentUser,
      latestAnswers: latestAnswers,
      latestVotesByOption: latestVotesByOption,
      ownVotesAndAnswers: [
        ...latestAnswers,
        ...latestVotesByOption.values.expand((it) => it),
      ].where((it) => it.userId == currentUser.id).toList(),
    );

    expect(poll, isA<Poll>());
    expect(poll.id, entity.id);
    expect(poll.name, entity.name);
    expect(poll.createdById, entity.createdById);
    expect(poll.votingVisibility, entity.votingVisibility);
    expect(poll.enforceUniqueVote, entity.enforceUniqueVote);
    expect(poll.maxVotesAllowed, entity.maxVotesAllowed);
    expect(poll.allowUserSuggestedOptions, entity.allowUserSuggestedOptions);
    for (var i = 0; i < poll.options.length; i++) {
      final pollOption = poll.options[i];
      final entityOptionJson = jsonDecode(entity.options[i]);
      final entityOption = PollOption.fromJson(entityOptionJson);
      expect(pollOption.id, entityOption.id);
      expect(pollOption.text, entityOption.text);
      expect(pollOption.extraData, entityOption.extraData);
    }
    expect(poll.allowAnswers, entity.allowAnswers);
    expect(poll.answersCount, entity.answersCount);
    expect(poll.isClosed, entity.isClosed);
    expect(poll.createdAt, isSameDateAs(entity.createdAt));
    expect(poll.updatedAt, isSameDateAs(entity.updatedAt));
    expect(poll.voteCountsByOption, entity.voteCountsByOption);
    expect(poll.voteCount, entity.voteCount);
    expect(poll.createdById, entity.createdById);
    expect(poll.extraData, entity.extraData);
  });

  test('toEntity should map poll into PollEntity', () {
    final currentUser = User(id: 'curr-user', name: 'Current User');
    final latestVotesByOption = {
      'option-1': [
        for (var i = 0; i < 5; i++)
          PollVote(
            userId: 'user-$i',
            user: User(id: 'user-$i', name: 'User $i'),
            optionId: 'option-1',
            createdAt: DateTime.now(),
          ),
      ],
      'option-2': [
        for (var i = 0; i < 2; i++)
          PollVote(
            userId: 'user-$i',
            user: User(id: 'user-$i', name: 'User $i'),
            optionId: 'option-2',
            createdAt: DateTime.now(),
          ),
      ],
      'option-3': [
        PollVote(
          user: currentUser,
          userId: currentUser.id,
          optionId: 'option-3',
          createdAt: DateTime.now(),
        ),
      ],
    };
    final voteCountsByOption = latestVotesByOption.map(
      (key, value) => MapEntry(key, value.length),
    );
    final latestAnswers = [
      PollVote(
        user: currentUser,
        userId: currentUser.id,
        answerText: 'I also like yellow',
        createdAt: DateTime.now(),
      ),
    ];
    final poll = Poll(
      id: 'poll-1',
      name: 'testQuestion',
      createdById: currentUser.id,
      allowUserSuggestedOptions: true,
      options: const [
        PollOption(id: 'option-1', text: 'Red'),
        PollOption(id: 'option-2', text: 'Blue'),
        PollOption(id: 'option-3', text: 'Green'),
      ],
      voteCount: voteCountsByOption.values.reduce((a, b) => a + b),
      voteCountsByOption: voteCountsByOption,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      enforceUniqueVote: false,
      allowAnswers: true,
      answersCount: latestAnswers.length,
      extraData: const {'test_extra_data': 'extraData'},
    );
    final entity = poll.toEntity();
    expect(entity, isA<PollEntity>());
    expect(entity.id, poll.id);
    expect(entity.name, poll.name);
    expect(entity.createdById, poll.createdById);
    expect(entity.votingVisibility, poll.votingVisibility);
    expect(entity.enforceUniqueVote, poll.enforceUniqueVote);
    expect(entity.maxVotesAllowed, poll.maxVotesAllowed);
    expect(entity.allowUserSuggestedOptions, poll.allowUserSuggestedOptions);
    expect(
      entity.options,
      poll.options.map((it) => jsonEncode(it.toJson())).toList(),
    );
    expect(entity.allowAnswers, poll.allowAnswers);
    expect(entity.answersCount, poll.answersCount);
    expect(entity.isClosed, poll.isClosed);
    expect(entity.createdAt, isSameDateAs(poll.createdAt));
    expect(entity.updatedAt, isSameDateAs(poll.updatedAt));
    expect(entity.voteCountsByOption, poll.voteCountsByOption);
    expect(entity.voteCount, poll.voteCount);
    expect(entity.createdById, poll.createdById);
    expect(entity.extraData, poll.extraData);
  });

  test('a poll keeps the translations of its name, description and options through the cache', () {
    final poll = Poll(
      name: 'Favourite colour?',
      nameI18n: const {'language': 'en', 'nl_text': 'Favoriete kleur?'},
      description: 'Pick one',
      descriptionI18n: const {'language': 'en', 'nl_text': 'Kies er een'},
      options: const [
        PollOption(id: 'option-1', text: 'Red', textI18n: {'language': 'en', 'nl_text': 'Rood'}),
      ],
    );

    final cached = poll.toEntity().toPoll();

    expect(cached.nameI18n, poll.nameI18n);
    expect(cached.descriptionI18n, poll.descriptionI18n);
    expect(cached.options.single.textI18n, poll.options.single.textI18n);
  });

  test('a poll option without translations is cached without a text_i18n entry', () {
    final poll = Poll(
      name: 'Favourite colour?',
      options: const [PollOption(id: 'option-1', text: 'Red')],
    );

    final entity = poll.toEntity();

    expect(jsonDecode(entity.options.single), isNot(contains('text_i18n')));
  });
}
