import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/channel_dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late ChannelDao channelDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    channelDao = database.channelDao;
  });

  test('getChannelByCid', () async {
    const id = 'testId';
    const cid = 'testCid';
    const type = 'testType';

    // Should be null initially
    final channel = await channelDao.getChannelByCid(cid);
    expect(channel, isNull);

    // Saving a dummy channel
    final dummyChannel = ChannelModel(
      id: id,
      type: type,
      cid: cid,
      config: ChannelConfig(),
    );
    await channelDao.updateChannels([dummyChannel]);

    // Should match the dummy channel
    final updatedChannel = await channelDao.getChannelByCid(cid);
    expect(updatedChannel, isNotNull);
    expect(updatedChannel!.id, id);
    expect(updatedChannel.cid, cid);
    expect(updatedChannel.type, type);
  });

  test('deleteChannelByCids', () async {
    const id = 'testId';
    const cid = 'testCid';
    const type = 'testType';

    // Saving a dummy channel
    final dummyChannel = ChannelModel(
      id: id,
      type: type,
      cid: cid,
      config: ChannelConfig(),
    );
    await channelDao.updateChannels([dummyChannel]);

    // Should match the dummy channel
    final updatedChannel = await channelDao.getChannelByCid(cid);
    expect(updatedChannel, isNotNull);
    expect(updatedChannel!.id, id);
    expect(updatedChannel.cid, cid);
    expect(updatedChannel.type, type);

    //Saving a dummy user
    const userId = 'userId';
    final dummyUser = User(id: userId);
    await database.userDao.updateUsers([dummyUser]);

    // Saving a dummy member
    final dummyMember = Member(userId: userId, user: dummyUser);
    await database.memberDao.updateMembers(cid, [dummyMember]);

    // Should match the dummy member
    final updatedMembers = await database.memberDao.getMembersByCid(cid);
    expect(updatedMembers.length, 1);
    expect(updatedMembers.first.userId, userId);

    // Saving a dummy message
    const messageId = 'messageId';
    final dummyMessage = Message(id: messageId, user: dummyUser);
    await database.messageDao.updateMessages(cid, [dummyMessage]);

    // Should match the dummy message
    final updatedMessages = await database.messageDao.getMessagesByCid(cid);
    expect(updatedMessages.length, 1);
    expect(updatedMessages.first.id, messageId);

    // Saving a dummy read
    final dummyRead = Read(lastRead: DateTime.now(), user: dummyUser);
    await database.readDao.updateReads(cid, [dummyRead]);

    // Should match the dummy read
    final updatedReads = await database.readDao.getReadsByCid(cid);
    expect(updatedReads.length, 1);
    expect(updatedReads.first.user, dummyUser);

    // Saving a dummy reaction
    final dummyReaction =
        Reaction(type: 'type', messageId: messageId, userId: userId);
    await database.reactionDao.updateReactions([dummyReaction]);

    // Should match the dummy reaction
    final updatedReactions =
        await database.reactionDao.getReactionsByUserId(messageId, userId);
    expect(updatedReactions.length, 1);
    expect(updatedReactions.first.messageId, messageId);

    // Deleting the dummyChannel using cid
    await channelDao.deleteChannelByCids([cid]);

    // Fetched channel Should be null
    final channel = await channelDao.getChannelByCid(cid);
    expect(channel, isNull);

    // Fetched members for passed cid should be empty
    final members = await database.memberDao.getMembersByCid(cid);
    expect(members, isEmpty);

    // Fetched messages for passed cid should be empty
    final messages = await database.messageDao.getMessagesByCid(cid);
    expect(messages, isEmpty);

    // Fetched reads for passed cid should be empty
    final reads = await database.readDao.getReadsByCid(cid);
    expect(reads, isEmpty);

    // Fetched readtions for passed message id and user id should be empty
    final reactions =
        await database.reactionDao.getReactionsByUserId(messageId, userId);
    expect(reactions, isEmpty);
  });

  test('cids', () async {
    // Should be empty initially
    final cids = await channelDao.cids;
    expect(cids, []);

    const id = 'testId';
    const cid = 'testCid';
    const type = 'testType';

    // Saving a dummy channel
    final dummyChannel = ChannelModel(
      id: id,
      type: type,
      cid: cid,
      config: ChannelConfig(),
    );
    await channelDao.updateChannels([dummyChannel]);

    // Should return the cid of the dummy channel
    final updatedCids = await channelDao.cids;
    expect(updatedCids, [cid]);
  });

  test('updateChannels', () async {
    const id = 'testId';
    const cid = 'testCid';
    const type = 'testType';

    // Should be null initially
    final channel = await channelDao.getChannelByCid(cid);
    expect(channel, isNull);

    // Saving a dummy channel
    final dummyChannel = ChannelModel(
      id: id,
      type: type,
      cid: cid,
      config: ChannelConfig(),
    );
    await channelDao.updateChannels([dummyChannel]);

    // Should match the dummy channel
    final updatedChannel = await channelDao.getChannelByCid(cid);
    expect(updatedChannel, isNotNull);
    expect(updatedChannel!.id, id);
    expect(updatedChannel.cid, cid);
    expect(updatedChannel.type, type);

    // Updating the previously saved channel
    const newType = 'newTestType';
    final newChannel = dummyChannel.copyWith(type: newType);
    await channelDao.updateChannels([newChannel]);

    // Should match the new channel
    final newUpdatedChannel = await channelDao.getChannelByCid(cid);
    expect(newUpdatedChannel, isNotNull);
    expect(newUpdatedChannel!.id, id);
    expect(newUpdatedChannel.cid, cid);
    expect(newUpdatedChannel.type, newType);
  });

  tearDown(() async {
    await database.disconnect();
  });
}
