// coverage:ignore-file
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
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Date of last user update
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// Date of last user connection
  DateTimeColumn get lastActive => dateTime().nullable()();

  /// True if user is online
  BoolColumn get online => boolean().withDefault(const Constant(false))();

  /// True if user is banned from the chat
  BoolColumn get banned => boolean().withDefault(const Constant(false))();

  /// Map of custom user extraData
  TextColumn get extraData => text().map(MapConverter<Object>())();

  @override
  Set<Column> get primaryKey => {id};
}
