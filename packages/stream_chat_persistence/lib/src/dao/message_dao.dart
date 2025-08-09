import 'dart:math';

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
    final msgList = await Future.wait(await (select(messages).join([
      leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        messages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])
          ..where(messages.parentId.isNotNull())
          ..where(messages.parentId.equals(parentId))
          ..orderBy([OrderingTerm.asc(messages.createdAt)]))
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
      if (options?.greaterThan != null) {
        final greaterThanIndex = msgList.indexWhere(
          (m) => m.id == options!.greaterThan,
        );
        if (greaterThanIndex != -1) {
          msgList.removeRange(0, greaterThanIndex);
        }
      }
      final limit = options?.limit;
      if (limit != null && limit > 0) {
        return msgList.take(limit).toList();
      }
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
    final query = select(messages).join([
      leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        messages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])
      ..where(messages.channelCid.equals(cid))
      ..where(messages.parentId.isNull() | messages.showInChannel.equals(true))
      ..orderBy([OrderingTerm.asc(messages.createdAt)]);

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
      if (messagePagination?.greaterThan != null) {
        final greaterThanIndex = msgList.indexWhere(
          (m) => m.id == messagePagination!.greaterThan,
        );
        if (greaterThanIndex != -1) {
          msgList.removeRange(0, greaterThanIndex);
        }
      }
      if (messagePagination?.limit != null) {
        return msgList
            .skip(max(0, msgList.length - messagePagination!.limit))
            .toList();
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
              (message) => message.toEntity(cid: entry.key),
            ) ??
            [])
        .expand((it) => it)
        .toList(growable: false);
    return batch(
      (batch) => batch.insertAllOnConflictUpdate(messages, entities),
    );
  }
}
