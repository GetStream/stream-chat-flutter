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

  Future<Message> _messageFromJoinRow(
    TypedResult rows, {
    bool fetchDraft = false,
  }) async {
    final userEntity = rows.readTableOrNull(_users);
    final pinnedByEntity = rows.readTableOrNull(_pinnedByUsers);
    final msgEntity = rows.readTable(messages);
    final latestReactions = await _db.reactionDao.getReactions(msgEntity.id);
    final ownReactions = await _db.reactionDao.getReactionsByUserId(
      msgEntity.id,
      _db.userId,
    );

    final quotedMessage = await switch (msgEntity.quotedMessageId) {
      final id? => getMessageById(id),
      _ => null,
    };

    final poll = await switch (msgEntity.pollId) {
      final id? => _db.pollDao.getPollById(id),
      _ => null,
    };

    final draft = await switch (fetchDraft) {
      true => _db.draftMessageDao.getDraftMessageByCid(
          msgEntity.channelCid,
          parentId: msgEntity.id,
        ),
      _ => null,
    };

    return msgEntity.toMessage(
      user: userEntity?.toUser(),
      pinnedBy: pinnedByEntity?.toUser(),
      latestReactions: latestReactions,
      ownReactions: ownReactions,
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

    return _messageFromJoinRow(
      result,
      fetchDraft: fetchDraft,
    );
  }

  /// Returns all the messages of a particular thread by matching
  /// [Messages.channelCid] with [cid]
  Future<List<Message>> getThreadMessages(String cid) async =>
      Future.wait(await (select(messages).join([
        leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
        leftOuterJoin(
          _pinnedByUsers,
          messages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
        ),
      ])
            ..where(messages.channelCid.equals(cid))
            ..where(messages.parentId.isNotNull())
            ..orderBy([OrderingTerm.asc(messages.createdAt)]))
          .map(_messageFromJoinRow)
          .get());

  /// Returns all the messages of a particular thread by matching
  /// [Messages.parentId] with [parentId]
  Future<List<Message>> getThreadMessagesByParentId(
    String parentId, {
    PaginationParams? options,
  }) async {
    final (
      lessThanCursor,
      lessThanOrEqualCursor,
      greaterThanCursor,
      greaterThanOrEqualCursor,
    ) = await (
      _lookupThreadCursor(parentId, options?.lessThan),
      _lookupThreadCursor(parentId, options?.lessThanOrEqual),
      _lookupThreadCursor(parentId, options?.greaterThan),
      _lookupThreadCursor(parentId, options?.greaterThanOrEqual),
    ).wait;

    // When the caller is paginating forward (greaterThan / greaterThanOrEqual
    // only), order ASC so the SQL `LIMIT` retains the N replies immediately
    // AFTER the cursor. Otherwise order DESC so `LIMIT` retains the N replies
    // closest to a `lessThan` cursor (or the thread's tail when no cursor is
    // set). The final result is always reshaped to ASC for display.
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
      ..where(messages.parentId.equals(parentId))
      ..orderBy(orderBy);

    // Cursor predicates compare the full `(createdAt, id)` tuple — the same
    // key used in ORDER BY — so replies sharing a `createdAt` with the cursor
    // fall on the correct side of the boundary. Filtering on `createdAt`
    // alone would skip or repeat those siblings across pages.
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

    if (options != null) {
      query.limit(options.limit);
    }

    final rows = await query.get();
    final orderedRows = isForwardPagination ? rows : rows.reversed.toList();

    return Future.wait(orderedRows.map(_messageFromJoinRow));
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

    return Future.wait(
      orderedRows
          .map((row) => _messageFromJoinRow(row, fetchDraft: fetchDraft)),
    );
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

  /// Returns the `(createdAt, id)` cursor for the thread reply with [id]
  /// under [parentId] in the local cache, or `null` if [id] is null or no
  /// such reply is cached.
  Future<({DateTime createdAt, String id})?> _lookupThreadCursor(
    String parentId,
    String? id,
  ) async {
    if (id == null) return null;
    final createdAt = await (selectOnly(messages)
          ..addColumns([messages.createdAt])
          ..where(messages.id.equals(id))
          ..where(messages.parentId.equals(parentId)))
        .map((row) => row.read(messages.createdAt))
        .getSingleOrNull();
    if (createdAt == null) return null;
    return (createdAt: createdAt, id: id);
  }
}
