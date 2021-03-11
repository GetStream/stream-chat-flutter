import 'package:mutex/mutex.dart';
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
    LogHandlerFunction logHandlerFunction,
  })  : assert(connectionMode != null),
        assert(logLevel != null),
        _connectionMode = connectionMode,
        _logger = Logger.detached('💽')..level = logLevel {
    _logger.onRecord.listen(_getDefaultLogHandler());
  }

  /// A function that has a parameter of type [LogRecord].
  /// This is called on every new log record.
  /// By default the client will use the handler returned by
  /// [_getDefaultLogHandler].
  /// Setting it you can handle the log messages directly instead of have them
  /// written to stdout,
  /// this is very convenient if you use an error tracking tool or if you want
  /// to centralize your logs into one facility.
  ///
  /// ```dart
  /// myLogHandlerFunction = (LogRecord record) {
  ///  // do something with the record (ie. send it to Sentry or Fabric)
  /// }
  ///
  /// final client = StreamChatPersistenceClient(
  ///   logHandlerFunction: myLogHandlerFunction,
  /// );
  ///```
  LogHandlerFunction logHandlerFunction;

  MoorChatDatabase _db;
  final Logger _logger;
  final ConnectionMode _connectionMode;
  final _mutex = ReadWriteMutex();

  LogHandlerFunction _getDefaultLogHandler() {
    final levelEmojiMapper = {
      Level.INFO.name: 'ℹ️',
      Level.WARNING.name: '⚠️',
      Level.SEVERE.name: '🚨',
    };
    return (record) {
      print(
        '(${record.time}) '
        '${levelEmojiMapper[record.level.name] ?? record.level.name} '
        '${record.loggerName} ${record.message}',
      );
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    };
  }

  Future<T> readProtected<T>(Future<T> Function() f) async {
    T ret;
    await _mutex.protectRead(() async {
      if (_db == null) {
        return;
      }
      ret = await f();
    });
    return ret;
  }

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
    return readProtected(() {
      _logger.info('getConnectionInfo');
      return _db.connectionEventDao.connectionEvent;
    });
  }

  @override
  Future<void> updateConnectionInfo(Event event) {
    return readProtected(() {
      _logger.info('updateConnectionInfo');
      return _db.connectionEventDao.updateConnectionEvent(event);
    });
  }

  @override
  Future<void> updateLastSyncAt(DateTime lastSyncAt) {
    return readProtected(() {
      _logger.info('updateLastSyncAt');
      return _db.connectionEventDao.updateLastSyncAt(lastSyncAt);
    });
  }

  @override
  Future<DateTime> getLastSyncAt() {
    return readProtected(() {
      _logger.info('getLastSyncAt');
      return _db.connectionEventDao.lastSyncAt;
    });
  }

  @override
  Future<void> deleteChannels(List<String> cids) {
    return readProtected(() {
      _logger.info('deleteChannels');
      return _db.channelDao.deleteChannelByCids(cids);
    });
  }

  @override
  Future<List<String>> getChannelCids() {
    return readProtected(() {
      _logger.info('getChannelCids');
      return _db.channelDao.cids;
    });
  }

  @override
  Future<void> deleteMessageByIds(List<String> messageIds) {
    return readProtected(() {
      _logger.info('deleteMessageByIds');
      return _db.messageDao.deleteMessageByIds(messageIds);
    });
  }

  @override
  Future<void> deletePinnedMessageByIds(List<String> messageIds) {
    return readProtected(() {
      _logger.info('deletePinnedMessageByIds');
      return _db.pinnedMessageDao.deleteMessageByIds(messageIds);
    });
  }

  @override
  Future<void> deleteMessageByCids(List<String> cids) {
    return readProtected(() {
      _logger.info('deleteMessageByCids');
      return _db.messageDao.deleteMessageByCids(cids);
    });
  }

  @override
  Future<void> deletePinnedMessageByCids(List<String> cids) {
    return readProtected(() {
      _logger.info('deletePinnedMessageByCids');
      return _db.pinnedMessageDao.deleteMessageByCids(cids);
    });
  }

  @override
  Future<List<Member>> getMembersByCid(String cid) {
    return readProtected(() {
      _logger.info('getMembersByCid');
      return _db.memberDao.getMembersByCid(cid);
    });
  }

  @override
  Future<ChannelModel> getChannelByCid(String cid) {
    return readProtected(() {
      _logger.info('getChannelByCid');
      return _db.channelDao.getChannelByCid(cid);
    });
  }

  @override
  Future<List<Message>> getMessagesByCid(
    String cid, {
    PaginationParams messagePagination,
  }) {
    return readProtected(() {
      _logger.info('getMessagesByCid');
      return _db.messageDao.getMessagesByCid(
        cid,
        messagePagination: messagePagination,
      );
    });
  }

  @override
  Future<List<Message>> getPinnedMessagesByCid(
    String cid, {
    PaginationParams messagePagination,
  }) {
    return readProtected(() {
      _logger.info('getPinnedMessagesByCid');
      return _db.pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: messagePagination,
      );
    });
  }

  @override
  Future<List<Read>> getReadsByCid(String cid) {
    return readProtected(() {
      _logger.info('getReadsByCid');
      return _db.readDao.getReadsByCid(cid);
    });
  }

  @override
  Future<Map<String, List<Message>>> getChannelThreads(String cid) async {
    return readProtected(() async {
      _logger.info('getChannelThreads');
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
    });
  }

  @override
  Future<List<Message>> getReplies(
    String parentId, {
    PaginationParams options,
  }) {
    return readProtected(() async {
      _logger.info('getReplies');
      return _db.messageDao.getThreadMessagesByParentId(
        parentId,
        options: options,
      );
    });
  }

  @override
  Future<List<ChannelState>> getChannelStates({
    Map<String, dynamic> filter,
    List<SortOption<ChannelModel>> sort = const [],
    PaginationParams paginationParams,
  }) async {
    return readProtected(() async {
      _logger.info('getChannelStates');
      final channels = await _db.channelQueryDao.getChannels(
        filter: filter,
        sort: sort,
        paginationParams: paginationParams,
      );
      return Future.wait(channels.map((e) => getChannelStateByCid(e.cid)));
    });
  }

  @override
  Future<void> updateChannelQueries(
    Map<String, dynamic> filter,
    List<String> cids,
    bool clearQueryCache,
  ) {
    return readProtected(() async {
      _logger.info('updateChannelQueries');
      return _db.channelQueryDao.updateChannelQueries(
        filter,
        cids,
        clearQueryCache,
      );
    });
  }

  @override
  Future<void> updateChannels(List<ChannelModel> channels) {
    return readProtected(() async {
      _logger.info('updateChannels');
      return _db.channelDao.updateChannels(channels);
    });
  }

  @override
  Future<void> updateMembers(String cid, List<Member> members) {
    return readProtected(() async {
      _logger.info('updateMembers');
      return _db.memberDao.updateMembers(cid, members);
    });
  }

  @override
  Future<void> updateMessages(String cid, List<Message> messages) {
    return readProtected(() async {
      _logger.info('updateMessages');
      return _db.messageDao.updateMessages(cid, messages);
    });
  }

  @override
  Future<void> updatePinnedMessages(String cid, List<Message> messages) {
    return readProtected(() async {
      _logger.info('updatePinnedMessages');
      return _db.pinnedMessageDao.updateMessages(cid, messages);
    });
  }

  @override
  Future<void> updateReactions(List<Reaction> reactions) {
    return readProtected(() async {
      _logger.info('updateReactions');
      return _db.reactionDao.updateReactions(reactions);
    });
  }

  @override
  Future<void> updateReads(String cid, List<Read> reads) {
    return readProtected(() async {
      _logger.info('updateReads');
      return _db.readDao.updateReads(cid, reads);
    });
  }

  @override
  Future<void> updateUsers(List<User> users) {
    return readProtected(() async {
      _logger.info('updateUsers');
      return _db.userDao.updateUsers(users);
    });
  }

  @override
  Future<void> deleteReactionsByMessageId(List<String> messageIds) {
    return readProtected(() async {
      _logger.info('deleteReactionsByMessageId');
      return _db.reactionDao.deleteReactionsByMessageIds(messageIds);
    });
  }

  @override
  Future<void> deleteMembersByCids(List<String> cids) {
    return readProtected(() async {
      _logger.info('deleteMembersByCids');
      return _db.memberDao.deleteMemberByCids(cids);
    });
  }

  @override
  Future<void> updateChannelStates(List<ChannelState> channelStates) {
    return readProtected(() async {
      return _db.transaction(() async {
        await super.updateChannelStates(channelStates);
      });
    });
  }

  @override
  Future<void> disconnect({bool flush = false}) async {
    return _mutex.protectWrite(() async {
      _logger.info('disconnect');
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
    });
  }
}
