import 'package:moor/moor.dart';

/// Represents a [Members] table in [MoorChatDatabase].
@DataClassName('MemberEntity')
class Members extends Table {
  /// The interested user id
  TextColumn get userId => text()();

  /// The channel cid of which this user is part of
  TextColumn get channelCid =>
      text().customConstraint('REFERENCES channels(cid) ON DELETE CASCADE')();

  /// The role of the user in the channel
  TextColumn get role => text().nullable()();

  /// The date on which the user accepted the invite to the channel
  DateTimeColumn get inviteAcceptedAt => dateTime().nullable()();

  /// The date on which the user rejected the invite to the channel
  DateTimeColumn get inviteRejectedAt => dateTime().nullable()();

  /// True if the user has been invited to the channel
  BoolColumn get invited => boolean().nullable()();

  /// True if the member is banned from the channel
  BoolColumn get banned => boolean().nullable()();

  /// True if the member is shadow banned from the channel
  BoolColumn get shadowBanned => boolean().nullable()();

  /// True if the user is a moderator of the channel
  BoolColumn get isModerator => boolean().nullable()();

  /// The date of creation
  DateTimeColumn get createdAt => dateTime()();

  /// The last date of update
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {
        userId,
        channelCid,
      };
}
