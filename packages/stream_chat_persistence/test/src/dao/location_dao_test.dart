// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late LocationDao locationDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    locationDao = database.locationDao;
  });

  Future<List<Location>> _prepareLocationData({
    required String cid,
    int count = 3,
  }) async {
    final channels = [ChannelModel(cid: cid)];
    final users = List.generate(count, (index) => User(id: 'testUserId$index'));
    final messages = List.generate(
      count,
      (index) => Message(
        id: 'testMessageId$cid$index',
        type: 'testType',
        user: users[index],
        createdAt: DateTime.now(),
        text: 'Test message #$index',
      ),
    );

    final locations = List.generate(
      count,
      (index) => Location(
        channelCid: cid,
        messageId: messages[index].id,
        userId: users[index].id,
        latitude: 37.7749 + index * 0.001, // San Francisco area
        longitude: -122.4194 + index * 0.001,
        createdByDeviceId: 'testDevice$index',
        endAt: index.isEven ? DateTime.now().add(const Duration(hours: 1)) : null, // Some live, some static
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await database.userDao.updateUsers(users);
    await database.channelDao.updateChannels(channels);
    await database.messageDao.updateMessages(cid, messages);
    await locationDao.updateLocations(locations);

    return locations;
  }

  test('getLocationsByCid', () async {
    const cid = 'test:Cid';

    // Should be empty initially
    final locations = await locationDao.getLocationsByCid(cid);
    expect(locations, isEmpty);

    // Adding sample locations
    final insertedLocations = await _prepareLocationData(cid: cid);
    expect(insertedLocations, isNotEmpty);

    // Fetched locations length should match inserted locations length
    final fetchedLocations = await locationDao.getLocationsByCid(cid);
    expect(fetchedLocations.length, insertedLocations.length);

    // Every location channelCid should match the provided cid
    expect(fetchedLocations.every((it) => it.channelCid == cid), true);
  });

  test('updateLocations', () async {
    const cid = 'test:Cid';

    // Preparing test data
    final insertedLocations = await _prepareLocationData(cid: cid);

    // Adding a new location
    final newUser = User(id: 'newUserId');
    final newMessage = Message(
      id: 'newMessageId',
      type: 'testType',
      user: newUser,
      createdAt: DateTime.now(),
      text: 'New test message',
    );
    final newLocation = Location(
      channelCid: cid,
      messageId: newMessage.id,
      userId: newUser.id,
      latitude: 40.7128, // New York
      longitude: -74.0060,
      createdByDeviceId: 'newDevice',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await database.userDao.updateUsers([newUser]);
    await database.messageDao.updateMessages(cid, [newMessage]);
    await locationDao.updateLocations([newLocation]);

    // Fetched locations length should be one more than inserted locations
    // Fetched locations should contain the newLocation
    final fetchedLocations = await locationDao.getLocationsByCid(cid);
    expect(fetchedLocations.length, insertedLocations.length + 1);
    expect(
      fetchedLocations.any(
        (it) =>
            it.messageId == newLocation.messageId &&
            it.latitude == newLocation.latitude &&
            it.longitude == newLocation.longitude,
      ),
      isTrue,
    );
  });

  test('getLocationByMessageId', () async {
    const cid = 'test:Cid';

    // Preparing test data
    final insertedLocations = await _prepareLocationData(cid: cid);

    // Fetched location should not be null
    final locationToFetch = insertedLocations.first;
    final fetchedLocation = await locationDao.getLocationByMessageId(locationToFetch.messageId!);
    expect(fetchedLocation, isNotNull);
    expect(fetchedLocation!.messageId, locationToFetch.messageId);
    expect(fetchedLocation.latitude, locationToFetch.latitude);
    expect(fetchedLocation.longitude, locationToFetch.longitude);
  });

  test(
    'getLocationByMessageId should return null for non-existent messageId',
    () async {
      // Should return null for non-existent messageId
      final fetchedLocation = await locationDao.getLocationByMessageId('nonExistentMessageId');
      expect(fetchedLocation, isNull);
    },
  );

  test('deleteLocationsByCid', () async {
    const cid = 'test:Cid';

    // Preparing test data
    final insertedLocations = await _prepareLocationData(cid: cid);

    // Verify locations exist
    final locationsBeforeDelete = await locationDao.getLocationsByCid(cid);
    expect(locationsBeforeDelete.length, insertedLocations.length);

    // Deleting all locations for the channel
    await locationDao.deleteLocationsByCid(cid);

    // Fetched location list should be empty
    final fetchedLocations = await locationDao.getLocationsByCid(cid);
    expect(fetchedLocations, isEmpty);
  });

  test('deleteLocationsByMessageIds', () async {
    const cid = 'test:Cid';

    // Preparing test data
    final insertedLocations = await _prepareLocationData(cid: cid);

    // Deleting the first two locations by their message IDs
    final messageIdsToDelete = insertedLocations.take(2).map((it) => it.messageId!).toList();
    await locationDao.deleteLocationsByMessageIds(messageIdsToDelete);

    // Fetched location list should be one less than inserted locations
    final fetchedLocations = await locationDao.getLocationsByCid(cid);
    expect(fetchedLocations.length, insertedLocations.length - messageIdsToDelete.length);

    // Deleted locations should not exist in fetched locations
    expect(
      fetchedLocations.any((it) => messageIdsToDelete.contains(it.messageId)),
      isFalse,
    );
  });

  group('deleteLocationsByMessageIds', () {
    test('should delete locations for specific message IDs only', () async {
      const cid1 = 'test:Cid1';
      const cid2 = 'test:Cid2';

      // Preparing test data for two channels
      final insertedLocations1 = await _prepareLocationData(cid: cid1, count: 2);
      final insertedLocations2 = await _prepareLocationData(cid: cid2, count: 2);

      // Verify all locations exist
      final locations1 = await locationDao.getLocationsByCid(cid1);
      final locations2 = await locationDao.getLocationsByCid(cid2);
      expect(locations1.length, insertedLocations1.length);
      expect(locations2.length, insertedLocations2.length);

      // Delete only locations from the first channel
      final messageIdsToDelete = insertedLocations1.map((it) => it.messageId!).toList();
      await locationDao.deleteLocationsByMessageIds(messageIdsToDelete);

      // Only locations from cid1 should be deleted
      final fetchedLocations1 = await locationDao.getLocationsByCid(cid1);
      final fetchedLocations2 = await locationDao.getLocationsByCid(cid2);
      expect(fetchedLocations1, isEmpty);
      expect(fetchedLocations2.length, insertedLocations2.length);
    });
  });

  group('Location entity references', () {
    test(
      'should delete locations when referenced channel is deleted',
      () async {
        const cid = 'test:channelRefCascade';

        // Prepare test data
        await _prepareLocationData(cid: cid, count: 2);

        // Verify locations exist before channel deletion
        final locationsBeforeDelete = await locationDao.getLocationsByCid(cid);
        expect(locationsBeforeDelete, isNotEmpty);
        expect(locationsBeforeDelete.length, 2);

        // Delete the channel
        await database.channelDao.deleteChannelByCids([cid]);

        // Verify locations have been deleted (cascade)
        final locationsAfterDelete = await locationDao.getLocationsByCid(cid);
        expect(locationsAfterDelete, isEmpty);
      },
    );

    test(
      'should delete locations when referenced message is deleted',
      () async {
        const cid = 'test:messageRefCascade';

        // Prepare test data
        final insertedLocations = await _prepareLocationData(cid: cid, count: 3);
        final messageToDelete = insertedLocations.first.messageId!;

        // Verify location exists before message deletion
        final locationBeforeDelete = await locationDao.getLocationByMessageId(messageToDelete);
        expect(locationBeforeDelete, isNotNull);
        expect(locationBeforeDelete!.messageId, messageToDelete);

        // Verify all locations exist
        final allLocationsBeforeDelete = await locationDao.getLocationsByCid(cid);
        expect(allLocationsBeforeDelete.length, 3);

        // Delete the message
        await database.messageDao.deleteMessageByIds([messageToDelete]);

        // Verify the specific location has been deleted (cascade)
        final locationAfterDelete = await locationDao.getLocationByMessageId(messageToDelete);
        expect(locationAfterDelete, isNull);

        // Verify other locations still exist
        final allLocationsAfterDelete = await locationDao.getLocationsByCid(cid);
        expect(allLocationsAfterDelete.length, 2);
        expect(
          allLocationsAfterDelete.any((it) => it.messageId == messageToDelete),
          isFalse,
        );
      },
    );

    test(
      'should delete all locations when multiple messages are deleted',
      () async {
        const cid = 'test:multipleMessageRefCascade';

        // Prepare test data
        final insertedLocations = await _prepareLocationData(cid: cid, count: 3);
        final messageIdsToDelete = insertedLocations.take(2).map((it) => it.messageId!).toList();

        // Verify locations exist before message deletion
        final allLocationsBeforeDelete = await locationDao.getLocationsByCid(cid);
        expect(allLocationsBeforeDelete.length, 3);

        // Delete multiple messages
        await database.messageDao.deleteMessageByIds(messageIdsToDelete);

        // Verify corresponding locations have been deleted (cascade)
        final allLocationsAfterDelete = await locationDao.getLocationsByCid(cid);
        expect(allLocationsAfterDelete.length, 1);
        expect(
          allLocationsAfterDelete.any((it) => messageIdsToDelete.contains(it.messageId)),
          isFalse,
        );
      },
    );
  });

  tearDown(() async {
    await database.disconnect();
  });
}
