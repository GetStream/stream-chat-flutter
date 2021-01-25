import 'package:moor/moor.dart';

@DataClassName('MemberEntity')
class Members extends Table {
  TextColumn get userId => text()();

  TextColumn get channelCid =>
      text().customConstraint('REFERENCES channels(cid) ON DELETE CASCADE')();

  TextColumn get role => text().nullable()();

  DateTimeColumn get inviteAcceptedAt => dateTime().nullable()();

  DateTimeColumn get inviteRejectedAt => dateTime().nullable()();

  BoolColumn get invited => boolean().nullable()();

  BoolColumn get banned => boolean().nullable()();

  BoolColumn get shadowBanned => boolean().nullable()();

  BoolColumn get isModerator => boolean().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {
        userId,
        channelCid,
      };
}
