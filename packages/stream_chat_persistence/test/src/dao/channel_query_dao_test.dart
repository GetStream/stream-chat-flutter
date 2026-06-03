import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/channel_query_dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';
import '../utils/date_matcher.dart';

void main() {
  late DriftChatDatabase database;
  late ChannelQueryDao channelQueryDao;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    channelQueryDao = database.channelQueryDao;
  });

  test('updateChannelQueries', () async {
    final filter = Filter.in_('members', const ['testUserId']);

    const cids = ['testCid1', 'testCid2', 'testCid3'];

    final cachedCids = await channelQueryDao.getCachedChannelCids(filter);
    expect(cachedCids, isEmpty);

    // Updating channel queries
    await channelQueryDao.updateChannelQueries(filter, cids);

    final updatedCids = await channelQueryDao.getCachedChannelCids(filter);
    expect(updatedCids, cids);
  });

  test('clear queryCache before updateChannelQueries', () async {
    final filter = Filter.in_('members', const ['testUserId']);

    const cids = ['testCid1', 'testCid2', 'testCid3'];

    final cachedCids = await channelQueryDao.getCachedChannelCids(filter);
    expect(cachedCids, isEmpty);

    // Updating channel queries
    await channelQueryDao.updateChannelQueries(
      filter,
      cids,
      clearQueryCache: true,
    );

    final updatedCids = await channelQueryDao.getCachedChannelCids(filter);
    expect(updatedCids, cids);
  });

  test('getCachedChannelCids', () async {
    final filter = Filter.in_('members', const ['testUserId']);

    const cids = ['testCid1', 'testCid2', 'testCid3'];

    final cachedCids = await channelQueryDao.getCachedChannelCids(filter);
    expect(cachedCids, isEmpty);

    // Updating channel queries
    await channelQueryDao.updateChannelQueries(filter, cids);

    final updatedCids = await channelQueryDao.getCachedChannelCids(filter);
    expect(updatedCids, cids);
  });

  Future<List<ChannelModel>> _insertTestDataForGetChannel(
    Filter filter, {
    int count = 3,
  }) async {
    final now = DateTime.now();
    final userDao = database.userDao;
    final channelDao = database.channelDao;

    final cids = List.generate(count, (index) => 'testCid$index');
    final users = List.generate(count, (index) => User(id: 'testId$index'));
    final channels = List.generate(
      count,
      (index) => ChannelModel(
        id: 'testId$index',
        type: 'testType$index',
        cid: cids[index],
        createdBy: users[index],
        config: ChannelConfig(),
        filterTags: ['tag$index'],
        extraData: {'test_custom_field': index + 3},
        createdAt: now,
        memberCount: index + 3,
        lastMessageAt: now.add(Duration(hours: index)),
      ),
    ).toList(growable: false);

    await userDao.updateUsers(users);
    await channelDao.updateChannels(channels);
    await channelQueryDao.updateChannelQueries(filter, cids);

    return channels;
  }

  group('getChannels', () {
    tearDown(() async => database.flush());

    final filter = Filter.in_('members', const ['testUserId']);

    test('should return empty list of channels', () async {
      final channels = await channelQueryDao.getChannels(filter: filter);
      expect(channels, isEmpty);
    });

    test('should return all the inserted channels', () async {
      // Inserting test data for get channels
      final insertedChannels = await _insertTestDataForGetChannel(filter);

      // Should match with the inserted channels
      final updatedChannels = await channelQueryDao.getChannels(filter: filter);
      expect(updatedChannels.length, insertedChannels.length);
      for (var i = 0; i < updatedChannels.length; i++) {
        final updatedChannel = updatedChannels[i];
        final insertedChannel = insertedChannels[i];

        // Should match all the basic details
        expect(updatedChannel.id, insertedChannel.id);
        expect(updatedChannel.type, insertedChannel.type);
        expect(updatedChannel.cid, insertedChannel.cid);
        expect(updatedChannel.memberCount, insertedChannel.memberCount);
        expect(updatedChannel.filterTags, insertedChannel.filterTags);

        // Should match createdAt date
        expect(
          updatedChannel.createdAt,
          isSameDateAs(insertedChannel.createdAt),
        );

        // Should match lastMessageAt date
        expect(
          updatedChannel.lastMessageAt,
          isSameDateAs(insertedChannel.lastMessageAt),
        );
      }
    });
  });

  Future<void> _insertChannelsForCids(List<String> cids) async {
    final users =
        List.generate(cids.length, (i) => User(id: 'user_${cids[i]}'));
    final channelModels = List.generate(
      cids.length,
      (i) => ChannelModel(
        id: 'id_${cids[i]}',
        type: 'messaging',
        cid: cids[i],
        createdBy: users[i],
        config: ChannelConfig(),
      ),
    );
    await database.userDao.updateUsers(users);
    await database.channelDao.updateChannels(channelModels);
  }

  test('updateChannelQueriesByPredefinedFilter', () async {
    const filterName = 'sample-app-list';
    const filterValues = {'user_id': 'testUserId'};
    const sortValues = {'pinned_at': true};
    const cids = ['testCid1', 'testCid2', 'testCid3'];
    final filter = Filter.equal('type', 'messaging');
    const sort = <SortOption<ChannelState>>[
      SortOption<ChannelState>.desc(ChannelSortKey.pinnedAt),
      SortOption<ChannelState>.desc(ChannelSortKey.lastMessageAt),
    ];

    await _insertChannelsForCids(cids);
    await channelQueryDao.updateChannelQueriesByPredefinedFilter(
      filterName,
      cids,
      filter: filter,
      sort: sort,
      filterValues: filterValues,
      sortValues: sortValues,
    );

    final (cachedChannels, storedFilter, storedSort) =
        await channelQueryDao.getChannelsAndSpecByPredefinedFilter(
      filterName,
      filterValues: filterValues,
      sortValues: sortValues,
    );

    expect(cachedChannels.map((c) => c.cid).toSet(), cids.toSet());
    expect(storedFilter, isNotNull);
    expect(storedFilter!.toJson(), filter.toJson());
    expect(storedSort, isNotNull);
    expect(storedSort!.length, 2);
    expect(storedSort.first.field, ChannelSortKey.pinnedAt);
    expect(storedSort.first.direction, SortOption.DESC);
    expect(storedSort.last.field, ChannelSortKey.lastMessageAt);
    expect(storedSort.last.direction, SortOption.DESC);
  });

  test('clear queryCache before updateChannelQueriesByPredefinedFilter',
      () async {
    const filterName = 'sample-app-list';
    const filterValues = {'user_id': 'testUserId'};
    const sortValues = {'pinned_at': true};
    const oldCids = ['oldCid1', 'oldCid2'];
    const newCids = ['newCid1'];
    final filter = Filter.equal('type', 'messaging');
    const sort = <SortOption<ChannelState>>[
      SortOption<ChannelState>.desc(ChannelSortKey.pinnedAt),
      SortOption<ChannelState>.desc(ChannelSortKey.lastMessageAt),
    ];

    await _insertChannelsForCids([...oldCids, ...newCids]);
    await channelQueryDao.updateChannelQueriesByPredefinedFilter(
      filterName,
      oldCids,
      filter: filter,
      sort: sort,
      filterValues: filterValues,
      sortValues: sortValues,
    );
    await channelQueryDao.updateChannelQueriesByPredefinedFilter(
      filterName,
      newCids,
      filter: filter,
      sort: sort,
      filterValues: filterValues,
      sortValues: sortValues,
      clearQueryCache: true,
    );

    final (cachedChannels, storedFilter, storedSort) =
        await channelQueryDao.getChannelsAndSpecByPredefinedFilter(
      filterName,
      filterValues: filterValues,
      sortValues: sortValues,
    );

    expect(cachedChannels.map((c) => c.cid).toSet(), newCids.toSet());
    expect(storedFilter, isNotNull);
    expect(storedFilter!.toJson(), filter.toJson());
    expect(storedSort, isNotNull);
    expect(storedSort!.length, 2);
    expect(storedSort.first.field, ChannelSortKey.pinnedAt);
    expect(storedSort.first.direction, SortOption.DESC);
    expect(storedSort.last.field, ChannelSortKey.lastMessageAt);
    expect(storedSort.last.direction, SortOption.DESC);
  });

  tearDown(() async {
    await database.disconnect();
  });
}
