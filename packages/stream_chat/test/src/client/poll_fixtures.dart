import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';

// Fixtures shared by the poll client tests. Every generated object carries a value in every field, including the
// ones the SDK models leave out, so a field the mapping drops or swaps changes the compared object.

/// A failure the generated API answers with.
const pollsApiError = StreamClientException(message: 'boom');

final generatedVoter = api.UserResponse(
  avgResponseTime: 12,
  banned: false,
  blockedUserIds: const ['blocked-user'],
  createdAt: DateTime.utc(2024, 1, 1),
  custom: const {'favorite_color': 'blue'},
  id: 'luke',
  image: 'https://example.com/luke.png',
  language: 'en',
  lastActive: DateTime.utc(2024, 1, 3),
  name: 'Luke',
  online: true,
  role: 'user',
  teams: const ['jedi'],
  teamsRole: const {'jedi': 'admin'},
  updatedAt: DateTime.utc(2024, 1, 2),
);

final voter = User(
  id: 'luke',
  role: 'user',
  name: 'Luke',
  image: 'https://example.com/luke.png',
  createdAt: DateTime.utc(2024, 1, 1),
  updatedAt: DateTime.utc(2024, 1, 2),
  lastActive: DateTime.utc(2024, 1, 3),
  online: true,
  teams: const ['jedi'],
  language: 'en',
  teamsRole: const {'jedi': 'admin'},
  avgResponseTime: 12,
  extraData: const {'favorite_color': 'blue'},
);

final generatedVote = api.PollVoteResponseData(
  answerTextI18n: const {'fr': 'ignored'},
  createdAt: DateTime.utc(2024, 4, 17, 10),
  id: 'vote-id',
  isAnswer: false,
  optionId: 'pizza',
  pollId: 'poll-id',
  updatedAt: DateTime.utc(2024, 4, 17, 11),
  user: generatedVoter,
  userId: 'luke',
);

final vote = PollVote(
  id: 'vote-id',
  pollId: 'poll-id',
  optionId: 'pizza',
  createdAt: DateTime.utc(2024, 4, 17, 10),
  updatedAt: DateTime.utc(2024, 4, 17, 11),
  userId: 'luke',
  user: voter,
);

// An answer selects no option, which arrives as an empty option id.
final generatedAnswer = api.PollVoteResponseData(
  answerText: 'Anything',
  answerTextI18n: const {'fr': "N'importe quoi"},
  createdAt: DateTime.utc(2024, 4, 18, 10),
  id: 'answer-id',
  isAnswer: true,
  optionId: '',
  pollId: 'poll-id',
  updatedAt: DateTime.utc(2024, 4, 18, 11),
  user: generatedVoter,
  userId: 'luke',
);

final answer = PollVote(
  id: 'answer-id',
  pollId: 'poll-id',
  optionId: '',
  answerText: 'Anything',
  createdAt: DateTime.utc(2024, 4, 18, 10),
  updatedAt: DateTime.utc(2024, 4, 18, 11),
  userId: 'luke',
  user: voter,
);

const generatedPizza = api.PollOptionResponseData(
  custom: {'color': 'red'},
  id: 'pizza',
  text: 'Pizza',
  textI18n: {'it': 'Pizza'},
);

const pizza = PollOption(id: 'pizza', text: 'Pizza', extraData: {'color': 'red'});

final generatedPoll = api.PollResponseData(
  allowAnswers: true,
  allowUserSuggestedOptions: true,
  answersCount: 1,
  createdAt: DateTime.utc(2024, 4, 17),
  createdBy: generatedVoter,
  createdById: 'luke',
  custom: const {'topic': 'food'},
  description: 'Pick one',
  descriptionI18n: const {'it': 'Scegline uno'},
  enforceUniqueVote: false,
  id: 'poll-id',
  isClosed: true,
  latestAnswers: [generatedAnswer],
  latestVotesByOption: {
    'pizza': [generatedVote],
  },
  maxVotesAllowed: 2,
  name: 'Lunch?',
  nameI18n: const {'it': 'Pranzo?'},
  options: const [generatedPizza],
  ownVotes: [generatedVote, generatedAnswer],
  updatedAt: DateTime.utc(2024, 4, 18),
  voteCount: 1,
  voteCountsByOption: const {'pizza': 1},
  votingVisibility: api.PollResponseDataVotingVisibility.anonymous,
);

final poll = Poll(
  id: 'poll-id',
  name: 'Lunch?',
  description: 'Pick one',
  options: const [pizza],
  votingVisibility: VotingVisibility.anonymous,
  enforceUniqueVote: false,
  maxVotesAllowed: 2,
  allowAnswers: true,
  latestAnswers: [answer],
  answersCount: 1,
  allowUserSuggestedOptions: true,
  isClosed: true,
  createdAt: DateTime.utc(2024, 4, 17),
  updatedAt: DateTime.utc(2024, 4, 18),
  voteCountsByOption: const {'pizza': 1},
  voteCount: 1,
  latestVotesByOption: {
    'pizza': [vote],
  },
  createdById: 'luke',
  createdBy: voter,
  ownVotesAndAnswers: [vote, answer],
  extraData: const {'topic': 'food'},
);

final generatedPollResponse = api.PollResponse(duration: '4.21ms', poll: generatedPoll);

final pollResponse = PollResponse(duration: '4.21ms', poll: poll);
