import 'package:stream_chat/stream_chat.dart';

import 'moor_chat_database.dart';
import 'shared/shared_db.dart';

///
class StreamChatDatabaseImpl implements StreamChatDatabase {
  ///
  StreamChatDatabaseImpl(
    this._userId, {
    Logger logger,
  })  : _logger = logger,
        assert(_userId != null);

  final String _userId;
  final Logger _logger;
  MoorChatDatabase _db;

  bool get _debugAssertConnected {
    assert(() {
      if (_db == null) {
        throw Exception(
          'A $runtimeType was used after being disconnected.\n'
          'Once you have called disconnect() on a $runtimeType, it can no longer be used.',
        );
      }
      return true;
    }());
    return true;
  }

  @override
  Future<void> connect({
    bool connectBackground = false,
    bool logStatements = false,
  }) async {
    if (_db != null) {
      throw Exception(
        'An instance of StreamChatDatabase is already connected.\n'
        'disconnect the previous instance before connecting again.',
      );
    }

    final dbName = 'db_$_userId';
    if (connectBackground) {
      _logger?.info('Connecting on background isolate');
      _db = await SharedDB.constructOfflineStorage(
        dbName,
        logStatements: logStatements,
      );
    } else {
      _logger?.info('Connecting on a regular isolate');
      _db = MoorChatDatabase(dbName, logStatements: logStatements);
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
  Future<void> deleteChannelByCids(List<String> cids) {
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
    int limit = 20,
    String messageLessThan,
    String messageGreaterThan,
  }) {
    return _db.messageDao.getMessagesByCid(
      cid,
      limit: limit,
      messageLessThan: messageLessThan,
      messageGreaterThan: messageGreaterThan,
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
    String lessThan,
  }) {
    return _db.messageDao.getThreadMessagesByParentId(
      parentId,
      lessThan: lessThan,
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
  Future<void> disconnect({bool flush = false}) async {
    if (_db != null) {
      _logger?.info('Disconnecting');
      if (flush) {
        _logger?.info('Flushing');
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
