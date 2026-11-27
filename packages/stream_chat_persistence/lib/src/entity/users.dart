// coverage:ignore-file
import 'package:drift/drift.dart';
import '../converter/converter.dart';

/// Represents a [Users] table in [DriftChatDatabase].
@DataClassName('UserEntity')
class Users extends Table {
  /// User id
  TextColumn get id => text()();

  /// User role
  TextColumn get role => text().nullable()();

  /// The language this user prefers.
  TextColumn get language => text().nullable()();

  /// Date of user creation
  DateTimeColumn get createdAt => dateTime().nullable()();

  /// Date of last user update
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// Date of last user connection
  DateTimeColumn get lastActive => dateTime().nullable()();

  /// True if user is online
  BoolColumn get online => boolean().withDefault(const Constant(false))();

  /// True if user is banned from the chat
  BoolColumn get banned => boolean().withDefault(const Constant(false))();

  /// The roles for the user in the teams.
  ///
  /// eg: `{'teamId': 'role', 'teamId2': 'role2'}`
  TextColumn get teamsRole => text().nullable().map(MapConverter<String>())();

  /// The average response time for the user in seconds.
  IntColumn get avgResponseTime => integer().nullable()();

  /// The user's name.
  TextColumn get name => text().nullable()();

  /// The URL of the user's image.
  TextColumn get image => text().nullable()();

  /// The date at which the user was deactivated.
  DateTimeColumn get deactivatedAt => dateTime().nullable()();

  /// The date at which the user was deleted.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Whether the user is shadow banned.
  BoolColumn get shadowBanned => boolean().nullable()();

  /// The ids of the users this user blocked.
  TextColumn get blockedUserIds => text().map(ListConverter<String>())();

  /// Custom data attached to the user.
  TextColumn get custom => text().map(MapConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
