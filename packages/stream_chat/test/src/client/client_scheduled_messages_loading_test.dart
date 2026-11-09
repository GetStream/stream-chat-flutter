import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  useScheduledMessageClient(loaded: false);

  test('scheduledMessages lists the ones scheduled before anything is loaded', () async {
    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('new'));
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('reply', parentId: 'parent'));

    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
    expect(idsOf(client.state.scheduledMessages), ['new', 'reply']);
    expect(idsOf(channel.state!.scheduledMessages), ['new']);
    expect(idsOf(channel.state!.scheduledThreadReplies('parent')), ['reply']);
  });

  test('loadScheduledMessages loads them all, and only those', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('stale'));
    stubQuery(fakePage([fakeScheduledMessage('a')]));

    await client.loadScheduledMessages();

    expect(client.state.scheduledMessageListState.hasLoadedAll, isTrue);
    expect(idsOf(client.state.scheduledMessages), ['a']);
  });

  test('queryScheduledMessages adds a page without a next one, and does not load them all', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    stubQuery(fakePage([fakeScheduledMessage('a', scheduledAt: DateTime.utc(2026, 11, 3))]));

    await client.queryScheduledMessages();

    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
    expect(idsOf(client.state.scheduledMessages), ['kept', 'a']);
  });

  test('queryScheduledMessages with a filter does not load them all', () async {
    stubQuery(fakePage([fakeScheduledMessage('a')]));

    await client.queryScheduledMessages(query: const ScheduledMessagesQuery(cid: testCid));

    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('loadScheduledMessages whose second page fails adds the first and removes nothing', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    final first = fakeScheduledMessage('first', scheduledAt: DateTime.utc(2026, 11, 3));
    stubPage(null, () async => fakePage([first], next: 'page-2'));
    stubPage('page-2', () async => throw offline);

    await expectLater(client.loadScheduledMessages(), throwsA(offline));

    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
    expect(idsOf(client.state.scheduledMessages), ['kept', 'first']);
  });

  test('scheduledMessageListStateStream emits on listen and again each time the state changes', () async {
    final emitted = <ScheduledMessageListState>[];
    final subscription = client.state.scheduledMessageListStateStream.listen(emitted.add);
    addTearDown(subscription.cancel);
    stubQuery(fakePage([fakeScheduledMessage('a')]));

    await client.loadScheduledMessages();
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('b'));
    await settle();

    expect([for (final it in emitted) it.hasLoadedAll], [false, false, true, true]);
    expect(idsOf(emitted.last.scheduledMessages), ['a', 'b']);
  });

  test("a channel query replaces that channel's ones without loading them all", () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('gone'));
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

    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
    expect(idsOf(client.state.scheduledMessages), ['here', 'reply', 'there']);
  });

  test('a recovered connection loads none of them when they were not all loaded', () async {
    stubQuery(fakePage([fakeScheduledMessage('a')]));

    client
      ..handleEvent(Event(type: EventType.connectionChanged, online: false))
      ..handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();

    verifyNever(
      () => api.scheduledMessages.queryScheduledMessages(any()),
    );
  });

  test('connecting a user loads none of them', () async {
    verifyNever(
      () => api.scheduledMessages.queryScheduledMessages(any()),
    );
  });

  test('connecting a user again after they were all loaded and the connection was lost loads none of them', () async {
    await loadAllScheduledMessages();
    client.handleEvent(Event(type: EventType.connectionChanged, online: false));
    await settle();

    await client.disconnectUser();
    await client.connectUser(testUser, testToken);
    await settle();

    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
    verifyNever(
      () => api.scheduledMessages.queryScheduledMessages(any()),
    );
  });

  test('a channel query that does not say which are scheduled changes nothing', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    stubQueryChannel(ChannelState(channel: ChannelModel(cid: testCid)));

    await client.queryChannel('messaging', channelId: 'general', includeScheduledMessages: true);

    expect(idsOf(client.state.scheduledMessages), ['kept']);
    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('a channel list query that does not say which are scheduled changes nothing', () async {
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    await receive(EventType.scheduledMessageCreated, elsewhere);
    stubQueryChannels([
      ChannelState(channel: ChannelModel(cid: testCid)),
      ChannelState(channel: ChannelModel(cid: 'messaging:other')),
    ]);

    await client.queryChannelsOnline(
      filter: Filter.in_('cid', const [testCid, 'messaging:other']),
      includeScheduledMessages: true,
    );

    expect(idsOf(client.state.scheduledMessages), ['kept', 'there']);
    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
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
