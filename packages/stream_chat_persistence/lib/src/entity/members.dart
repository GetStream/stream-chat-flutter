// coverage:ignore-file
import 'package:drift/drift.dart';

/// Represents a [Members] table in [MoorChatDatabase].
@DataClassName('MemberEntity')
class Members extends Table {
  /// The interested user id
  TextColumn get userId => text()();

  /// The channel cid of which this user is part of
  TextColumn get channelCid =>
      text().customConstraint('REFERENCES channels(cid) ON DELETE CASCADE')();

  /// The role of the user in the channel
  @Deprecated('Please use channelRole')
  TextColumn get role => text().nullable()();

  /// The role of the user in the channel
  TextColumn get channelRole => text().nullable()();

  /// The date on which the user accepted the invite to the channel
  DateTimeColumn get inviteAcceptedAt => dateTime().nullable()();

  /// The date on which the user rejected the invite to the channel
  DateTimeColumn get inviteRejectedAt => dateTime().nullable()();

  /// True if the user has been invited to the channel
  BoolColumn get invited => boolean().withDefault(const Constant(false))();

  /// True if the member is banned from the channel
  BoolColumn get banned => boolean().withDefault(const Constant(false))();

  /// True if the member is shadow banned from the channel
  BoolColumn get shadowBanned => boolean().withDefault(const Constant(false))();

  /// True if the user is a moderator of the channel
  BoolColumn get isModerator => boolean().withDefault(const Constant(false))();

  /// The date of creation
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The last date of update
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId, channelCid};
}
