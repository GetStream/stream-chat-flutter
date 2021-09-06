import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/read.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/db/chat_persistence_client.dart';
import 'package:test/test.dart';

class TestPersistenceClient extends ChatPersistenceClient {
  @override
  Future<void> connect(String userId) => throw UnimplementedError();

  @override
  Future<void> deleteChannels(List<String> cids) => throw UnimplementedError();

  @override
  Future<void> deleteMembersByCids(List<String> cids) => Future.value();

  @override
  Future<void> deleteMessageByCids(List<String> cids) => Future.value();

  @override
  Future<void> deleteMessageByIds(List<String> messageIds) => Future.value();

  @override
  Future<void> deletePinnedMessageByCids(List<String> cids) => Future.value();

  @override
  Future<void> deletePinnedMessageByIds(List<String> messageIds) =>
      Future.value();

  @override
  Future<void> deleteReactionsByMessageId(List<String> messageIds) =>
      Future.value();

  @override
  Future<void> deletePinnedMessageReactionsByMessageId(
          List<String> messageIds) =>
      Future.value();

  @override
  Future<void> disconnect({bool flush = false}) => throw UnimplementedError();

  @override
  Future<ChannelModel?> getChannelByCid(String cid) async =>
      ChannelModel(cid: cid);

  @override
  Future<List<String>> getChannelCids() => throw UnimplementedError();

  @override
  Future<List<ChannelState>> getChannelStates(
          {Filter? filter,
          List<SortOption<ChannelModel>>? sort,
          PaginationParams? paginationParams}) =>
      throw UnimplementedError();

  @override
  Future<Map<String, List<Message>>> getChannelThreads(String cid) =>
      throw UnimplementedError();

  @override
  Future<Event?> getConnectionInfo() => throw UnimplementedError();

  @override
  Future<DateTime?> getLastSyncAt() => throw UnimplementedError();

  @override
  Future<List<Member>> getMembersByCid(String cid) async => [];

  @override
  Future<List<Message>> getMessagesByCid(String cid,
          {PaginationParams? messagePagination}) async =>
      [];

  @override
  Future<List<Message>> getPinnedMessagesByCid(String cid,
          {PaginationParams? messagePagination}) async =>
      [];

  @override
  Future<List<Read>> getReadsByCid(String cid) async => [];

  @override
  Future<List<Message>> getReplies(String parentId,
          {PaginationParams? options}) =>
      throw UnimplementedError();

  @override
  Future<void> updateChannelQueries(Filter? filter, List<String> cids,
          {bool clearQueryCache = false}) =>
      throw UnimplementedError();

  @override
  Future<void> updateChannels(List<ChannelModel> channels) => Future.value();

  @override
  Future<void> updateConnectionInfo(Event event) => throw UnimplementedError();

  @override
  Future<void> updateLastSyncAt(DateTime lastSyncAt) =>
      throw UnimplementedError();

  @override
  Future<void> updateReactions(List<Reaction> reactions) => Future.value();

  @override
  Future<void> updatePinnedMessageReactions(List<Reaction> reactions) =>
      Future.value();

  @override
  Future<void> updateUsers(List<User> users) => Future.value();

  @override
  Future<void> bulkUpdateMembers(Map<String, List<Member>> members) =>
      Future.value();

  @override
  Future<void> bulkUpdateMessages(Map<String, List<Message>> messages) =>
      Future.value();

  @override
  Future<void> bulkUpdatePinnedMessages(Map<String, List<Message>> messages) =>
      Future.value();

  @override
  Future<void> bulkUpdateReads(Map<String, List<Read>> reads) => Future.value();
}

void main() {
  group('chatPersistenceClient', () {
    final persistenceClient = TestPersistenceClient();

    test('deleteMessageById', () {
      const messageId = 'message-id';
      persistenceClient.deleteMessageById(messageId);
    });

    test('deleteMessageByCid', () {
      const messageId = 'message-id';
      persistenceClient.deleteMessageByCid(messageId);
    });

    test('deletePinnedMessageById', () {
      const messageId = 'message-id';
      persistenceClient.deletePinnedMessageById(messageId);
    });

    test('deletePinnedMessageByCid', () {
      const messageId = 'message-id';
      persistenceClient.deletePinnedMessageByCid(messageId);
    });

    test('getChannelStateByCid', () async {
      const cid = 'test:cid';
      final channelState = await persistenceClient.getChannelStateByCid(cid);
      expect(channelState, isNotNull);
    });

    test('updateChannelState', () async {
      final channelState = ChannelState();
      persistenceClient.updateChannelState(channelState);
    });

    test('updateChannelStates', () async {
      const cid = 'test:cid';
      final user = User(id: 'test-user-id');
      final channelState = ChannelState(
        channel: ChannelModel(cid: cid, createdBy: user),
        messages: [
          Message(
            id: 'test-message',
            text: 'test-message',
            user: user,
            ownReactions: [Reaction(type: 'test', user: user)],
            latestReactions: [Reaction(type: 'test', user: user)],
          )
        ],
        pinnedMessages: [
          Message(
            id: 'test-message',
            text: 'test-message',
            user: user,
            ownReactions: [Reaction(type: 'test', user: user)],
            latestReactions: [Reaction(type: 'test', user: user)],
          )
        ],
        read: [Read(lastRead: DateTime.now(), user: user)],
        members: [Member(user: user)],
      );
      persistenceClient.updateChannelStates([channelState]);
    });
  });
}
