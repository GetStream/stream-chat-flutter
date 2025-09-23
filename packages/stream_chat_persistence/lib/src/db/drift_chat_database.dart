import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/converter/converter.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/entity/entity.dart';

export 'shared/shared_db.dart';

part 'drift_chat_database.g.dart';

/// A chat database implemented using moor
@DriftDatabase(
  tables: [
    Channels,
    DraftMessages,
    Messages,
    PinnedMessages,
    Polls,
    PollVotes,
    PinnedMessageReactions,
    Reactions,
    Users,
    Members,
    Reads,
    ChannelQueries,
    ConnectionEvents,
  ],
  daos: [
    UserDao,
    ChannelDao,
    MessageDao,
    DraftMessageDao,
    PinnedMessageDao,
    PinnedMessageReactionDao,
    MemberDao,
    PollDao,
    PollVoteDao,
    ReactionDao,
    ReadDao,
    ChannelQueryDao,
    ConnectionEventDao,
  ],
)
class DriftChatDatabase extends _$DriftChatDatabase {
  /// Creates a new drift chat database instance
  DriftChatDatabase(
    this._userId,
    QueryExecutor executor,
  ) : super(executor);

  final String _userId;

  /// User id to which the database is connected
  String get userId => _userId;

  // you should bump this number whenever you change or add a table definition.
  @override
  int get schemaVersion => 23;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onUpgrade: (migrator, from, to) async {
          if (from != to) {
            for (final table in allTables) {
              await migrator.deleteTable(table.actualTableName);
            }
            await migrator.createAll();
          }
        },
      );

  /// Deletes all the tables
  Future<void> flush() async {
    await customStatement('PRAGMA foreign_keys = OFF');
    try {
      await transaction(() async {
        for (final table in allTables) {
          await delete(table).go();
        }
      });
    } finally {
      await customStatement('PRAGMA foreign_keys = ON');
    }
  }

  /// Closes the database instance
  Future<void> disconnect() => close();
}
