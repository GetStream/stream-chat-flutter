import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/channel_queries.dart';
import 'package:stream_chat_persistence/src/entity/channels.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import '../mapper/mapper.dart';

part 'channel_query_dao.g.dart';

/// The Data Access Object for operations in [ChannelQueries] table.
@UseDao(tables: [ChannelQueries, Channels, Users])
class ChannelQueryDao extends DatabaseAccessor<MoorChatDatabase>
    with _$ChannelQueryDaoMixin {
  /// Creates a new channel query dao instance
  ChannelQueryDao(this._db) : super(_db);

  final MoorChatDatabase _db;

  String _computeHash(Map<String, dynamic> filter) {
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
    Map<String, dynamic> filter,
    List<String> cids,
    bool clearQueryCache,
  ) async {
    final hash = _computeHash(filter);
    if (clearQueryCache) {
      await (delete(channelQueries)
            ..where((query) => query.queryHash.equals(hash)))
          .go();
    }

    return batch((batch) {
      batch.insertAll(
        channelQueries,
        cids.map((cid) {
          return ChannelQueryEntity(
            queryHash: hash,
            channelCid: cid,
          );
        }).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  /// Get list of channels by filter, sort and paginationParams
  Future<List<ChannelState>> getChannelStates({
    Map<String, dynamic> filter,
    List<SortOption> sort = const [],
    PaginationParams paginationParams,
  }) async {
    final hash = _computeHash(filter);
    final cachedChannels = await Future.wait(await (select(channelQueries)
          ..where((c) => c.queryHash.equals(hash)))
        .get()
        .then((channelQueries) {
      final cids = channelQueries.map((c) => c.channelCid).toList();
      final query = select(channels)..where((c) => c.cid.isIn(cids));

      sort = sort
          ?.where((s) => ChannelModel.topLevelFields.contains(s.field))
          ?.toList();

      if (sort != null && sort.isNotEmpty) {
        query.orderBy(sort.map((s) {
          final orderExpression = CustomExpression('channels.${s.field}');
          return (c) => OrderingTerm(
                expression: orderExpression,
                mode: s.direction == 1 ? OrderingMode.asc : OrderingMode.desc,
              );
        }).toList());
      }

      if (paginationParams != null) {
        query.limit(
          paginationParams.limit ?? 10,
          offset: paginationParams.offset,
        );
      }

      return query.join([
        leftOuterJoin(users, channels.createdById.equalsExp(users.id)),
      ]).map((row) async {
        final userEntity = row.readTable(users);
        final channelEntity = row.readTable(channels);

        final cid = channelEntity.cid;
        final members = await _db.memberDao.getMembersByCid(cid);
        final reads = await _db.readDao.getReadsByCid(cid);
        final messages = await _db.messageDao.getMessagesByCid(cid);
        final pinnedMessages = await _db.pinnedMessageDao.getMessagesByCid(cid);

        return channelEntity.toChannelState(
          createdBy: userEntity?.toUser(),
          members: members,
          reads: reads,
          messages: messages,
          pinnedMessages: pinnedMessages,
        );
      }).get();
    }));

    if (sort?.isEmpty != false && cachedChannels?.isNotEmpty == true) {
      cachedChannels
          .sort((a, b) => b.channel.updatedAt.compareTo(a.channel.updatedAt));
      cachedChannels.sort((a, b) {
        final dateA = a.channel.lastMessageAt ?? a.channel.createdAt;
        final dateB = b.channel.lastMessageAt ?? b.channel.createdAt;
        return dateB.compareTo(dateA);
      });
    }

    return cachedChannels;
  }
}
