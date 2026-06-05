import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/messages.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'message_dao.g.dart';

/// The Data Access Object for operations in [Messages] table.
@DriftAccessor(tables: [Messages, Users])
class MessageDao extends DatabaseAccessor<DriftChatDatabase>
    with _$MessageDaoMixin {
  /// Creates a new message dao instance
  MessageDao(this._db) : super(_db);

  final DriftChatDatabase _db;

  $UsersTable get _users => alias(users, 'users');

  $UsersTable get _pinnedByUsers => alias(users, 'pinnedByUsers');

  /// Removes all the messages by matching [Messages.id] in [messageIds]
  ///
  /// This will automatically delete the following linked records
  /// 1. Message Reactions
  Future<int> deleteMessageByIds(List<String> messageIds) =>
      (delete(messages)..where((tbl) => tbl.id.isIn(messageIds))).go();

  /// Removes all the messages by matching [Messages.channelCid] in [cids]
  ///
  /// This will automatically delete the following linked records
  /// 1. Message Reactions
  Future<void> deleteMessageByCids(List<String> cids) async =>
      (delete(messages)..where((tbl) => tbl.channelCid.isIn(cids))).go();

  /// Hydrates `rows` into `Message`s using batched lookups for related
  /// entities. Reactions, polls, and (optionally) quoted messages and drafts
  /// are each fetched once via a single `WHERE ... IN (?).
  Future<List<Message>> _messagesFromJoinRows(
    List<TypedResult> rows, {
    bool fetchDraft = false,
    bool fetchQuotedMessage = true,
  }) async {
    if (rows.isEmpty) return const [];

    final messageIds = <String>[];
    final quotedIds = <String>[];
    final pollIds = <String>[];
    // note: While possible, in real case scenarios this will NOT hold more than
    // a single value.
    final cids = <String>{};
    for (final row in rows) {
      final msg = row.readTable(messages);
      messageIds.add(msg.id);
      if (msg.quotedMessageId case final id?) quotedIds.add(id);
      if (msg.pollId case final id?) pollIds.add(id);
      cids.add(msg.channelCid);
    }

    final results = await Future.wait([
      // Reactions
      _db.reactionDao.getReactionsForMessages(messageIds),
      // Own reactions
      _db.reactionDao.getReactionsForMessagesByUserId(messageIds, _db.userId),
      // Polls
      if (pollIds.isNotEmpty)
        _db.pollDao.getPollsByIds(pollIds)
      else
        Future.value(const <String, Poll?>{}),
      // Drafts
      if (fetchDraft)
        Future.wait([
          for (final cid in cids)
            _db.draftMessageDao
                .getDraftMessagesByParentIds(cid, messageIds)
                .then((map) => MapEntry(cid, map)),
        ]).then(Map.fromEntries)
      else
        Future.value(const <String, Map<String, Draft?>>{}),
    ]);

    final latestReactionsByMsg = results[0] as Map<String, List<Reaction>>;
    final ownReactionsByMsg = results[1] as Map<String, List<Reaction>>;
    final pollsById = results[2] as Map<String, Poll?>;
    final draftsByCidByParentId =
        results[3] as Map<String, Map<String, Draft?>>;

    final quotedById = <String, Message>{};
    if (fetchQuotedMessage && quotedIds.isNotEmpty) {
      final quoteRows = await (select(messages).join([
        leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
        leftOuterJoin(
          _pinnedByUsers,
          messages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
        ),
      ])
            ..where(messages.id.isIn(quotedIds)))
          .get();
      final quotedMessages = await _messagesFromJoinRows(
        quoteRows,
        fetchQuotedMessage: false,
      );
      for (final m in quotedMessages) {
        quotedById[m.id] = m;
      }
    }

    return [
      for (final row in rows)
        _buildMessage(
          row,
          latestReactionsByMsg: latestReactionsByMsg,
          ownReactionsByMsg: ownReactionsByMsg,
          pollsById: pollsById,
          quotedById: quotedById,
          draftsByCidByParentId: draftsByCidByParentId,
        ),
    ];
  }

  /// Builds a single [Message] from a join row + the pre-fetched maps
  /// assembled by [_messagesFromJoinRows].
  Message _buildMessage(
    TypedResult row, {
    required Map<String, List<Reaction>> latestReactionsByMsg,
    required Map<String, List<Reaction>> ownReactionsByMsg,
    required Map<String, Poll?> pollsById,
    required Map<String, Message> quotedById,
    required Map<String, Map<String, Draft?>> draftsByCidByParentId,
  }) {
    final userEntity = row.readTableOrNull(_users);
    final pinnedByEntity = row.readTableOrNull(_pinnedByUsers);
    final msgEntity = row.readTable(messages);

    final quotedMessage = switch (msgEntity.quotedMessageId) {
      final id? => quotedById[id],
      _ => null,
    };
    final poll = switch (msgEntity.pollId) {
      final id? => pollsById[id],
      _ => null,
    };
    final draft = draftsByCidByParentId[msgEntity.channelCid]?[msgEntity.id];

    return msgEntity.toMessage(
      user: userEntity?.toUser(),
      pinnedBy: pinnedByEntity?.toUser(),
      latestReactions: latestReactionsByMsg[msgEntity.id] ?? const [],
      ownReactions: ownReactionsByMsg[msgEntity.id] ?? const [],
      quotedMessage: quotedMessage,
      poll: poll,
      draft: draft,
    );
  }

  /// Returns a single message by matching the [Messages.id] with [id].
  ///
  /// If [fetchDraft] is true, it will also fetch the draft message for the
  /// message.
  Future<Message?> getMessageById(
    String id, {
    bool fetchDraft = true,
  }) async {
    final query = select(messages).join([
      leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        messages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])
      ..where(messages.id.equals(id));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    final hydrated =
        await _messagesFromJoinRows([result], fetchDraft: fetchDraft);
    return hydrated.firstOrNull;
  }

  /// Returns all the messages of a particular thread by matching
  /// [Messages.channelCid] with [cid]
  Future<List<Message>> getThreadMessages(String cid) async {
    final rows = await (select(messages).join([
      leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        messages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])
          ..where(messages.channelCid.equals(cid))
          ..where(messages.parentId.isNotNull())
          ..orderBy([OrderingTerm.asc(messages.createdAt)]))
        .get();
    return _messagesFromJoinRows(rows);
  }

  /// Returns all the messages of a particular thread by matching
  /// [Messages.parentId] with [parentId]
  Future<List<Message>> getThreadMessagesByParentId(
    String parentId, {
    PaginationParams? options,
  }) async {
    final rows = await (select(messages).join([
      leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        messages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])
          ..where(messages.parentId.isNotNull())
          ..where(messages.parentId.equals(parentId))
          ..orderBy([OrderingTerm.asc(messages.createdAt)]))
        .get();
    final msgList = await _messagesFromJoinRows(rows);

    if (msgList.isNotEmpty) {
      final mutable = msgList.toList();
      if (options?.lessThan != null) {
        final lessThanIndex = mutable.indexWhere(
          (m) => m.id == options!.lessThan,
        );
        if (lessThanIndex != -1) {
          mutable.removeRange(lessThanIndex, mutable.length);
        }
      }
      if (options?.greaterThan != null) {
        final greaterThanIndex = mutable.indexWhere(
          (m) => m.id == options!.greaterThan,
        );
        if (greaterThanIndex != -1) {
          mutable.removeRange(0, greaterThanIndex);
        }
      }
      final limit = options?.limit;
      if (limit != null && limit > 0) {
        return mutable.take(limit).toList();
      }
      return mutable;
    }
    return msgList;
  }

  /// Returns all the messages of a channel by matching
  /// [Messages.channelCid] with [parentId]
  Future<List<Message>> getMessagesByCid(
    String cid, {
    bool fetchDraft = true,
    PaginationParams? messagePagination,
  }) async {
    final (
      lessThanCursor,
      lessThanOrEqualCursor,
      greaterThanCursor,
      greaterThanOrEqualCursor,
    ) = await (
      _lookupCursor(messagePagination?.lessThan),
      _lookupCursor(messagePagination?.lessThanOrEqual),
      _lookupCursor(messagePagination?.greaterThan),
      _lookupCursor(messagePagination?.greaterThanOrEqual),
    ).wait;

    // When the caller is paginating forward (greaterThan / greaterThanOrEqual
    // only), order ASC so the SQL `LIMIT` retains the N messages immediately
    // AFTER the cursor. Otherwise order DESC so `LIMIT` retains the N most
    // recent (closest to a `lessThan` cursor, or the channel tail when no
    // cursor is set). The final result is always reshaped to ASC for display.
    final isForwardPagination =
        (greaterThanCursor != null || greaterThanOrEqualCursor != null) &&
            lessThanCursor == null &&
            lessThanOrEqualCursor == null;

    final orderBy = isForwardPagination
        ? [
            OrderingTerm.asc(messages.createdAt),
            OrderingTerm.asc(messages.id),
          ]
        : [
            OrderingTerm.desc(messages.createdAt),
            OrderingTerm.desc(messages.id),
          ];

    final query = select(messages).join([
      leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        messages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])
      ..where(messages.channelCid.equals(cid))
      ..where(messages.parentId.isNull() | messages.showInChannel.equals(true))
      ..orderBy(orderBy);

    // Cursor predicates compare the full `(createdAt, id)` tuple — the same
    // key used in ORDER BY — so messages sharing a `createdAt` with the cursor
    // fall on the correct side of the boundary. Filtering on `createdAt` alone
    // would skip or repeat those siblings across pages.
    if (lessThanCursor case final c?) {
      query.where(
        messages.createdAt.isSmallerThanValue(c.createdAt) |
            (messages.createdAt.equals(c.createdAt) &
                messages.id.isSmallerThanValue(c.id)),
      );
    }
    if (lessThanOrEqualCursor case final c?) {
      query.where(
        messages.createdAt.isSmallerThanValue(c.createdAt) |
            (messages.createdAt.equals(c.createdAt) &
                messages.id.isSmallerOrEqualValue(c.id)),
      );
    }
    if (greaterThanCursor case final c?) {
      query.where(
        messages.createdAt.isBiggerThanValue(c.createdAt) |
            (messages.createdAt.equals(c.createdAt) &
                messages.id.isBiggerThanValue(c.id)),
      );
    }
    if (greaterThanOrEqualCursor case final c?) {
      query.where(
        messages.createdAt.isBiggerThanValue(c.createdAt) |
            (messages.createdAt.equals(c.createdAt) &
                messages.id.isBiggerOrEqualValue(c.id)),
      );
    }

    if (messagePagination != null) {
      query.limit(messagePagination.limit);
    }

    final rows = await query.get();
    final orderedRows = isForwardPagination ? rows : rows.reversed.toList();
    return _messagesFromJoinRows(orderedRows, fetchDraft: fetchDraft);
  }

  /// Updates the message data of a particular channel with
  /// the new [messageList] data
  Future<void> updateMessages(String cid, List<Message> messageList) =>
      bulkUpdateMessages({cid: messageList});

  /// Bulk updates the message data of multiple channels
  Future<void> bulkUpdateMessages(
    Map<String, List<Message>?> channelWithMessages,
  ) {
    final entities = channelWithMessages.entries
        .map((entry) =>
            entry.value?.map(
              (message) => message.toEntity(cid: entry.key),
            ) ??
            [])
        .expand((it) => it)
        .toList(growable: false);
    return batch(
      (batch) => batch.insertAllOnConflictUpdate(messages, entities),
    );
  }

  /// Returns the `(createdAt, id)` cursor for the message with [id] in the
  /// local cache, or `null` if [id] is null, the message isn't cached, or
  /// isn't visible in the channel (i.e. a thread reply with
  /// `showInChannel = false`).
  Future<({DateTime createdAt, String id})?> _lookupCursor(String? id) async {
    if (id == null) return null;
    final createdAt = await (selectOnly(messages)
          ..addColumns([messages.createdAt])
          ..where(messages.id.equals(id))
          ..where(
            messages.parentId.isNull() | messages.showInChannel.equals(true),
          ))
        .map((row) => row.read(messages.createdAt))
        .getSingleOrNull();
    if (createdAt == null) return null;
    return (createdAt: createdAt, id: id);
  }
}
