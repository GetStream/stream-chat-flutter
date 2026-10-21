// Each test stores the middle of three rows with a UTC offset, the way a date
// created on the device is stored, and checks that the DAO still returns the
// rows in time order. Comparing the stored text instead would move that row
// to the end, and failing to read the date would move it to the start.

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
  });

  tearDown(() async {
    await database.disconnect();
  });

  test('MessageDao.getMessagesByCid returns messages in time order', () async {
    await _insertChannel(database);
    await database.messageDao.bulkUpdateMessages({_cid: _messages()});
    await _storeAsLocalMessage(database, 'messages', 'older');

    final messages = await database.messageDao.getMessagesByCid(_cid);

    expect(messages.map((it) => it.id), ['oldest', 'older', 'newer']);
  });

  test('MessageDao.getMessagesByCid returns messages after a cursor in time order', () async {
    await _insertChannel(database);
    await database.messageDao.bulkUpdateMessages({_cid: _messages()});
    await _storeAsLocalMessage(database, 'messages', 'older');

    final messages = await database.messageDao.getMessagesByCid(
      _cid,
      messagePagination: const PaginationParams(limit: 10, greaterThan: 'oldest'),
    );

    expect(messages.map((it) => it.id), ['older', 'newer']);
  });

  test('MessageDao.getMessagesByCid orders messages in the same millisecond by id', () async {
    await _insertChannel(database);
    await database.messageDao.bulkUpdateMessages({
      _cid: [
        _message('a', createdAt: _sameMillisecondEarlier),
        _message('b', createdAt: _sameMillisecondLater),
      ],
    });

    final messages = await database.messageDao.getMessagesByCid(_cid);

    expect(messages.map((it) => it.id), ['a', 'b']);
  });

  test('MessageDao.getThreadMessages returns replies in time order', () async {
    await _insertChannel(database);
    await database.messageDao.bulkUpdateMessages({
      _cid: [_parent(), ..._messages(parentId: 'parent')],
    });
    await _storeAsLocalMessage(database, 'messages', 'older');

    final replies = await database.messageDao.getThreadMessages(_cid);

    expect(replies.map((it) => it.id), ['oldest', 'older', 'newer']);
  });

  test('MessageDao.getThreadMessagesByParentId returns replies in time order', () async {
    await _insertChannel(database);
    await database.messageDao.bulkUpdateMessages({
      _cid: [_parent(), ..._messages(parentId: 'parent')],
    });
    await _storeAsLocalMessage(database, 'messages', 'older');

    final replies = await database.messageDao.getThreadMessagesByParentId('parent');

    expect(replies.map((it) => it.id), ['oldest', 'older', 'newer']);
  });

  test('MessageDao.getThreadMessagesByParentId returns replies after a cursor in time order', () async {
    await _insertChannel(database);
    await database.messageDao.bulkUpdateMessages({
      _cid: [_parent(), ..._messages(parentId: 'parent')],
    });
    await _storeAsLocalMessage(database, 'messages', 'older');

    final replies = await database.messageDao.getThreadMessagesByParentId(
      'parent',
      options: const PaginationParams(limit: 10, greaterThan: 'oldest'),
    );

    expect(replies.map((it) => it.id), ['older', 'newer']);
  });

  test('MessageDao.getThreadMessagesByParentId orders replies in the same millisecond by id', () async {
    await _insertChannel(database);
    await database.messageDao.bulkUpdateMessages({
      _cid: [
        _parent(),
        _message('a', createdAt: _sameMillisecondEarlier, parentId: 'parent'),
        _message('b', createdAt: _sameMillisecondLater, parentId: 'parent'),
      ],
    });

    final replies = await database.messageDao.getThreadMessagesByParentId('parent');

    expect(replies.map((it) => it.id), ['a', 'b']);
  });

  test('PinnedMessageDao.getMessagesByCid returns pinned messages in time order', () async {
    await _insertChannel(database);
    await database.pinnedMessageDao.bulkUpdateMessages({_cid: _messages()});
    await _storeAsLocalMessage(database, 'pinned_messages', 'older');

    final messages = await database.pinnedMessageDao.getMessagesByCid(_cid);

    expect(messages.map((it) => it.id), ['oldest', 'older', 'newer']);
  });

  test('PinnedMessageDao.getMessagesByCid returns pinned messages after a cursor in time order', () async {
    await _insertChannel(database);
    await database.pinnedMessageDao.bulkUpdateMessages({_cid: _messages()});
    await _storeAsLocalMessage(database, 'pinned_messages', 'older');

    final messages = await database.pinnedMessageDao.getMessagesByCid(
      _cid,
      messagePagination: const PaginationParams(limit: 10, greaterThan: 'oldest'),
    );

    expect(messages.map((it) => it.id), ['older', 'newer']);
  });

  test('PinnedMessageDao.getMessagesByCid orders pinned messages in the same millisecond by id', () async {
    await _insertChannel(database);
    await database.pinnedMessageDao.bulkUpdateMessages({
      _cid: [
        _message('a', createdAt: _sameMillisecondEarlier),
        _message('b', createdAt: _sameMillisecondLater),
      ],
    });

    final messages = await database.pinnedMessageDao.getMessagesByCid(_cid);

    expect(messages.map((it) => it.id), ['a', 'b']);
  });

  test('ReactionDao.getReactionsForMessages returns reactions in time order', () async {
    await _insertChannel(database);
    await database.messageDao.bulkUpdateMessages({
      _cid: [_message('message', createdAt: _oldest)],
    });
    await database.reactionDao.updateReactions(_reactions());
    await _storeAsLocal(database, 'reactions', 'created_at', where: "user_id = 'older'");

    final reactions = await database.reactionDao.getReactionsForMessages(['message']);

    expect(reactions['message']!.map((it) => it.userId), ['oldest', 'older', 'newer']);
  });

  test('PinnedMessageReactionDao.getReactionsForMessages returns reactions in time order', () async {
    await _insertChannel(database);
    await database.pinnedMessageDao.bulkUpdateMessages({
      _cid: [_message('message', createdAt: _oldest)],
    });
    await database.pinnedMessageReactionDao.updateReactions(_reactions());
    await _storeAsLocal(database, 'pinned_message_reactions', 'created_at', where: "user_id = 'older'");

    final reactions = await database.pinnedMessageReactionDao.getReactionsForMessages(['message']);

    expect(reactions['message']!.map((it) => it.userId), ['oldest', 'older', 'newer']);
  });

  test('MemberDao.getMembersByCid returns members in time order', () async {
    await _insertChannel(database);
    await database.memberDao.bulkUpdateMembers({
      _cid: [
        for (final (id, createdAt) in _rows)
          Member(
            user: User(id: id),
            createdAt: createdAt,
          ),
      ],
    });
    await _storeAsLocal(database, 'members', 'created_at', where: "user_id = 'older'");

    final members = await database.memberDao.getMembersByCid(_cid);

    expect(members.map((it) => it.userId), ['oldest', 'older', 'newer']);
  });

  test('ReadDao.getReadsByCid returns reads in time order', () async {
    await _insertChannel(database);
    await database.readDao.bulkUpdateReads({
      _cid: [
        for (final (id, lastRead) in _rows)
          Read(
            user: User(id: id),
            lastRead: lastRead,
          ),
      ],
    });
    await _storeAsLocal(database, 'reads', 'last_read', where: "user_id = 'older'");

    final reads = await database.readDao.getReadsByCid(_cid);

    expect(reads.map((it) => it.user.id), ['oldest', 'older', 'newer']);
  });

  test('PollVoteDao.getPollVotes returns votes in time order', () async {
    await _insertPoll(database);
    await database.pollVoteDao.updatePollVotes(_pollVotes());
    await _storeAsLocal(database, 'poll_votes', 'created_at', where: "id = 'older'");

    final votes = await database.pollVoteDao.getPollVotes(_pollId);

    expect(votes.map((it) => it.id), ['oldest', 'older', 'newer']);
  });

  test('PollVoteDao.getPollVotesForPolls returns votes in time order', () async {
    await _insertPoll(database);
    await database.pollVoteDao.updatePollVotes(_pollVotes());
    await _storeAsLocal(database, 'poll_votes', 'created_at', where: "id = 'older'");

    final votes = await database.pollVoteDao.getPollVotesForPolls([_pollId]);

    expect(votes[_pollId]!.map((it) => it.id), ['oldest', 'older', 'newer']);
  });

  test('ChannelDao.cids returns the most recently active channels first', () async {
    await database.channelDao.updateChannels([
      for (final (id, lastMessageAt) in _rows)
        ChannelModel(cid: 'messaging:$id', createdAt: DateTime.utc(2026), lastMessageAt: lastMessageAt),
    ]);
    await _storeAsLocal(database, 'channels', 'last_message_at', where: "cid = 'messaging:older'");

    final cids = await database.channelDao.cids;

    expect(cids, ['messaging:newer', 'messaging:older', 'messaging:oldest']);
  });
}

const _cid = 'messaging:channel';
const _pollId = 'poll';

final _oldest = DateTime.utc(2026, 10, 20, 21, 26);
final _older = DateTime.utc(2026, 10, 20, 21, 27);
final _newer = DateTime.utc(2026, 10, 20, 21, 28);

// The ids and dates of the three rows each test stores.
final _rows = [('oldest', _oldest), ('older', _older), ('newer', _newer)];

// [_older] the way drift stores a local time at UTC+2. As text it sorts after
// [_newer], which is stored as `2026-10-20T21:28:00.000Z`.
const _olderAsLocalTime = '2026-10-20T23:27:00.000 +02:00';

// The same millisecond. As text, `…00.345Z` sorts after `…00.345001Z`.
final _sameMillisecondEarlier = DateTime.utc(2026, 10, 20, 21, 27, 0, 345);
final _sameMillisecondLater = DateTime.utc(2026, 10, 20, 21, 27, 0, 345, 1);

Future<void> _insertChannel(DriftChatDatabase database) async {
  await database.userDao.updateUsers([for (final (id, _) in _rows) User(id: id)]);
  await database.channelDao.updateChannels([ChannelModel(cid: _cid)]);
}

Future<void> _insertPoll(DriftChatDatabase database) async {
  await database.pollDao.updatePolls([
    Poll(
      id: _pollId,
      name: 'poll',
      options: const [PollOption(id: 'option', text: 'option')],
    ),
  ]);
}

Message _message(String id, {required DateTime createdAt, String? parentId}) {
  return Message(
    id: id,
    text: id,
    user: User(id: 'oldest'),
    createdAt: createdAt,
    parentId: parentId,
  );
}

Message _parent() => _message('parent', createdAt: _oldest.subtract(const Duration(hours: 1)));

List<Message> _messages({String? parentId}) {
  return [for (final (id, createdAt) in _rows) _message(id, createdAt: createdAt, parentId: parentId)];
}

List<Reaction> _reactions() {
  return [
    for (final (id, createdAt) in _rows)
      Reaction(
        type: 'like',
        messageId: 'message',
        userId: id,
        user: User(id: id),
        createdAt: createdAt,
      ),
  ];
}

List<PollVote> _pollVotes() {
  return [
    for (final (id, createdAt) in _rows)
      PollVote(id: id, pollId: _pollId, optionId: 'option', userId: id, createdAt: createdAt),
  ];
}

// Turns the message [id] in [table] into one that only exists on the device,
// created at [_older] in local time.
Future<void> _storeAsLocalMessage(DriftChatDatabase database, String table, String id) {
  return database.customStatement(
    'UPDATE $table SET remote_created_at = NULL, local_created_at = ? WHERE id = ?',
    [_olderAsLocalTime, id],
  );
}

// Rewrites [column] of the rows matching [where] in [table] to [_older] in
// local time.
Future<void> _storeAsLocal(DriftChatDatabase database, String table, String column, {required String where}) {
  return database.customStatement('UPDATE $table SET $column = ? WHERE $where', [_olderAsLocalTime]);
}
