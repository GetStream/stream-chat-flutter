import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/models/attachment_file.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/read.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';
import 'package:stream_chat/src/core/util/extension.dart';

/// A simple client used for persisting chat data locally.
abstract class ChatPersistenceClient {
  /// Whether the connection is established.
  bool get isConnected;

  /// The current user id to which the client is connected.
  ///
  /// Returns `null` if the client is not connected.
  String? get userId;

  /// Creates a new connection to the client
  Future<void> connect(String userId);

  /// Closes the client connection
  /// If [flush] is true, the data will also be deleted
  Future<void> disconnect({bool flush = false});

  /// Get stored replies by messageId
  Future<List<Message>> getReplies(
    String parentId, {
    PaginationParams? options,
  });

  /// Get stored connection event
  Future<Event?> getConnectionInfo();

  /// Get stored lastSyncAt
  Future<DateTime?> getLastSyncAt();

  /// Update stored connection event
  Future<void> updateConnectionInfo(Event event);

  /// Update stored lastSyncAt
  Future<void> updateLastSyncAt(DateTime lastSyncAt);

  /// Get the channel cids saved in the offline storage
  Future<List<String>> getChannelCids();

  /// Get stored [ChannelModel]s by providing channel [cid]
  Future<ChannelModel?> getChannelByCid(String cid);

  /// Get stored channel [Member]s by providing channel [cid]
  Future<List<Member>?> getMembersByCid(String cid);

  /// Get stored channel [Read]s by providing channel [cid]
  Future<List<Read>?> getReadsByCid(String cid);

  /// Get stored [Message]s by providing channel [cid]
  ///
  /// Optionally, you can [messagePagination]
  /// for filtering out messages
  Future<List<Message>> getMessagesByCid(
    String cid, {
    PaginationParams? messagePagination,
  });

  /// Get stored pinned [Message]s by providing channel [cid]
  Future<List<Message>> getPinnedMessagesByCid(
    String cid, {
    PaginationParams? messagePagination,
  });

  /// Get [ChannelState] data by providing channel [cid]
  Future<ChannelState> getChannelStateByCid(
    String cid, {
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
      members: data[0] as List<Member>?,
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
    Filter? filter,
    @Deprecated('''
    sort has been deprecated. 
    Please use channelStateSort instead.''') List<SortOption<ChannelModel>>? sort,
    List<SortOption<ChannelState>>? channelStateSort,
    PaginationParams? paginationParams,
  });

  /// Update list of channel queries.
  ///
  /// If [clearQueryCache] is true before the insert
  /// the list of matching rows will be deleted
  Future<void> updateChannelQueries(
    Filter? filter,
    List<String> cids, {
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
  Future<void> deleteMessageByCid(String cid) => deleteMessageByCids([cid]);

  /// Remove a pinned message by channel [cid]
  Future<void> deletePinnedMessageByCid(String cid) async =>
      deletePinnedMessageByCids([cid]);

  /// Remove a message by message [cids]
  Future<void> deleteMessageByCids(List<String> cids);

  /// Remove a pinned message by message [cids]
  Future<void> deletePinnedMessageByCids(List<String> cids);

  /// Remove a channel by [channelId]
  Future<void> deleteChannels(List<String> cids);

  /// Updates the message data of a particular channel [cid] with
  /// the new [messages] data
  Future<void> updateMessages(String cid, List<Message> messages) =>
      bulkUpdateMessages({cid: messages});

  /// Bulk updates the message data of multiple channels.
  Future<void> bulkUpdateMessages(Map<String, List<Message>?> messages);

  /// Updates the pinned message data of a particular channel [cid] with
  /// the new [messages] data
  Future<void> updatePinnedMessages(String cid, List<Message> messages) =>
      bulkUpdatePinnedMessages({cid: messages});

  /// Bulk updates the message data of multiple channels.
  Future<void> bulkUpdatePinnedMessages(Map<String, List<Message>?> messages);

  /// Returns all the threads by parent message of a particular channel by
  /// providing channel [cid]
  Future<Map<String, List<Message>>> getChannelThreads(String cid);

  /// Updates all the channels using the new [channels] data.
  Future<void> updateChannels(List<ChannelModel> channels);

  /// Updates all the members of a particular channle [cid]
  /// with the new [members] data
  Future<void> updateMembers(String cid, List<Member> members) =>
      bulkUpdateMembers({cid: members});

  /// Bulk updates the members data of multiple channels.
  Future<void> bulkUpdateMembers(Map<String, List<Member>?> members);

  /// Updates the read data of a particular channel [cid] with
  /// the new [reads] data
  Future<void> updateReads(String cid, List<Read> reads) =>
      bulkUpdateReads({cid: reads});

  /// Bulk updates the read data of multiple channels.
  Future<void> bulkUpdateReads(Map<String, List<Read>?> reads);

  /// Updates the users data with the new [users] data
  Future<void> updateUsers(List<User> users);

  /// Updates the reactions data with the new [reactions] data
  Future<void> updateReactions(List<Reaction> reactions);

  /// Updates the pinned message reactions data with the new [reactions] data
  Future<void> updatePinnedMessageReactions(List<Reaction> reactions);

  /// Deletes all the reactions by [messageIds]
  Future<void> deleteReactionsByMessageId(List<String> messageIds);

  /// Deletes all the pinned messages reactions by [messageIds]
  Future<void> deletePinnedMessageReactionsByMessageId(List<String> messageIds);

  /// Deletes all the members by channel [cids]
  Future<void> deleteMembersByCids(List<String> cids);

  /// Updates the channel [cid] threads data along with reactions and users.
  Future<void> updateChannelThreads(
    String cid,
    Map<String, List<Message>> threads,
  ) async {
    final messages = threads.values.expand((it) => it).toList();

    // Removing old reactions before saving the new
    final oldReactions = messages.map((it) => it.id).toList();
    await deleteReactionsByMessageId(oldReactions);

    // Adding new reactions and users data
    final reactions = messages.expand(_expandReactions).toList();
    final users = messages.map((it) => it.user).withNullifyer.toList();

    await Future.wait([
      updateMessages(cid, messages),
      updateReactions(reactions),
      updateUsers(users),
    ]);
  }

  /// Update the channel state data using [channelState]
  Future<void> updateChannelState(ChannelState channelState) =>
      updateChannelStates([channelState]);

  /// Update list of channel states
  Future<void> updateChannelStates(List<ChannelState> channelStates) async {
    final reactionsToDelete = <String>[];
    final pinnedReactionsToDelete = <String>[];
    final membersToDelete = <String>[];

    final channels = <ChannelModel>[];
    final channelWithMessages = <String, List<Message>?>{};
    final channelWithPinnedMessages = <String, List<Message>?>{};
    final channelWithReads = <String, List<Read>?>{};
    final channelWithMembers = <String, List<Member>?>{};

    final users = <User>[];
    final reactions = <Reaction>[];
    final pinnedReactions = <Reaction>[];

    for (final state in channelStates) {
      final channel = state.channel;
      if (channel != null) {
        channels.add(channel);

        final cid = channel.cid;
        final reads = state.read;
        final members = state.members;
        final Iterable<Message>? messages;
        if (CurrentPlatform.isWeb) {
          messages = state.messages?.where((it) => !it.attachments.any(
                (attachment) =>
                    attachment.uploadState != const UploadState.success(),
              ));
        } else {
          messages = state.messages;
        }
        final pinnedMessages = state.pinnedMessages;

        // Preparing deletion data
        membersToDelete.add(cid);
        reactionsToDelete.addAll(state.messages?.map((it) => it.id) ?? []);
        pinnedReactionsToDelete
            .addAll(state.pinnedMessages?.map((it) => it.id) ?? []);

        // preparing addition data
        channelWithReads[cid] = reads;
        channelWithMembers[cid] = members;
        channelWithMessages[cid] = messages?.toList();
        channelWithPinnedMessages[cid] = pinnedMessages;

        reactions.addAll(messages?.expand(_expandReactions) ?? []);
        pinnedReactions.addAll(pinnedMessages?.expand(_expandReactions) ?? []);

        users.addAll([
          channel.createdBy,
          ...messages?.map((it) => it.user) ?? <User>[],
          ...reads?.map((it) => it.user) ?? <User>[],
          ...members?.map((it) => it.user) ?? <User>[],
          ...reactions.map((it) => it.user),
          ...pinnedReactions.map((it) => it.user),
        ].withNullifyer);
      }
    }

    // Removing old members and reactions data as they may have
    // changes over the time.
    await Future.wait([
      deleteMembersByCids(membersToDelete),
      deleteReactionsByMessageId(reactionsToDelete),
      deletePinnedMessageReactionsByMessageId(pinnedReactionsToDelete),
    ]);

    // Updating first as does not depend on any other table.
    await Future.wait([
      updateUsers(users.toList(growable: false)),
      updateChannels(channels.toList(growable: false)),
    ]);

    // All has a foreign key relation with channels table.
    await Future.wait([
      bulkUpdateReads(channelWithReads),
      bulkUpdateMembers(channelWithMembers),
      bulkUpdateMessages(channelWithMessages),
      bulkUpdatePinnedMessages(channelWithPinnedMessages),
    ]);

    // Both has a foreign key relation with messages, pinnedMessages table.
    await Future.wait([
      updateReactions(reactions.toList(growable: false)),
      updatePinnedMessageReactions(
        pinnedReactions.toList(growable: false),
      ),
    ]);
  }

  List<Reaction> _expandReactions(Message message) {
    final own = message.ownReactions;
    final latest = message.latestReactions;
    return [
      if (own != null) ...own.where((r) => r.userId != null),
      if (latest != null) ...latest.where((r) => r.userId != null),
    ];
  }
}
