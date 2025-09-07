import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/channel_queries.dart';
import 'package:stream_chat_persistence/src/entity/channels.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'channel_query_dao.g.dart';

/// The Data Access Object for operations in [ChannelQueries] table.
@DriftAccessor(tables: [ChannelQueries, Channels, Users])
class ChannelQueryDao extends DatabaseAccessor<DriftChatDatabase>
    with _$ChannelQueryDaoMixin {
  /// Creates a new channel query dao instance
  ChannelQueryDao(super.db);

  String _computeHash(Filter? filter) {
    if (filter == null) {
      return 'allchannels';
    }
    final hash = base64Encode(utf8.encode('filter: ${jsonEncode(filter)}'));
    return hash;
  }

  /// Update list of channel queries
  /// If [clearQueryCache] is true before the insert
  /// the list of matching rows will be deleted
  Future<void> updateChannelQueries(
    Filter? filter,
    List<String> cids, {
    bool clearQueryCache = false,
  }) async =>
      transaction(() async {
        final hash = _computeHash(filter);
        if (clearQueryCache) {
          await batch((it) {
            it.deleteWhere<ChannelQueries, ChannelQueryEntity>(
              channelQueries,
              (c) => c.queryHash.equals(hash),
            );
          });
        }

        await batch((it) {
          it.insertAllOnConflictUpdate(
            channelQueries,
            cids
                .map((cid) =>
                    ChannelQueryEntity(queryHash: hash, channelCid: cid))
                .toList(),
          );
        });
      });

  ///
  Future<List<String>> getCachedChannelCids(Filter? filter) {
    final hash = _computeHash(filter);
    return (select(channelQueries)..where((c) => c.queryHash.equals(hash)))
        .map((c) => c.channelCid)
        .get();
  }

  /// Get list of channels by filter, sort and paginationParams
  Future<List<ChannelModel>> getChannels({Filter? filter}) async {
    final cachedChannelCids = await getCachedChannelCids(filter);
    final query = select(channels)..where((c) => c.cid.isIn(cachedChannelCids));

    final cachedChannels = await query.join([
      leftOuterJoin(users, channels.createdById.equalsExp(users.id)),
    ]).map((row) {
      final createdByEntity = row.readTableOrNull(users);
      final channelEntity = row.readTable(channels);
      return channelEntity.toChannelModel(createdBy: createdByEntity?.toUser());
    }).get();

    return cachedChannels;
  }
}
