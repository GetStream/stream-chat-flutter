import 'package:stream_chat/src/api/requests.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/channel_state.dart';
import 'package:stream_chat/src/models/event.dart';
import 'package:stream_chat/src/models/member.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/reaction.dart';
import 'package:stream_chat/src/models/read.dart';
import 'package:stream_chat/src/models/user.dart';

/// A simple client used for persisting chat data locally.
abstract class ChatPersistenceClient {
  /// Creates a new connection to the client
  Future<void> connect(String? userId);

  /// Closes the client connection
  /// If [flush] is true, the data will also be deleted
  Future<void> disconnect({bool flush = false});

  /// Get stored replies by messageId
  Future<List<Message>> getReplies(
    String parentId, {
    PaginationParams? options,
  });

  /// Get stored connection event
  Future<Event> getConnectionInfo();

  /// Get stored lastSyncAt
  Future<DateTime> getLastSyncAt();

  /// Update stored connection event
  Future<void> updateConnectionInfo(Event event);

  /// Update stored lastSyncAt
  Future<void> updateLastSyncAt(DateTime? lastSyncAt);

  /// Get the channel cids saved in the offline storage
  Future<List<String>> getChannelCids();

  /// Get stored [ChannelModel]s by providing channel [cid]
  Future<ChannelModel> getChannelByCid(String? cid);

  /// Get stored channel [Member]s by providing channel [cid]
  Future<List<Member>> getMembersByCid(String? cid);

  /// Get stored channel [Read]s by providing channel [cid]
  Future<List<Read>> getReadsByCid(String? cid);

  /// Get stored [Message]s by providing channel [cid]
  ///
  /// Optionally, you can [messagePagination]
  /// for filtering out messages
  Future<List<Message>> getMessagesByCid(
    String? cid, {
    PaginationParams? messagePagination,
  });

  /// Get stored pinned [Message]s by providing channel [cid]
  Future<List<Message>> getPinnedMessagesByCid(
    String? cid, {
    PaginationParams? messagePagination,
  });

  /// Get [ChannelState] data by providing channel [cid]
  Future<ChannelState> getChannelStateByCid(
    String? cid, {
    PaginationParams? messagePagination,
    PaginationParams? pinnedMessagePagination,
  }) async {
    final data = await Future.wait([
      getMembersByCid(cid),
      getReadsByCid(cid),
      getChannelByCid(cid),
      getMessagesByCid(cid, messagePagination: messagePagination),
      getPinnedMessagesByCid(cid, messagePagination: pinnedMessagePagination),
    ]);
    return ChannelState(
      members: data[0] as List<Member?>?,
      read: data[1] as List<Read>?,
      channel: data[2] as ChannelModel?,
      messages: data[3] as List<Message>?,
      pinnedMessages: data[4] as List<Message>?,
    );
  }

  /// Get all the stored [ChannelState]s
  ///
  /// Optionally, pass [filter], [sort], [paginationParams]
  /// for filtering out states.
  Future<List<ChannelState>> getChannelStates({
    Map<String, dynamic>? filter,
    List<SortOption<ChannelModel>>? sort = const [],
    PaginationParams? paginationParams,
  });

  /// Update list of channel queries.
  ///
  /// If [clearQueryCache] is true before the insert
  /// the list of matching rows will be deleted
  Future<void> updateChannelQueries(
    Map<String, dynamic>? filter,
    List<String?> cids, {
    bool clearQueryCache = false,
  });

  /// Remove a message by [messageId]
  Future<void> deleteMessageById(String messageId) =>
      deleteMessageByIds([messageId]);

  /// Remove a pinned message by [messageId]
  Future<void> deletePinnedMessageById(String messageId) =>
      deletePinnedMessageByIds([messageId]);

  /// Remove a message by [messageIds]
  Future<void> deleteMessageByIds(List<String> messageIds);

  /// Remove a pinned message by [messageIds]
  Future<void> deletePinnedMessageByIds(List<String> messageIds);

  /// Remove a message by channel [cid]
  Future<void> deleteMessageByCid(String? cid) => deleteMessageByCids([cid]);

  /// Remove a pinned message by channel [cid]
  Future<void> deletePinnedMessageByCid(String cid) async =>
      deletePinnedMessageByCids([cid]);

  /// Remove a message by message [cids]
  Future<void> deleteMessageByCids(List<String?> cids);

  /// Remove a pinned message by message [cids]
  Future<void> deletePinnedMessageByCids(List<String> cids);

  /// Remove a channel by [cid]
  Future<void> deleteChannels(List<String?> cids);

  /// Updates the message data of a particular channel [cid] with
  /// the new [messages] data
  Future<void> updateMessages(String? cid, List<Message> messages);

  /// Updates the pinned message data of a particular channel [cid] with
  /// the new [messages] data
  Future<void> updatePinnedMessages(String? cid, List<Message> messages);

  /// Returns all the threads by parent message of a particular channel by
  /// providing channel [cid]
  Future<Map<String, List<Message>>> getChannelThreads(String? cid);

  /// Updates all the channels using the new [channels] data.
  Future<void> updateChannels(List<ChannelModel?> channels);

  /// Updates all the members of a particular channle [cid]
  /// with the new [members] data
  Future<void> updateMembers(String? cid, List<Member?> members);

  /// Updates the read data of a particular channel [cid] with
  /// the new [reads] data
  Future<void> updateReads(String? cid, List<Read> reads);

  /// Updates the users data with the new [users] data
  Future<void> updateUsers(List<User?> users);

  /// Updates the reactions data with the new [reactions] data
  Future<void> updateReactions(List<Reaction> reactions);

  /// Deletes all the reactions by [messageIds]
  Future<void> deleteReactionsByMessageId(List<String> messageIds);

  /// Deletes all the members by channel [cids]
  Future<void> deleteMembersByCids(List<String?> cids);

  /// Update the channel state data using [channelState]
  Future<void> updateChannelState(ChannelState channelState) =>
      updateChannelStates([channelState]);

  /// Update list of channel states
  Future<void> updateChannelStates(List<ChannelState> channelStates) async {
    final deleteReactions = deleteReactionsByMessageId(channelStates
        .expand((it) => it.messages!)
        .map((m) => m.id)
        .toList(growable: false));

    final deleteMembers = deleteMembersByCids(
      channelStates.map((it) => it.channel!.cid).toList(growable: false),
    );

    await Future.wait([
      deleteReactions,
      deleteMembers,
    ]);

    final channels =
        channelStates.map((it) => it.channel).where((it) => it != null);

    final reactions = channelStates
        .expand((it) => it.messages!)
        .expand((it) => [
              if (it.ownReactions != null)
                ...it.ownReactions!.where((r) => r.userId != null),
              if (it.latestReactions != null)
                ...it.latestReactions!.where((r) => r.userId != null)
            ])
        .where((it) => it != null);

    final users = channelStates
        .map((cs) => [
              cs.channel?.createdBy,
              ...?cs.messages
                  ?.map((m) => [
                        m.user,
                        if (m.latestReactions != null)
                          ...m.latestReactions!.map((r) => r.user),
                        if (m.ownReactions != null)
                          ...m.ownReactions!.map((r) => r.user),
                      ])
                  .expand((v) => v),
              if (cs.read != null) ...cs.read!.map((r) => r.user),
              if (cs.members != null) ...cs.members!.map((m) => m!.user),
            ])
        .expand((it) => it)
        .where((it) => it != null);

    final updateMessagesFuture = channelStates.map((it) {
      final cid = it.channel!.cid;
      final messages = it.messages!.where((it) => it != null);
      return updateMessages(cid, messages.toList(growable: false));
    }).toList(growable: false);

    final updatePinnedMessagesFuture = channelStates.map((it) {
      final cid = it.channel!.cid;
      final messages = it.pinnedMessages!.where((it) => it != null);
      return updatePinnedMessages(cid, messages.toList(growable: false));
    }).toList(growable: false);

    final updateReadsFuture = channelStates.map((it) {
      final cid = it.channel!.cid;
      final reads = it.read?.where((it) => it != null) ?? [];
      return updateReads(cid, reads.toList(growable: false));
    }).toList(growable: false);

    final updateMembersFuture = channelStates.map((it) {
      final cid = it.channel!.cid;
      final members = it.members!.where((it) => it != null);
      return updateMembers(cid, members.toList(growable: false));
    }).toList(growable: false);

    await Future.wait([
      ...updateMessagesFuture,
      ...updatePinnedMessagesFuture,
      ...updateReadsFuture,
      ...updateMembersFuture,
      updateUsers(users.toList(growable: false)),
      updateChannels(channels.toList(growable: false)),
      updateReactions(reactions.toList(growable: false)),
    ]);
  }
}
