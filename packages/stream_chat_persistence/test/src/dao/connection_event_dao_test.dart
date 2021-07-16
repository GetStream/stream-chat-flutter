import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/connection_event_dao.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:test/test.dart';

import '../../stream_chat_persistence_client_test.dart';
import '../utils/date_matcher.dart';

void main() {
  late ConnectionEventDao eventDao;
  late MoorChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    eventDao = database.connectionEventDao;
  });

  test('connectionEvent', () async {
    // Should be null initially
    final event = await eventDao.connectionEvent;
    expect(event, isNull);

    // Adding a new event
    final newEvent = Event(
      createdAt: DateTime.now(),
      totalUnreadCount: 33,
      unreadChannels: 3,
      me: OwnUser(id: 'testUserId'),
    );
    await eventDao.updateConnectionEvent(newEvent);

    // Should match the added event
    final updatedEvent = await eventDao.connectionEvent;
    expect(updatedEvent, isNotNull);
    expect(updatedEvent!.me!.id, newEvent.me!.id);
    expect(updatedEvent.totalUnreadCount, newEvent.totalUnreadCount);
    expect(updatedEvent.unreadChannels, newEvent.unreadChannels);
  });

  test('lastSyncAt', () async {
    // Should be null initially
    final lastSyncAt = await eventDao.lastSyncAt;
    expect(lastSyncAt, isNull);

    // Adding an event for testing
    final event = Event(
      createdAt: DateTime.now(),
      totalUnreadCount: 33,
      unreadChannels: 3,
      me: OwnUser(id: 'testUserId'),
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
    final event = Event(
      createdAt: DateTime.now(),
      totalUnreadCount: 33,
      unreadChannels: 3,
      me: OwnUser(id: 'testUserId'),
    );
    await eventDao.updateConnectionEvent(event);

    // Should match the previously added event
    final fetchedEvent = await eventDao.connectionEvent;
    expect(fetchedEvent, isNotNull);
    expect(fetchedEvent!.me!.id, event.me!.id);
    expect(fetchedEvent.totalUnreadCount, event.totalUnreadCount);
    expect(fetchedEvent.unreadChannels, event.unreadChannels);

    // Updating the added event
    final newEvent = event.copyWith(unreadChannels: 4);
    await eventDao.updateConnectionEvent(newEvent);

    // Should match the updated event
    final fetchedNewEvent = await eventDao.connectionEvent;
    expect(fetchedNewEvent, isNotNull);
    expect(fetchedNewEvent!.me!.id, event.me!.id);
    expect(fetchedNewEvent.totalUnreadCount, event.totalUnreadCount);
    expect(fetchedNewEvent.unreadChannels, newEvent.unreadChannels);
  });

  test('updateLastSyncAt', () async {
    // Should be null initially
    final lastSyncAt = await eventDao.lastSyncAt;
    expect(lastSyncAt, isNull);

    // Adding an event just for testing
    final event = Event(
      createdAt: DateTime.now(),
      totalUnreadCount: 33,
      unreadChannels: 3,
      me: OwnUser(id: 'testUserId'),
    );
    await eventDao.updateConnectionEvent(event);

    // Updating it's last sync
    final now = DateTime.now();
    await eventDao.updateLastSyncAt(now);

    // Should match the last sync
    final updatedLastSyncAt = await eventDao.lastSyncAt;
    expect(updatedLastSyncAt, isSameDateAs(now));
  });

  tearDown(() async {
    await database.disconnect();
  });
}
