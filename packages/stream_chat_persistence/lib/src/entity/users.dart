import 'package:moor/moor.dart';
import 'package:stream_chat_persistence/src/converter/map_converter.dart';

/// Represents a [Users] table in [MoorChatDatabase].
@DataClassName('UserEntity')
class Users extends Table {
  /// User id
  TextColumn get id => text()();

  /// User role
  TextColumn get role => text().nullable()();

  /// Date of user creation
  DateTimeColumn get createdAt => dateTime().nullable()();

  /// Date of last user update
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// Date of last user connection
  DateTimeColumn get lastActive => dateTime().nullable()();

  /// True if user is online
  BoolColumn get online => boolean().nullable()();

  /// True if user is banned from the chat
  BoolColumn get banned => boolean().nullable()();

  /// Map of custom user extraData
  TextColumn get extraData => text().nullable().map(MapConverter<Object>())();

  @override
  Set<Column> get primaryKey => {id};
}
