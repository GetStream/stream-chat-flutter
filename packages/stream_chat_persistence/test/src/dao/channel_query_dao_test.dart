import 'dart:math' as math;

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/channel_query_dao.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:test/test.dart';

void main() {
  MoorChatDatabase database;
  ChannelQueryDao channelQueryDao;

  setUp(() {
    database = MoorChatDatabase.testable('testUserId');
    channelQueryDao = database.channelQueryDao;
  });

  test('updateChannelQueries', () async {
    const filter = {
      'members': {
        r'$in': ['testUserId'],
      },
    };

    const cids = ['testCid1', 'testCid2', 'testCid3'];

    final cachedCids = await channelQueryDao.getCachedChannelCids(filter);
    expect(cachedCids, []);

    // Updating channel queries
    await channelQueryDao.updateChannelQueries(filter, cids);

    final updatedCids = await channelQueryDao.getCachedChannelCids(filter);
    expect(updatedCids, cids);
  });

  test('getCachedChannelCids', () async {
    const filter = {
      'members': {
        r'$in': ['testUserId'],
      },
    };

    const cids = ['testCid1', 'testCid2', 'testCid3'];

    final cachedCids = await channelQueryDao.getCachedChannelCids(filter);
    expect(cachedCids, []);

    // Updating channel queries
    await channelQueryDao.updateChannelQueries(filter, cids);

    final updatedCids = await channelQueryDao.getCachedChannelCids(filter);
    expect(updatedCids, cids);
  });

  Future<List<ChannelModel>> _insertTestDataForGetChannel(
      Map<String, Object> filter) async {
    final now = DateTime.now();
    final userDao = database.userDao;
    final channelDao = database.channelDao;

    const cids = ['testCid0', 'testCid1', 'testCid2'];
    final users = List.generate(3, (index) => User(id: 'testId$index'));
    final channels = List.generate(
      3,
      (index) => ChannelModel(
        id: 'testId$index',
        type: 'testType$index',
        cid: cids[index],
        createdBy: users[index],
        config: ChannelConfig(),
        extraData: {'test_custom_field': math.Random().nextInt(100)},
        createdAt: now,
        memberCount: math.Random().nextInt(100),
        lastMessageAt: now.add(Duration(hours: index)),
      ),
    ).reversed.toList(growable: false);

    await userDao.updateUsers(users);
    await channelDao.updateChannels(channels);
    await channelQueryDao.updateChannelQueries(filter, cids);

    return channels;
  }

  group('getChannels', () {
    const filter = {
      'members': {
        r'$in': ['testUserId'],
      },
    };

    test('should return empty list of channels', () async {
      final channels = await channelQueryDao.getChannels(filter: filter);
      expect(channels, []);
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
          updatedChannel.createdAt.hour,
          insertedChannel.createdAt.hour,
        );
        expect(
          updatedChannel.createdAt.minute,
          insertedChannel.createdAt.minute,
        );
        expect(
          updatedChannel.createdAt.second,
          insertedChannel.createdAt.second,
        );

        // Should match lastMessageAt date
        expect(
          updatedChannel.lastMessageAt.hour,
          insertedChannel.lastMessageAt.hour,
        );
        expect(
          updatedChannel.lastMessageAt.minute,
          insertedChannel.lastMessageAt.minute,
        );
        expect(
          updatedChannel.lastMessageAt.second,
          insertedChannel.lastMessageAt.second,
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
        sort: [SortOption('member_count', comparator: sortComparator)],
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
          updatedChannel.createdAt.hour,
          insertedChannel.createdAt.hour,
        );
        expect(
          updatedChannel.createdAt.minute,
          insertedChannel.createdAt.minute,
        );
        expect(
          updatedChannel.createdAt.second,
          insertedChannel.createdAt.second,
        );

        // Should match lastMessageAt date
        expect(
          updatedChannel.lastMessageAt.hour,
          insertedChannel.lastMessageAt.hour,
        );
        expect(
          updatedChannel.lastMessageAt.minute,
          insertedChannel.lastMessageAt.minute,
        );
        expect(
          updatedChannel.lastMessageAt.second,
          insertedChannel.lastMessageAt.second,
        );
      }
    });

    test('should throw if comparator is not provided in sort list', () {
      expect(
        () => channelQueryDao.getChannels(
          sort: [const SortOption('test_custom_field')],
        ),
        throwsArgumentError,
      );
    });

    test('should return sorted channels using custom field', () async {
      int sortComparator(ChannelModel a, ChannelModel b) {
        final aData = a.extraData['test_custom_field'] as int;
        final bData = b.extraData['test_custom_field'] as int;
        return bData.compareTo(aData);
      }

      // Inserting test data for get channels
      final insertedChannels = await _insertTestDataForGetChannel(filter);
      insertedChannels.sort(sortComparator);

      // Should match with the inserted channels
      final updatedChannels = await channelQueryDao.getChannels(
        filter: filter,
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
          updatedChannel.createdAt.hour,
          insertedChannel.createdAt.hour,
        );
        expect(
          updatedChannel.createdAt.minute,
          insertedChannel.createdAt.minute,
        );
        expect(
          updatedChannel.createdAt.second,
          insertedChannel.createdAt.second,
        );

        // Should match lastMessageAt date
        expect(
          updatedChannel.lastMessageAt.hour,
          insertedChannel.lastMessageAt.hour,
        );
        expect(
          updatedChannel.lastMessageAt.minute,
          insertedChannel.lastMessageAt.minute,
        );
        expect(
          updatedChannel.lastMessageAt.second,
          insertedChannel.lastMessageAt.second,
        );
      }
    });
  });

  tearDown(() async {
    await database.disconnect();
  });
}
