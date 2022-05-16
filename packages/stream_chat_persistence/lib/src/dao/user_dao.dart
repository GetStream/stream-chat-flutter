import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/user_mapper.dart';

part 'user_dao.g.dart';

/// The Data Access Object for operations in [Users] table.
@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<DriftChatDatabase> with _$UserDaoMixin {
  /// Creates a new user dao instance
  UserDao(super.db);

  /// Updates the users data with the new [userList] data
  Future<void> updateUsers(List<User> userList) => batch(
        (it) => it.insertAllOnConflictUpdate(
          users,
          userList.map((u) => u.toEntity()).toList(),
        ),
      );

  /// Returns the list of all the users stored in db
  Future<List<User>> getUsers() =>
      (select(users)..orderBy([(u) => OrderingTerm.desc(u.createdAt)]))
          .map((it) => it.toUser())
          .get();
}
