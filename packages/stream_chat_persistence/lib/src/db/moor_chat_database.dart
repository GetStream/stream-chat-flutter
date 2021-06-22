import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';

import 'package:stream_chat_persistence/src/converter/converter.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/entity/entity.dart';

export 'shared/shared_db.dart';

part 'moor_chat_database.g.dart';

/// A chat database implemented using moor
@UseMoor(tables: [
  Channels,
  Messages,
  PinnedMessages,
  Reactions,
  Users,
  Members,
  Reads,
  ChannelQueries,
  ConnectionEvents,
], daos: [
  UserDao,
  ChannelDao,
  MessageDao,
  PinnedMessageDao,
  MemberDao,
  ReactionDao,
  ReadDao,
  ChannelQueryDao,
  ConnectionEventDao,
])
class MoorChatDatabase extends _$MoorChatDatabase {
  /// Creates a new moor chat database instance
  MoorChatDatabase(
    this._userId,
    QueryExecutor executor,
  ) : super(executor);

  /// Instantiate a new database instance
  MoorChatDatabase.connect(
    this._userId,
    DatabaseConnection connection,
  ) : super.connect(connection);

  final String _userId;

  /// User id to which the database is connected
  String get userId => _userId;

  // you should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (openingDetails, before, after) async {
          if (before != after) {
            final m = createMigrator();
            for (final table in allTables) {
              await m.deleteTable(table.actualTableName);
              await m.createTable(table);
            }
          }
        },
      );

  /// Deletes all the tables
  Future<void> flush() => batch((batch) {
        allTables.forEach((table) {
          delete(table).go();
        });
      });

  /// Closes the database instance
  Future<void> disconnect() => close();
}
