import 'package:meta/meta.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';

import 'package:stream_chat_persistence/src/converter/converter.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/entity/entity.dart';
import 'package:stream_chat_persistence/src/db/shared/shared_db.dart';

part 'moor_chat_database.g.dart';

LazyDatabase _openConnection(
  String userId, {
  bool logStatements = false,
}) =>
    LazyDatabase(() async => SharedDB.constructDatabase(
          userId,
          logStatements: logStatements,
        ));

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
  }) : super(_openConnection(
          _userId,
          logStatements: logStatements,
        ));

  /// Instantiate a new database instance
  MoorChatDatabase.connect(
    this._userId,
    DatabaseConnection connection,
  ) : super.connect(connection);

  /// Custom constructor used only for testing
  @visibleForTesting
  MoorChatDatabase.testable(this._userId) : super(VmDatabase.memory());

  final String _userId;

  /// User id to which the database is connected
  String get userId => _userId;

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
  Future<void> disconnect() => close();
}
