// ignore_for_file: join_return_with_assignment

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/locations.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'location_dao.g.dart';

/// The Data Access Object for operations in [Locations] table.
@DriftAccessor(tables: [Locations])
class LocationDao extends DatabaseAccessor<DriftChatDatabase> with _$LocationDaoMixin {
  /// Creates a new location dao instance
  LocationDao(this._db) : super(_db);

  final DriftChatDatabase _db;

  Future<Location> _locationFromEntity(LocationEntity entity) async {
    // We do not want to fetch the location of the parent and quoted
    // message because it will create a circular dependency and will
    // result in infinite loop.
    const fetchDraft = false;
    const fetchSharedLocation = false;

    final channel = await switch (entity.channelCid) {
      final cid? => db.channelDao.getChannelByCid(cid),
      _ => null,
    };

    final message = await switch (entity.messageId) {
      final id? => _db.messageDao.getMessageById(
        id,
        fetchDraft: fetchDraft,
        fetchSharedLocation: fetchSharedLocation,
      ),
      _ => null,
    };

    return entity.toLocation(
      channel: channel,
      message: message,
    );
  }

  /// Get all locations for a channel
  Future<List<Location>> getLocationsByCid(String cid) async {
    final query = select(locations)..where((tbl) => tbl.channelCid.equals(cid));

    final result = await query.map(_locationFromEntity).get();
    return Future.wait(result);
  }

  /// Get location by message ID
  Future<Location?> getLocationByMessageId(String messageId) async {
    final query =
        select(locations) //
          ..where((tbl) => tbl.messageId.equals(messageId));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return _locationFromEntity(result);
  }

  /// Update multiple locations
  Future<void> updateLocations(List<Location> locationList) {
    return batch(
      (it) => it.insertAllOnConflictUpdate(
        locations,
        locationList.map((it) => it.toEntity()),
      ),
    );
  }

  /// Delete locations by channel ID
  Future<void> deleteLocationsByCid(String cid) => (delete(locations)..where((tbl) => tbl.channelCid.equals(cid))).go();

  /// Delete locations by message IDs
  Future<void> deleteLocationsByMessageIds(List<String> messageIds) =>
      (delete(locations)..where((tbl) => tbl.messageId.isIn(messageIds))).go();
}
