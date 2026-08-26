import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import '../db/drift_chat_database.dart';
import '../entity/channels.dart';
import '../entity/users.dart';
import '../mapper/mapper.dart';

part 'channel_dao.g.dart';

/// The Data Access Object for operations in [Channels] table.
@DriftAccessor(tables: [Channels, Users])
class ChannelDao extends DatabaseAccessor<DriftChatDatabase> with _$ChannelDaoMixin {
  /// Creates a new channel dao instance
  ChannelDao(super.db);

  /// Get channel by cid
  Future<ChannelModel?> getChannelByCid(String cid) async => (select(channels)..where((c) => c.cid.equals(cid)))
      .join([
        leftOuterJoin(users, channels.createdById.equalsExp(users.id)),
      ])
      .map((rows) {
        final channel = rows.readTable(channels);
        final createdBy = rows.readTableOrNull(users);
        return channel.toChannelModel(createdBy: createdBy?.toUser());
      })
      .getSingleOrNull();

  /// Delete all channels by matching cid in [cids]
  ///
  /// This will automatically delete the following linked records
  /// 1. Channel Reads
  /// 2. Channel Members
  /// 3. Channel Messages -> Messages Reactions
  Future<int> deleteChannelByCids(List<String> cids) async =>
      (delete(channels)..where((tbl) => tbl.cid.isIn(cids))).go();

  /// Get the channel cids saved in the storage, capped at the 250 most
  /// recently active channels.
  Future<List<String>> get cids =>
      (select(channels)
            ..orderBy([(c) => OrderingTerm.desc(_lastUpdatedAt(c))])
            ..limit(250))
          .map((c) => c.cid)
          .get();

  // The later of `lastMessageAt` and `createdAt`, mirroring
  // `ChannelModel.lastUpdatedAt`. Truncating a channel moves `lastMessageAt`
  // back instead of clearing it, so ordering on that column alone would rank a
  // truncated channel as the stalest row and drop it from the cap first.
  Expression<DateTime> _lastUpdatedAt($ChannelsTable c) => CaseWhenExpression(
    cases: [CaseWhen(c.lastMessageAt.isBiggerThan(c.createdAt), then: c.lastMessageAt)],
    orElse: c.createdAt,
  );

  /// Updates all the channels using the new [channelList] data
  Future<void> updateChannels(List<ChannelModel> channelList) => batch(
    (it) => it.insertAllOnConflictUpdate(
      channels,
      channelList.map((c) => c.toEntity()).toList(),
    ),
  );
}
