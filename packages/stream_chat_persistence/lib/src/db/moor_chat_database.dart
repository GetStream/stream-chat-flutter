import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';

import '../entity/entity.dart';
import '../dao/dao.dart';
import 'shared/shared_db.dart';

part 'moor_chat_database.g.dart';

LazyDatabase _openConnection(
  String dbName, {
  logStatements = false,
}) {
  return LazyDatabase(() async {
    return await SharedDB.constructDatabase(
      dbName,
      logStatements: logStatements,
    );
  });
}

///
@UseMoor(tables: [
  Channels,
  Messages,
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
  MemberDao,
  ReactionDao,
  ReadDao,
  ChannelQueryDao,
  ConnectionEventDao,
])
class MoorChatDatabase extends _$MoorChatDatabase {
  /// Instantiate a new database instance
  MoorChatDatabase(
    String dbName, {
    logStatements = false,
  }) : super(_openConnection(
          dbName,
          logStatements: logStatements,
        ));

  /// Instantiate a new database instance
  MoorChatDatabase.connect(
    this._isolate,
    DatabaseConnection connection,
  ) : super.connect(connection);

  MoorIsolate _isolate;

  // you should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 1;

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

  /// Closes the database instance
  Future<void> disconnect() async {
    await _isolate?.shutdownAll();
    await close();
  }
}
