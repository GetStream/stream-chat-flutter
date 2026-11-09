import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  useScheduledMessageClient();

  final local = fakeScheduledMessage('local', status: ScheduledMessageStatus.preparingToSchedule);

  test("a channel's first query fills its state, keeping the ones not on the server yet", () async {
    await hold([fakeScheduledMessage('gone'), local, elsewhere]);
    stubQueryChannel(carrying([fakeScheduledMessage('fresh')]));
    final channel = client.channel('messaging', id: 'general');

    await channel.query(includeScheduledMessages: true);

    expect(idsOf(channel.state!.scheduledMessages), ['fresh', 'local']);
  });

  final loads = <(String, Future<void> Function(Channel))>[
    ('querying', (channel) => channel.query(includeScheduledMessages: true)),
    ('watching', (channel) => channel.watch(includeScheduledMessages: true)),
  ];

  for (final (name, load) in loads) {
    test('$name a channel that has a state updates it and the client', () async {
      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
      addTearDown(channel.dispose);
      await hold([fakeScheduledMessage('gone'), local, elsewhere]);
      stubQueryChannel(carrying([fakeScheduledMessage('fresh')]));

      await load(channel);

      expect(idsOf(client.state.scheduledMessages), ['fresh', 'local', 'there']);
      expect(idsOf(channel.state!.channelState.scheduledMessages), ['fresh', 'local']);
    });
  }

  test('a channel query keeps one whose request failed', () async {
    final failed = fakeScheduledMessage(
      'failed',
      status: ScheduledMessageStatus.failed,
      failureReason: ScheduledMessageFailureReason.requestFailed,
    );
    await hold([failed]);
    stubQueryChannel(carrying([fakeScheduledMessage('fresh')]));

    await client.queryChannel('messaging', channelId: 'general', includeScheduledMessages: true);

    expect(idsOf(client.state.scheduledMessages), ['fresh', 'failed']);
  });

  test(
    'a channel list query replaces the ones in each channel it loads and keeps the ones not on the server yet',
    () async {
      await hold([fakeScheduledMessage('gone'), local, elsewhere]);
      stubQueryChannels([
        carrying([fakeScheduledMessage('fresh')]),
      ]);

      await client.queryChannelsOnline(
        filter: Filter.equal('cid', testCid),
        includeScheduledMessages: true,
      );

      expect(idsOf(client.state.scheduledMessages), ['fresh', 'local', 'there']);
    },
  );

  test('a channel list query fills the state of each channel it loads', () async {
    await hold([fakeScheduledMessage('gone'), local, elsewhere]);
    stubQueryChannels([
      carrying([fakeScheduledMessage('fresh')]),
    ]);

    final [channel] = await client.queryChannelsOnline(
      filter: Filter.equal('cid', testCid),
      includeScheduledMessages: true,
    );

    expect(idsOf(channel.state!.scheduledMessages), ['fresh', 'local']);
  });

  test('a channel list query lists the ones of all its channels at once', () async {
    stubQueryChannels([
      ChannelState(
        channel: ChannelModel(cid: 'messaging:a'),
        scheduledMessages: [fakeScheduledMessage('in-a', cid: 'messaging:a')],
      ),
      ChannelState(
        channel: ChannelModel(cid: 'messaging:b'),
        scheduledMessages: [fakeScheduledMessage('in-b', cid: 'messaging:b')],
      ),
      ChannelState(channel: ChannelModel(cid: 'messaging:c')),
    ]);
    var emissions = 0;
    final subscription = client.state.scheduledMessagesStream.skip(1).listen((_) => emissions++);
    addTearDown(subscription.cancel);

    await client.queryChannelsOnline(filter: const Filter.empty(), includeScheduledMessages: true);
    await settle();

    expect(emissions, 1);
    expect(idsOf(client.state.scheduledMessages), ['in-a', 'in-b']);
  });

  test("a channel created without them starts with the client's ones in that channel", () async {
    await hold([fakeScheduledMessage('here'), fakeScheduledMessage('reply', parentId: 'parent'), elsewhere]);

    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    expect(idsOf(channel.state!.channelState.scheduledMessages), ['here']);
  });

  test("a channel created with them lists the client's ones instead", () async {
    await hold([fakeScheduledMessage('held')]);

    final channel = Channel.fromState(client, carrying([fakeScheduledMessage('carried')]));
    addTearDown(channel.dispose);

    expect(idsOf(channel.state!.scheduledMessages), ['held']);
  });

  test("a channel's scheduledMessages leaves out the replies in its threads", () async {
    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await hold([fakeScheduledMessage('here'), fakeScheduledMessage('reply', parentId: 'parent')]);

    expect(idsOf(channel.state!.scheduledMessages), ['here']);
  });

  test("a channel's scheduledThreadReplies lists the replies in one of its threads", () async {
    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await hold([
      fakeScheduledMessage('here'),
      fakeScheduledMessage('reply', parentId: 'parent'),
      fakeScheduledMessage('other', parentId: 'other-parent'),
    ]);

    expect(idsOf(channel.state!.scheduledThreadReplies('parent')), ['reply']);
  });

  test("a scheduledMessageCreated event adds it to the channel's state", () async {
    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('new'));

    expect(idsOf(channel.state!.channelState.scheduledMessages), ['new']);
  });

  test("a scheduledMessageCreated event emits the channel's state with it", () async {
    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);
    final emitted = <List<String>>[];
    final subscription = channel.state!.channelStateStream.listen(
      (it) => emitted.add(idsOf(it.scheduledMessages)),
    );
    addTearDown(subscription.cancel);

    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('new'));

    expect(emitted.last, ['new']);
  });

  test('scheduledMessagesStream emits on listen and on each change in the channel', () async {
    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);
    final emitted = <List<String>>[];
    final subscription = channel.state!.scheduledMessagesStream.listen((it) => emitted.add(idsOf(it)));
    addTearDown(subscription.cancel);
    await settle();

    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('here'));
    await receive(EventType.scheduledMessageCreated, elsewhere);

    expect(emitted, [
      <String>[],
      ['here'],
    ]);
  });

  test('scheduledThreadRepliesStream emits on listen and on each change in the thread', () async {
    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);
    final emitted = <List<String>>[];
    final replies = channel.state!.scheduledThreadRepliesStream('parent');
    final subscription = replies.listen((it) => emitted.add(idsOf(it)));
    addTearDown(subscription.cancel);
    await settle();

    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('reply', parentId: 'parent'));
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('here'));

    expect(emitted, [
      <String>[],
      ['reply'],
    ]);
  });

  test('updating the channel state with a stale copy does not bring back a sent scheduled message', () async {
    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);
    await hold([fakeScheduledMessage('sent')]);
    final stale = channel.state!.channelState;
    await receive(EventType.scheduledMessageSent, fakeScheduledMessage('sent'));

    channel.state!.updateChannelState(stale.copyWith(messages: [Message(id: 'sent')]));

    expect(channel.state!.channelState.scheduledMessages, isEmpty);
    expect(client.state.scheduledMessages, isEmpty);
  });

  test('a scheduledMessageCreated event in another channel leaves the channel state as it is', () async {
    final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);
    final before = channel.state!.channelState;

    await receive(EventType.scheduledMessageCreated, elsewhere);

    expect(channel.state!.channelState, same(before));
  });

  test(
    'a query that carries them replaces the ones in that channel and keeps the ones not on the server yet',
    () async {
      await hold([fakeScheduledMessage('gone'), local, elsewhere]);
      stubQueryChannel(carrying([fakeScheduledMessage('fresh')]));

      await client.queryChannel('messaging', channelId: 'general', includeScheduledMessages: true);

      expect(idsOf(client.state.scheduledMessages), ['fresh', 'local', 'there']);
    },
  );

  test('a query that carries an empty list removes the ones in that channel', () async {
    await hold([fakeScheduledMessage('gone'), elsewhere]);
    stubQueryChannel(carrying(const []));

    await client.queryChannel('messaging', channelId: 'general', includeScheduledMessages: true);

    expect(idsOf(client.state.scheduledMessages), ['there']);
  });

  test('a channel list query that carries an empty list removes the ones in that channel', () async {
    await hold([fakeScheduledMessage('gone'), elsewhere]);
    stubQueryChannels([carrying(const [])]);

    await client.queryChannelsOnline(filter: Filter.equal('cid', testCid), includeScheduledMessages: true);

    expect(idsOf(client.state.scheduledMessages), ['there']);
  });
}

// A channel state for [testCid] carrying [scheduledMessages].
ChannelState carrying(List<ScheduledMessage> scheduledMessages) {
  return ChannelState(
    channel: ChannelModel(cid: testCid),
    scheduledMessages: scheduledMessages,
  );
}
