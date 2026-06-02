// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_message_dao.dart';

// ignore_for_file: type=lint
mixin _$DraftMessageDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $DraftMessagesTable get draftMessages => attachedDatabase.draftMessages;
  $MessagesTable get messages => attachedDatabase.messages;
  DraftMessageDaoManager get managers => DraftMessageDaoManager(this);
}

class DraftMessageDaoManager {
  final _$DraftMessageDaoMixin _db;
  DraftMessageDaoManager(this._db);
  $$DraftMessagesTableTableManager get draftMessages =>
      $$DraftMessagesTableTableManager(_db.attachedDatabase, _db.draftMessages);
  $$MessagesTableTableManager get messages => $$MessagesTableTableManager(_db.attachedDatabase, _db.messages);
}
