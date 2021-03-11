import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';

import '../converter/converter.dart';
import '../dao/dao.dart';
import '../entity/entity.dart';
import 'shared/shared_db.dart';

part 'moor_chat_database.g.dart';

LazyDatabase _openConnection(
  String userId, {
  bool logStatements = false,
  bool persistOnDisk = true,
}) {
  return LazyDatabase(() async {
    return await SharedDB.constructDatabase(
      userId,
      logStatements: logStatements,
      persistOnDisk: persistOnDisk,
    );
  });
}

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
    this._userId, {
    logStatements = false,
    bool persistOnDisk = true,
  }) : super(_openConnection(
          _userId,
          logStatements: logStatements,
          persistOnDisk: persistOnDisk,
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
  int get schemaVersion => 2;

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
