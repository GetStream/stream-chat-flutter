import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/pinned_messages.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';

import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'pinned_message_dao.g.dart';

/// The Data Access Object for operations in [Messages] table.
@DriftAccessor(tables: [PinnedMessages, Users])
class PinnedMessageDao extends DatabaseAccessor<DriftChatDatabase>
    with _$PinnedMessageDaoMixin {
  /// Creates a new message dao instance
  PinnedMessageDao(this._db) : super(_db);

  final DriftChatDatabase _db;

  $UsersTable get _users => alias(users, 'users');

  $UsersTable get _pinnedByUsers => alias(users, 'pinnedByUsers');

  /// Removes all the messages by matching [PinnedMessages.id] in [messageIds]
  ///
  /// This will automatically delete the following linked records
  /// 1. Message Reactions
  Future<void> deleteMessageByIds(List<String> messageIds) =>
      (delete(pinnedMessages)..where((tbl) => tbl.id.isIn(messageIds))).go();

  /// Removes all the messages by matching [PinnedMessages.channelCid] in [cids]
  ///
  /// This will automatically delete the following linked records
  /// 1. Message Reactions
  Future<void> deleteMessageByCids(List<String> cids) async =>
      (delete(pinnedMessages)..where((tbl) => tbl.channelCid.isIn(cids))).go();

  Future<Message> _messageFromJoinRow(
    TypedResult rows, {
    bool fetchDraft = false,
  }) async {
    final userEntity = rows.readTableOrNull(_users);
    final pinnedByEntity = rows.readTableOrNull(_pinnedByUsers);
    final msgEntity = rows.readTable(pinnedMessages);
    final latestReactions =
        await _db.pinnedMessageReactionDao.getReactions(msgEntity.id);
    final ownReactions =
        await _db.pinnedMessageReactionDao.getReactionsByUserId(
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

  /// Returns a single message by matching the [PinnedMessages.id] with [id]
  Future<Message?> getMessageById(
    String id, {
    bool fetchDraft = true,
  }) async {
    final query = select(pinnedMessages).join([
      leftOuterJoin(_users, pinnedMessages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        pinnedMessages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])
      ..where(pinnedMessages.id.equals(id));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return _messageFromJoinRow(
      result,
      fetchDraft: fetchDraft,
    );
  }

  /// Returns all the messages of a particular thread by matching
  /// [PinnedMessages.channelCid] with [cid]
  Future<List<Message>> getThreadMessages(String cid) async =>
      Future.wait(await (select(pinnedMessages).join([
        leftOuterJoin(_users, pinnedMessages.userId.equalsExp(_users.id)),
        leftOuterJoin(
          _pinnedByUsers,
          pinnedMessages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
        ),
      ])
            ..where(pinnedMessages.channelCid.equals(cid))
            ..where(pinnedMessages.parentId.isNotNull())
            ..orderBy([OrderingTerm.asc(pinnedMessages.createdAt)]))
          .map(_messageFromJoinRow)
          .get());

  /// Returns all the messages of a particular thread by matching
  /// [PinnedMessages.parentId] with [parentId]
  Future<List<Message>> getThreadMessagesByParentId(
    String parentId, {
    PaginationParams? options,
  }) async {
    final msgList = await Future.wait(await (select(pinnedMessages).join([
      leftOuterJoin(_users, pinnedMessages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        pinnedMessages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])
          ..where(pinnedMessages.parentId.isNotNull())
          ..where(pinnedMessages.parentId.equals(parentId))
          ..orderBy([OrderingTerm.asc(pinnedMessages.createdAt)]))
        .map(_messageFromJoinRow)
        .get());

    if (msgList.isNotEmpty) {
      if (options?.lessThan != null) {
        final lessThanIndex = msgList.indexWhere(
          (m) => m.id == options!.lessThan,
        );
        if (lessThanIndex != -1) {
          msgList.removeRange(lessThanIndex, msgList.length);
        }
      }
      if (options?.greaterThanOrEqual != null) {
        final greaterThanIndex = msgList.indexWhere(
          (m) => m.id == options!.greaterThanOrEqual,
        );
        if (greaterThanIndex != -1) {
          msgList.removeRange(0, greaterThanIndex);
        }
      }
      if (options?.limit != null) {
        return msgList.take(options!.limit).toList();
      }
    }
    return msgList;
  }

  /// Returns all the messages of a channel by matching
  /// [PinnedMessages.channelCid] with [parentId]
  Future<List<Message>> getMessagesByCid(
    String cid, {
    bool fetchDraft = true,
    PaginationParams? messagePagination,
  }) async {
    final query = select(pinnedMessages).join([
      leftOuterJoin(_users, pinnedMessages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        pinnedMessages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])
      ..where(pinnedMessages.channelCid.equals(cid))
      ..where(pinnedMessages.parentId.isNull() |
          pinnedMessages.showInChannel.equals(true))
      ..orderBy([OrderingTerm.asc(pinnedMessages.createdAt)]);

    final result = await query.get();
    if (result.isEmpty) return [];

    final msgList = await Future.wait(
      result.map(
        (row) => _messageFromJoinRow(
          row,
          fetchDraft: fetchDraft,
        ),
      ),
    );

    if (msgList.isNotEmpty) {
      if (messagePagination?.lessThan != null) {
        final lessThanIndex = msgList.indexWhere(
          (m) => m.id == messagePagination!.lessThan,
        );
        if (lessThanIndex != -1) {
          msgList.removeRange(lessThanIndex, msgList.length);
        }
      }
      if (messagePagination?.greaterThanOrEqual != null) {
        final greaterThanIndex = msgList.indexWhere(
          (m) => m.id == messagePagination!.greaterThanOrEqual,
        );
        if (greaterThanIndex != -1) {
          msgList.removeRange(0, greaterThanIndex);
        }
      }
      if (messagePagination?.limit != null) {
        return msgList.take(messagePagination!.limit).toList();
      }
    }
    return msgList;
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
              (message) => message.toPinnedEntity(cid: entry.key),
            ) ??
            [])
        .expand((it) => it)
        .toList(growable: false);
    return batch(
      (batch) => batch.insertAllOnConflictUpdate(pinnedMessages, entities),
    );
  }
}
