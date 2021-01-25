import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/channels.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import '../mapper/mapper.dart';

part 'channel_dao.g.dart';

///
@UseDao(tables: [Channels, Users])
class ChannelDao extends DatabaseAccessor<MoorChatDatabase>
    with _$ChannelDaoMixin {
  ///
  ChannelDao(MoorChatDatabase db) : super(db);

  /// Get channel by cid
  Future<ChannelModel> getChannelByCid(String cid) async {
    return (select(channels)..where((c) => c.cid.equals(cid))).join([
      leftOuterJoin(users, channels.createdById.equalsExp(users.id)),
    ]).map((rows) {
      final channel = rows.readTable(channels);
      final createdBy = rows.readTable(users);
      return channel.toChannelModel(createdBy: createdBy?.toUser());
    }).getSingle();
  }

  /// Delete all channels by matching cid in [cids]
  ///
  /// This will automatically delete the following linked records
  /// 1. Channel Reads
  /// 2. Channel Members
  /// 3. Channel Messages -> Messages Reactions
  Future<void> deleteChannelByCids(List<String> cids) async {
    return (delete(channels)..where((tbl) => tbl.cid.isIn(cids))).go();
  }

  /// Get the channel cids saved in the storage
  Future<List<String>> get cids {
    return (select(channels)
          ..orderBy([(c) => OrderingTerm.desc(c.lastMessageAt)])
          ..limit(250))
        .map((c) => c.cid)
        .get();
  }

  ///
  Future<void> updateChannels(List<ChannelModel> channelList) {
    return batch(
      (it) => it.insertAll(
        channels,
        channelList.map((c) => c.toEntity()).toList(),
        mode: InsertMode.insertOrReplace,
      ),
    );
  }
}
