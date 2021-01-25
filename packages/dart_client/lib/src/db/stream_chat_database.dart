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
abstract class StreamChatDatabase {
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

  Future<ChannelModel> getChannelByCid(String cid);

  Future<List<Member>> getMembersByCid(String cid);

  Future<List<Read>> getReadsByCid(String cid);

  Future<List<Message>> getMessagesByCid(
    String cid, {
    int limit = 20,
    String messageLessThan,
    String messageGreaterThan,
  });

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
  Future<void> deleteMessageByIds(List<String> messageIds);

  /// Remove a message by message id
  Future<void> deleteMessageByCids(List<String> cids);

  /// Remove a channel by cid
  Future<void> deleteChannelByCids(List<String> cids);

  /// Update messages data from a list
  Future<void> updateMessages(String cid, List<Message> messages);

  /// Get the info about channel threads
  Future<Map<String, List<Message>>> getChannelThreads(String cid);

  Future<void> updateChannels(List<ChannelModel> channels);

  Future<void> updateMembers(String cid, List<Member> members);

  Future<void> updateReads(String cid, List<Read> reads);

  Future<void> updateUsers(List<User> users);

  Future<void> updateReactions(List<Reaction> reactions);
}
