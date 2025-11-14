import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/read_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  test('toRead should map entity into Read', () {
    const cid = 'testCid';
    const lastMessageId = 'lastMessageId';
    const lastDeliveredMessageId = 'lastDeliveredMessageId';
    final user = User(id: 'testUserId');
    final lastDeliveredAt = DateTime.now();
    final entity = ReadEntity(
      lastRead: DateTime.now(),
      userId: user.id,
      channelCid: cid,
      unreadMessages: 33,
      lastReadMessageId: lastMessageId,
      lastDeliveredAt: lastDeliveredAt,
      lastDeliveredMessageId: lastDeliveredMessageId,
    );

    final read = entity.toRead(user: user);
    expect(read, isA<Read>());
    expect(read.lastRead, isSameDateAs(entity.lastRead));
    expect(read.user.id, entity.userId);
    expect(read.unreadMessages, entity.unreadMessages);
    expect(read.lastReadMessageId, lastMessageId);
    expect(read.lastDeliveredAt, isSameDateAs(lastDeliveredAt));
    expect(read.lastDeliveredMessageId, lastDeliveredMessageId);
  });

  test('toEntity should map read into ReadEntity', () {
    const cid = 'testCid';
    const lastMessageId = 'lastMessageId';
    const lastDeliveredMessageId = 'lastDeliveredMessageId';
    final user = User(id: 'testUserId');
    final lastDeliveredAt = DateTime.now();
    final read = Read(
      lastRead: DateTime.now(),
      user: user,
      unreadMessages: 33,
      lastReadMessageId: lastMessageId,
      lastDeliveredAt: lastDeliveredAt,
      lastDeliveredMessageId: lastDeliveredMessageId,
    );

    final entity = read.toEntity(cid: cid);
    expect(entity, isA<ReadEntity>());
    expect(entity.lastRead, isSameDateAs(read.lastRead));
    expect(entity.userId, read.user.id);
    expect(entity.unreadMessages, read.unreadMessages);
    expect(entity.lastReadMessageId, lastMessageId);
    expect(entity.lastDeliveredAt, isSameDateAs(lastDeliveredAt));
    expect(entity.lastDeliveredMessageId, lastDeliveredMessageId);
  });
}
