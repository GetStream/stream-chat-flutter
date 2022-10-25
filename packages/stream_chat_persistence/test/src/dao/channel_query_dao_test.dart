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
        extraData: {'test_custom_field': index + 3},
        createdAt: now,
        memberCount: index + 3,
        lastMessageAt: now.add(Duration(hours: index)),
      ),
    ).reversed.toList(growable: false);

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

        // Should match createdAt date
        expect(
          updatedChannel.createdAt,
          isSameDateAs(insertedChannel.createdAt),
        );

        // Should match lastMessageAt date
        expect(
          updatedChannel.lastMessageAt,
          isSameDateAs(insertedChannel.lastMessageAt!),
        );
      }
    });

    test('should return sorted channels using member count', () async {
      int sortComparator(ChannelModel a, ChannelModel b) =>
          b.memberCount.compareTo(a.memberCount);

      // Inserting test data for get channels
      final insertedChannels = await _insertTestDataForGetChannel(filter);
      insertedChannels.sort(sortComparator);

      // Should match with the inserted channels
      final updatedChannels = await channelQueryDao.getChannels(
        filter: filter,
        // ignore: deprecated_member_use_from_same_package
        sort: [
          SortOption(
            'member_count',
            comparator: sortComparator,
          )
        ],
      );

      expect(updatedChannels.length, insertedChannels.length);
      for (var i = 0; i < updatedChannels.length; i++) {
        final updatedChannel = updatedChannels[i];
        final insertedChannel = insertedChannels[i];

        // Should match all the basic details
        expect(updatedChannel.id, insertedChannel.id);
        expect(updatedChannel.type, insertedChannel.type);
        expect(updatedChannel.cid, insertedChannel.cid);
        expect(updatedChannel.memberCount, insertedChannel.memberCount);

        // Should match createdAt date
        expect(
          updatedChannel.createdAt,
          isSameDateAs(insertedChannel.createdAt),
        );

        // Should match lastMessageAt date
        expect(
          updatedChannel.lastMessageAt,
          isSameDateAs(insertedChannel.lastMessageAt!),
        );
      }
    });

    test('should return sorted channels using custom field', () async {
      int sortComparator(ChannelModel a, ChannelModel b) {
        final aData = int.parse(a.extraData['test_custom_field'].toString());
        final bData = int.parse(b.extraData['test_custom_field'].toString());
        return bData.compareTo(aData);
      }

      // Inserting test data for get channels
      final insertedChannels = await _insertTestDataForGetChannel(filter);
      insertedChannels.sort(sortComparator);

      // Should match with the inserted channels
      final updatedChannels = await channelQueryDao.getChannels(
        filter: filter,
        // ignore: deprecated_member_use_from_same_package
        sort: [SortOption('test_custom_field', comparator: sortComparator)],
      );

      expect(updatedChannels.length, insertedChannels.length);
      for (var i = 0; i < updatedChannels.length; i++) {
        final updatedChannel = updatedChannels[i];
        final insertedChannel = insertedChannels[i];

        // Should match all the basic details
        expect(updatedChannel.id, insertedChannel.id);
        expect(updatedChannel.type, insertedChannel.type);
        expect(updatedChannel.cid, insertedChannel.cid);
        expect(updatedChannel.memberCount, insertedChannel.memberCount);

        // Should match createdAt date
        expect(
          updatedChannel.createdAt,
          isSameDateAs(insertedChannel.createdAt),
        );

        // Should match lastMessageAt date
        expect(
          updatedChannel.lastMessageAt,
          isSameDateAs(insertedChannel.lastMessageAt!),
        );
      }
    });
  });

  tearDown(() async {
    await database.disconnect();
  });
}
