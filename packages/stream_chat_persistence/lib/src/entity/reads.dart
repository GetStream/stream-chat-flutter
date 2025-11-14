// coverage:ignore-file
import 'package:drift/drift.dart';
import 'package:stream_chat_persistence/src/entity/channels.dart';

/// Represents a [Reads] table in [MoorChatDatabase].
@DataClassName('ReadEntity')
class Reads extends Table {
  /// Date of the read event
  DateTimeColumn get lastRead => dateTime()();

  /// Id of the User who sent the event
  TextColumn get userId => text()();

  /// The channel cid of which this read belongs
  TextColumn get channelCid =>
      text().references(Channels, #cid, onDelete: KeyAction.cascade)();

  /// Number of unread messages
  IntColumn get unreadMessages => integer().withDefault(const Constant(0))();

  /// Id of the last read message
  TextColumn get lastReadMessageId => text().nullable()();

  /// Date of the last delivered message
  DateTimeColumn get lastDeliveredAt => dateTime().nullable()();

  /// Id of the last delivered message
  TextColumn get lastDeliveredMessageId => text().nullable()();

  @override
  Set<Column> get primaryKey => {
        userId,
        channelCid,
      };
}
