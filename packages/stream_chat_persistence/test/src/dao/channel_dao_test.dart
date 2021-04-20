import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/channel_dao.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:test/test.dart';

void main() {
  late ChannelDao channelDao;
  late MoorChatDatabase database;

  setUp(() {
    database = MoorChatDatabase.testable('testUserId');
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

    // Deleting the dummyChannel using cid
    await channelDao.deleteChannelByCids([cid]);

    // Fetched channel Should be null
    final channel = await channelDao.getChannelByCid(cid);
    expect(channel, isNull);
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
