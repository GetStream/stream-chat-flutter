// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/entity/channels.dart';
import 'package:stream_chat_persistence/src/entity/messages.dart';

/// Represents a [Locations] table in [DriftChatDatabase].
@DataClassName('LocationEntity')
class Locations extends Table {
  /// The channel CID where the location is shared
  TextColumn get channelCid => text()
      .nullable()
      .references(Channels, #cid, onDelete: KeyAction.cascade)();

  /// The ID of the message that contains this shared location
  TextColumn get messageId => text()
      .nullable()
      .references(Messages, #id, onDelete: KeyAction.cascade)();

  /// The ID of the user who shared the location
  TextColumn get userId => text().nullable()();

  /// The latitude of the shared location
  RealColumn get latitude => real()();

  /// The longitude of the shared location
  RealColumn get longitude => real()();

  /// The ID of the device that created the location
  TextColumn get createdByDeviceId => text()();

  /// The date at which the shared location will end (for live locations)
  /// If null, this is a static location
  DateTimeColumn get endAt => dateTime().nullable()();

  /// The date at which the location was created
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The date at which the location was last updated
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {messageId};
}
