import 'package:moor/moor.dart';

@DataClassName('ReadEntity')
class Reads extends Table {
  DateTimeColumn get lastRead => dateTime()();

  TextColumn get userId => text()();

  TextColumn get channelCid =>
      text().customConstraint('REFERENCES channels(cid) ON DELETE CASCADE')();

  IntColumn get unreadMessages => integer().nullable()();

  @override
  Set<Column> get primaryKey => {
        userId,
        channelCid,
      };
}
