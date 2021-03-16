import 'package:moor/moor.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';

/// Represents a [Channels] table in [MoorChatDatabase].
@DataClassName('ChannelEntity')
class Channels extends Table {
  /// The id of this channel
  TextColumn get id => text()();

  /// The type of this channel
  TextColumn get type => text()();

  /// The cid of this channel
  TextColumn get cid => text()();

  /// The channel configuration data
  TextColumn get config => text().map(MapConverter<Object>())();

  /// True if this channel entity is frozen
  BoolColumn get frozen => boolean().withDefault(const Constant(false))();

  /// The date of the last message
  DateTimeColumn get lastMessageAt => dateTime().nullable()();

  /// The date of channel creation
  DateTimeColumn get createdAt => dateTime().nullable()();

  /// The date of the last channel update
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// The date of channel deletion
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// The count of this channel members
  IntColumn get memberCount => integer().nullable()();

  /// The id of the user that created this channel
  TextColumn get createdById => text().nullable()();

  /// Map of custom channel extraData
  TextColumn get extraData => text().nullable().map(MapConverter<Object>())();

  @override
  Set<Column> get primaryKey => {cid};
}
