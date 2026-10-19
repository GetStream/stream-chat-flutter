// coverage:ignore-file
import 'package:drift/drift.dart';
import '../converter/converter.dart';

/// Represents a [Channels] table in [DriftChatDatabase].
@DataClassName('ChannelEntity')
class Channels extends Table {
  /// The id of this channel
  TextColumn get id => text()();

  /// The type of this channel
  TextColumn get type => text()();

  /// The cid of this channel
  TextColumn get cid => text()();

  /// List of user permissions on this channel
  TextColumn get ownCapabilities => text().nullable().map(ListConverter<String>())();

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

  /// The count of messages in this channel
  IntColumn get messageCount => integer().nullable()();

  /// The id of the user that created this channel
  TextColumn get createdById => text().nullable()();

  /// List of filter tags for this channel
  TextColumn get filterTags => text().nullable().map(ListConverter<String>())();

  /// The team the channel belongs to
  TextColumn get team => text().nullable()();

  /// Whether the channel is disabled.
  BoolColumn get disabled => boolean().nullable()();

  /// Whether the channel is hidden.
  BoolColumn get hidden => boolean().nullable()();

  /// Whether the current user muted the channel.
  BoolColumn get muted => boolean().nullable()();

  /// Whether the current user blocked the channel.
  BoolColumn get blocked => boolean().nullable()();

  /// The date the channel was last truncated.
  DateTimeColumn get truncatedAt => dateTime().nullable()();

  /// The id of the user that last truncated the channel.
  TextColumn get truncatedById => text().nullable()();

  /// Whether messages in the channel are translated automatically.
  BoolColumn get autoTranslationEnabled => boolean().nullable()();

  /// The language the channel's messages are translated into automatically.
  TextColumn get autoTranslationLanguage => text().nullable()();

  /// Custom data attached to the channel.
  TextColumn get custom => text().nullable().map(MapConverter())();

  @override
  Set<Column> get primaryKey => {cid};
}
