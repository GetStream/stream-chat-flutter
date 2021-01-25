import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import '../mapper/user_mapper.dart';

part 'user_dao.g.dart';

///
@UseDao(tables: [Users])
class UserDao extends DatabaseAccessor<MoorChatDatabase> with _$UserDaoMixin {
  ///
  UserDao(MoorChatDatabase db) : super(db);

  ///
  Future<void> updateUsers(List<User> userList) {
    return batch(
      (it) => it.insertAll(
        users,
        userList.map((u) => u.toEntity()).toList(),
        mode: InsertMode.insertOrReplace,
      ),
    );
  }
}
