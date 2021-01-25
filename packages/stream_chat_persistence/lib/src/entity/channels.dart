import 'package:moor/moor.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';

@DataClassName('ChannelEntity')
class Channels extends Table {
  TextColumn get id => text()();

  TextColumn get type => text()();

  TextColumn get cid => text()();

  TextColumn get config => text().map(MapConverter<Object>())();

  BoolColumn get frozen => boolean().withDefault(Constant(false))();

  DateTimeColumn get lastMessageAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  IntColumn get memberCount => integer().nullable()();

  TextColumn get createdById => text().nullable()();

  TextColumn get extraData => text().nullable().map(MapConverter<Object>())();

  @override
  Set<Column> get primaryKey => {cid};
}
