import 'package:moor/moor.dart';
import 'package:stream_chat_persistence/src/converter/list_converter.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';
import 'package:stream_chat_persistence/src/converter/message_sending_status_converter.dart';

@DataClassName('MessageEntity')
class Messages extends Table {
  TextColumn get id => text()();

  TextColumn get messageText => text().nullable()();

  TextColumn get attachments =>
      text().nullable().map(ListConverter<String>())();

  IntColumn get status =>
      integer().nullable().map(MessageSendingStatusConverter())();

  TextColumn get type => text().nullable()();

  TextColumn get mentionedUsers =>
      text().nullable().map(ListConverter<String>())();

  TextColumn get reactionCounts => text().nullable().map(MapConverter<int>())();

  TextColumn get reactionScores => text().nullable().map(MapConverter<int>())();

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

  TextColumn get channelCid => text().nullable().customConstraint(
      'NULLABLE REFERENCES channels(cid) ON DELETE CASCADE')();

  TextColumn get extraData => text().nullable().map(MapConverter<Object>())();

  @override
  Set<Column> get primaryKey => {id};
}
