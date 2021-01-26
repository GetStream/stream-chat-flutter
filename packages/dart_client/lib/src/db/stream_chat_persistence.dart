import 'package:stream_chat/src/api/requests.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/channel_state.dart';
import 'package:stream_chat/src/models/event.dart';
import 'package:stream_chat/src/models/member.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/reaction.dart';
import 'package:stream_chat/src/models/read.dart';
import 'package:stream_chat/src/models/user.dart';

///
abstract class StreamChatPersistence {
  /// Creates a new connection to the database
  Future<void> connect({
    bool connectBackground = false,
    bool logStatements = false,
  });

  /// Closes the database instance
  /// If [flush] is true, the database data will be deleted
  Future<void> disconnect({bool flush = false});

  /// Get stored replies by messageId
  Future<List<Message>> getReplies(
    String parentId, {
    String lessThan,
  });

  /// Get stored connection event
  Future<Event> getConnectionInfo();

  /// Get stored lastSyncAt
  Future<DateTime> getLastSyncAt();

  /// Update stored connection event
  Future<void> updateConnectionInfo(Event event);

  /// Update stored lastSyncAt
  Future<void> updateLastSyncAt(DateTime lastSyncAt);

  /// Get the channel cids saved in the offline storage
  Future<List<String>> getChannelCids();

  ///
  Future<ChannelModel> getChannelByCid(String cid);

  ///
  Future<List<Member>> getMembersByCid(String cid);

  ///
  Future<List<Read>> getReadsByCid(String cid);

  ///
  Future<List<Message>> getMessagesByCid(
    String cid, {
    PaginationParams messagePagination,
  });

  /// Get channel data by cid
  Future<ChannelState> getChannelStateByCid(
    String cid, {
    PaginationParams messagePagination,
  }) async {
    final members = await getMembersByCid(cid);
    final reads = await getReadsByCid(cid);
    final channel = await getChannelByCid(cid);
    final messages = await getMessagesByCid(
      cid,
      messagePagination: messagePagination,
    );
    return ChannelState(
      members: members,
      read: reads,
      messages: messages,
      channel: channel,
    );
  }

  /// Get list of channels by filter, sort and paginationParams
  Future<List<ChannelState>> getChannelStates({
    Map<String, dynamic> filter,
    List<SortOption> sort = const [],
    PaginationParams paginationParams,
  });

  /// Update list of channel queries
  /// If [clearQueryCache] is true before the insert
  /// the list of matching rows will be deleted
  Future<void> updateChannelQueries(
    Map<String, dynamic> filter,
    List<String> cids,
    bool clearQueryCache,
  );

  /// Remove a message by message id
  Future<void> deleteMessageById(String messageId) {
    return deleteMessageByIds([messageId]);
  }

  /// Remove a message by message ids
  Future<void> deleteMessageByIds(List<String> messageIds);

  /// Remove a message by channel cid
  Future<void> deleteMessageByCid(String cid) {
    return deleteMessageByCids([cid]);
  }

  /// Remove a message by message cids
  Future<void> deleteMessageByCids(List<String> cids);

  /// Remove a channel by cid
  Future<void> deleteChannels(List<String> cids);

  /// Update messages data from a list
  Future<void> updateMessages(String cid, List<Message> messages);

  /// Get the info about channel threads
  Future<Map<String, List<Message>>> getChannelThreads(String cid);

  ///
  Future<void> updateChannels(List<ChannelModel> channels);

  ///
  Future<void> updateMembers(String cid, List<Member> members);

  ///
  Future<void> updateReads(String cid, List<Read> reads);

  ///
  Future<void> updateUsers(List<User> users);

  ///
  Future<void> updateReactions(List<Reaction> reactions);

  ///
  Future<void> updateChannelState(ChannelState channelState) {
    return updateChannelStates([channelState]);
  }

  /// Update list of channel states
  Future<void> updateChannelStates(List<ChannelState> channelStates) async {
    final channels = channelStates.map((it) {
      return it.channel;
    }).where((it) => it != null);

    final reactions = channelStates.expand((it) => it.messages).expand((it) {
      return [
        ...it.ownReactions.where((r) => r.userId != null),
        ...it.latestReactions.where((r) => r.userId != null)
      ];
    }).where((it) => it != null);

    final users = channelStates
        .map((cs) => [
              cs.channel?.createdBy,
              ...cs.messages?.map((m) {
                return [
                  m.user,
                  ...m.latestReactions?.map((r) => r.user),
                  ...m.ownReactions?.map((r) => r.user),
                ];
              })?.expand((v) => v),
              ...cs.read?.map((r) => r.user),
              ...cs.members?.map((m) => m.user),
            ])
        .expand((it) => it)
        .where((it) => it != null);

    final updateMessagesFuture = channelStates.map((it) {
      final cid = it.channel.cid;
      final messages = it.messages.where((it) => it != null);
      return updateMessages(cid, messages.toList(growable: false));
    }).toList(growable: false);

    final updateReadsFuture = channelStates.map((it) {
      final cid = it.channel.cid;
      final reads = it.read.where((it) => it != null);
      return updateReads(cid, reads.toList(growable: false));
    }).toList(growable: false);

    final updateMembersFuture = channelStates.map((it) {
      final cid = it.channel.cid;
      final members = it.members.where((it) => it != null);
      return updateMembers(cid, members.toList(growable: false));
    }).toList(growable: false);

    await Future.wait([
      ...updateMessagesFuture,
      ...updateReadsFuture,
      ...updateMembersFuture,
      updateChannels(channels.toList(growable: false)),
      updateReactions(reactions.toList(growable: false)),
      updateUsers(users.toList(growable: false)),
    ]);
  }
}
