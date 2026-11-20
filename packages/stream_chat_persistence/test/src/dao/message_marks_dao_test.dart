import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

const _cid = 'messaging:general';

void main() {
  late DriftChatDatabase database;

  setUp(() async {
    database = testDatabaseProvider('testUserId');
    await database.channelDao.updateChannels([ChannelModel(cid: _cid)]);
  });

  tearDown(() => database.disconnect());

  final markGroups = {
    MessageMarkType.played: MarkGroup(
      count: 2,
      latestBy: [
        MessageMarker(
          userId: 'second-listener',
          createdAt: DateTime.utc(2026, 11, 20, 10),
        ),
        MessageMarker(
          userId: 'first-listener',
          createdAt: DateTime.utc(2026, 11, 19, 10),
        ),
      ],
    ),
  };
  final ownMarks = [
    OwnMark(
      type: MessageMarkType.played,
      createdAt: DateTime.utc(2026, 11, 20, 11),
    ),
  ];

  test('a stored message keeps its marks', () async {
    final message = Message(
      id: 'voice-note',
      markGroups: markGroups,
      ownMarks: ownMarks,
    );

    await database.messageDao.bulkUpdateMessages({
      _cid: [message],
    });
    final stored = await database.messageDao.getMessageById('voice-note');

    expect(stored?.markGroups, markGroups);
    expect(stored?.ownMarks, ownMarks);
  });

  test('a stored pinned message keeps its marks', () async {
    final message = Message(
      id: 'voice-note',
      pinned: true,
      markGroups: markGroups,
      ownMarks: ownMarks,
    );

    await database.pinnedMessageDao.bulkUpdateMessages({
      _cid: [message],
    });
    final stored = await database.pinnedMessageDao.getMessageById('voice-note');

    expect(stored?.markGroups, markGroups);
    expect(stored?.ownMarks, ownMarks);
  });

  test('a stored message without marks has none', () async {
    await database.messageDao.bulkUpdateMessages({
      _cid: [Message(id: 'text')],
    });
    final stored = await database.messageDao.getMessageById('text');

    expect(stored?.markGroups, isNull);
    expect(stored?.ownMarks, isNull);
  });
}
