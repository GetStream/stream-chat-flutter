import 'package:flutter/foundation.dart';
import 'package:stream_chat/stream_chat.dart';
import 'db/drift_chat_database.dart';

/// Various connection modes on which [StreamChatPersistenceClient] can work
enum ConnectionMode {
  /// Connects the [StreamChatPersistenceClient] on a regular/default isolate
  regular,

  /// Connects the [StreamChatPersistenceClient] on a background isolate
  background,
}

/// Signature for a function which provides instance of [DriftChatDatabase]
typedef DatabaseProvider = DriftChatDatabase Function(String, ConnectionMode);

/// A [DriftChatDatabase] based implementation of the [ChatPersistenceClient]
class StreamChatPersistenceClient extends ChatPersistenceClient {
  /// Creates a new instance of the stream chat persistence client
  StreamChatPersistenceClient({
    /// Connection mode on which the client will work
    this._connectionMode = ConnectionMode.regular,

    /// Whether to use an experimental storage implementation on the web
    /// that uses IndexedDB if the current browser supports it.
    /// Otherwise, falls back to the local storage based implementation.
    bool webUseExperimentalIndexedDb = false,
  }) : _webUseIndexedDbIfSupported = webUseExperimentalIndexedDb;

  /// [DriftChatDatabase] instance used by this client.
  @visibleForTesting
  DriftChatDatabase? db;

  static const _logger = StreamLogger('SCh:Persistence');
  final ConnectionMode _connectionMode;
  final bool _webUseIndexedDbIfSupported;

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
  ) => SharedDB.constructDatabase(
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
    _logger.v(() => 'connect');
    db = databaseProvider?.call(userId, _connectionMode) ?? await _defaultDatabaseProvider(userId, _connectionMode);
  }

  @override
  Future<Event?> getConnectionInfo() {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getConnectionInfo');
    return db!.connectionEventDao.connectionEvent;
  }

  @override
  Future<void> updateConnectionInfo(Event event) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updateConnectionInfo');
    return db!.connectionEventDao.updateConnectionEvent(event);
  }

  @override
  Future<void> updateLastSyncAt(DateTime lastSyncAt) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updateLastSyncAt');
    return db!.connectionEventDao.updateLastSyncAt(lastSyncAt);
  }

  @override
  Future<DateTime?> getLastSyncAt() {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getLastSyncAt');
    return db!.connectionEventDao.lastSyncAt;
  }

  @override
  Future<void> deleteChannels(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deleteChannels');
    return db!.channelDao.deleteChannelByCids(cids);
  }

  @override
  Future<List<String>> getChannelCids() {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getChannelCids');
    return db!.channelDao.cids;
  }

  @override
  Future<void> deleteMessageByIds(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deleteMessageByIds');
    return db!.messageDao.deleteMessageByIds(messageIds);
  }

  @override
  Future<void> deletePinnedMessageByIds(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deletePinnedMessageByIds');
    return db!.pinnedMessageDao.deleteMessageByIds(messageIds);
  }

  @override
  Future<void> deleteMessageByCids(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deleteMessageByCids');
    return db!.messageDao.deleteMessageByCids(cids);
  }

  @override
  Future<void> deletePinnedMessageByCids(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deletePinnedMessageByCids');
    return db!.pinnedMessageDao.deleteMessageByCids(cids);
  }

  @override
  Future<List<Member>> getMembersByCid(String cid) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getMembersByCid');
    return db!.memberDao.getMembersByCid(cid);
  }

  @override
  Future<ChannelModel?> getChannelByCid(String cid) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getChannelByCid');
    return db!.channelDao.getChannelByCid(cid);
  }

  @override
  Future<List<Message>> getMessagesByCid(
    String cid, {
    PaginationParams? messagePagination,
  }) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getMessagesByCid');
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
    _logger.v(() => 'getPinnedMessagesByCid');
    return db!.pinnedMessageDao.getMessagesByCid(
      cid,
      messagePagination: messagePagination,
    );
  }

  @override
  Future<void> deleteMessagesFromUser({
    String? cid,
    required String userId,
    bool hardDelete = false,
    DateTime? deletedAt,
  }) async {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deleteMessagesFromUser');

    // Delete from both messages and pinned_messages tables
    await Future.wait(
      [
        db!.messageDao.deleteMessagesByUser,
        db!.pinnedMessageDao.deleteMessagesByUser,
      ].map(
        (f) => f.call(
          cid: cid,
          userId: userId,
          hardDelete: hardDelete,
          deletedAt: deletedAt,
        ),
      ),
    );
  }

  @override
  Future<Draft?> getDraftMessageByCid(
    String cid, {
    String? parentId,
  }) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getDraftMessageByCid');
    return db!.draftMessageDao.getDraftMessageByCid(
      cid,
      parentId: parentId,
    );
  }

  @override
  Future<List<Location>> getLocationsByCid(String cid) async {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getLocationsByCid');
    return db!.locationDao.getLocationsByCid(cid);
  }

  @override
  Future<Location?> getLocationByMessageId(String messageId) async {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getLocationByMessageId');
    return db!.locationDao.getLocationByMessageId(messageId);
  }

  @override
  Future<List<Read>> getReadsByCid(String cid) async {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getReadsByCid');
    return db!.readDao.getReadsByCid(cid);
  }

  @override
  Future<Map<String, List<Message>>> getChannelThreads(String cid) async {
    assert(_debugIsConnected, '');
    _logger.v(() => 'getChannelThreads');
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
    _logger.v(() => 'getReplies');
    return db!.messageDao.getThreadMessagesByParentId(
      parentId,
      options: options,
    );
  }

  /// Drift-backed implementation of
  /// [ChatPersistenceClient.getChannelStates].
  @Deprecated('Use queryChannelStates instead')
  @override
  Future<List<ChannelState>> getChannelStates({
    Filter? filter,
    List<ChannelSort>? channelStateSort,
    int? messageLimit,
    PaginationParams? paginationParams,
  }) async {
    final res = await queryChannelStates(
      filter: filter,
      sort: channelStateSort,
      messageLimit: messageLimit,
      paginationParams: paginationParams,
    );
    return res.channels;
  }

  /// Drift-backed implementation of
  /// [ChatPersistenceClient.queryChannelStates].
  @override
  Future<QueryChannelsResponse> queryChannelStates({
    Filter? filter,
    List<ChannelSort>? sort,
    String? predefinedFilter,
    Map<String, Object?>? filterValues,
    Map<String, Object?>? sortValues,
    int? messageLimit,
    PaginationParams? paginationParams,
  }) async {
    assert(_debugIsConnected, '');
    _logger.v(() => 'queryChannelStates');
    if (predefinedFilter != null) {
      final (channelModels, resolvedFilter, resolvedSort) = await db!.channelQueryDao
          .getChannelsAndSpecByPredefinedFilter(
            predefinedFilter,
            filterValues: filterValues,
            sortValues: sortValues,
          );

      final channels = await _getChannelStatesPage(
        channelModels,
        resolvedSort,
        paginationParams,
        messageLimit: messageLimit,
      );
      final spec = resolvedFilter == null
          ? null
          : PredefinedFilter(
              name: predefinedFilter,
              filter: resolvedFilter,
              sort: resolvedSort,
            );

      return QueryChannelsResponse()
        ..channels = channels
        ..predefinedFilter = spec;
    }

    final channelModels = await db!.channelQueryDao.getChannels(filter: filter);
    final channels = await _getChannelStatesPage(
      channelModels,
      sort,
      paginationParams,
      messageLimit: messageLimit,
    );
    return QueryChannelsResponse()..channels = channels;
  }

  // Wraps channel models in sort envelopes, attaches memberships when the
  // sort needs them, sorts, slices the requested page, and hydrates only the
  // page with full channel state.
  Future<List<ChannelState>> _getChannelStatesPage(
    List<ChannelModel> channelModels,
    List<ChannelSort>? channelStateSort,
    PaginationParams? paginationParams, {
    int? messageLimit,
  }) async {
    // A cached read has no server to defer to, and the rows arrive in whatever
    // order the cid lookup returned.
    final sort = switch (channelStateSort) {
      null || [] => ChannelSort.defaultSort,
      final channelStateSort => channelStateSort,
    };

    // 1) Wrap each model in a sort envelope. No state loaded yet.
    var envelopes = channelModels.map((m) => ChannelState(channel: m)).toList(growable: false);

    // 2) If sort uses `pinnedAt`, preload the current user's memberships in
    //    one batched query and attach them to the envelopes.
    final clientUserId = userId;
    if (clientUserId != null && _sortRequiresMembership(sort)) {
      envelopes = await _attachMemberships(envelopes, clientUserId);
    }

    // 3) Sort using the comparator — on envelopes instead of fully-hydrated
    //    states.
    envelopes.sort(sort.compare);

    // 4) Slice the page.
    final total = envelopes.length;
    final offset = (paginationParams?.offset ?? 0).clamp(0, total);
    final limit = paginationParams?.limit ?? (total - offset);
    final pagedCids = envelopes.skip(offset).take(limit).map((s) => s.channel!.cid).toList();

    // 5) Hydrate ONLY the page.
    final messagePagination = PaginationParams(
      // Default limit is set to 25 in backend.
      limit: messageLimit ?? 25,
    );
    return Future.wait(pagedCids.map((cid) => getChannelStateByCid(cid, messagePagination: messagePagination)));
  }

  /// Drift-backed implementation of
  /// [ChatPersistenceClient.updateChannelQueries].
  @Deprecated('Use saveChannelQueries instead')
  @override
  Future<void> updateChannelQueries(
    Filter? filter,
    List<String> cids, {
    bool clearQueryCache = false,
  }) {
    return saveChannelQueries(
      cids: cids,
      filter: filter,
      clearQueryCache: clearQueryCache,
    );
  }

  /// Drift-backed implementation of
  /// [ChatPersistenceClient.saveChannelQueries].
  @override
  Future<void> saveChannelQueries({
    required List<String> cids,
    Filter? filter,
    List<ChannelSort>? sort,
    String? predefinedFilter,
    Filter? resolvedFilter,
    List<ChannelSort>? resolvedSort,
    Map<String, Object?>? filterValues,
    Map<String, Object?>? sortValues,
    bool clearQueryCache = false,
  }) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'saveChannelQueries');
    if (predefinedFilter != null) {
      return db!.channelQueryDao.updateChannelQueriesByPredefinedFilter(
        predefinedFilter,
        cids,
        filter: resolvedFilter ?? const Filter.empty(),
        sort: resolvedSort ?? const [],
        filterValues: filterValues,
        sortValues: sortValues,
        clearQueryCache: clearQueryCache,
      );
    }
    // Standard path's DAO hash currently keys on `filter` only; `sort` is
    // accepted at the public API but not consumed here.
    return db!.channelQueryDao.updateChannelQueries(
      filter,
      cids,
      clearQueryCache: clearQueryCache,
    );
  }

  @override
  Future<void> updateChannels(List<ChannelModel> channels) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updateChannels');
    return db!.channelDao.updateChannels(channels);
  }

  @override
  Future<void> updateDraftMessages(List<Draft> draftMessages) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updateDraftMessages');
    return db!.draftMessageDao.updateDraftMessages(draftMessages);
  }

  @override
  Future<void> updatePolls(List<Poll> polls) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updatePolls');
    return db!.pollDao.updatePolls(polls);
  }

  @override
  Future<void> deletePollsByIds(List<String> pollIds) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deletePollsByIds');
    return db!.pollDao.deletePollsByIds(pollIds);
  }

  @override
  Future<void> bulkUpdateMembers(Map<String, List<Member>?> members) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'bulkUpdateMembers');
    return db!.memberDao.bulkUpdateMembers(members);
  }

  @override
  Future<void> bulkUpdateMessages(Map<String, List<Message>?> messages) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'bulkUpdateMessages');
    return db!.messageDao.bulkUpdateMessages(messages);
  }

  @override
  Future<void> bulkUpdatePinnedMessages(Map<String, List<Message>?> messages) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'bulkUpdatePinnedMessages');
    return db!.pinnedMessageDao.bulkUpdateMessages(messages);
  }

  @override
  Future<void> updatePollVotes(List<PollVote> pollVotes) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updatePollVotes');
    return db!.pollVoteDao.updatePollVotes(pollVotes);
  }

  @override
  Future<void> updatePinnedMessageReactions(List<Reaction> reactions) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updatePinnedMessageReactions');
    return db!.pinnedMessageReactionDao.updateReactions(reactions);
  }

  @override
  Future<void> updateReactions(List<Reaction> reactions) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updateReactions');
    return db!.reactionDao.updateReactions(reactions);
  }

  @override
  Future<void> bulkUpdateReads(Map<String, List<Read>?> reads) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'bulkUpdateReads');
    return db!.readDao.bulkUpdateReads(reads);
  }

  @override
  Future<void> updateUsers(List<User> users) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updateUsers');
    return db!.userDao.updateUsers(users);
  }

  @override
  Future<void> updateLocations(List<Location> locations) async {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updateLocations');
    return db!.locationDao.updateLocations(locations);
  }

  @override
  Future<void> deletePinnedMessageReactionsByMessageId(
    List<String> messageIds,
  ) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deletePinnedMessageReactionsByMessageId');
    return db!.pinnedMessageReactionDao.deleteReactionsByMessageIds(messageIds);
  }

  @override
  Future<void> deleteReactionsByMessageId(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deleteReactionsByMessageId');
    return db!.reactionDao.deleteReactionsByMessageIds(messageIds);
  }

  @override
  Future<void> deletePollVotesByPollIds(List<String> pollIds) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deletePollVotesByPollIds');
    return db!.pollVoteDao.deletePollVotesByPollIds(pollIds);
  }

  @override
  Future<void> deleteMembersByCids(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deleteMembersByCids');
    return db!.memberDao.deleteMemberByCids(cids);
  }

  @override
  Future<void> deleteDraftMessagesByCids(List<String> cids) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deleteDraftMessagesByCids');
    return db!.draftMessageDao.deleteDraftMessagesByCids(cids);
  }

  @override
  Future<void> deleteDraftMessageByCid(
    String cid, {
    String? parentId,
  }) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deleteDraftMessageByCid');
    return db!.draftMessageDao.deleteDraftMessageByCid(
      cid,
      parentId: parentId,
    );
  }

  @override
  Future<void> deleteLocationsByCid(String cid) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deleteLocationsByCid');
    return db!.locationDao.deleteLocationsByCid(cid);
  }

  @override
  Future<void> deleteLocationsByMessageIds(List<String> messageIds) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'deleteLocationsByMessageIds');
    return db!.locationDao.deleteLocationsByMessageIds(messageIds);
  }

  @override
  Future<void> updateChannelThreads(
    String cid,
    Map<String, List<Message>> threads,
  ) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updateChannelThreads');
    return db!.transaction(() => super.updateChannelThreads(cid, threads));
  }

  @override
  Future<void> updateChannelStates(List<ChannelState> channelStates) {
    assert(_debugIsConnected, '');
    _logger.v(() => 'updateChannelStates');
    return db!.transaction(() => super.updateChannelStates(channelStates));
  }

  @override
  Future<void> flush() {
    assert(_debugIsConnected, '');
    _logger.v(() => 'flush');
    return db!.flush();
  }

  @override
  Future<void> disconnect({bool flush = false}) async {
    _logger.v(() => 'disconnect');
    if (isConnected) {
      _logger.v(() => 'Disconnecting');
      if (flush) {
        _logger.v(() => 'Flushing');
        await db!.flush();
      }
      await db!.disconnect();
      db = null;
    }
  }

  bool _sortRequiresMembership(List<ChannelSort>? sort) {
    return sort?.any((it) => it.field.remote == ChannelSortField.pinnedAt.remote) ?? false;
  }

  Future<List<ChannelState>> _attachMemberships(
    List<ChannelState> envelopes,
    String currentUserId,
  ) async {
    final cids = envelopes.map((s) => s.channel?.cid).whereType<String>().toList(growable: false);
    final memberships = await db!.memberDao.getMembershipsForChannels(
      cids,
      currentUserId,
    );
    return [
      for (final s in envelopes) s.copyWith(membership: memberships[s.channel?.cid]),
    ];
  }
}
