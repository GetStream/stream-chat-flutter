import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/messages.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import '../mapper/mapper.dart';

part 'message_dao.g.dart';

///
@UseDao(tables: [Messages, Users])
class MessageDao extends DatabaseAccessor<MoorChatDatabase>
    with _$MessageDaoMixin {
  ///
  MessageDao(this._db) : super(_db);

  final MoorChatDatabase _db;

  /// Removes all the messages by matching [messages.id] in [messageIds]
  ///
  /// This will automatically delete the following linked records
  /// 1. Message Reactions
  Future<void> deleteMessageByIds(List<String> messageIds) {
    return (delete(messages)..where((tbl) => tbl.id.isIn(messageIds))).go();
  }

  /// Removes all the messages by matching [messages.channelCid] in [cids]
  ///
  /// This will automatically delete the following linked records
  /// 1. Message Reactions
  Future<void> deleteMessageByCids(List<String> cids) async {
    return (delete(messages)..where((tbl) => tbl.channelCid.isIn(cids))).go();
  }

  Future<Message> _messageFromJoinRow(TypedResult rows) async {
    final userEntity = rows.readTable(users);
    final msgEntity = rows.readTable(messages);
    final latestReactions = await _db.reactionDao.getReactions(msgEntity.id);
    final ownReactions = await _db.reactionDao.getOwnReactions(
      msgEntity.id,
      userEntity.id,
    );
    Message quotedMessage;
    if (msgEntity.quotedMessageId != null) {
      quotedMessage = await getMessageById(msgEntity.quotedMessageId);
    }
    return msgEntity.toMessage(
      user: userEntity?.toUser(),
      latestReactions: latestReactions,
      ownReactions: ownReactions,
      quotedMessage: quotedMessage,
    );
  }

  ///
  Future<Message> getMessageById(String id) async {
    return await (select(messages).join([
      leftOuterJoin(users, messages.userId.equalsExp(users.id)),
    ])
          ..where(messages.id.equals(id)))
        .map(_messageFromJoinRow)
        .getSingle();
  }

  ///
  Future<List<Message>> getThreadMessages(String cid) async {
    return Future.wait(await (select(messages).join([
      leftOuterJoin(users, messages.userId.equalsExp(users.id)),
    ])
          ..where(messages.channelCid.equals(cid))
          ..where(isNotNull(messages.parentId))
          ..orderBy([OrderingTerm.asc(messages.createdAt)]))
        .map(_messageFromJoinRow)
        .get());
  }

  ///
  Future<List<Message>> getThreadMessagesByParentId(
    String parentId, {
    String lessThan,
  }) async {
    final msgList = await Future.wait(await (select(messages).join([
      innerJoin(users, messages.userId.equalsExp(users.id)),
    ])
          ..where(messages.parentId.equals(parentId))
          ..orderBy([OrderingTerm.asc(messages.createdAt)]))
        .map(_messageFromJoinRow)
        .get());

    if (lessThan != null) {
      final lessThanIndex = msgList.indexWhere((m) => m.id == lessThan);
      msgList.removeRange(lessThanIndex, msgList.length);
    }
    return msgList;
  }

  ///
  Future<List<Message>> getMessagesByCid(
    String cid, {
    int limit = 20,
    String messageLessThan,
    String messageGreaterThan,
  }) async {
    final msgList = await Future.wait(await (select(messages).join([
      leftOuterJoin(users, messages.userId.equalsExp(users.id)),
    ])
          ..where(messages.channelCid.equals(cid))
          ..where(
              isNull(messages.parentId) | messages.showInChannel.equals(true))
          ..orderBy([OrderingTerm.asc(messages.createdAt)]))
        .map(_messageFromJoinRow)
        .get());

    if (messageLessThan != null) {
      final lessThanIndex = msgList.indexWhere((m) => m.id == messageLessThan);
      if (lessThanIndex != -1) {
        msgList.removeRange(lessThanIndex, msgList.length);
      }
    }
    if (messageGreaterThan != null) {
      final greaterThanIndex =
          msgList.indexWhere((m) => m.id == messageGreaterThan);
      if (greaterThanIndex != -1) {
        msgList.removeRange(0, greaterThanIndex);
      }
    }
    if (limit != null) {
      return msgList.take(limit).toList();
    }
    return msgList;
  }

  ///
  Future<int> updateMessages(String cid, List<Message> messageList) {
    return batch((batch) {
      batch.insertAll(
        messages,
        messageList.map((it) => it.toEntity(cid: cid)).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}
