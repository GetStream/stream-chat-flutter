import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient(loaded: false);

  test('one scheduled before anything is loaded does not load them all', () async {
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('new'));

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('scheduledMessages lists the ones scheduled before anything is loaded', () async {
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('new'));
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('reply', parentId: 'parent'));

    expect(idsOf(harness.client.state.scheduledMessages), ['new', 'reply']);
  });

  test("a channel's scheduledMessages lists the ones scheduled in it before anything is loaded", () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('new'));

    expect(idsOf(channel.state!.scheduledMessages), ['new']);
  });

  test("a channel's scheduledThreadReplies lists the replies scheduled before anything is loaded", () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('reply', parentId: 'parent'));

    expect(idsOf(channel.state!.scheduledThreadReplies('parent')), ['reply']);
  });

  test('loadScheduledMessages loads them all, and only those', () async {
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('stale'));
    harness.stubQuery(fakePage([fakeScheduledMessage('a')]));

    await harness.client.loadScheduledMessages();

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isTrue);
    expect(idsOf(harness.client.state.scheduledMessages), ['a']);
  });

  test('queryScheduledMessages adds a page without a next one, and does not load them all', () async {
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    harness.stubQuery(fakePage([fakeScheduledMessage('a', scheduledAt: DateTime.utc(2026, 11, 3))]));

    await harness.client.queryScheduledMessages();

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
    expect(idsOf(harness.client.state.scheduledMessages), ['kept', 'a']);
  });

  test('queryScheduledMessages with a filter does not load them all', () async {
    harness.stubQuery(fakePage([fakeScheduledMessage('a')]));

    await harness.client.queryScheduledMessages(query: const ScheduledMessagesQuery(cid: testCid));

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('loadScheduledMessages whose second page fails adds the first and removes nothing', () async {
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    final first = fakeScheduledMessage('first', scheduledAt: DateTime.utc(2026, 11, 3));
    harness
      ..stubPage(null, () async => fakePage([first], next: 'page-2'))
      ..stubPage('page-2', () async => throw offline);

    await expectLater(harness.client.loadScheduledMessages(), throwsA(offline));

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
    expect(idsOf(harness.client.state.scheduledMessages), ['kept', 'first']);
  });

  test('scheduledMessageListStateStream emits on listen and again each time the state changes', () async {
    final emitted = <ScheduledMessageListState>[];
    final subscription = harness.client.state.scheduledMessageListStateStream.listen(emitted.add);
    addTearDown(subscription.cancel);
    harness.stubQuery(fakePage([fakeScheduledMessage('a')]));

    await harness.client.loadScheduledMessages();
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('b'));
    await settle();

    expect([for (final it in emitted) it.hasLoadedAll], [false, false, true, true]);
    expect(idsOf(emitted.last.scheduledMessages), ['a', 'b']);
  });

  test("a channel query replaces that channel's ones without loading them all", () async {
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('gone'));
    await harness.receive(EventType.scheduledMessageCreated, elsewhere);
    harness.stubQueryChannel(
      ChannelState(
        channel: ChannelModel(cid: testCid),
        scheduledMessages: [
          fakeScheduledMessage('here'),
          fakeScheduledMessage('reply', parentId: 'parent'),
        ],
      ),
    );
    final channel = harness.client.channel('messaging', id: 'general');

    await channel.query(includeScheduledMessages: true);

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
    expect(idsOf(harness.client.state.scheduledMessages), ['here', 'reply', 'there']);
  });

  test('a recovered connection loads none of them when they were not all loaded', () async {
    harness.stubQuery(fakePage([fakeScheduledMessage('a')]));

    harness.client
      ..handleEvent(Event(type: EventType.connectionChanged, online: false))
      ..handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();

    verifyNever(
      () => harness.api.scheduledMessages.queryScheduledMessages(any()),
    );
  });

  test('connecting a user loads none of them', () async {
    verifyNever(
      () => harness.api.scheduledMessages.queryScheduledMessages(any()),
    );
  });

  test('connecting a user again after they were all loaded and the connection was lost loads none of them', () async {
    await harness.loadAllScheduledMessages();
    harness.client.handleEvent(Event(type: EventType.connectionChanged, online: false));
    await settle();

    await harness.client.disconnectUser();
    await harness.client.connectUser(testUser, testToken);
    await settle();

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
    verifyNever(
      () => harness.api.scheduledMessages.queryScheduledMessages(any()),
    );
  });

  test('a channel query that does not say which are scheduled changes nothing', () async {
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    harness.stubQueryChannel(ChannelState(channel: ChannelModel(cid: testCid)));

    await harness.client.queryChannel('messaging', channelId: 'general', includeScheduledMessages: true);

    expect(idsOf(harness.client.state.scheduledMessages), ['kept']);
    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('a channel list query that does not say which are scheduled changes nothing', () async {
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    await harness.receive(EventType.scheduledMessageCreated, elsewhere);
    harness.stubQueryChannels([
      ChannelState(channel: ChannelModel(cid: testCid)),
      ChannelState(channel: ChannelModel(cid: 'messaging:other')),
    ]);

    await harness.client.queryChannelsOnline(
      filter: Filter.in_('cid', const [testCid, 'messaging:other']),
      includeScheduledMessages: true,
    );

    expect(idsOf(harness.client.state.scheduledMessages), ['kept', 'there']);
    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  // Queries the channel [testCid], which carries one scheduled message, 'here'.
  Future<Channel> queryChannel() async {
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('kept'));
    harness.stubQueryChannel(
      ChannelState(
        channel: ChannelModel(cid: testCid),
        scheduledMessages: [fakeScheduledMessage('here')],
      ),
    );
    final channel = harness.client.channel('messaging', id: 'general');
    await channel.query(includeScheduledMessages: true);
    return channel;
  }

  test("a channel's scheduledMessages lists the ones its query carries", () async {
    final channel = await queryChannel();

    expect(idsOf(channel.state!.scheduledMessages), ['here']);
  });

  test("a channel's scheduledMessages adds one scheduled in it after its query", () async {
    final channel = await queryChannel();

    final later = fakeScheduledMessage('new', scheduledAt: DateTime.utc(2026, 11, 3));
    await harness.receive(EventType.scheduledMessageCreated, later);

    expect(idsOf(channel.state!.scheduledMessages), ['here', 'new']);
  });

  test("a channel's scheduledMessages lists the ones a later complete load returns", () async {
    final channel = await queryChannel();

    harness.stubQuery(fakePage([fakeScheduledMessage('loaded')]));
    await harness.client.loadScheduledMessages();
    await settle();

    expect(idsOf(channel.state!.scheduledMessages), ['loaded']);
  });
}
