// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';

/// Represents a [PendingOperations] table in [DriftChatDatabase].
///
/// Stores optimistic mutations (e.g. reactions added or removed while offline)
/// awaiting replay.
@DataClassName('PendingOperationEntity')
class PendingOperations extends Table {
  /// Autoincrement id.
  IntColumn get id => integer().autoIncrement()();

  /// The operation-type discriminator (e.g. `reaction.add`).
  TextColumn get type => text()();

  /// The id of the message the operation targets, if any.
  TextColumn get targetMessageId => text().nullable()();

  /// The operation-specific value fields, stored as JSON.
  TextColumn get payload => text().map(MapConverter())();
}
