import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/messages.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';

import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'message_dao.g.dart';

/// The Data Access Object for operations in [Messages] table.
@UseDao(tables: [Messages, Users])
class MessageDao extends DatabaseAccessor<MoorChatDatabase>
    with _$MessageDaoMixin {
  /// Creates a new message dao instance
  MessageDao(this._db) : super(_db);

  final MoorChatDatabase _db;

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

  Future<Message> _messageFromJoinRow(TypedResult rows) async {
    final userEntity = rows.readTableOrNull(_users);
    final pinnedByEntity = rows.readTableOrNull(_pinnedByUsers);
    final msgEntity = rows.readTable(messages);
    final latestReactions = await _db.reactionDao.getReactions(msgEntity.id);
    final ownReactions = await _db.reactionDao.getReactionsByUserId(
      msgEntity.id,
      _db.userId,
    );
    Message? quotedMessage;
    final quotedMessageId = msgEntity.quotedMessageId;
    if (quotedMessageId != null) {
      quotedMessage = await getMessageById(quotedMessageId);
    }
    return msgEntity.toMessage(
      user: userEntity?.toUser(),
      pinnedBy: pinnedByEntity?.toUser(),
      latestReactions: latestReactions,
      ownReactions: ownReactions,
      quotedMessage: quotedMessage,
    );
  }

  /// Returns a single message by matching the [Messages.id] with [id]
  Future<Message?> getMessageById(String id) async =>
      await (select(messages).join([
        leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
        leftOuterJoin(
          _pinnedByUsers,
          messages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
        ),
      ])
            ..where(messages.id.equals(id)))
          .map(_messageFromJoinRow)
          .getSingleOrNull();

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
      if (options?.greaterThanOrEqual != null) {
        final greaterThanIndex = msgList.indexWhere(
          (m) => m.id == options!.greaterThanOrEqual,
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
    PaginationParams? messagePagination,
  }) async {
    final msgList = await Future.wait(await (select(messages).join([
      leftOuterJoin(_users, messages.userId.equalsExp(_users.id)),
      leftOuterJoin(
        _pinnedByUsers,
        messages.pinnedByUserId.equalsExp(_pinnedByUsers.id),
      ),
    ])
          ..where(messages.channelCid.equals(cid))
          ..where(
            messages.parentId.isNull() | messages.showInChannel.equals(true),
          )
          ..orderBy([OrderingTerm.asc(messages.createdAt)]))
        .map(_messageFromJoinRow)
        .get());

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
    Map<String, List<Message>> channelWithMessages,
  ) {
    final entities = channelWithMessages.entries
        .map((entry) => entry.value.map(
              (message) => message.toEntity(cid: entry.key),
            ))
        .expand((it) => it)
        .toList(growable: false);
    return batch(
      (batch) => batch.insertAllOnConflictUpdate(messages, entities),
    );
  }
}
