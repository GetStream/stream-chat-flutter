// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/converter/converter.dart';

/// Represents a [Channels] table in [MoorChatDatabase].
@DataClassName('ChannelEntity')
class Channels extends Table {
  /// The id of this channel
  TextColumn get id => text()();

  /// The type of this channel
  TextColumn get type => text()();

  /// The cid of this channel
  TextColumn get cid => text()();

  /// List of user permissions on this channel
  TextColumn get ownCapabilities =>
      text().nullable().map(ListConverter<String>())();

  /// The channel configuration data
  TextColumn get config => text().map(MapConverter())();

  /// True if this channel entity is frozen
  BoolColumn get frozen => boolean().withDefault(const Constant(false))();

  /// The date of the last message
  DateTimeColumn get lastMessageAt => dateTime().nullable()();

  /// The date of channel creation
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The date of the last channel update
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// The date of channel deletion
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// The count of this channel members
  IntColumn get memberCount => integer().withDefault(const Constant(0))();

  /// The id of the user that created this channel
  TextColumn get createdById => text().nullable()();

  /// Map of custom channel extraData
  TextColumn get extraData => text().nullable().map(MapConverter())();

  @override
  Set<Column> get primaryKey => {cid};
}
