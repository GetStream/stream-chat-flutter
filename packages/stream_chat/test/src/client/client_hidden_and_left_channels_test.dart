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
    final persistence = MockPersistenceClient();
    when(() => persistence.deleteChannels(any())).thenAnswer((_) async {});
    when(() => persistence.getChannelThreads(any())).thenAnswer((_) async => {});
    client.chatPersistenceClient = persistence;
    _addChannel(client, 'messaging:hidden');

    await _hide(client, 'messaging:hidden');

    verify(() => persistence.deleteChannels(['messaging:hidden'])).called(1);
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

  test('querying a channel whose response has no membership keeps the current one', () async {
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

  test('channel.deleted disposes a hidden channel', () async {
    final channel = _addChannel(client, 'messaging:hidden');
    await _hide(client, 'messaging:hidden');

    client.handleEvent(
      Event(
        type: EventType.channelDeleted,
        cid: 'messaging:hidden',
        channel: ChannelModel(cid: 'messaging:hidden'),
      ),
    );
    await Future<void>.delayed(Duration.zero);

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
}

Channel _addChannel(StreamChatClient client, String cid, {Member? membership}) {
  final channel = Channel.fromState(
    client,
    ChannelState(
      channel: ChannelModel(cid: cid),
      membership: membership,
    ),
  );
  client.state.addChannels({cid: channel});
  return channel;
}

Member _membershipOf(User user) => Member(userId: user.id, user: user);

Future<void> _hide(StreamChatClient client, String cid) async {
  client.handleEvent(
    Event(
      type: EventType.channelHidden,
      cid: cid,
      channel: ChannelModel(cid: cid),
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

void _stubQueryChannel(FakeChatApi api, String cid) {
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
  ).thenAnswer((_) async => ChannelState(channel: ChannelModel(cid: cid)));
}

void _stubQueryChannels(FakeChatApi api, List<String> cids) {
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
        for (final cid in cids) ChannelState(channel: ChannelModel(cid: cid)),
      ],
  );
}
