import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';

import '../entity/entity.dart';
import '../dao/dao.dart';
import '../converter/converter.dart';
import 'shared/shared_db.dart';

part 'moor_chat_database.g.dart';

LazyDatabase _openConnection(
  String userId, {
  logStatements = false,
}) {
  return LazyDatabase(() async {
    return await SharedDB.constructDatabase(
      userId,
      logStatements: logStatements,
    );
  });
}

/// A chat database implemented using moor
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
  /// Creates a new moor chat database instance
  MoorChatDatabase(
    this._userId, {
    logStatements = false,
  }) : super(_openConnection(
          _userId,
          logStatements: logStatements,
        ));

  /// Instantiate a new database instance
  MoorChatDatabase.connect(
    this._userId,
    this._isolate,
    DatabaseConnection connection,
  ) : super.connect(connection);

  final String _userId;

  /// User id to which the database is connected
  String get userId => _userId;

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
