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
  ChannelQueryDao(MoorChatDatabase db) : super(db);

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
      await batch((it) {
        it.deleteWhere<ChannelQueries, ChannelQueryEntity>(
          channelQueries,
          (c) => c.queryHash.equals(hash),
        );
      });
    }

    return batch((it) {
      it.insertAll(
        channelQueries,
        cids.map((cid) {
          return ChannelQueryEntity(queryHash: hash, channelCid: cid);
        }).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  /// Get list of channels by filter, sort and paginationParams
  Future<List<ChannelModel>> getChannels({
    Map<String, dynamic> filter,
    List<SortOption<ChannelModel>> sort = const [],
    PaginationParams paginationParams,
  }) async {
    assert(() {
      if (sort != null && sort.any((it) => it.comparator == null)) {
        throw ArgumentError(
          'SortOption requires a comparator in order to sort',
        );
      }
      return true;
    }());

    final hash = _computeHash(filter);
    final cachedChannelCids = await (select(channelQueries)
          ..where((c) => c.queryHash.equals(hash)))
        .map((c) => c.channelCid)
        .get();

    final query = select(channels)..where((c) => c.cid.isIn(cachedChannelCids));

    final cachedChannels = await (query.join([
      leftOuterJoin(users, channels.createdById.equalsExp(users.id)),
    ]).map((row) {
      final createdByEntity = row.readTable(users);
      final channelEntity = row.readTable(channels);
      return channelEntity.toChannelModel(createdBy: createdByEntity?.toUser());
    })).get();

    final possibleSortingFields = cachedChannels.fold<List<String>>(
        ChannelModel.topLevelFields, (previousValue, element) {
      return {...previousValue, ...element.extraData.keys}.toList();
    });

    sort = sort
        ?.where((s) => possibleSortingFields.contains(s.field))
        ?.toList(growable: false);

    var chainedComparator = (a, b) {
      final dateA = a.lastMessageAt ?? a.createdAt;
      final dateB = b.lastMessageAt ?? b.createdAt;
      return dateB.compareTo(dateA);
    };

    if (sort != null && sort.isNotEmpty) {
      chainedComparator = (a, b) {
        int result;
        for (final comparator in sort.map((it) => it.comparator)) {
          try {
            result = comparator(a, b);
          } catch (e) {
            result = 0;
          }
          if (result != 0) return result;
        }
        return 0;
      };
    }

    cachedChannels.sort(chainedComparator);

    if (paginationParams?.offset != null) {
      cachedChannels.removeRange(0, paginationParams.offset);
    }

    if (paginationParams?.limit != null) {
      return cachedChannels.take(paginationParams.limit).toList();
    }

    return cachedChannels;
  }
}
