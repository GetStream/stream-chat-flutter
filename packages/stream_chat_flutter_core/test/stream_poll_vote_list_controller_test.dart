import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_poll_vote_list_controller.dart';

import 'mocks.dart';

void main() {
  test('StreamPollVoteListController.doInitialLoad loads the first page of votes', () async {
    final channel = _channelAnswering([
      Result.success(_page([_vote('v1'), _vote('v2')], next: 'cursor')),
    ]);
    final controller = _controller(channel);

    await controller.doInitialLoad();

    expect(controller.value, PagedValue<String, PollVote>(items: [_vote('v1'), _vote('v2')], nextPageKey: 'cursor'));
  });

  test('StreamPollVoteListController.doInitialLoad asks for three pages at once', () async {
    final channel = _channelAnswering([Result.success(_page([]))]);
    final controller = _controller(channel);

    await controller.doInitialLoad();

    verify(
      () => channel.queryPollVotes(
        'poll-id',
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        limit: 30,
      ),
    );
  });

  test('StreamPollVoteListController.doInitialLoad turns a failure into the error state', () async {
    const error = StreamClientException(message: 'boom');
    final channel = _channelAnswering([const Result.failure(error)]);
    final controller = _controller(channel);

    await controller.doInitialLoad();

    expect(controller.value, const PagedValue<String, PollVote>.error(error));
  });

  test('StreamPollVoteListController.doInitialLoad turns an error the channel throws into the error state', () async {
    final channel = MockChannel();
    final thrown = StateError('Channel is not initialized');
    when(
      () => channel.queryPollVotes(
        any(),
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        limit: any(named: 'limit'),
        next: any(named: 'next'),
        prev: any(named: 'prev'),
      ),
    ).thenThrow(thrown);
    final controller = _controller(channel);

    await controller.doInitialLoad();

    final error = controller.value.mapOrNull(null, error: (it) => it.error);
    expect(error, isA<StreamClientException>().having((it) => it.cause, 'cause', thrown));
  });

  test('StreamPollVoteListController.loadMore appends the next page of votes', () async {
    final channel = _channelAnswering([
      Result.success(_page([_vote('v1')], next: 'cursor')),
      Result.success(_page([_vote('v2')])),
    ]);
    final controller = _controller(channel);
    await controller.doInitialLoad();

    await controller.loadMore('cursor');

    expect(controller.value, PagedValue<String, PollVote>(items: [_vote('v1'), _vote('v2')]));
    verify(
      () => channel.queryPollVotes(
        'poll-id',
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        limit: 10,
        next: 'cursor',
      ),
    );
  });

  test('StreamPollVoteListController.loadMore keeps the loaded votes and records a failure', () async {
    const error = StreamClientException(message: 'boom');
    final channel = _channelAnswering([
      Result.success(_page([_vote('v1')], next: 'cursor')),
      const Result.failure(error),
    ]);
    final controller = _controller(channel);
    await controller.doInitialLoad();

    await controller.loadMore('cursor');

    expect(controller.value, PagedValue<String, PollVote>(items: [_vote('v1')], nextPageKey: 'cursor', error: error));
  });
}

PollVote _vote(String id) => PollVote(
  id: id,
  pollId: 'poll-id',
  optionId: 'pizza',
  createdAt: DateTime.utc(2024),
  updatedAt: DateTime.utc(2024),
);

QueryPollVotesResponse _page(List<PollVote> votes, {String? next}) =>
    QueryPollVotesResponse(duration: '4.21ms', votes: votes, next: next);

// A channel whose vote queries answer [results] in order.
MockChannel _channelAnswering(List<Result<QueryPollVotesResponse>> results) {
  final channel = MockChannel();
  final pending = [...results];
  when(
    () => channel.queryPollVotes(
      any(),
      filter: any(named: 'filter'),
      sort: any(named: 'sort'),
      limit: any(named: 'limit'),
      next: any(named: 'next'),
      prev: any(named: 'prev'),
    ),
  ).thenAnswer((_) async => pending.removeAt(0));
  when(channel.on).thenAnswer((_) => const Stream.empty());
  return channel;
}

StreamPollVoteListController _controller(Channel channel) {
  final controller = StreamPollVoteListController(channel: channel, pollId: 'poll-id');
  addTearDown(controller.dispose);
  return controller;
}
