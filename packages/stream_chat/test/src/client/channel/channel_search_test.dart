import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  );
}

void main() {
  group('`.search`', () {
    final filter = Filter.in_('cid', const [_channelCid]);

    channelTest(
      'should work fine with `query`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const query = 'test-search-query';
        const sort = [SortOption.asc('test-sort-field')];
        const pagination = PaginationParams();

        final results = List.generate(3, (index) => createDefaultGetMessageResponse());

        tester.mockApi(
          (api) => api.general.searchMessages(
            filter,
            query: query,
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
          result: createDefaultSearchMessagesResponse(results: results),
        );

        final res = await tester.channel.search(
          query: query,
          sort: sort,
          paginationParams: pagination,
        );

        expect(res, isNotNull);
        expect(res.results.length, results.length);

        tester.verifyApi(
          (api) => api.general.searchMessages(
            filter,
            query: query,
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        );
      },
    );

    channelTest(
      'should work fine with `messageFilters`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final messageFilters = Filter.query('key', 'text');
        const sort = [SortOption.desc('test-sort-field')];
        const pagination = PaginationParams();

        final results = List.generate(3, (index) => createDefaultGetMessageResponse());

        tester.mockApi(
          (api) => api.general.searchMessages(
            filter,
            messageFilters: messageFilters,
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
          result: createDefaultSearchMessagesResponse(results: results),
        );

        final res = await tester.channel.search(
          sort: sort,
          paginationParams: pagination,
          messageFilters: messageFilters,
        );

        expect(res, isNotNull);
        expect(res.results.length, results.length);

        tester.verifyApi(
          (api) => api.general.searchMessages(
            filter,
            messageFilters: messageFilters,
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        );
      },
    );
  });
}
