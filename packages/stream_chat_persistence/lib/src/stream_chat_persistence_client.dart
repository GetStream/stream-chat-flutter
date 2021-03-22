import 'package:logging/logging.dart' show LogRecord;
import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';
import 'package:stream_chat/stream_chat.dart';

import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// Various connection modes on which [StreamChatPersistenceClient] can work
enum ConnectionMode {
  /// Connects the [StreamChatPersistenceClient] on a regular/default isolate
  regular,

  /// Connects the [StreamChatPersistenceClient] on a background isolate
  background,
}

/// Signature for a function which provides instance of [MoorChatDatabase]
typedef DatabaseProvider = MoorChatDatabase Function(String, ConnectionMode);

final _levelEmojiMapper = {
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
};

/// A [MoorChatDatabase] based implementation of the [ChatPersistenceClient]
class StreamChatPersistenceClient extends ChatPersistenceClient {
  /// Creates a new instance of the stream chat persistence client
  StreamChatPersistenceClient({
    /// Connection mode on which the client will work
    ConnectionMode connectionMode = ConnectionMode.regular,
    Level logLevel = Level.WARNING,
    LogHandlerFunction logHandlerFunction,
  })  : assert(connectionMode != null, 'ConnectionMode cannot be null'),
        assert(logLevel != null, 'LogLevel cannot be null'),
        _connectionMode = connectionMode,
        _logger = Logger.detached('💽')..level = logLevel {
    _logger.onRecord.listen(logHandlerFunction ?? _defaultLogHandler);
  }

  /// [MoorChatDatabase] instance used by this client.
  @visibleForTesting
  MoorChatDatabase db;

  final Logger _logger;
  final ConnectionMode _connectionMode;
  final _mutex = ReadWriteMutex();

  void _defaultLogHandler(LogRecord record) {
    print(
      '(${record.time}) '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '${record.loggerName} ${record.message}',
    );
    if (record.stackTrace != null) print(record.stackTrace);
  }

  Future<T> _readProtected<T>(Future<T> Function() f) async {
    T ret;
    await _mutex.protectRead(() async {
      if (db == null) {
        return;
      }
      ret = await f();
    });
    return ret;
  }

  MoorChatDatabase _defaultDatabaseProvider(
    String userId,
    ConnectionMode mode,
  ) =>
      SharedDB.constructDatabase(userId, connectionMode: mode);

  @override
  Future<void> connect(
    String userId, {
    DatabaseProvider databaseProvider, // Used only for testing
  }) async {
    if (db != null) {
      throw Exception(
        'An instance of StreamChatDatabase is already connected.\n'
        'disconnect the previous instance before connecting again.',
      );
    }
    db = databaseProvider?.call(userId, _connectionMode) ??
        _defaultDatabaseProvider(userId, _connectionMode);
  }

  @override
  Future<Event> getConnectionInfo() => _readProtected(() {
        _logger.info('getConnectionInfo');
        return db.connectionEventDao.connectionEvent;
      });

  @override
  Future<void> updateConnectionInfo(Event event) => _readProtected(() {
        _logger.info('updateConnectionInfo');
        return db.connectionEventDao.updateConnectionEvent(event);
      });

  @override
  Future<void> updateLastSyncAt(DateTime lastSyncAt) => _readProtected(() {
        _logger.info('updateLastSyncAt');
        return db.connectionEventDao.updateLastSyncAt(lastSyncAt);
      });

  @override
  Future<DateTime> getLastSyncAt() => _readProtected(() {
        _logger.info('getLastSyncAt');
        return db.connectionEventDao.lastSyncAt;
      });

  @override
  Future<void> deleteChannels(List<String> cids) => _readProtected(() {
        _logger.info('deleteChannels');
        return db.channelDao.deleteChannelByCids(cids);
      });

  @override
  Future<List<String>> getChannelCids() => _readProtected(() {
        _logger.info('getChannelCids');
        return db.channelDao.cids;
      });

  @override
  Future<void> deleteMessageByIds(List<String> messageIds) =>
      _readProtected(() {
        _logger.info('deleteMessageByIds');
        return db.messageDao.deleteMessageByIds(messageIds);
      });

  @override
  Future<void> deletePinnedMessageByIds(List<String> messageIds) =>
      _readProtected(() {
        _logger.info('deletePinnedMessageByIds');
        return db.pinnedMessageDao.deleteMessageByIds(messageIds);
      });

  @override
  Future<void> deleteMessageByCids(List<String> cids) => _readProtected(() {
        _logger.info('deleteMessageByCids');
        return db.messageDao.deleteMessageByCids(cids);
      });

  @override
  Future<void> deletePinnedMessageByCids(List<String> cids) =>
      _readProtected(() {
        _logger.info('deletePinnedMessageByCids');
        return db.pinnedMessageDao.deleteMessageByCids(cids);
      });

  @override
  Future<List<Member>> getMembersByCid(String cid) => _readProtected(() {
        _logger.info('getMembersByCid');
        return db.memberDao.getMembersByCid(cid);
      });

  @override
  Future<ChannelModel> getChannelByCid(String cid) => _readProtected(() {
        _logger.info('getChannelByCid');
        return db.channelDao.getChannelByCid(cid);
      });

  @override
  Future<List<Message>> getMessagesByCid(
    String cid, {
    PaginationParams messagePagination,
  }) =>
      _readProtected(() {
        _logger.info('getMessagesByCid');
        return db.messageDao.getMessagesByCid(
          cid,
          messagePagination: messagePagination,
        );
      });

  @override
  Future<List<Message>> getPinnedMessagesByCid(
    String cid, {
    PaginationParams messagePagination,
  }) =>
      _readProtected(() {
        _logger.info('getPinnedMessagesByCid');
        return db.pinnedMessageDao.getMessagesByCid(
          cid,
          messagePagination: messagePagination,
        );
      });

  @override
  Future<List<Read>> getReadsByCid(String cid) => _readProtected(() {
        _logger.info('getReadsByCid');
        return db.readDao.getReadsByCid(cid);
      });

  @override
  Future<Map<String, List<Message>>> getChannelThreads(String cid) async =>
      _readProtected(() async {
        _logger.info('getChannelThreads');
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
      });

  @override
  Future<List<Message>> getReplies(
    String parentId, {
    PaginationParams options,
  }) =>
      _readProtected(() async {
        _logger.info('getReplies');
        return db.messageDao.getThreadMessagesByParentId(
          parentId,
          options: options,
        );
      });

  @override
  Future<List<ChannelState>> getChannelStates({
    Map<String, dynamic> filter,
    List<SortOption<ChannelModel>> sort = const [],
    PaginationParams paginationParams,
  }) async =>
      _readProtected(() async {
        _logger.info('getChannelStates');
        final channels = await db.channelQueryDao.getChannels(
          filter: filter,
          sort: sort,
          paginationParams: paginationParams,
        );
        return Future.wait(channels.map((e) => getChannelStateByCid(e.cid)));
      });

  @override
  Future<void> updateChannelQueries(
    Map<String, dynamic> filter,
    List<String> cids, {
    bool clearQueryCache = false,
  }) =>
      _readProtected(() async {
        _logger.info('updateChannelQueries');
        return db.channelQueryDao.updateChannelQueries(
          filter,
          cids,
          clearQueryCache: clearQueryCache,
        );
      });

  @override
  Future<void> updateChannels(List<ChannelModel> channels) =>
      _readProtected(() async {
        _logger.info('updateChannels');
        return db.channelDao.updateChannels(channels);
      });

  @override
  Future<void> updateMembers(String cid, List<Member> members) =>
      _readProtected(() async {
        _logger.info('updateMembers');
        return db.memberDao.updateMembers(cid, members);
      });

  @override
  Future<void> updateMessages(String cid, List<Message> messages) =>
      _readProtected(() async {
        _logger.info('updateMessages');
        return db.messageDao.updateMessages(cid, messages);
      });

  @override
  Future<void> updatePinnedMessages(String cid, List<Message> messages) =>
      _readProtected(() async {
        _logger.info('updatePinnedMessages');
        return db.pinnedMessageDao.updateMessages(cid, messages);
      });

  @override
  Future<void> updateReactions(List<Reaction> reactions) =>
      _readProtected(() async {
        _logger.info('updateReactions');
        return db.reactionDao.updateReactions(reactions);
      });

  @override
  Future<void> updateReads(String cid, List<Read> reads) =>
      _readProtected(() async {
        _logger.info('updateReads');
        return db.readDao.updateReads(cid, reads);
      });

  @override
  Future<void> updateUsers(List<User> users) => _readProtected(() async {
        _logger.info('updateUsers');
        return db.userDao.updateUsers(users);
      });

  @override
  Future<void> deleteReactionsByMessageId(List<String> messageIds) =>
      _readProtected(() async {
        _logger.info('deleteReactionsByMessageId');
        return db.reactionDao.deleteReactionsByMessageIds(messageIds);
      });

  @override
  Future<void> deleteMembersByCids(List<String> cids) =>
      _readProtected(() async {
        _logger.info('deleteMembersByCids');
        return db.memberDao.deleteMemberByCids(cids);
      });

  @override
  Future<void> updateChannelStates(List<ChannelState> channelStates) =>
      _readProtected(() async => db.transaction(() async {
            await super.updateChannelStates(channelStates);
          }));

  @override
  Future<void> disconnect({bool flush = false}) async =>
      _mutex.protectWrite(() async {
        _logger.info('disconnect');
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
      });
}
