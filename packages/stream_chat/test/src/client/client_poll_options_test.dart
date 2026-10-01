import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'poll_fixtures.dart';

void main() {
  test(
    'StreamChatClient.createPollOption sends the option text and custom data and returns the created option',
    () async {
      final defaultApi = pollsDefaultApi();
      when(
        () => defaultApi.createPollOption(
          pollId: 'poll-id',
          createPollOptionRequest: const api.CreatePollOptionRequest(text: 'Pizza', custom: {'color': 'red'}),
        ),
      ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));
      final client = pollsClient(defaultApi);

      final result = await client.createPollOption(
        'poll-id',
        const PollOption(text: 'Pizza', extraData: {'color': 'red'}),
      );

      expect(result, const Result.success(_pizzaResponse));
    },
  );

  test('StreamChatClient.createPollOption returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.createPollOption(
        pollId: 'poll-id',
        createPollOptionRequest: any(named: 'createPollOptionRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.createPollOption('poll-id', const PollOption(text: 'Pizza'));

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.getPollOption sends the poll and option ids and returns the option', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.getPollOption(pollId: 'poll-id', optionId: 'pizza'),
    ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));
    final client = pollsClient(defaultApi);

    final result = await client.getPollOption('poll-id', 'pizza');

    expect(result, const Result.success(_pizzaResponse));
  });

  test('StreamChatClient.getPollOption returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.getPollOption(pollId: 'poll-id', optionId: 'pizza'),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.getPollOption('poll-id', 'pizza');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test(
    "StreamChatClient.getPollOption keeps custom fields named like the option's own fields out of its custom data",
    () async {
      final defaultApi = pollsDefaultApi();
      final response = api.PollOptionResponse(
        duration: '4.21ms',
        pollOption: generatedPizza.copyWith(custom: const {'color': 'red', 'text': 'custom-text'}),
      );
      when(
        () => defaultApi.getPollOption(pollId: 'poll-id', optionId: 'pizza'),
      ).thenAnswer((_) async => Result.success(response));
      final client = pollsClient(defaultApi);

      final result = await client.getPollOption('poll-id', 'pizza');

      expect(result.getOrNull()?.pollOption.extraData, const {'color': 'red'});
    },
  );

  test('StreamChatClient.updatePollOption sends the option and returns the updated option', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.updatePollOption(
        pollId: 'poll-id',
        updatePollOptionRequest: const api.UpdatePollOptionRequest(
          id: 'pizza',
          text: 'Pizza',
          custom: {'color': 'red'},
        ),
      ),
    ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));
    final client = pollsClient(defaultApi);

    final result = await client.updatePollOption('poll-id', pizza);

    expect(result, const Result.success(_pizzaResponse));
  });

  test('StreamChatClient.updatePollOption sends an option without an id with an empty id', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.updatePollOption(
        pollId: 'poll-id',
        updatePollOptionRequest: const api.UpdatePollOptionRequest(id: '', text: 'Pizza', custom: {}),
      ),
    ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));
    final client = pollsClient(defaultApi);

    final result = await client.updatePollOption('poll-id', const PollOption(text: 'Pizza'));

    expect(result, const Result.success(_pizzaResponse));
  });

  test('StreamChatClient.updatePollOption returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.updatePollOption(
        pollId: 'poll-id',
        updatePollOptionRequest: any(named: 'updatePollOptionRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.updatePollOption('poll-id', pizza);

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.deletePollOption sends the poll and option ids and returns a success', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.deletePollOption(pollId: 'poll-id', optionId: 'pizza'),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '4.21ms')));
    final client = pollsClient(defaultApi);

    final result = await client.deletePollOption('poll-id', 'pizza');

    expect(result, const Result<void>.success(null));
  });

  test('StreamChatClient.deletePollOption returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.deletePollOption(pollId: 'poll-id', optionId: 'pizza'),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.deletePollOption('poll-id', 'pizza');

    expect(result.exceptionOrNull(), pollsApiError);
  });
}

const _generatedPizzaResponse = api.PollOptionResponse(duration: '4.21ms', pollOption: generatedPizza);

const _pizzaResponse = PollOptionResponse(duration: '4.21ms', pollOption: pizza);
