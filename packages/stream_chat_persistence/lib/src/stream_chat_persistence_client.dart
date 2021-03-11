import 'package:meta/meta.dart';
import 'package:stream_chat/stream_chat.dart';

import 'db/moor_chat_database.dart';
import 'db/shared/shared_db.dart';

/// Various connection modes on which [StreamChatPersistenceClient] can work
enum ConnectionMode {
  /// Connects the [StreamChatPersistenceClient] on a regular/default isolate
  regular,

  /// Connects the [StreamChatPersistenceClient] on a background isolate
  background,
}

/// A [MoorChatDatabase] based implementation of the [ChatPersistenceClient]
class StreamChatPersistenceClient extends ChatPersistenceClient {
  /// Creates a new instance of the stream chat persistence client
  StreamChatPersistenceClient({
    /// Connection mode on which the client will work
    ConnectionMode connectionMode = ConnectionMode.regular,
    Level logLevel = Level.WARNING,
  })  : assert(connectionMode != null),
        assert(logLevel != null),
        _connectionMode = connectionMode,
        _logger = Logger.detached('💽')..level = logLevel;

  @visibleForTesting
  MoorChatDatabase db;
  final Logger _logger;
  final ConnectionMode _connectionMode;

  @override
  Future<void> connect(String userId) async {
    if (db != null) {
      throw Exception(
        'An instance of StreamChatDatabase is already connected.\n'
        'disconnect the previous instance before connecting again.',
      );
    }
    switch (_connectionMode) {
      case ConnectionMode.regular:
        _logger.info('Connecting on a regular isolate');
        db = MoorChatDatabase(userId);
        return;
      case ConnectionMode.background:
        _logger.info('Connecting on background isolate');
        db = await SharedDB.constructMoorChatDatabase(userId);
        return;
    }
  }

  @override
  Future<Event> getConnectionInfo() {
    return db.connectionEventDao.connectionEvent;
  }

  @override
  Future<void> updateConnectionInfo(Event event) {
    return db.connectionEventDao.updateConnectionEvent(event);
  }

  @override
  Future<void> updateLastSyncAt(DateTime lastSyncAt) {
    return db.connectionEventDao.updateLastSyncAt(lastSyncAt);
  }

  @override
  Future<DateTime> getLastSyncAt() {
    return db.connectionEventDao.lastSyncAt;
  }

  @override
  Future<void> deleteChannels(List<String> cids) {
    return db.channelDao.deleteChannelByCids(cids);
  }

  @override
  Future<List<String>> getChannelCids() => db.channelDao.cids;

  @override
  Future<void> deleteMessageByIds(List<String> messageIds) {
    return db.messageDao.deleteMessageByIds(messageIds);
  }

  @override
  Future<void> deletePinnedMessageByIds(List<String> messageIds) {
    return db.pinnedMessageDao.deleteMessageByIds(messageIds);
  }

  @override
  Future<void> deleteMessageByCids(List<String> cids) {
    return db.messageDao.deleteMessageByCids(cids);
  }

  @override
  Future<void> deletePinnedMessageByCids(List<String> cids) {
    return db.pinnedMessageDao.deleteMessageByCids(cids);
  }

  @override
  Future<List<Member>> getMembersByCid(String cid) {
    return db.memberDao.getMembersByCid(cid);
  }

  @override
  Future<ChannelModel> getChannelByCid(String cid) {
    return db.channelDao.getChannelByCid(cid);
  }

  @override
  Future<List<Message>> getMessagesByCid(
    String cid, {
    PaginationParams messagePagination,
  }) {
    return db.messageDao.getMessagesByCid(
      cid,
      messagePagination: messagePagination,
    );
  }

  @override
  Future<List<Message>> getPinnedMessagesByCid(
    String cid, {
    PaginationParams messagePagination,
  }) {
    return db.pinnedMessageDao.getMessagesByCid(
      cid,
      messagePagination: messagePagination,
    );
  }

  @override
  Future<List<Read>> getReadsByCid(String cid) {
    return db.readDao.getReadsByCid(cid);
  }

  @override
  Future<Map<String, List<Message>>> getChannelThreads(String cid) async {
    final messages = await db.messageDao.getThreadMessages(cid);
    final messageByParentIdDictionary = <String, List<Message>>{};
    for (final message in messages) {
      final parentId = message.parentId;
      messageByParentIdDictionary[parentId] = [
        ...messageByParentIdDictionary[parentId] ?? [],
        message
      ];
    }
    return messageByParentIdDictionary;
  }

  @override
  Future<List<Message>> getReplies(
    String parentId, {
    PaginationParams options,
  }) {
    return db.messageDao.getThreadMessagesByParentId(
      parentId,
      options: options,
    );
  }

  @override
  Future<List<ChannelState>> getChannelStates({
    Map<String, dynamic> filter,
    List<SortOption<ChannelModel>> sort = const [],
    PaginationParams paginationParams,
  }) async {
    final channels = await db.channelQueryDao.getChannels(
      filter: filter,
      sort: sort,
      paginationParams: paginationParams,
    );
    return Future.wait(channels.map((e) => getChannelStateByCid(e.cid)));
  }

  @override
  Future<void> updateChannelQueries(
    Map<String, dynamic> filter,
    List<String> cids,
    bool clearQueryCache,
  ) {
    return db.channelQueryDao.updateChannelQueries(
      filter,
      cids,
      clearQueryCache,
    );
  }

  @override
  Future<void> updateChannels(List<ChannelModel> channels) {
    return db.channelDao.updateChannels(channels);
  }

  @override
  Future<void> updateMembers(String cid, List<Member> members) {
    return db.memberDao.updateMembers(cid, members);
  }

  @override
  Future<void> updateMessages(String cid, List<Message> messages) {
    return db.messageDao.updateMessages(cid, messages);
  }

  @override
  Future<void> updatePinnedMessages(String cid, List<Message> messages) {
    return db.pinnedMessageDao.updateMessages(cid, messages);
  }

  @override
  Future<void> updateReactions(List<Reaction> reactions) {
    return db.reactionDao.updateReactions(reactions);
  }

  @override
  Future<void> updateReads(String cid, List<Read> reads) {
    return db.readDao.updateReads(cid, reads);
  }

  @override
  Future<void> updateUsers(List<User> users) {
    return db.userDao.updateUsers(users);
  }

  @override
  Future<void> deleteReactionsByMessageId(List<String> messageIds) {
    return db.reactionDao.deleteReactionsByMessageIds(messageIds);
  }

  @override
  Future<void> deleteMembersByCids(List<String> cids) {
    return db.memberDao.deleteMemberByCids(cids);
  }

  @override
  Future<void> disconnect({bool flush = false}) async {
    if (db != null) {
      _logger.info('Disconnecting');
      if (flush) {
        _logger.info('Flushing');
        await db.batch((batch) {
          db.allTables.forEach((table) {
            db.delete(table).go();
          });
        });
      }
      await db.disconnect();
      db = null;
    }
  }
}
