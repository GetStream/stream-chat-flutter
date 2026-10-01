import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  test('Message.fromJson reads every field of a poll', () {
    final message = Message.fromJson({'id': 'message-id', 'poll': _fullPollJson()});

    expect(
      message.poll,
      Poll(
        id: 'poll-id',
        name: 'Lunch?',
        description: 'Pick one',
        options: const [
          PollOption(id: 'pizza', text: 'Pizza', extraData: {'color': 'red'}),
          PollOption(id: 'sushi', text: 'Sushi'),
        ],
        votingVisibility: VotingVisibility.public,
        enforceUniqueVote: false,
        maxVotesAllowed: 2,
        allowAnswers: true,
        allowUserSuggestedOptions: true,
        isClosed: true,
        voteCount: 1,
        answersCount: 1,
        voteCountsByOption: const {'pizza': 1},
        latestVotesByOption: {
          'pizza': [_vote],
        },
        latestAnswers: [_answer],
        ownVotesAndAnswers: [_vote, _answer],
        createdById: 'luke',
        createdBy: User.fromJson(const {'id': 'luke', 'name': 'Luke'}),
        createdAt: DateTime.utc(2024, 4, 17, 14, 46, 23),
        updatedAt: DateTime.utc(2024, 4, 18),
        extraData: const {'topic': 'food'},
      ),
    );
  });

  test('Message.fromJson reads poll dates sent as epoch nanoseconds', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'poll': {
        'id': 'poll-id',
        'name': 'Lunch?',
        'options': <Object?>[],
        'created_at': 1704067200123456000,
        'updated_at': 1704153600000000000,
      },
    });

    expect(message.poll!.createdAt, DateTime.utc(2024, 1, 1, 0, 0, 0, 123, 456));
    expect(message.poll!.updatedAt, DateTime.utc(2024, 1, 2));
  });

  test('Message.fromJson gives a poll without its optional keys the default settings', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'poll': {'id': 'poll-id', 'name': 'Lunch?', 'options': <Object?>[]},
    });

    final poll = message.poll!;
    expect(poll.votingVisibility, VotingVisibility.public);
    expect(poll.enforceUniqueVote, isTrue);
    expect(poll.maxVotesAllowed, isNull);
    expect(poll.allowAnswers, isFalse);
    expect(poll.allowUserSuggestedOptions, isFalse);
    expect(poll.isClosed, isFalse);
    expect(poll.voteCountsByOption, isEmpty);
    expect(poll.latestVotesByOption, isEmpty);
    expect(poll.ownVotesAndAnswers, isEmpty);
    expect(poll.extraData, isEmpty);
  });

  test('Message.fromJson keeps the translations of a poll and its options out of their custom data', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'poll': {
        'id': 'poll-id',
        'name': 'Lunch?',
        'name_i18n': {'it': 'Pranzo?'},
        'description_i18n': {'it': 'Scegline uno'},
        'options': [
          {
            'id': 'pizza',
            'text': 'Pizza',
            'text_i18n': {'it': 'Pizza'},
            'color': 'red',
          },
        ],
        'topic': 'food',
      },
    });

    expect(message.poll!.extraData, {'topic': 'food'});
    expect(message.poll!.options.single.extraData, {'color': 'red'});
  });

  test('Message.fromJson keeps a voting visibility the SDK does not name', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'poll': {'id': 'poll-id', 'name': 'Lunch?', 'options': <Object?>[], 'voting_visibility': 'members_only'},
    });

    expect(message.poll!.votingVisibility, const VotingVisibility('members_only'));
  });

  test('Message.fromJson reads an answer, which selects no option', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'poll': {
        'id': 'poll-id',
        'name': 'Lunch?',
        'options': <Object?>[],
        'latest_answers': [_answerJson],
      },
    });

    final answer = message.poll!.latestAnswers.single;
    expect(answer.optionId, '');
    expect(answer.isAnswer, isTrue);
  });

  test('Event.fromJson reads the poll and the vote of a vote event', () {
    final event = Event.fromJson({
      'type': EventType.pollVoteCasted,
      'poll': _fullPollJson(),
      'poll_vote': _voteJson,
    });

    expect(event.poll!.id, 'poll-id');
    expect(event.poll!.ownVotesAndAnswers, [_vote, _answer]);
    expect(event.pollVote, _vote);
  });

  test('Event.toJson writes the poll settings with the custom data beside them', () {
    final event = Event(
      type: EventType.pollUpdated,
      poll: Poll(
        id: 'poll-id',
        name: 'Lunch?',
        description: 'Pick one',
        options: const [
          PollOption(id: 'pizza', text: 'Pizza', extraData: {'color': 'red'}),
        ],
        voteCount: 3,
        extraData: const {'topic': 'food'},
      ),
    );

    expect(event.toJson()['poll'], {
      'topic': 'food',
      'id': 'poll-id',
      'name': 'Lunch?',
      'description': 'Pick one',
      'options': [
        {'color': 'red', 'id': 'pizza', 'text': 'Pizza'},
      ],
      'voting_visibility': 'public',
      'enforce_unique_vote': true,
      'max_votes_allowed': null,
      'allow_user_suggested_options': false,
      'allow_answers': false,
      'is_closed': false,
    });
  });

  test('Event.toJson writes only the id, the option and the answer of a vote', () {
    final event = Event(type: EventType.pollVoteCasted, pollVote: _vote);

    expect(event.toJson()['poll_vote'], {'id': 'vote-id', 'option_id': 'pizza'});
  });

  test('Event.fromJson reads back the poll settings written by toJson', () {
    final poll = Poll(
      id: 'poll-id',
      name: 'Lunch?',
      options: const [
        PollOption(id: 'pizza', text: 'Pizza', extraData: {'color': 'red'}),
      ],
      votingVisibility: VotingVisibility.anonymous,
      maxVotesAllowed: 2,
      extraData: const {'topic': 'food'},
    );

    final event = Event.fromJson(Event(type: EventType.pollUpdated, poll: poll).toJson());

    expect(event.poll!.copyWith(createdAt: poll.createdAt, updatedAt: poll.updatedAt), poll);
  });
}

final _vote = PollVote(
  id: 'vote-id',
  pollId: 'poll-id',
  optionId: 'pizza',
  createdAt: DateTime.utc(2024, 4, 17),
  updatedAt: DateTime.utc(2024, 4, 17),
  userId: 'luke',
  user: User.fromJson(const {'id': 'luke', 'name': 'Luke'}),
);

const _voteJson = {
  'id': 'vote-id',
  'poll_id': 'poll-id',
  'option_id': 'pizza',
  'created_at': '2024-04-17T00:00:00Z',
  'updated_at': '2024-04-17T00:00:00Z',
  'user_id': 'luke',
  'user': {'id': 'luke', 'name': 'Luke'},
};

final _answer = PollVote(
  id: 'answer-id',
  pollId: 'poll-id',
  optionId: '',
  answerText: 'Anything',
  createdAt: DateTime.utc(2024, 4, 18),
  updatedAt: DateTime.utc(2024, 4, 18),
  userId: 'luke',
);

const _answerJson = {
  'id': 'answer-id',
  'poll_id': 'poll-id',
  'option_id': '',
  'answer_text': 'Anything',
  'is_answer': true,
  'created_at': '2024-04-18T00:00:00Z',
  'updated_at': '2024-04-18T00:00:00Z',
  'user_id': 'luke',
};

Map<String, Object?> _fullPollJson() => {
  'id': 'poll-id',
  'name': 'Lunch?',
  'description': 'Pick one',
  'options': [
    {'id': 'pizza', 'text': 'Pizza', 'color': 'red'},
    {'id': 'sushi', 'text': 'Sushi'},
  ],
  'voting_visibility': 'public',
  'enforce_unique_vote': false,
  'max_votes_allowed': 2,
  'allow_answers': true,
  'allow_user_suggested_options': true,
  'is_closed': true,
  'vote_count': 1,
  'answers_count': 1,
  'vote_counts_by_option': {'pizza': 1},
  'latest_votes_by_option': {
    'pizza': [_voteJson],
  },
  'latest_answers': [_answerJson],
  'own_votes': [_voteJson, _answerJson],
  'created_by_id': 'luke',
  'created_by': {'id': 'luke', 'name': 'Luke'},
  'created_at': '2024-04-17T14:46:23Z',
  'updated_at': '2024-04-18T00:00:00Z',
  'topic': 'food',
};
