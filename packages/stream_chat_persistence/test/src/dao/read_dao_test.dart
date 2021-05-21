import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:test/test.dart';

import '../../stream_chat_persistence_client_test.dart';
import '../utils/date_matcher.dart';

void main() {
  late ReadDao readDao;
  late MoorChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    readDao = database.readDao;
  });

  Future<List<Read>> _prepareReadData(String cid, {int count = 3}) async {
    final users = List.generate(count, (index) => User(id: 'testUserId$index'));
    final reads = List.generate(
      count,
      (index) => Read(
        lastRead: DateTime.now(),
        user: users[index],
        unreadMessages: index + 10,
      ),
    );

    await database.userDao.updateUsers(users);
    await readDao.updateReads(cid, reads);
    return reads;
  }

  test('getReadsByCid', () async {
    const cid = 'testCid';

    // Should be empty initially
    final reads = await readDao.getReadsByCid(cid);
    expect(reads, isEmpty);

    // Preparing test data
    final insertedReads = await _prepareReadData(cid);
    expect(insertedReads, isNotEmpty);

    // Fetched reads should be equal to inserted reads
    final fetchedReads = await readDao.getReadsByCid(cid);
    expect(fetchedReads.length, insertedReads.length);
    for (var i = 0; i < fetchedReads.length; i++) {
      final fetchedRead = fetchedReads[i];
      final insertedRead = insertedReads[i];
      expect(fetchedRead.user.id, insertedRead.user.id);
      expect(fetchedRead.lastRead, isSameDateAs(insertedRead.lastRead));
      expect(fetchedRead.unreadMessages, insertedRead.unreadMessages);
    }
  });

  test('updateReads', () async {
    const cid = 'testCid';

    // Preparing test data
    final insertedReads = await _prepareReadData(cid);

    // Modifying one of the read and also adding one new
    final copyRead = insertedReads.first.copyWith(unreadMessages: 33);
    final newUser = User(id: 'testUserId3');
    final newRead = Read(
      lastRead: DateTime.now(),
      user: newUser,
      unreadMessages: 30,
    );
    await database.userDao.updateUsers([newUser]);
    await readDao.updateReads(cid, [copyRead, newRead]);

    // Fetched reads length should be one more than inserted reads.
    // copyRead `unreadMessages` modified field should be 33.
    // Fetched reads should contain the newRead.
    final fetchedReads = await readDao.getReadsByCid(cid);
    expect(fetchedReads.length, insertedReads.length + 1);
    expect(
      fetchedReads
          .firstWhere((it) => it.user.id == copyRead.user.id)
          .unreadMessages,
      33,
    );
    expect(
      fetchedReads
          .where((it) =>
              it.user.id == newRead.user.id &&
              it.unreadMessages == newRead.unreadMessages)
          .isNotEmpty,
      true,
    );
  });

  tearDown(() async {
    await database.disconnect();
  });
}
