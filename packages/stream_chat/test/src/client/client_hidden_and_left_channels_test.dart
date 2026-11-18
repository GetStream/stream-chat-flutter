import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  const apiKey = 'test-api-key';
  final currentUser = OwnUser(id: 'current-user');
  final otherUser = User(id: 'other-user');

  late FakeChatApi api;
  late StreamChatClient client;

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
    registerFallbackValue(const ChannelState());
  });

  setUp(() {
    api = FakeChatApi();
    client = StreamChatClient(apiKey, ws: FakeWebSocket(), chatApi: api);
    client.state
      ..currentUser = currentUser
      ..subscribeToEvents();
  });

  tearDown(() {
    client.dispose();
  });

  test('channel.hidden leaves the channel out of client.state.channels', () async {
    _addChannel(client, 'messaging:hidden');

    await _hide(client, 'messaging:hidden');

    expect(client.state.channels, isNot(contains('messaging:hidden')));
  });

  test('channel.hidden keeps the channel usable for code still holding it', () async {
    final channel = _addChannel(client, 'messaging:hidden');

    await _hide(client, 'messaging:hidden');

    expect(channel.state, isNotNull);
  });

  test('channel.hidden deletes the channel from persistence', () async {
    final persistence = _persistence();
    client.chatPersistenceClient = persistence;
    _addChannel(client, 'messaging:hidden');

    await _hide(client, 'messaging:hidden');

    verify(() => persistence.deleteChannels(['messaging:hidden'])).called(1);
  });

  test('hiding a channel that is not loaded deletes it from persistence', () async {
    final persistence = _persistence();
    client.chatPersistenceClient = persistence;

    await _hide(client, 'messaging:hidden');

    verify(() => persistence.deleteChannels(['messaging:hidden'])).called(1);
  });

  test('channel.hidden keeps the messages', () async {
    final channel = _addChannel(
      client,
      'messaging:hidden',
      messages: [Message(id: 'message', text: 'Hi')],
    );

    await _hide(client, 'messaging:hidden');

    expect(channel.state!.messages, isNotEmpty);
  });

  test('channel.hidden with a cleared history clears the messages', () async {
    final channel = _addChannel(
      client,
      'messaging:hidden',
      messages: [Message(id: 'message', text: 'Hi')],
    );

    await _hide(client, 'messaging:hidden', clearHistory: true);

    expect(channel.state!.messages, isEmpty);
  });

  test('channel.hidden with a cleared history deletes the messages from persistence', () async {
    final persistence = _persistence();
    when(() => persistence.deleteMessageByCid(any())).thenAnswer((_) async {});
    client.chatPersistenceClient = persistence;
    _addChannel(
      client,
      'messaging:hidden',
      messages: [Message(id: 'message', text: 'Hi')],
    );

    await _hide(client, 'messaging:hidden', clearHistory: true);

    verify(() => persistence.deleteMessageByCid('messaging:hidden')).called(1);
  });

  test('a new message shows a hidden channel again', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    await _receiveMessage(client, 'messaging:hidden', Message(id: 'message', text: 'Hi', user: otherUser));

    expect(channel.hidden, isFalse);
  });

  test('a new shadowed message keeps a hidden channel hidden', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    await _receiveMessage(
      client,
      'messaging:hidden',
      Message(id: 'message', text: 'Hi', user: otherUser, shadowed: true),
    );

    expect(channel.hidden, isTrue);
  });

  test('channel.hidden marks the channel as hidden', () async {
    final channel = _addChannel(client, 'messaging:hidden');

    await _hide(client, 'messaging:hidden');

    expect(channel.hidden, isTrue);
  });

  test('channel.visible marks a hidden channel as visible', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    client.handleEvent(
      Event(
        type: EventType.channelVisible,
        cid: 'messaging:hidden',
        channel: ChannelModel(cid: 'messaging:hidden'),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(channel.hidden, isFalse);
  });

  test('notification.removed_from_channel leaves the channel out of client.state.channels', () async {
    _addChannel(client, 'messaging:left');

    await _removeFromChannel(client, 'messaging:left', currentUser);

    expect(client.state.channels, isNot(contains('messaging:left')));
  });

  test('notification.removed_from_channel keeps the channel usable for code still holding it', () async {
    final channel = _addChannel(client, 'messaging:left');

    await _removeFromChannel(client, 'messaging:left', currentUser);

    expect(channel.state, isNotNull);
  });

  test("notification.removed_from_channel clears the current user's membership", () async {
    final channel = _addChannel(client, 'messaging:left', membership: _membershipOf(currentUser));

    await _removeFromChannel(client, 'messaging:left', currentUser);

    expect(channel.state!.channelState.membership, isNull);
  });

  test('member.removed for the current user clears their membership', () async {
    final channel = _addChannel(client, 'messaging:left', membership: _membershipOf(currentUser));

    client.handleEvent(
      Event(
        type: EventType.memberRemoved,
        cid: 'messaging:left',
        channel: ChannelModel(cid: 'messaging:left'),
        user: currentUser,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(channel.state!.channelState.membership, isNull);
  });

  test("member.removed for another user keeps the current user's membership", () async {
    final channel = _addChannel(client, 'messaging:group', membership: _membershipOf(currentUser));

    client.handleEvent(
      Event(
        type: EventType.memberRemoved,
        cid: 'messaging:group',
        channel: ChannelModel(cid: 'messaging:group'),
        user: otherUser,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(channel.state!.channelState.membership, isNotNull);
  });

  test('querying channels keeps the current membership when the response has none', () async {
    final channel = _addChannel(client, 'messaging:group', membership: _membershipOf(currentUser));
    _stubQueryChannels(api, ['messaging:group']);

    await client.queryChannelsOnline(waitForConnect: false);

    expect(channel.state!.channelState.membership, isNotNull);
  });

  test('member.removed for another user keeps the channel in client.state.channels', () async {
    _addChannel(client, 'messaging:group');

    client.handleEvent(
      Event(
        type: EventType.memberRemoved,
        cid: 'messaging:group',
        channel: ChannelModel(cid: 'messaging:group'),
        user: otherUser,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(client.state.channels, contains('messaging:group'));
  });

  test('client.channel returns the same instance for a hidden channel', () async {
    final channel = _addChannel(client, 'messaging:hidden');

    await _hide(client, 'messaging:hidden');

    expect(client.channel('messaging', id: 'hidden'), same(channel));
  });

  test('client.channel returns a new instance for a deleted channel', () async {
    final channel = _addChannel(client, 'messaging:deleted');

    await _delete(client, 'messaging:deleted');

    expect(client.channel('messaging', id: 'deleted'), isNot(same(channel)));
  });

  test('client.channel returns a new instance for a channel the user left', () async {
    final channel = _addChannel(client, 'messaging:left');

    await _removeFromChannel(client, 'messaging:left', currentUser);

    expect(client.channel('messaging', id: 'left'), isNot(same(channel)));
  });

  test('watching a hidden channel puts it back in client.state.channels', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');
    _stubQueryChannel(api, 'messaging:hidden');

    await channel.watch();

    expect(client.state.channels, contains('messaging:hidden'));
  });

  test('querying a hidden channel without watching it leaves it out of client.state.channels', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');
    _stubQueryChannel(api, 'messaging:hidden');

    await channel.query(messagesPagination: const PaginationParams(limit: 20));

    expect(client.state.channels, isNot(contains('messaging:hidden')));
  });

  test('querying a hidden channel keeps it hidden', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');
    _stubQueryChannel(api, 'messaging:hidden');

    await channel.query(messagesPagination: const PaginationParams(limit: 20));

    expect(channel.hidden, isTrue);
  });

  test('querying channels brings back only the hidden channels the server returns', () async {
    _addChannel(client, 'messaging:returned');
    _addChannel(client, 'messaging:still-hidden');
    await _hide(client, 'messaging:returned');
    await _hide(client, 'messaging:still-hidden');
    _stubQueryChannels(api, ['messaging:returned']);

    await client.queryChannelsOnline(waitForConnect: false);

    expect(
      client.state.channels.keys,
      allOf(contains('messaging:returned'), isNot(contains('messaging:still-hidden'))),
    );
  });

  test('querying channels reuses the instance of a hidden channel', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');
    _stubQueryChannels(api, ['messaging:hidden']);

    final channels = await client.queryChannelsOnline(waitForConnect: false);

    expect(channels.single, same(channel));
  });

  test('client.state.channels stays unmodifiable while a channel is hidden', () async {
    _addChannel(client, 'messaging:visible');
    _addChannel(client, 'messaging:hidden');

    await _hide(client, 'messaging:hidden');

    expect(() => client.state.channels.clear(), throwsUnsupportedError);
  });

  test('disposing the client state disposes hidden channels too', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    client.state.dispose();

    expect(channel.state, isNull);
  });

  test('channel.deleted keeps the channel usable for code still holding it', () async {
    final channel = _addChannel(client, 'messaging:deleted');

    await _delete(client, 'messaging:deleted');

    expect(channel.state, isNotNull);
  });

  test('channel.deleted leaves the channel out of client.state.channels', () async {
    _addChannel(client, 'messaging:deleted');

    await _delete(client, 'messaging:deleted');

    expect(client.state.channels, isNot(contains('messaging:deleted')));
  });

  test('channel.deleted marks the channel as deleted', () async {
    final deletedAt = DateTime.utc(2026, 11, 17);
    final channel = _addChannel(client, 'messaging:deleted');

    await _delete(client, 'messaging:deleted', deletedAt: deletedAt);

    expect(channel.deletedAt, deletedAt);
  });

  test('channel.deleted clears the messages', () async {
    final channel = _addChannel(
      client,
      'messaging:deleted',
      messages: [Message(id: 'message', text: 'Hi')],
    );

    await _delete(client, 'messaging:deleted');

    expect(channel.state!.messages, isEmpty);
  });

  test('notification.channel_deleted marks the channel as deleted', () async {
    final deletedAt = DateTime.utc(2026, 11, 17);
    final channel = _addChannel(client, 'messaging:deleted');

    await _delete(client, 'messaging:deleted', deletedAt: deletedAt, type: EventType.notificationChannelDeleted);

    expect(channel.deletedAt, deletedAt);
  });

  test('channel.deleted deletes the channel from persistence', () async {
    final persistence = _persistence();
    client.chatPersistenceClient = persistence;
    _addChannel(client, 'messaging:deleted');

    await _delete(client, 'messaging:deleted');

    verify(() => persistence.deleteChannels(['messaging:deleted'])).called(1);
  });

  test('channel.deleted stops saving the channel to persistence', () async {
    final persistence = _persistence();
    client.chatPersistenceClient = persistence;
    _addChannel(client, 'messaging:deleted');

    await _delete(client, 'messaging:deleted');
    await Future<void>.delayed(_pastPersistenceDebounce);

    verifyNever(() => persistence.updateChannelState(any()));
  });

  test('notification.removed_from_channel stops saving the channel to persistence', () async {
    final persistence = _persistence();
    client.chatPersistenceClient = persistence;
    _addChannel(client, 'messaging:left', membership: _membershipOf(currentUser));

    await _removeFromChannel(client, 'messaging:left', currentUser);
    await Future<void>.delayed(_pastPersistenceDebounce);

    verifyNever(() => persistence.updateChannelState(any()));
  });

  test('channel.hidden stops saving the channel to persistence', () async {
    final persistence = _persistence();
    client.chatPersistenceClient = persistence;
    _addChannel(client, 'messaging:hidden');

    await _hide(client, 'messaging:hidden');
    await Future<void>.delayed(_pastPersistenceDebounce);

    verifyNever(() => persistence.updateChannelState(any()));
  });

  test('a channel queried with hidden: true is saved to persistence', () async {
    final persistence = _persistence();
    when(
      () => persistence.saveChannelQueries(
        cids: any(named: 'cids'),
        filter: any(named: 'filter'),
        clearQueryCache: any(named: 'clearQueryCache'),
      ),
    ).thenAnswer((_) async {});
    client.chatPersistenceClient = persistence;
    _stubQueryChannels(api, ['messaging:hidden'], hidden: true);

    await client.queryChannelsOnline(filter: Filter.equal('hidden', true), waitForConnect: false);
    await Future<void>.delayed(_pastPersistenceDebounce);

    verify(() => persistence.updateChannelState(any())).called(1);
  });

  test('a new message on a hidden channel saves it again', () async {
    final persistence = _persistence();
    client.chatPersistenceClient = persistence;
    _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');
    await Future<void>.delayed(_pastPersistenceDebounce);

    await _receiveMessage(client, 'messaging:hidden', Message(id: 'message', text: 'Hi', user: otherUser));
    await Future<void>.delayed(_pastPersistenceDebounce);

    verify(() => persistence.updateChannelState(any())).called(1);
  });

  test('watching a channel the user was removed from saves it again', () async {
    final persistence = _persistence();
    client.chatPersistenceClient = persistence;
    final channel = _addChannel(client, 'messaging:left', membership: _membershipOf(currentUser));
    await _removeFromChannel(client, 'messaging:left', currentUser);
    _stubQueryChannel(api, 'messaging:left');

    await channel.watch();
    await Future<void>.delayed(_pastPersistenceDebounce);

    verify(() => persistence.updateChannelState(any())).called(1);
  });

  test('a new message puts a hidden channel back in client.state.channels', () async {
    _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    await _receiveMessage(client, 'messaging:hidden', Message(id: 'message', text: 'Hi', user: otherUser));

    expect(client.state.channels, contains('messaging:hidden'));
  });

  test('disposing the client state disposes a hidden channel another instance replaced', () async {
    final replaced = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');
    _addChannel(client, 'messaging:hidden');

    client.state.dispose();

    expect(replaced.state, isNull);
  });

  test('a channel another instance replaced stops saving to persistence', () async {
    final persistence = _persistence();
    client.chatPersistenceClient = persistence;
    final replaced = _addChannel(client, 'messaging:replaced');
    _addChannel(client, 'messaging:replaced');

    replaced.state!.unreadCount = 3;
    await Future<void>.delayed(_pastPersistenceDebounce);

    // Only the replacing instance saves.
    verify(() => persistence.updateChannelState(any())).called(1);
  });

  test('disposing a detached channel keeps the current one for its cid', () async {
    final detached = _addChannel(client, 'messaging:left');
    await _removeFromChannel(client, 'messaging:left', currentUser);
    final current = _addChannel(client, 'messaging:left');

    detached.dispose();

    expect(client.state.channels['messaging:left'], same(current));
  });

  test('a new shadowed message keeps a hidden channel out of client.state.channels', () async {
    _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    await _receiveMessage(
      client,
      'messaging:hidden',
      Message(id: 'message', text: 'Hi', user: otherUser, shadowed: true),
    );

    expect(client.state.channels, isNot(contains('messaging:hidden')));
  });

  test('a new system message keeps a hidden channel hidden', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    await _receiveMessage(
      client,
      'messaging:hidden',
      Message(id: 'message', text: 'Hi', user: otherUser, type: MessageType.system),
    );

    expect(channel.hidden, isTrue);
    expect(client.state.channels, isNot(contains('messaging:hidden')));
  });

  test('a new message from a user the current user blocked keeps a hidden channel hidden', () async {
    client.state.currentUser = OwnUser(id: currentUser.id, blockedUserIds: [otherUser.id]);
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    await _receiveMessage(client, 'messaging:hidden', Message(id: 'message', text: 'Hi', user: otherUser));

    expect(channel.hidden, isTrue);
    expect(client.state.channels, isNot(contains('messaging:hidden')));
  });

  test('a new thread reply shows a hidden channel again', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    await _receiveMessage(
      client,
      'messaging:hidden',
      Message(id: 'reply', text: 'Hi', user: otherUser, parentId: 'parent', type: MessageType.reply),
    );

    expect(channel.hidden, isFalse);
    expect(client.state.channels, contains('messaging:hidden'));
  });

  test('a new message for a channel that is not loaded leaves client.state.channels unchanged', () async {
    await _receiveMessage(client, 'messaging:unknown', Message(id: 'message', text: 'Hi', user: otherUser));

    expect(client.state.channels, isNot(contains('messaging:unknown')));
  });

  test('a new message lists only the current instance of a hidden channel', () async {
    _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');
    final current = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    await _receiveMessage(client, 'messaging:hidden', Message(id: 'message', text: 'Hi', user: otherUser));

    expect(client.state.channels['messaging:hidden'], same(current));
  });

  test('disposing the client state disposes a deleted channel', () async {
    final channel = _addChannel(client, 'messaging:deleted');
    await _delete(client, 'messaging:deleted');

    client.state.dispose();

    expect(channel.state, isNull);
  });

  test('channel.visible puts a hidden channel back in client.state.channels', () async {
    _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    client.handleEvent(
      Event(
        type: EventType.channelVisible,
        cid: 'messaging:hidden',
        channel: ChannelModel(cid: 'messaging:hidden'),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(client.state.channels, contains('messaging:hidden'));
  });

  test("deleting a banned user's messages reaches a hidden channel", () async {
    final bannedUser = User(id: 'banned-user');
    final channel = Channel.fromState(
      client,
      ChannelState(
        channel: ChannelModel(cid: 'messaging:hidden'),
        messages: [Message(id: 'banned-message', user: bannedUser)],
      ),
    );
    client.state.addChannels({'messaging:hidden': channel});
    await _hide(client, 'messaging:hidden');

    client.handleEvent(
      Event(type: EventType.userMessagesDeleted, user: bannedUser, hardDelete: true),
    );
    await Future<void>.delayed(Duration.zero);

    expect(channel.state!.messages, isEmpty);
  });

  test('client.channel returns the same instance before it is watched', () {
    final channel = client.channel('messaging', id: 'created');

    expect(client.channel('messaging', id: 'created'), same(channel));
  });

  test("client.channel merges a later call's extra data before the channel is loaded", () {
    client.channel('messaging', id: 'created', extraData: {'name': 'First'});

    final channel = client.channel('messaging', id: 'created', extraData: {'name': 'Second'});

    expect(channel.extraData['name'], 'Second');
  });

  test("client.channel ignores a later call's extra data once the channel is loaded", () {
    final channel = _addChannel(client, 'messaging:loaded');

    client.channel('messaging', id: 'loaded', extraData: {'name': 'Later'});

    expect(channel.extraData['name'], isNull);
  });

  test('querying channels completes initialized after a failed first watch', () async {
    final channel = client.channel('messaging', id: 'retry');
    _stubQueryChannel(api, 'messaging:retry', failWhen: () => true);
    final initializedFailure = expectLater(channel.initialized, throwsA(isA<StreamChatNetworkError>()));
    await expectLater(channel.watch(), throwsA(isA<StreamChatNetworkError>()));
    await initializedFailure;
    _stubQueryChannels(api, ['messaging:retry']);

    await client.queryChannelsOnline(waitForConnect: false);

    expect(await channel.initialized, isTrue);
  });

  test('querying channels returns the instance client.channel created', () async {
    final channel = client.channel('messaging', id: 'created');
    _stubQueryChannels(api, ['messaging:created']);

    final channels = await client.queryChannelsOnline(waitForConnect: false);

    expect(channels.single, same(channel));
  });

  test('querying channels loads the instance client.channel created', () async {
    final channel = client.channel('messaging', id: 'created');
    _stubQueryChannels(api, ['messaging:created']);

    await client.queryChannelsOnline(waitForConnect: false);

    expect(channel.state, isNotNull);
  });

  test('a new message for a channel that was created but not watched leaves client.state.channels unchanged', () async {
    client.channel('messaging', id: 'created');

    await _receiveMessage(client, 'messaging:created', Message(id: 'message', text: 'Hi', user: otherUser));

    expect(client.state.channels, isNot(contains('messaging:created')));
  });

  test('disposing a channel that was never watched makes client.channel return a new instance', () {
    final channel = client.channel('messaging', id: 'created')..dispose();

    expect(client.channel('messaging', id: 'created'), isNot(same(channel)));
  });

  test('watching a channel again after a failed first watch loads it', () async {
    final channel = client.channel('messaging', id: 'retry');
    var isOffline = true;
    _stubQueryChannel(api, 'messaging:retry', failWhen: () => isOffline);
    // The failed watch also fails `initialized`; listen so it isn't unhandled.
    final initializedFailure = expectLater(channel.initialized, throwsA(isA<StreamChatNetworkError>()));
    await expectLater(channel.watch(), throwsA(isA<StreamChatNetworkError>()));
    await initializedFailure;
    isOffline = false;

    await channel.watch();

    expect(channel.state, isNotNull);
  });
}

Channel _addChannel(
  StreamChatClient client,
  String cid, {
  Member? membership,
  List<Message> messages = const [],
}) {
  final channel = Channel.fromState(
    client,
    ChannelState(
      channel: ChannelModel(cid: cid),
      membership: membership,
      messages: messages,
    ),
  );
  client.state.addChannels({cid: channel});
  return channel;
}

Member _membershipOf(User user) => Member(userId: user.id, user: user);

// Longer than the delay before a channel saves its state to persistence.
const _pastPersistenceDebounce = Duration(milliseconds: 1100);

MockPersistenceClient _persistence() {
  final persistence = MockPersistenceClient();
  when(() => persistence.getChannelThreads(any())).thenAnswer((_) async => {});
  when(() => persistence.deleteChannels(any())).thenAnswer((_) async {});
  when(() => persistence.updateChannelState(any())).thenAnswer((_) async {});
  return persistence;
}

Future<void> _hide(StreamChatClient client, String cid, {bool clearHistory = false}) async {
  client.handleEvent(
    Event(
      type: EventType.channelHidden,
      cid: cid,
      channel: ChannelModel(cid: cid),
      extraData: {'clear_history': clearHistory},
    ),
  );
  await Future<void>.delayed(Duration.zero);
}

Future<void> _delete(
  StreamChatClient client,
  String cid, {
  DateTime? deletedAt,
  String type = EventType.channelDeleted,
}) async {
  client.handleEvent(
    Event(
      type: type,
      cid: cid,
      channel: ChannelModel(cid: cid, deletedAt: deletedAt),
    ),
  );
  await Future<void>.delayed(Duration.zero);
}

Future<void> _receiveMessage(StreamChatClient client, String cid, Message message) async {
  client.handleEvent(
    Event(
      type: EventType.messageNew,
      cid: cid,
      channel: ChannelModel(cid: cid),
      message: message,
      user: message.user,
    ),
  );
  await Future<void>.delayed(Duration.zero);
}

Future<void> _removeFromChannel(StreamChatClient client, String cid, User user) async {
  client.handleEvent(
    Event(
      type: EventType.notificationRemovedFromChannel,
      cid: cid,
      channel: ChannelModel(cid: cid),
      user: user,
    ),
  );
  await Future<void>.delayed(Duration.zero);
}

// Stubs [cid]'s query, failing while [failWhen] returns true.
void _stubQueryChannel(FakeChatApi api, String cid, {bool Function()? failWhen}) {
  final [type, id] = cid.split(':');
  when(
    () => api.channel.queryChannel(
      type,
      channelId: id,
      channelData: any(named: 'channelData'),
      state: any(named: 'state'),
      watch: any(named: 'watch'),
      presence: any(named: 'presence'),
      messagesPagination: any(named: 'messagesPagination'),
      membersPagination: any(named: 'membersPagination'),
      watchersPagination: any(named: 'watchersPagination'),
    ),
  ).thenAnswer((_) async {
    if (failWhen?.call() ?? false) throw StreamChatNetworkError(ChatErrorCode.internalSystemError);
    return ChannelState(channel: ChannelModel(cid: cid));
  });
}

void _stubQueryChannels(FakeChatApi api, List<String> cids, {bool? hidden}) {
  when(
    () => api.channel.queryChannels(
      filter: any(named: 'filter'),
      sort: any(named: 'sort'),
      state: any(named: 'state'),
      watch: any(named: 'watch'),
      presence: any(named: 'presence'),
      memberLimit: any(named: 'memberLimit'),
      messageLimit: any(named: 'messageLimit'),
      paginationParams: any(named: 'paginationParams'),
    ),
  ).thenAnswer(
    (_) async => QueryChannelsResponse()
      ..channels = [
        for (final cid in cids)
          ChannelState(
            channel: ChannelModel(cid: cid, hidden: hidden),
          ),
      ],
  );
}
