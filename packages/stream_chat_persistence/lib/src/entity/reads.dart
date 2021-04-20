// coverage:ignore-file
import 'package:moor/moor.dart';

/// Represents a [Reads] table in [MoorChatDatabase].
@DataClassName('ReadEntity')
class Reads extends Table {
  /// Date of the read event
  DateTimeColumn get lastRead => dateTime()();

  /// Id of the User who sent the event
  TextColumn get userId => text()();

  /// The channel cid of which this read belongs
  TextColumn get channelCid =>
      text().customConstraint('REFERENCES channels(cid) ON DELETE CASCADE')();

  /// Number of unread messages
  IntColumn get unreadMessages => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {
        userId,
        channelCid,
      };
}
