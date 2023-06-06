import 'package:flutter/foundation.dart';
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

    /// Whether to use an experimental storage implementation on the web
    /// that uses IndexedDB if the current browser supports it.
    /// Otherwise, falls back to the local storage based implementation.
    bool webUseExperimentalIndexedDb = false,
    LogHandlerFunction? logHandlerFunction,
  })  : _connectionMode = connectionMode,
        _webUseIndexedDbIfSupported = webUseExperimentalIndexedDb,
        _logger = Logger.detached('💽')..level = logLevel {
    _logger.onRecord.listen(logHandlerFunction ?? _defaultLogHandler);
  }

  /// [DriftChatDatabase] instance used by this client.
  @visibleForTesting
  DriftChatDatabase? db;

  final Logger _logger;
  final ConnectionMode _connectionMode;
  final bool _webUseIndexedDbIfSupported;

  void _defaultLogHandler(LogRecord record) {
    print(
      '(${record.time}) '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '${record.loggerName} ${record.message}',
    );
    if (record.stackTrace != null) print(record.stackTrace);
  }

  bool get _debugIsConnected {
    assert(() {
      if (!isConnected) {
        throw StateError('''
        $runtimeType hasn't been connected yet or used after `disconnect` 
        was called. Consider calling `connect` to create a connection. 
          ''');
      }
      return true;
    }(), '');
    return true;
  }

  Future<DriftChatDatabase> _defaultDatabaseProvider(
    String userId,
    ConnectionMode mode,
  ) =>
      SharedDB.constructDatabase(
        userId,
        connectionMode: mode,
        webUseIndexedDbIfSupported: _webUseIndexedDbIfSupported,
      );

  @override
  bool get isConnected => db != null;

  @override
  String? get userId => db?.userId;

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
    _logger.info('connect');
    db = databaseProvider?.call(userId, _connectionMode) ??
        await _defaultDatabaseProvider(userId, _connectionMode);
  }

  @override
  Future<Event?> getConnectionInfo() {
    assert(_debugIsConnected, '');
    _logger.info('getConnectionInfo');
    return db!.connectionEventDao.connectionEvent;
  }

  @override
  Future<void> updateConnectionInfo(Event event) {
    assert(_debugIsConnected, '');
    _logger.info('updateConnectionInfo');
    return db!.connectionEventDao.updateConnectionEvent(event);
  }

  @override
  Future<void> updateLastSyncAt(DateTime lastSyncAt) {
    assert(_debugIsConnected, '');
    _logger.info('updateLastSyncAt');
    return db!.connectionEventDao.updateLastSyncAt(lastSyncAt);
  }

  @override
  Future<DateTime?> getLastSyncAt() {
    assert(_debugIsConnected, '');
    _logger.info('getLastSyncAt');
    return db!.connectionEventDao.lastSyncAt;
  }

  @override
  Future<void> deleteChannels(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.info('deleteChannels');
    return db!.channelDao.deleteChannelByCids(cids);
  }

  @override
  Future<List<String>> getChannelCids() {
    assert(_debugIsConnected, '');
    _logger.info('getChannelCids');
    return db!.channelDao.cids;
  }

  @override
  Future<void> deleteMessageByIds(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.info('deleteMessageByIds');
    return db!.messageDao.deleteMessageByIds(messageIds);
  }

  @override
  Future<void> deletePinnedMessageByIds(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.info('deletePinnedMessageByIds');
    return db!.pinnedMessageDao.deleteMessageByIds(messageIds);
  }

  @override
  Future<void> deleteMessageByCids(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.info('deleteMessageByCids');
    return db!.messageDao.deleteMessageByCids(cids);
  }

  @override
  Future<void> deletePinnedMessageByCids(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.info('deletePinnedMessageByCids');
    return db!.pinnedMessageDao.deleteMessageByCids(cids);
  }

  @override
  Future<List<Member>> getMembersByCid(String cid) {
    assert(_debugIsConnected, '');
    _logger.info('getMembersByCid');
    return db!.memberDao.getMembersByCid(cid);
  }

  @override
  Future<ChannelModel?> getChannelByCid(String cid) {
    assert(_debugIsConnected, '');
    _logger.info('getChannelByCid');
    return db!.channelDao.getChannelByCid(cid);
  }

  @override
  Future<List<Message>> getMessagesByCid(
    String cid, {
    PaginationParams? messagePagination,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('getMessagesByCid');
    return db!.messageDao.getMessagesByCid(
      cid,
      messagePagination: messagePagination,
    );
  }

  @override
  Future<List<Message>> getPinnedMessagesByCid(
    String cid, {
    PaginationParams? messagePagination,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('getPinnedMessagesByCid');
    return db!.pinnedMessageDao.getMessagesByCid(
      cid,
      messagePagination: messagePagination,
    );
  }

  @override
  Future<List<Read>> getReadsByCid(String cid) async {
    assert(_debugIsConnected, '');
    _logger.info('getReadsByCid');
    return db!.readDao.getReadsByCid(cid);
  }

  @override
  Future<Map<String, List<Message>>> getChannelThreads(String cid) async {
    assert(_debugIsConnected, '');
    _logger.info('getChannelThreads');
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
  }

  @override
  Future<List<Message>> getReplies(
    String parentId, {
    PaginationParams? options,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('getReplies');
    return db!.messageDao.getThreadMessagesByParentId(
      parentId,
      options: options,
    );
  }

  @override
  Future<List<ChannelState>> getChannelStates({
    Filter? filter,
    @Deprecated('''
    sort has been deprecated. 
    Please use channelStateSort instead.''') List<SortOption<ChannelModel>>? sort,
    List<SortOption<ChannelState>>? channelStateSort,
    PaginationParams? paginationParams,
  }) async {
    assert(_debugIsConnected, '');
    assert(
      sort == null || channelStateSort == null,
      'sort and channelStateSort cannot be used together',
    );
    _logger.info('getChannelStates');

    final channels = await db!.channelQueryDao.getChannels(
      filter: filter,
      sort: sort,
    );

    final channelStates = await Future.wait(
      channels.map((e) => getChannelStateByCid(e.cid)),
    );

    // Only sort the channel states if the channels are not already sorted.
    if (sort == null) {
      var comparator = _defaultChannelStateComparator;
      if (channelStateSort != null && channelStateSort.isNotEmpty) {
        comparator = _combineComparators(
          channelStateSort.map((it) => it.comparator).withNullifyer,
        );
      }

      channelStates.sort(comparator);
    }

    final offset = paginationParams?.offset;
    if (offset != null && offset > 0 && channelStates.isNotEmpty) {
      channelStates.removeRange(0, offset);
    }

    if (paginationParams?.limit != null) {
      return channelStates.take(paginationParams!.limit).toList();
    }

    return channelStates;
  }

  @override
  Future<void> updateChannelQueries(
    Filter? filter,
    List<String> cids, {
    bool clearQueryCache = false,
  }) {
    assert(_debugIsConnected, '');
    _logger.info('updateChannelQueries');
    return db!.channelQueryDao.updateChannelQueries(
      filter,
      cids,
      clearQueryCache: clearQueryCache,
    );
  }

  @override
  Future<void> updateChannels(List<ChannelModel> channels) {
    assert(_debugIsConnected, '');
    _logger.info('updateChannels');
    return db!.channelDao.updateChannels(channels);
  }

  @override
  Future<void> bulkUpdateMembers(Map<String, List<Member>?> members) {
    assert(_debugIsConnected, '');
    _logger.info('bulkUpdateMembers');
    return db!.memberDao.bulkUpdateMembers(members);
  }

  @override
  Future<void> bulkUpdateMessages(Map<String, List<Message>?> messages) {
    assert(_debugIsConnected, '');
    _logger.info('bulkUpdateMessages');
    return db!.messageDao.bulkUpdateMessages(messages);
  }

  @override
  Future<void> bulkUpdatePinnedMessages(Map<String, List<Message>?> messages) {
    assert(_debugIsConnected, '');
    _logger.info('bulkUpdatePinnedMessages');
    return db!.pinnedMessageDao.bulkUpdateMessages(messages);
  }

  @override
  Future<void> updatePinnedMessageReactions(List<Reaction> reactions) {
    assert(_debugIsConnected, '');
    _logger.info('updatePinnedMessageReactions');
    return db!.pinnedMessageReactionDao.updateReactions(reactions);
  }

  @override
  Future<void> updateReactions(List<Reaction> reactions) {
    assert(_debugIsConnected, '');
    _logger.info('updateReactions');
    return db!.reactionDao.updateReactions(reactions);
  }

  @override
  Future<void> bulkUpdateReads(Map<String, List<Read>?> reads) {
    assert(_debugIsConnected, '');
    _logger.info('bulkUpdateReads');
    return db!.readDao.bulkUpdateReads(reads);
  }

  @override
  Future<void> updateUsers(List<User> users) {
    assert(_debugIsConnected, '');
    _logger.info('updateUsers');
    return db!.userDao.updateUsers(users);
  }

  @override
  Future<void> deletePinnedMessageReactionsByMessageId(
    List<String> messageIds,
  ) {
    assert(_debugIsConnected, '');
    _logger.info('deletePinnedMessageReactionsByMessageId');
    return db!.pinnedMessageReactionDao.deleteReactionsByMessageIds(messageIds);
  }

  @override
  Future<void> deleteReactionsByMessageId(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.info('deleteReactionsByMessageId');
    return db!.reactionDao.deleteReactionsByMessageIds(messageIds);
  }

  @override
  Future<void> deleteMembersByCids(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.info('deleteMembersByCids');
    return db!.memberDao.deleteMemberByCids(cids);
  }

  @override
  Future<void> updateChannelThreads(
    String cid,
    Map<String, List<Message>> threads,
  ) {
    assert(_debugIsConnected, '');
    _logger.info('updateChannelThreads');
    return db!.transaction(() => super.updateChannelThreads(cid, threads));
  }

  @override
  Future<void> updateChannelStates(List<ChannelState> channelStates) {
    assert(_debugIsConnected, '');
    _logger.info('updateChannelStates');
    return db!.transaction(() => super.updateChannelStates(channelStates));
  }

  @override
  Future<void> disconnect({bool flush = false}) async {
    _logger.info('disconnect');
    if (isConnected) {
      _logger.info('Disconnecting');
      if (flush) {
        _logger.info('Flushing');
        await db!.flush();
      }
      await db!.disconnect();
      db = null;
    }
  }
}

// Creates a new combined [Comparator] which sorts items
// by the given [comparators].
Comparator<T> _combineComparators<T>(Iterable<Comparator<T>> comparators) {
  return (T a, T b) {
    for (final comparator in comparators) {
      try {
        final result = comparator(a, b);
        if (result != 0) return result;
      } catch (e) {
        // If the comparator throws an exception, we ignore it and
        // continue with the next comparator.
        continue;
      }
    }
    return 0;
  };
}

// The default [Comparator] used to sort [ChannelState]s.
int _defaultChannelStateComparator(ChannelState a, ChannelState b) {
  final dateA = a.channel?.lastMessageAt ?? a.channel?.createdAt;
  final dateB = b.channel?.lastMessageAt ?? b.channel?.createdAt;

  if (dateA == null && dateB == null) return 0;
  if (dateA == null) return 1;
  if (dateB == null) {
    return -1;
  } else {
    return dateB.compareTo(dateA);
  }
}
