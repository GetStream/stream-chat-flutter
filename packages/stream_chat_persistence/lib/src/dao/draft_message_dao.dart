// ignore_for_file: join_return_with_assignment

import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/entity.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'draft_message_dao.g.dart';

/// The Data Access Object for operations in [DraftMessages] table.
@DriftAccessor(tables: [DraftMessages, Messages])
class DraftMessageDao extends DatabaseAccessor<DriftChatDatabase>
    with _$DraftMessageDaoMixin {
  /// Creates a new draft message dao instance
  DraftMessageDao(this._db) : super(_db);

  final DriftChatDatabase _db;

  Future<Draft> _draftFromEntity(DraftMessageEntity entity) async {
    // We do not want to fetch the draft and shared location of the parent and
    // quoted message because it will create a circular dependency and will
    // result in infinite loop.
    const fetchDraft = false;
    const fetchSharedLocation = false;

    final parentMessage = await switch (entity.parentId) {
      final id? => _db.messageDao.getMessageById(
          id,
          fetchDraft: fetchDraft,
          fetchSharedLocation: fetchSharedLocation,
        ),
      _ => null,
    };

    final quotedMessage = await switch (entity.quotedMessageId) {
      final id? => _db.messageDao.getMessageById(
          id,
          fetchDraft: fetchDraft,
          fetchSharedLocation: fetchSharedLocation,
        ),
      _ => null,
    };

    final poll = await switch (entity.pollId) {
      final id? => _db.pollDao.getPollById(id),
      _ => null,
    };

    return entity.toDraft(
      parentMessage: parentMessage,
      quotedMessage: quotedMessage,
      poll: poll,
    );
  }

  /// Returns the draft message by matching [DraftMessages.channelCid].
  ///
  /// Note: This will skip the thread draft messages.
  Future<Draft?> getDraftMessageByCid(
    String cid, {
    String? parentId,
  }) async {
    final query = select(draftMessages)
      ..where((tbl) {
        var filter = tbl.channelCid.equals(cid);
        filter &= tbl.parentId.equalsNullable(parentId);

        return filter;
      });

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return _draftFromEntity(result);
  }

  /// Updates the draft message data of a particular channel with
  /// the new [messageList] data.
  Future<void> updateDraftMessages(List<Draft> draftMessageList) {
    return transaction(() async {
      for (final draftMessage in draftMessageList) {
        final entity = draftMessage.toEntity();

        // Find and delete existing drafts with the same channelCid
        // and parentId (if any).
        await deleteDraftMessageByCid(
          entity.channelCid,
          parentId: entity.parentId,
        );

        // Insert the new draft message.
        await into(draftMessages).insertOnConflictUpdate(entity);
      }
    });
  }

  /// Deletes the draft message by matching [DraftMessages.channelCid] and
  /// [DraftMessages.parentId].
  Future<void> deleteDraftMessageByCid(
    String cid, {
    String? parentId,
  }) {
    final query = delete(draftMessages)
      ..where((tbl) {
        var filter = tbl.channelCid.equals(cid);
        filter &= tbl.parentId.equalsNullable(parentId);

        return filter;
      });

    return query.go();
  }

  /// Deletes all the draft messages by matching [DraftMessages.channelCid]
  /// with the given list of [cids].
  Future<void> deleteDraftMessagesByCids(List<String> cids) =>
      (delete(draftMessages)..where((tbl) => tbl.channelCid.isIn(cids))).go();
}
