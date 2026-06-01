// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_message_dao.dart';

// ignore_for_file: type=lint
mixin _$DraftMessageDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $ChannelsTable get channels => attachedDatabase.channels;
  $MessagesTable get messages => attachedDatabase.messages;
  $DraftMessagesTable get draftMessages => attachedDatabase.draftMessages;
  DraftMessageDaoManager get managers => DraftMessageDaoManager(this);
}

class DraftMessageDaoManager {
  final _$DraftMessageDaoMixin _db;
  DraftMessageDaoManager(this._db);
  $$ChannelsTableTableManager get channels =>
      $$ChannelsTableTableManager(_db.attachedDatabase, _db.channels);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db.attachedDatabase, _db.messages);
  $$DraftMessagesTableTableManager get draftMessages =>
      $$DraftMessagesTableTableManager(_db.attachedDatabase, _db.draftMessages);
}
