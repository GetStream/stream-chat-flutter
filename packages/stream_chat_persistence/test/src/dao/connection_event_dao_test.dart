import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/connection_event_dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';
import '../utils/date_matcher.dart';

void main() {
  late ConnectionEventDao eventDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    eventDao = database.connectionEventDao;
  });

  test('connectedUser is null before any connection is stored', () async {
    expect(await eventDao.connectedUser, isNull);
  });

  test('connectedUser returns the user of the stored hello', () async {
    final newEvent = HealthCheckEvent(
      connectionId: 'test-connection-id',
      createdAt: DateTime.now(),
      me: OwnUser(id: 'testUserId', totalUnreadCount: 33, unreadChannels: 3),
    );
    await eventDao.updateConnectionEvent(newEvent);

    final updatedUser = await eventDao.connectedUser;
    expect(updatedUser, isNotNull);
    expect(updatedUser!.id, newEvent.me.id);
    expect(updatedUser.totalUnreadCount, newEvent.me.totalUnreadCount);
    expect(updatedUser.unreadChannels, newEvent.me.unreadChannels);
  });

  test('lastSyncAt', () async {
    // Should be null initially
    final lastSyncAt = await eventDao.lastSyncAt;
    expect(lastSyncAt, isNull);

    // Adding an event for testing
    final event = HealthCheckEvent(
      connectionId: 'test-connection-id',
      createdAt: DateTime.now(),
      me: OwnUser(id: 'testUserId', totalUnreadCount: 33, unreadChannels: 3),
    );
    await eventDao.updateConnectionEvent(event);

    // Updating it's last sync
    final now = DateTime.now();
    await eventDao.updateLastSyncAt(now);

    // Should match the updated last sync
    final updatedLastSyncAt = await eventDao.lastSyncAt;
    expect(updatedLastSyncAt, isSameDateAs(now));
  });

  test('updateConnectionEvent', () async {
    // Adding and event for testing
    final event = HealthCheckEvent(
      connectionId: 'test-connection-id',
      createdAt: DateTime.now(),
      me: OwnUser(id: 'testUserId', totalUnreadCount: 33, unreadChannels: 3),
    );
    await eventDao.updateConnectionEvent(event);

    // Should match the user of the previously added event
    final fetchedUser = await eventDao.connectedUser;
    expect(fetchedUser, isNotNull);
    expect(fetchedUser!.id, event.me.id);
    expect(fetchedUser.totalUnreadCount, event.me.totalUnreadCount);
    expect(fetchedUser.unreadChannels, event.me.unreadChannels);

    // Updating the added event
    final newEvent = HealthCheckEvent(
      connectionId: 'test-connection-id',
      createdAt: DateTime.now(),
      me: event.me.copyWith(unreadChannels: 4),
    );
    await eventDao.updateConnectionEvent(newEvent);

    // Should match the user of the updated event
    final fetchedNewUser = await eventDao.connectedUser;
    expect(fetchedNewUser, isNotNull);
    expect(fetchedNewUser!.id, event.me.id);
    expect(fetchedNewUser.totalUnreadCount, event.me.totalUnreadCount);
    expect(fetchedNewUser.unreadChannels, newEvent.me.unreadChannels);
  });

  test('updateLastSyncAt', () async {
    // Should be null initially
    final lastSyncAt = await eventDao.lastSyncAt;
    expect(lastSyncAt, isNull);

    // Adding an event just for testing
    final event = HealthCheckEvent(
      connectionId: 'test-connection-id',
      createdAt: DateTime.now(),
      me: OwnUser(id: 'testUserId', totalUnreadCount: 33, unreadChannels: 3),
    );
    await eventDao.updateConnectionEvent(event);

    // Updating it's last sync
    final now = DateTime.now();
    await eventDao.updateLastSyncAt(now);

    // Should match the last sync
    final updatedLastSyncAt = await eventDao.lastSyncAt;
    expect(updatedLastSyncAt, isSameDateAs(now));
  });

  test('updateLastSyncAt preserves millisecond precision', () async {
    final preciseDate = DateTime.utc(2026, 5, 28, 12, 34, 56, 123);
    await eventDao.updateLastSyncAt(preciseDate);

    final readBack = await eventDao.lastSyncAt;
    expect(readBack, equals(preciseDate));
    expect(readBack!.millisecond, equals(123));
  });

  test('updateLastSyncAt stores the checkpoint after the database was reset', () async {
    await eventDao.updateConnectionEvent(
      HealthCheckEvent(
        connectionId: 'test-connection-id',
        me: OwnUser(id: 'testUserId'),
      ),
    );

    await database.flush();

    final afterReset = DateTime.utc(2026, 5, 28, 12);
    await eventDao.updateLastSyncAt(afterReset);

    expect(await eventDao.lastSyncAt, equals(afterReset));
  });

  test('updateLastSyncAt keeps the stored connected user', () async {
    final event = HealthCheckEvent(
      connectionId: 'test-connection-id',
      createdAt: DateTime.now(),
      me: OwnUser(id: 'testUserId', totalUnreadCount: 33, unreadChannels: 3),
    );
    await eventDao.updateConnectionEvent(event);

    await eventDao.updateLastSyncAt(DateTime.now());

    final storedUser = await eventDao.connectedUser;
    expect(storedUser, isNotNull);
    expect(storedUser!.id, event.me.id);
    expect(storedUser.totalUnreadCount, event.me.totalUnreadCount);
    expect(storedUser.unreadChannels, event.me.unreadChannels);
  });

  test('a checkpoint written on its own is not read back as a connected user', () async {
    await eventDao.updateLastSyncAt(DateTime.now());

    expect(await eventDao.connectedUser, isNull);
  });

  tearDown(() async {
    await database.disconnect();
  });
}
