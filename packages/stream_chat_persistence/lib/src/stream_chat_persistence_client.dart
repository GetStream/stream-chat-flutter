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

  MoorChatDatabase _db;
  final Logger _logger;
  final ConnectionMode _connectionMode;

  @override
  Future<void> connect(String userId) async {
    if (_db != null) {
      throw Exception(
        'An instance of StreamChatDatabase is already connected.\n'
        'disconnect the previous instance before connecting again.',
      );
    }
    switch (_connectionMode) {
      case ConnectionMode.regular:
        _logger.info('Connecting on a regular isolate');
        _db = MoorChatDatabase(userId);
        return;
      case ConnectionMode.background:
        _logger.info('Connecting on background isolate');
        _db = await SharedDB.constructMoorChatDatabase(userId);
        return;
    }
  }

  @override
  Future<Event> getConnectionInfo() {
    return _db.connectionEventDao.connectionEvent;
  }

  @override
  Future<void> updateConnectionInfo(Event event) {
    return _db.connectionEventDao.updateConnectionEvent(event);
  }

  @override
  Future<void> updateLastSyncAt(DateTime lastSyncAt) {
    return _db.connectionEventDao.updateLastSyncAt(lastSyncAt);
  }

  @override
  Future<DateTime> getLastSyncAt() {
    return _db.connectionEventDao.lastSyncAt;
  }

  @override
  Future<void> deleteChannels(List<String> cids) {
    return _db.channelDao.deleteChannelByCids(cids);
  }

  @override
  Future<List<String>> getChannelCids() => _db.channelDao.cids;

  @override
  Future<void> deleteMessageByIds(List<String> messageIds) {
    return _db.messageDao.deleteMessageByIds(messageIds);
  }

  @override
  Future<void> deleteMessageByCids(List<String> cids) {
    return _db.messageDao.deleteMessageByCids(cids);
  }

  @override
  Future<List<Member>> getMembersByCid(String cid) {
    return _db.memberDao.getMembersByCid(cid);
  }

  @override
  Future<ChannelModel> getChannelByCid(String cid) {
    return _db.channelDao.getChannelByCid(cid);
  }

  @override
  Future<List<Message>> getMessagesByCid(
    String cid, {
    PaginationParams messagePagination,
  }) {
    return _db.messageDao.getMessagesByCid(
      cid,
      messagePagination: messagePagination,
    );
  }

  @override
  Future<List<Read>> getReadsByCid(String cid) {
    return _db.readDao.getReadsByCid(cid);
  }

  @override
  Future<Map<String, List<Message>>> getChannelThreads(String cid) async {
    final messages = await _db.messageDao.getThreadMessages(cid);
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
    return _db.messageDao.getThreadMessagesByParentId(
      parentId,
      options: options,
    );
  }

  @override
  Future<List<ChannelState>> getChannelStates({
    Map<String, dynamic> filter,
    List<SortOption> sort = const [],
    PaginationParams paginationParams,
  }) {
    return _db.channelQueryDao.getChannelStates(
      filter: filter,
      sort: sort,
      paginationParams: paginationParams,
    );
  }

  @override
  Future<void> updateChannelQueries(
    Map<String, dynamic> filter,
    List<String> cids,
    bool clearQueryCache,
  ) {
    return _db.channelQueryDao.updateChannelQueries(
      filter,
      cids,
      clearQueryCache,
    );
  }

  @override
  Future<void> updateChannels(List<ChannelModel> channels) {
    return _db.channelDao.updateChannels(channels);
  }

  @override
  Future<void> updateMembers(String cid, List<Member> members) {
    return _db.memberDao.updateMembers(cid, members);
  }

  @override
  Future<void> updateMessages(String cid, List<Message> messages) {
    return _db.messageDao.updateMessages(cid, messages);
  }

  @override
  Future<void> updateReactions(List<Reaction> reactions) {
    return _db.reactionDao.updateReactions(reactions);
  }

  @override
  Future<void> updateReads(String cid, List<Read> reads) {
    return _db.readDao.updateReads(cid, reads);
  }

  @override
  Future<void> updateUsers(List<User> users) {
    return _db.userDao.updateUsers(users);
  }

  @override
  Future<void> deleteReactionsByMessageId(List<String> messageIds) {
    return _db.reactionDao.deleteReactionsByMessageIds(messageIds);
  }

  @override
  Future<void> deleteMembersByCids(List<String> cids) {
    return _db.memberDao.deleteMemberByCids(cids);
  }

  @override
  Future<void> disconnect({bool flush = false}) async {
    if (_db != null) {
      _logger.info('Disconnecting');
      if (flush) {
        _logger.info('Flushing');
        await _db.batch((batch) {
          _db.allTables.forEach((table) {
            _db.delete(table).go();
          });
        });
      }
      await _db.disconnect();
      _db = null;
    }
  }
}
