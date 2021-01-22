part of 'offline_storage.dart';

@DataClassName('ChannelQuery')
class _ChannelQueries extends Table {
  TextColumn get queryHash => text()();

  TextColumn get channelCid => text()();

  @override
  Set<Column> get primaryKey => {
        queryHash,
        channelCid,
      };
}

class _Channels extends Table {
  TextColumn get id => text()();

  TextColumn get type => text()();

  TextColumn get cid => text()();

  TextColumn get config => text()();

  BoolColumn get frozen => boolean().withDefault(Constant(false))();

  DateTimeColumn get lastMessageAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  IntColumn get memberCount => integer().nullable()();

  TextColumn get extraData => text().nullable().map(_ExtraDataConverter())();

  TextColumn get createdBy => text().nullable()();

  @override
  Set<Column> get primaryKey => {cid};
}

class _ConnectionEvent extends Table {
  IntColumn get id => integer()();

  TextColumn get ownUser => text().nullable().map(_ExtraDataConverter())();

  IntColumn get totalUnreadCount => integer().nullable()();

  IntColumn get unreadChannels => integer().nullable()();

  DateTimeColumn get lastEventAt => dateTime().nullable()();

  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class _Users extends Table {
  TextColumn get id => text()();

  TextColumn get role => text().nullable()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get lastActive => dateTime().nullable()();

  BoolColumn get online => boolean().nullable()();

  BoolColumn get banned => boolean().nullable()();

  TextColumn get extraData => text().nullable().map(_ExtraDataConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class _Reads extends Table {
  DateTimeColumn get lastRead => dateTime()();

  TextColumn get userId => text()();

  TextColumn get channelCid => text()();

  IntColumn get unreadMessages => integer().nullable()();

  @override
  Set<Column> get primaryKey => {
        userId,
        channelCid,
      };
}

class _Reactions extends Table {
  TextColumn get messageId => text()();

  TextColumn get type => text()();

  DateTimeColumn get createdAt => dateTime()();

  IntColumn get score => integer().nullable()();

  TextColumn get userId => text()();

  TextColumn get extraData => text().nullable().map(_ExtraDataConverter())();

  @override
  Set<Column> get primaryKey => {
        messageId,
        type,
        userId,
      };
}

class _Messages extends Table {
  TextColumn get id => text()();

  TextColumn get messageText => text().nullable()();

  TextColumn get attachmentJson => text().nullable()();

  IntColumn get status =>
      integer().map(_MessageSendingStatusConverter()).nullable()();

  TextColumn get type => text().nullable()();

  List<User> mentionedUsers;

  TextColumn get reactionCounts =>
      text().nullable().map(_ExtraDataConverter<int>())();

  TextColumn get reactionScores =>
      text().nullable().map(_ExtraDataConverter<int>())();

  TextColumn get parentId => text().nullable()();

  TextColumn get quotedMessageId => text().nullable()();

  IntColumn get replyCount => integer().nullable()();

  BoolColumn get showInChannel => boolean().nullable()();

  BoolColumn get shadowed => boolean().nullable()();

  TextColumn get command => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  TextColumn get userId => text().nullable()();

  TextColumn get channelCid => text().nullable()();

  TextColumn get extraData => text().nullable().map(_ExtraDataConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class _Members extends Table {
  TextColumn get userId => text()();

  TextColumn get channelCid => text()();

  TextColumn get role => text().nullable()();

  DateTimeColumn get inviteAcceptedAt => dateTime().nullable()();

  DateTimeColumn get inviteRejectedAt => dateTime().nullable()();

  BoolColumn get invited => boolean().nullable()();

  BoolColumn get banned => boolean().nullable()();

  BoolColumn get shadowBanned => boolean().nullable()();

  BoolColumn get isModerator => boolean().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {
        userId,
        channelCid,
      };
}

class _ExtraDataConverter<T> extends TypeConverter<Map<String, T>, String> {
  @override
  Map<String, T> mapToDart(fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Map<String, T>.from(jsonDecode(fromDb) ?? {});
  }

  @override
  String mapToSql(value) {
    return jsonEncode(value);
  }
}

class _MessageSendingStatusConverter
    extends TypeConverter<MessageSendingStatus, int> {
  @override
  MessageSendingStatus mapToDart(int fromDb) {
    switch (fromDb) {
      case 0:
        return MessageSendingStatus.sending;
      case 1:
        return MessageSendingStatus.sent;
      case 2:
        return MessageSendingStatus.failed;
      case 3:
        return MessageSendingStatus.updating;
      case 4:
        return MessageSendingStatus.failed_update;
      case 5:
        return MessageSendingStatus.deleting;
      case 6:
        return MessageSendingStatus.failed_delete;
      default:
        return null;
    }
  }

  @override
  int mapToSql(MessageSendingStatus value) {
    switch (value) {
      case MessageSendingStatus.sending:
        return 0;
      case MessageSendingStatus.sent:
        return 1;
      case MessageSendingStatus.failed:
        return 2;
      case MessageSendingStatus.updating:
        return 3;
      case MessageSendingStatus.failed_update:
        return 4;
      case MessageSendingStatus.deleting:
        return 5;
      case MessageSendingStatus.failed_delete:
        return 6;
      default:
        return null;
    }
  }
}
