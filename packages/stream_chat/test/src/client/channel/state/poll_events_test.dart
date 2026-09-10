import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';
const _pollMessageId = 'poll-message-id';
const _pollId = 'poll-id';

final _createdAt = DateTime.utc(2021, 3);

ChannelState _seedChannel(ChannelState _) =>
    createDefaultChannelState(channel: createDefaultChannelModel(cid: _channelCid));

Poll _createPoll({
  String name = 'Favorite color?',
  List<PollVote> latestAnswers = const [],
  List<PollVote> ownVotesAndAnswers = const [],
}) {
  return Poll(
    id: _pollId,
    name: name,
    options: const [
      PollOption(id: 'option-a', text: 'A'),
      PollOption(id: 'option-b', text: 'B'),
    ],
    latestAnswers: latestAnswers,
    ownVotesAndAnswers: ownVotesAndAnswers,
  );
}

Message _seedPollMessage(
  ChannelTester tester, {
  String? parentId,
  List<PollVote> latestAnswers = const [],
  List<PollVote> ownVotesAndAnswers = const [],
}) {
  final message = Message(
    id: _pollMessageId,
    parentId: parentId,
    user: User(id: 'other-user'),
    createdAt: _createdAt,
    poll: _createPoll(
      latestAnswers: latestAnswers,
      ownVotesAndAnswers: ownVotesAndAnswers,
    ),
  );
  tester.channelState!.updateMessage(message);
  return message;
}

Message _storedPollMessage(ChannelTester tester) {
  return tester.channelState!.messages.firstWhere((it) => it.id == _pollMessageId);
}

void main() {
  group('Poll events', () {
    channelTest(
      '${EventType.pollCreated} adds the poll message',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollCreated,
            message: Message(
              id: _pollMessageId,
              user: User(id: 'other-user'),
              createdAt: _createdAt,
              poll: _createPoll(),
            ),
          ),
        );

        expect(_storedPollMessage(tester).poll?.id, _pollId);
      },
    );

    channelTest(
      '${EventType.pollCreated} without a poll is ignored',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollCreated,
            message: Message(
              id: _pollMessageId,
              user: User(id: 'other-user'),
              createdAt: _createdAt,
            ),
          ),
        );

        expect(tester.channelState!.messages, isEmpty);
      },
    );

    channelTest(
      '${EventType.pollUpdated} updates the poll but preserves own votes',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final ownVote = PollVote(
          id: 'own-vote-id',
          optionId: 'option-a',
          userId: tester.currentUser!.id,
        );
        _seedPollMessage(tester, ownVotesAndAnswers: [ownVote]);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollUpdated,
            poll: _createPoll(name: 'Renamed'),
          ),
        );

        final stored = _storedPollMessage(tester);
        expect(stored.poll?.name, 'Renamed');
        expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-vote-id']);
      },
    );

    channelTest(
      '${EventType.pollUpdated} for an unknown poll is ignored',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        _seedPollMessage(tester);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollUpdated,
            poll: Poll(
              id: 'unknown-poll-id',
              name: 'Renamed',
              options: const [PollOption(text: 'A')],
            ),
          ),
        );

        expect(_storedPollMessage(tester).poll?.name, 'Favorite color?');
      },
    );

    channelTest(
      '${EventType.pollUpdated} without a poll is ignored',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        _seedPollMessage(tester);

        await tester.emitEvent(createDefaultEvent(cid: tester.channel.cid, type: EventType.pollUpdated));

        expect(_storedPollMessage(tester).poll?.name, 'Favorite color?');
      },
    );

    channelTest(
      '${EventType.pollUpdated} updates a poll on a thread message',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const parentId = 'poll-parent-id';
        _seedPollMessage(tester, parentId: parentId);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollUpdated,
            poll: _createPoll(name: 'Renamed'),
          ),
        );

        final stored = tester.channelState!.threads[parentId]!.firstWhere((it) => it.id == _pollMessageId);
        expect(stored.poll?.name, 'Renamed');
      },
    );

    channelTest(
      '${EventType.pollClosed} closes the poll and keeps the cached data',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        _seedPollMessage(tester);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollClosed,
            poll: _createPoll(name: 'Renamed'),
          ),
        );

        final stored = _storedPollMessage(tester);
        expect(stored.poll?.isClosed, isTrue);
        expect(stored.poll?.name, 'Favorite color?');
      },
    );

    channelTest(
      '${EventType.pollAnswerCasted} adds own answers only for the current user',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        _seedPollMessage(tester);

        final ownAnswer = PollVote(
          id: 'own-answer-id',
          answerText: 'my answer',
          userId: tester.currentUser!.id,
        );
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollAnswerCasted,
            poll: _createPoll(),
            pollVote: ownAnswer,
          ),
        );

        var stored = _storedPollMessage(tester);
        expect(stored.poll?.latestAnswers.map((v) => v.id), ['own-answer-id']);
        expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-answer-id']);

        final otherAnswer = PollVote(
          id: 'other-answer-id',
          answerText: 'their answer',
          userId: 'other-user',
        );
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollAnswerCasted,
            poll: _createPoll(),
            pollVote: otherAnswer,
          ),
        );

        stored = _storedPollMessage(tester);
        expect(stored.poll?.latestAnswers.map((v) => v.id), contains('other-answer-id'));
        expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-answer-id']);
      },
    );

    channelTest(
      '${EventType.pollVoteCasted} adds own votes only for the current user',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        _seedPollMessage(tester);

        final ownVote = PollVote(
          id: 'own-vote-id',
          optionId: 'option-a',
          userId: tester.currentUser!.id,
        );
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollVoteCasted,
            poll: _createPoll(),
            pollVote: ownVote,
          ),
        );

        var stored = _storedPollMessage(tester);
        expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-vote-id']);

        final otherVote = PollVote(
          id: 'other-vote-id',
          optionId: 'option-b',
          userId: 'other-user',
        );
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollVoteCasted,
            poll: _createPoll(),
            pollVote: otherVote,
          ),
        );

        stored = _storedPollMessage(tester);
        expect(stored.poll?.ownVotesAndAnswers.map((v) => v.id), ['own-vote-id']);
      },
    );

    channelTest(
      '${EventType.pollVoteChanged} upserts the current user vote',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        _seedPollMessage(tester);

        final changedVote = PollVote(
          id: 'changed-vote-id',
          optionId: 'option-b',
          userId: tester.currentUser!.id,
        );
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollVoteChanged,
            poll: _createPoll(),
            pollVote: changedVote,
          ),
        );

        expect(
          _storedPollMessage(tester).poll?.ownVotesAndAnswers.map((v) => v.id),
          contains('changed-vote-id'),
        );
      },
    );

    channelTest(
      '${EventType.pollAnswerRemoved} removes the answer from both lists',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final answer = PollVote(
          id: 'answer-id',
          answerText: 'my answer',
          userId: tester.currentUser!.id,
        );
        _seedPollMessage(tester, latestAnswers: [answer], ownVotesAndAnswers: [answer]);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollAnswerRemoved,
            poll: _createPoll(),
            pollVote: answer,
          ),
        );

        final stored = _storedPollMessage(tester);
        expect(stored.poll?.latestAnswers, isEmpty);
        expect(stored.poll?.ownVotesAndAnswers, isEmpty);
      },
    );

    channelTest(
      '${EventType.pollVoteRemoved} removes the vote from own votes',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        final vote = PollVote(
          id: 'vote-id',
          optionId: 'option-a',
          userId: tester.currentUser!.id,
        );
        _seedPollMessage(tester, ownVotesAndAnswers: [vote]);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.pollVoteRemoved,
            poll: _createPoll(),
            pollVote: vote,
          ),
        );

        expect(_storedPollMessage(tester).poll?.ownVotesAndAnswers, isEmpty);
      },
    );
  });
}
