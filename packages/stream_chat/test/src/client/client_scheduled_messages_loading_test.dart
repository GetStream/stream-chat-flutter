import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  useScheduledMessageClient(loaded: false);

  final offline = StreamChatNetworkError.raw(code: -1, message: 'No connection');

  void stubQueryChannel(ChannelState channelState) {
    when(
      () => api.channel.queryChannel(
        'messaging',
        channelId: 'general',
        channelData: any(named: 'channelData'),
        state: any(named: 'state'),
        watch: any(named: 'watch'),
        presence: any(named: 'presence'),
        messagesPagination: any(named: 'messagesPagination'),
        membersPagination: any(named: 'membersPagination'),
        watchersPagination: any(named: 'watchersPagination'),
        includeScheduledMessages: any(named: 'includeScheduledMessages'),
      ),
    ).thenAnswer((_) async => channelState);
  }

  void stubQueryChannels(List<ChannelState> channelStates) {
    when(
      () => api.channel.queryChannels(
        filter: any(named: 'filter'),
        state: any(named: 'state'),
        watch: any(named: 'watch'),
        presence: any(named: 'presence'),
        includeScheduledMessages: any(named: 'includeScheduledMessages'),
        paginationParams: any(named: 'paginationParams'),
      ),
    ).thenAnswer((_) async => QueryChannelsResponse()..channels = channelStates);
  }

  test('lists the ones scheduled before anything is loaded', () async {
    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('new'));
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('reply', parentId: 'parent'));

    expect(client.state.hasLoadedAllScheduledMessages, isFalse);
    expect(idsOf(client.state.scheduledMessages), ['new', 'reply']);
    expect(idsOf(channel.state!.scheduledMessages), ['new']);
    expect(idsOf(channel.state!.scheduledThreadReplies('parent')), ['reply']);
  });

  test('loadScheduledMessages loads them all, and only those', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('stale'));
    stubQuery(fakePage([fakeScheduledMessage('a')]));

    await client.loadScheduledMessages();

    expect(client.state.hasLoadedAllScheduledMessages, isTrue);
    expect(idsOf(client.state.scheduledMessages), ['a']);
  });

  test('a page without a next one only adds to them, and does not load them all', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    stubQuery(fakePage([fakeScheduledMessage('a', scheduledAt: DateTime.utc(2026, 11, 3))]));

    await client.queryScheduledMessages();

    expect(client.state.hasLoadedAllScheduledMessages, isFalse);
    expect(idsOf(client.state.scheduledMessages), ['kept', 'a']);
  });

  test('a filtered load does not load them all', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    stubQuery(fakePage([fakeScheduledMessage('a', scheduledAt: DateTime.utc(2026, 11, 3))]));

    await client.queryScheduledMessages(cid: testCid);

    expect(client.state.hasLoadedAllScheduledMessages, isFalse);
    expect(idsOf(client.state.scheduledMessages), ['kept', 'a']);
  });

  test('loadScheduledMessages whose second page fails adds the first and removes nothing', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    final first = fakeScheduledMessage('first', scheduledAt: DateTime.utc(2026, 11, 3));
    stubPage(null, () async => fakePage([first], next: 'page-2'));
    stubPage('page-2', () async => throw offline);

    await expectLater(client.loadScheduledMessages(), throwsA(offline));

    expect(client.state.hasLoadedAllScheduledMessages, isFalse);
    expect(idsOf(client.state.scheduledMessages), ['kept', 'first']);
  });

  test('hasLoadedAllScheduledMessagesStream emits on listen and again only when it changes', () async {
    final emitted = <bool>[];
    final subscription = client.state.hasLoadedAllScheduledMessagesStream.listen(emitted.add);
    addTearDown(subscription.cancel);
    stubQuery(fakePage([fakeScheduledMessage('a')]));

    await client.loadScheduledMessages();
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('b'));
    await settle();

    expect(emitted, [false, true]);
  });

  test("a channel query replaces that channel's ones without loading them all", () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('gone'));
    final elsewhere = fakeScheduledMessage('there', cid: 'messaging:other', scheduledAt: DateTime.utc(2026, 11, 3));
    await receive(EventType.scheduledMessageCreated, elsewhere);
    stubQueryChannel(
      ChannelState(
        channel: ChannelModel(cid: testCid),
        scheduledMessages: [
          fakeScheduledMessage('here'),
          fakeScheduledMessage('reply', parentId: 'parent'),
        ],
      ),
    );
    final channel = client.channel('messaging', id: 'general');

    await channel.query(includeScheduledMessages: true);

    expect(client.state.hasLoadedAllScheduledMessages, isFalse);
    expect(idsOf(client.state.scheduledMessages), ['here', 'reply', 'there']);
    expect(idsOf(channel.state!.scheduledMessages), ['here']);
    expect(idsOf(channel.state!.scheduledThreadReplies('parent')), ['reply']);
  });

  test('they are not loaded when the connection recovers', () async {
    stubQuery(fakePage([fakeScheduledMessage('a')]));

    client
      ..handleEvent(Event(type: EventType.connectionChanged, online: false))
      ..handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();

    verifyNever(
      () => api.scheduledMessages.queryScheduledMessages(
        cid: any(named: 'cid'),
        statuses: any(named: 'statuses'),
        pagination: any(named: 'pagination'),
      ),
    );
  });

  test('connecting a user loads none of them until loadScheduledMessages is called', () async {
    verifyNever(
      () => api.scheduledMessages.queryScheduledMessages(
        cid: any(named: 'cid'),
        statuses: any(named: 'statuses'),
        pagination: any(named: 'pagination'),
      ),
    );

    stubQuery(fakePage([fakeScheduledMessage('a')]));
    await client.loadScheduledMessages();

    verify(
      () => api.scheduledMessages.queryScheduledMessages(
        cid: any(named: 'cid'),
        statuses: any(named: 'statuses'),
        pagination: any(named: 'pagination'),
      ),
    ).called(1);
  });

  test('connecting a user again after they were all loaded and the connection was lost loads none of them', () async {
    await loadAllScheduledMessages();
    client.handleEvent(Event(type: EventType.connectionChanged, online: false));
    await settle();

    await client.disconnectUser();
    await client.connectUser(testUser, testToken);
    await settle();

    expect(client.state.hasLoadedAllScheduledMessages, isFalse);
    verifyNever(
      () => api.scheduledMessages.queryScheduledMessages(
        cid: any(named: 'cid'),
        statuses: any(named: 'statuses'),
        pagination: any(named: 'pagination'),
      ),
    );
  });

  test('a channel query that does not say which are scheduled changes nothing', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    stubQueryChannel(ChannelState(channel: ChannelModel(cid: testCid)));

    await client.queryChannel('messaging', channelId: 'general', includeScheduledMessages: true);

    expect(idsOf(client.state.scheduledMessages), ['kept']);
    expect(client.state.hasLoadedAllScheduledMessages, isFalse);
  });

  test('a channel list query that does not say which are scheduled changes nothing', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    final other = fakeScheduledMessage('there', cid: 'messaging:other', scheduledAt: DateTime.utc(2026, 11, 3));
    await receive(EventType.scheduledMessageCreated, other);
    stubQueryChannels([
      ChannelState(channel: ChannelModel(cid: testCid)),
      ChannelState(channel: ChannelModel(cid: 'messaging:other')),
    ]);

    await client.queryChannelsOnline(
      filter: Filter.in_('cid', const [testCid, 'messaging:other']),
      includeScheduledMessages: true,
    );

    expect(idsOf(client.state.scheduledMessages), ['kept', 'there']);
    expect(client.state.hasLoadedAllScheduledMessages, isFalse);
  });

  test("a channel's state lists the client's scheduled messages in that channel as they change", () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    stubQueryChannel(
      ChannelState(
        channel: ChannelModel(cid: testCid),
        scheduledMessages: [fakeScheduledMessage('here')],
      ),
    );
    final channel = client.channel('messaging', id: 'general');

    await channel.query(includeScheduledMessages: true);
    expect(idsOf(channel.state!.channelState.scheduledMessages), ['here']);

    final later = fakeScheduledMessage('new', scheduledAt: DateTime.utc(2026, 11, 3));
    await receive(EventType.scheduledMessageCreated, later);
    expect(idsOf(channel.state!.channelState.scheduledMessages), ['here', 'new']);

    stubQuery(fakePage([fakeScheduledMessage('loaded')]));
    await client.loadScheduledMessages();
    await settle();
    expect(idsOf(channel.state!.channelState.scheduledMessages), ['loaded']);
  });
}
