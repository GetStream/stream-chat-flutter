import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('`.queryChannels`', () {
    chatClientTest(
      'should work fine without persistent channels',
      body: (tester) async {
        final channelStates = List.generate(
          3,
          (index) => createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'test-type-$index:test-id-$index'),
          ),
        );

        tester.mockApi(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
          result: createDefaultQueryChannelsResponse(channels: channelStates),
        );

        await expectLater(
          tester.client.queryChannels(),
          emitsInOrder([channelStates.map(isCorrectChannelFor)]),
        );

        tester.verifyApi(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
        );
      },
    );

    chatClientTest(
      '''should rethrow if `.queryChannelsOnline` throws and persistence channels are empty''',
      body: (tester) async {
        tester.mockApiFailure(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
        );

        await expectLater(
          tester.client.queryChannels(),
          emitsError(isA<StreamChatNetworkError>()),
        );

        tester.verifyApi(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
        );
      },
    );

    chatClientTest(
      'should coalesce concurrent identical calls into a single HTTP request',
      body: (tester) async {
        // Regression test for a TOCTOU race in the _queryChannelsStreams
        // cache: the cache write previously happened after an offline-await,
        // so N sibling calls in the same event-loop tick all missed the
        // cache and each fired its own queryChannels HTTP request.
        //
        // With the fix, the cache slot is reserved synchronously after the
        // hash check, so concurrent callers find the in-flight future and
        // share its result.
        final channelStates = List.generate(
          3,
          (index) => createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'test-type-$index:test-id-$index'),
          ),
        );

        // Slow down the API so all concurrent callers are guaranteed to be
        // in flight at the same time when the cache write happens.
        tester.mockApi(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
          result: createDefaultQueryChannelsResponse(channels: channelStates),
          delay: const Duration(milliseconds: 100),
        );

        // Fire 5 identical calls back-to-back in the same tick.
        final results = await Future.wait(
          List.generate(5, (_) => tester.client.queryChannels().toList()),
        );

        // All callers should receive the same channels.
        for (final emitted in results) {
          expect(emitted, hasLength(1));
          expect(emitted.single, channelStates.map(isCorrectChannelFor));
        }

        // But only ONE HTTP request should have been issued.
        tester.verifyApi(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
        );
      },
    );

    chatClientTest(
      'should fire a fresh request once the cached future has settled',
      body: (tester) async {
        // After the in-flight future completes, the cache slot is freed and
        // the next call must hit the API again — only concurrent callers
        // share the future, not sequential ones.
        final channelStates = List.generate(
          3,
          (index) => createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'test-type-$index:test-id-$index'),
          ),
        );

        tester.mockApi(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
          result: createDefaultQueryChannelsResponse(channels: channelStates),
        );

        await tester.client.queryChannels().toList();
        await tester.client.queryChannels().toList();

        tester.verifyApiCalled(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
          times: 2,
        );
      },
    );

    chatClientTest(
      'concurrent calls with different filters do not share the cache',
      body: (tester) async {
        // The cache is keyed on a hash of the query parameters. Callers
        // with different filters/limits must each fire their own request.
        tester.mockApi(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
          result: createDefaultQueryChannelsResponse(),
          delay: const Duration(milliseconds: 100),
        );

        await Future.wait([
          tester.client.queryChannels(filter: Filter.in_('cid', const ['a'])).toList(),
          tester.client.queryChannels(filter: Filter.in_('cid', const ['b'])).toList(),
        ]);

        tester.verifyApiCalled(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
          times: 2,
        );
      },
    );

    chatClientTest(
      'concurrent calls share the same error when the request fails',
      body: (tester) async {
        // If the in-flight HTTP request fails, every concurrent caller
        // awaiting the shared future should see the same error rather than
        // each firing its own retry request.
        tester.mockApiFailure(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
          delay: const Duration(milliseconds: 100),
        );

        final errors = await Future.wait(
          List.generate(5, (_) async {
            try {
              await tester.client.queryChannels().toList();
              return null;
            } catch (e) {
              return e;
            }
          }),
        );

        // Every caller surfaces the same error type.
        expect(errors, hasLength(5));
        for (final error in errors) {
          expect(error, isA<StreamChatNetworkError>());
        }

        // But only ONE HTTP request was made — the rest piggybacked.
        tester.verifyApi(
          (api) => api.channel.queryChannels(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            state: any(named: 'state'),
            watch: any(named: 'watch'),
            presence: any(named: 'presence'),
            memberLimit: any(named: 'memberLimit'),
            messageLimit: any(named: 'messageLimit'),
            paginationParams: any(named: 'paginationParams'),
          ),
        );
      },
    );
  });
}
