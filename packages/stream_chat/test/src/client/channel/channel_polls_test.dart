import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';
import '../../utils.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';

void main() {
  test('Channel.sendPoll creates the poll and sends it in a message', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    final createdPoll = _poll.copyWith(id: 'created-poll-id');
    when(() => client.createPoll(_poll)).thenAnswer((_) async => Result.success(_pollResponse(createdPoll)));
    when(
      () => client.sendMessage(any(), _channelId, _channelType),
    ).thenAnswer(
      (invocation) async => SendMessageResponse()..message = invocation.positionalArguments.first as Message,
    );

    final result = await channel.sendPoll(_poll, messageText: 'Vote please');

    final sent = verify(() => client.sendMessage(captureAny(), _channelId, _channelType)).captured.single as Message;
    expect(sent.text, 'Vote please');
    expect(sent.pollId, 'created-poll-id');
    expect(sent.poll, createdPoll);
    expect(result.getOrNull()?.message.id, sent.id);
  });

  test('Channel.sendPoll returns the failure to create the poll without sending a message', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    const error = StreamClientException(message: 'boom');
    when(() => client.createPoll(_poll)).thenAnswer((_) async => const Result.failure(error));

    final result = await channel.sendPoll(_poll);

    expect(result.exceptionOrNull(), error);
    verifyNever(() => client.sendMessage(any(), any(), any()));
  });

  test('Channel.sendPoll returns the failure to send the message without throwing', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    final error = apiException(code: StreamErrorCode.notAllowed, statusCode: 403);
    when(() => client.createPoll(_poll)).thenAnswer((_) async => Result.success(_pollResponse(_poll)));
    when(() => client.sendMessage(any(), _channelId, _channelType)).thenThrow(error);

    final result = await channel.sendPoll(_poll);

    expect(result.exceptionOrNull(), error);
  });

  test('Channel.updatePoll returns the updated poll', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    when(() => client.updatePoll(_poll)).thenAnswer((_) async => Result.success(_pollResponse(_poll)));

    final result = await channel.updatePoll(_poll);

    expect(result, Result.success(_pollResponse(_poll)));
  });

  test('Channel.deletePoll deletes the poll and returns a success', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    when(() => client.deletePoll(_poll.id)).thenAnswer((_) async => const Result.success(null));

    final result = await channel.deletePoll(_poll);

    expect(result, const Result<void>.success(null));
  });

  test('Channel.closePoll closes the poll and returns it', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    final closed = _poll.copyWith(isClosed: true);
    when(() => client.closePoll(_poll.id)).thenAnswer((_) async => Result.success(_pollResponse(closed)));

    final result = await channel.closePoll(_poll);

    expect(result, Result.success(_pollResponse(closed)));
  });

  test('Channel.createPollOption adds the option to the poll and returns it', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    const option = PollOption(text: 'Sushi');
    const response = PollOptionResponse(
      duration: '4.21ms',
      pollOption: PollOption(id: 'sushi', text: 'Sushi'),
    );
    when(() => client.createPollOption(_poll.id, option)).thenAnswer((_) async => const Result.success(response));

    final result = await channel.createPollOption(_poll, option);

    expect(result, const Result.success(response));
  });

  test('Channel.castPollVote votes for the option and returns the vote', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    final response = PollVoteResponse(duration: '4.21ms', vote: _vote);
    when(
      () => client.castPollVote(_message.id, _poll.id, optionId: 'pizza'),
    ).thenAnswer((_) async => Result.success(response));

    final result = await channel.castPollVote(_message, _poll, const PollOption(id: 'pizza', text: 'Pizza'));

    expect(result, Result.success(response));
  });

  test('Channel.castPollVote returns a failure without voting when the option has no id', () async {
    final client = _client();
    final channel = _initializedChannel(client);

    final result = await channel.castPollVote(_message, _poll, const PollOption(text: 'Pizza'));

    expect(result.exceptionOrNull(), isA<StreamClientException>());
    verifyNever(() => client.castPollVote(any(), any(), optionId: any(named: 'optionId')));
  });

  test('Channel.addPollAnswer leaves the answer and returns it', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    final response = PollVoteResponse(duration: '4.21ms', vote: _vote);
    when(
      () => client.addPollAnswer(_message.id, _poll.id, answerText: 'Anything'),
    ).thenAnswer((_) async => Result.success(response));

    final result = await channel.addPollAnswer(_message, _poll, answerText: 'Anything');

    expect(result, Result.success(response));
  });

  test('Channel.removePollVote removes the vote and returns it', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    final response = PollVoteResponse(duration: '4.21ms', vote: _vote);
    when(
      () => client.removePollVote(_message.id, _poll.id, 'vote-id'),
    ).thenAnswer((_) async => Result.success(response));

    final result = await channel.removePollVote(_message, _poll, _vote);

    expect(result, Result.success(response));
  });

  test('Channel.removePollVote returns a failure without removing anything when the vote has no id', () async {
    final client = _client();
    final channel = _initializedChannel(client);

    final result = await channel.removePollVote(_message, _poll, PollVote(optionId: 'pizza'));

    expect(result.exceptionOrNull(), isA<StreamClientException>());
    verifyNever(() => client.removePollVote(any(), any(), any()));
  });

  test('Channel.queryPollVotes forwards the query and returns the matching votes', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    final filter = Filter.equal(PollVoteFilterField.isAnswer, true);
    final sort = [PollVoteSort.desc(PollVoteSortField.createdAt)];
    final response = QueryPollVotesResponse(duration: '4.21ms', votes: [_vote], next: 'after');
    when(
      () => client.queryPollVotes(_poll.id, filter: filter, sort: sort, limit: 5, next: 'cursor'),
    ).thenAnswer((_) async => Result.success(response));

    final result = await channel.queryPollVotes(_poll.id, filter: filter, sort: sort, limit: 5, next: 'cursor');

    expect(result, Result.success(response));
  });

  test('Channel.queryPollVotes asks for ten votes when no limit is given', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    const response = QueryPollVotesResponse(duration: '4.21ms', votes: []);
    when(() => client.queryPollVotes(_poll.id, limit: 10)).thenAnswer((_) async => const Result.success(response));

    final result = await channel.queryPollVotes(_poll.id);

    expect(result, const Result.success(response));
  });

  test('Channel.sendPoll reports an unexpected error sending the message as a client failure', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    final thrown = StateError('unexpected');
    when(() => client.createPoll(_poll)).thenAnswer((_) async => Result.success(_pollResponse(_poll)));
    when(() => client.sendMessage(any(), _channelId, _channelType)).thenThrow(thrown);

    final result = await channel.sendPoll(_poll);

    expect(result.exceptionOrNull(), isA<StreamClientException>().having((it) => it.cause, 'cause', thrown));
  });

  test('Channel.updatePoll returns the failure without throwing', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    when(() => client.updatePoll(_poll)).thenAnswer((_) async => const Result.failure(_error));

    final result = await channel.updatePoll(_poll);

    expect(result.exceptionOrNull(), _error);
  });

  test('Channel.deletePoll returns the failure without throwing', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    when(() => client.deletePoll(_poll.id)).thenAnswer((_) async => const Result.failure(_error));

    final result = await channel.deletePoll(_poll);

    expect(result.exceptionOrNull(), _error);
  });

  test('Channel.closePoll returns the failure without throwing', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    when(() => client.closePoll(_poll.id)).thenAnswer((_) async => const Result.failure(_error));

    final result = await channel.closePoll(_poll);

    expect(result.exceptionOrNull(), _error);
  });

  test('Channel.createPollOption returns the failure without throwing', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    const option = PollOption(text: 'Sushi');
    when(() => client.createPollOption(_poll.id, option)).thenAnswer((_) async => const Result.failure(_error));

    final result = await channel.createPollOption(_poll, option);

    expect(result.exceptionOrNull(), _error);
  });

  test('Channel.castPollVote returns the failure without throwing', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    when(
      () => client.castPollVote(_message.id, _poll.id, optionId: 'pizza'),
    ).thenAnswer((_) async => const Result.failure(_error));

    final result = await channel.castPollVote(_message, _poll, const PollOption(id: 'pizza', text: 'Pizza'));

    expect(result.exceptionOrNull(), _error);
  });

  test('Channel.addPollAnswer returns the failure without throwing', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    when(
      () => client.addPollAnswer(_message.id, _poll.id, answerText: 'Anything'),
    ).thenAnswer((_) async => const Result.failure(_error));

    final result = await channel.addPollAnswer(_message, _poll, answerText: 'Anything');

    expect(result.exceptionOrNull(), _error);
  });

  test('Channel.removePollVote returns the failure without throwing', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    when(
      () => client.removePollVote(_message.id, _poll.id, 'vote-id'),
    ).thenAnswer((_) async => const Result.failure(_error));

    final result = await channel.removePollVote(_message, _poll, _vote);

    expect(result.exceptionOrNull(), _error);
  });

  test('Channel.queryPollVotes returns the failure without throwing', () async {
    final client = _client();
    final channel = _initializedChannel(client);
    when(() => client.queryPollVotes(_poll.id, limit: 10)).thenAnswer((_) async => const Result.failure(_error));

    final result = await channel.queryPollVotes(_poll.id);

    expect(result.exceptionOrNull(), _error);
  });
}

const _error = StreamClientException(message: 'boom');

final _poll = Poll(
  id: 'poll-id',
  name: 'Lunch?',
  options: const [PollOption(id: 'pizza', text: 'Pizza')],
  createdAt: DateTime.utc(2024),
  updatedAt: DateTime.utc(2024),
);

final _message = Message(id: 'message-id', pollId: 'poll-id');

final _vote = PollVote(
  id: 'vote-id',
  pollId: 'poll-id',
  optionId: 'pizza',
  createdAt: DateTime.utc(2024),
  updatedAt: DateTime.utc(2024),
);

PollResponse _pollResponse(Poll poll) => PollResponse(duration: '4.21ms', poll: poll);

MockStreamChatClient _client() {
  registerFallbackValue(FakeMessage());

  final client = MockStreamChatClient();
  when(() => client.retryPolicy).thenReturn(
    RetryPolicy(shouldRetry: (_, _, _) => false, delayFactor: Duration.zero),
  );
  when(() => client.state).thenReturn(FakeClientState());
  when(() => client.moderation).thenReturn(MockModerationClient());
  when(() => client.channelDeliveryReporter.submitForDelivery(any())).thenAnswer((_) async {});
  return client;
}

Channel _initializedChannel(StreamChatClient client) {
  final channel = Channel.fromState(
    client,
    ChannelState(
      channel: ChannelModel(id: _channelId, type: _channelType),
    ),
  );
  addTearDown(channel.dispose);
  return channel;
}
