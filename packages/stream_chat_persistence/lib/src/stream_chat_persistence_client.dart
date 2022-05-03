import 'package:flutter/foundation.dart';
import 'package:mutex/mutex.dart';
import 'package:stream_chat/stream_chat.dart';

import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Various connection modes on which [StreamChatPersistenceClient] can work
enum ConnectionMode {
  /// Connects the [StreamChatPersistenceClient] on a regular/default isolate
  regular,

  /// Connects the [StreamChatPersistenceClient] on a background isolate
  background,
}

/// Signature for a function which provides instance of [DriftChatDatabase]
typedef DatabaseProvider = DriftChatDatabase Function(String, ConnectionMode);

final _levelEmojiMapper = {
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
};

/// A [DriftChatDatabase] based implementation of the [ChatPersistenceClient]
class StreamChatPersistenceClient extends ChatPersistenceClient {
  /// Creates a new instance of the stream chat persistence client
  StreamChatPersistenceClient({
    /// Connection mode on which the client will work
    ConnectionMode connectionMode = ConnectionMode.regular,
    Level logLevel = Level.WARNING,
    LogHandlerFunction? logHandlerFunction,
  })  : _connectionMode = connectionMode,
        _logger = Logger.detached('💽')..level = logLevel {
    _logger.onRecord.listen(logHandlerFunction ?? _defaultLogHandler);
  }

  /// [DriftChatDatabase] instance used by this client.
  @visibleForTesting
  DriftChatDatabase? db;

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

  Future<T> _readProtected<T>(AsyncValueGetter<T> func) =>
      _mutex.protectRead(func);

  bool get _debugIsConnected {
    assert(() {
      if (db == null) {
        throw StateError('''
        $runtimeType hasn't been connected yet or used after `disconnect` 
        was called. Consider calling `connect` to create a connection. 
          ''');
      }
      return true;
    }(), '');
    return true;
  }

  DriftChatDatabase _defaultDatabaseProvider(
    String userId,
    ConnectionMode mode,
  ) =>
      SharedDB.constructDatabase(userId, connectionMode: mode);

  @override
  Future<void> connect(
    String userId, {
    DatabaseProvider? databaseProvider, // Used only for testing
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
  Future<Event?> getConnectionInfo() {
    assert(_debugIsConnected, '');
    _logger.info('getConnectionInfo');
    return _readProtected(() => db!.connectionEventDao.connectionEvent);
  }

  @override
  Future<void> updateConnectionInfo(Event event) {
    assert(_debugIsConnected, '');
    _logger.info('updateConnectionInfo');
    return _readProtected(
      () => db!.connectionEventDao.updateConnectionEvent(event),
    );
  }

  @override
  Future<void> updateLastSyncAt(DateTime lastSyncAt) {
    assert(_debugIsConnected, '');
    _logger.info('updateLastSyncAt');
    return _readProtected(
      () => db!.connectionEventDao.updateLastSyncAt(lastSyncAt),
    );
  }

  @override
  Future<DateTime?> getLastSyncAt() {
    assert(_debugIsConnected, '');
    _logger.info('getLastSyncAt');
    return _readProtected(() => db!.connectionEventDao.lastSyncAt);
  }

  @override
  Future<void> deleteChannels(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.info('deleteChannels');
    return _readProtected(() => db!.channelDao.deleteChannelByCids(cids));
  }

  @override
  Future<List<String>> getChannelCids() {
    assert(_debugIsConnected, '');
    _logger.info('getChannelCids');
    return _readProtected(() => db!.channelDao.cids);
  }

  @override
  Future<void> deleteMessageByIds(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.info('deleteMessageByIds');
    return _readProtected(() => db!.messageDao.deleteMessageByIds(messageIds));
  }

  @override
  Future<void> deletePinnedMessageByIds(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.info('deletePinnedMessageByIds');
    return _readProtected(
      () => db!.pinnedMessageDao.deleteMessageByIds(messageIds),
    );
  }

  @override
  Future<void> deleteMessageByCids(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.info('deleteMessageByCids');
    return _readProtected(() => db!.messageDao.deleteMessageByCids(cids));
  }

  @override
  Future<void> deletePinnedMessageByCids(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.info('deletePinnedMessageByCids');
    return _readProtected(() => db!.pinnedMessageDao.deleteMessageByCids(cids));
  }

  @override
  Future<List<Member>> getMembersByCid(String cid) {
    assert(_debugIsConnected, '');
    _logger.info('getMembersByCid');
    return _readProtected(() => db!.memberDao.getMembersByCid(cid));
  }

  @override
  Future<ChannelModel?> getChannelByCid(String cid) {
    assert(_debugIsConnected, '');
    _logger.info('getChannelByCid');
    return _readProtected(() => db!.channelDao.getChannelByCid(cid));
  }

  @override
  Future<List<Message>> getMessagesByCid(
    String cid, {
    PaginationParams? messagePagination,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('getMessagesByCid');
    return _readProtected(
      () => db!.messageDao.getMessagesByCid(
        cid,
        messagePagination: messagePagination,
      ),
    );
  }

  @override
  Future<List<Message>> getPinnedMessagesByCid(
    String cid, {
    PaginationParams? messagePagination,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('getPinnedMessagesByCid');
    return _readProtected(
      () => db!.pinnedMessageDao.getMessagesByCid(
        cid,
        messagePagination: messagePagination,
      ),
    );
  }

  @override
  Future<List<Read>> getReadsByCid(String cid) {
    assert(_debugIsConnected, '');
    _logger.info('getReadsByCid');
    return _readProtected(() => db!.readDao.getReadsByCid(cid));
  }

  @override
  Future<Map<String, List<Message>>> getChannelThreads(String cid) {
    assert(_debugIsConnected, '');
    _logger.info('getChannelThreads');
    return _readProtected(() async {
      final messages = await db!.messageDao.getThreadMessages(cid);
      final messageByParentIdDictionary = <String, List<Message>>{};
      for (final message in messages) {
        final parentId = message.parentId!;
        messageByParentIdDictionary[parentId] = [
          ...messageByParentIdDictionary[parentId] ?? [],
          message,
        ];
      }
      return messageByParentIdDictionary;
    });
  }

  @override
  Future<List<Message>> getReplies(
    String parentId, {
    PaginationParams? options,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('getReplies');
    return _readProtected(
      () => db!.messageDao.getThreadMessagesByParentId(
        parentId,
        options: options,
      ),
    );
  }

  @override
  Future<List<ChannelState>> getChannelStates({
    Filter? filter,
    List<SortOption<ChannelModel>>? sort,
    PaginationParams? paginationParams,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('getChannelStates');
    return _readProtected(
      () async {
        final channels = await db!.channelQueryDao.getChannels(
          filter: filter,
          sort: sort,
          paginationParams: paginationParams,
        );
        return Future.wait(channels.map((e) => getChannelStateByCid(e.cid)));
      },
    );
  }

  @override
  Future<void> updateChannelQueries(
    Filter? filter,
    List<String> cids, {
    bool clearQueryCache = false,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('updateChannelQueries');
    return _readProtected(
      () => db!.channelQueryDao.updateChannelQueries(
        filter,
        cids,
        clearQueryCache: clearQueryCache,
      ),
    );
  }

  @override
  Future<void> updateChannels(List<ChannelModel> channels) {
    assert(_debugIsConnected, '');
    _logger.info('updateChannels');
    return _readProtected(() => db!.channelDao.updateChannels(channels));
  }

  @override
  Future<void> bulkUpdateMembers(Map<String, List<Member>?> members) {
    assert(_debugIsConnected, '');
    _logger.info('bulkUpdateMembers');
    return _readProtected(() => db!.memberDao.bulkUpdateMembers(members));
  }

  @override
  Future<void> bulkUpdateMessages(Map<String, List<Message>?> messages) {
    assert(_debugIsConnected, '');
    _logger.info('bulkUpdateMessages');
    return _readProtected(() => db!.messageDao.bulkUpdateMessages(messages));
  }

  @override
  Future<void> bulkUpdatePinnedMessages(Map<String, List<Message>?> messages) {
    assert(_debugIsConnected, '');
    _logger.info('bulkUpdatePinnedMessages');
    return _readProtected(
      () => db!.pinnedMessageDao.bulkUpdateMessages(messages),
    );
  }

  @override
  Future<void> updatePinnedMessageReactions(List<Reaction> reactions) {
    assert(_debugIsConnected, '');
    _logger.info('updatePinnedMessageReactions');
    return _readProtected(
      () => db!.pinnedMessageReactionDao.updateReactions(reactions),
    );
  }

  @override
  Future<void> updateReactions(List<Reaction> reactions) {
    assert(_debugIsConnected, '');
    _logger.info('updateReactions');
    return _readProtected(() => db!.reactionDao.updateReactions(reactions));
  }

  @override
  Future<void> bulkUpdateReads(Map<String, List<Read>?> reads) {
    assert(_debugIsConnected, '');
    _logger.info('bulkUpdateReads');
    return _readProtected(() => db!.readDao.bulkUpdateReads(reads));
  }

  @override
  Future<void> updateUsers(List<User> users) {
    assert(_debugIsConnected, '');
    _logger.info('updateUsers');
    return _readProtected(() => db!.userDao.updateUsers(users));
  }

  @override
  Future<void> deletePinnedMessageReactionsByMessageId(
    List<String> messageIds,
  ) {
    assert(_debugIsConnected, '');
    _logger.info('deletePinnedMessageReactionsByMessageId');
    return _readProtected(
      () =>
          db!.pinnedMessageReactionDao.deleteReactionsByMessageIds(messageIds),
    );
  }

  @override
  Future<void> deleteReactionsByMessageId(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.info('deleteReactionsByMessageId');
    return _readProtected(
      () => db!.reactionDao.deleteReactionsByMessageIds(messageIds),
    );
  }

  @override
  Future<void> deleteMembersByCids(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.info('deleteMembersByCids');
    return _readProtected(() => db!.memberDao.deleteMemberByCids(cids));
  }

  @override
  Future<void> updateChannelStates(List<ChannelState> channelStates) {
    assert(_debugIsConnected, '');
    _logger.info('updateChannelStates');
    return _readProtected(
      () async => db!.transaction(
        () async {
          await super.updateChannelStates(channelStates);
        },
      ),
    );
  }

  @override
  Future<void> disconnect({bool flush = false}) async =>
      _mutex.protectWrite(() async {
        _logger.info('disconnect');
        if (db != null) {
          _logger.info('Disconnecting');
          if (flush) {
            _logger.info('Flushing');
            await db!.flush();
          }
          await db!.disconnect();
          db = null;
        }
      });
}
