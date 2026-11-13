import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  final local = fakeScheduledMessage('local', status: ScheduledMessageStatus.preparingToSchedule, isOnServer: false);

  test("a channel's first query fills its state, keeping the ones not on the server yet", () async {
    await harness.hold([fakeScheduledMessage('gone'), local, elsewhere]);
    harness.stubQueryChannel(carrying([fakeScheduledMessage('fresh')]));
    final channel = harness.client.channel('messaging', id: 'general');

    await channel.query(includeScheduledMessages: true);

    expect(idsOf(channel.state!.scheduledMessages), ['fresh', 'local']);
  });

  final loads = <(String, Future<void> Function(Channel))>[
    ('querying', (channel) => channel.query(includeScheduledMessages: true)),
    ('watching', (channel) => channel.watch(includeScheduledMessages: true)),
  ];

  for (final (name, load) in loads) {
    test('$name a channel that has a state updates its scheduledMessages and the client', () async {
      final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
      addTearDown(channel.dispose);
      await harness.hold([fakeScheduledMessage('gone'), local, elsewhere]);
      harness.stubQueryChannel(carrying([fakeScheduledMessage('fresh')]));

      await load(channel);

      expect(idsOf(harness.client.state.scheduledMessages), ['fresh', 'local', 'there']);
      expect(idsOf(channel.state!.scheduledMessages), ['fresh', 'local']);
    });
  }

  test("a channel query keeps what it returned in the channel's state", () async {
    final reply = fakeScheduledMessage('reply', parentId: 'parent');
    harness.stubQueryChannel(carrying([fakeScheduledMessage('fresh'), reply]));
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await channel.query(includeScheduledMessages: true);

    expect(idsOf(channel.state!.channelState.scheduledMessages), ['fresh', 'reply']);
  });

  test('a channel query keeps one whose request failed', () async {
    final failed = fakeScheduledMessage(
      'failed',
      status: ScheduledMessageStatus.failed,
      failureReason: ScheduledMessageFailureReason.requestFailed,
    );
    await harness.hold([failed]);
    harness.stubQueryChannel(carrying([fakeScheduledMessage('fresh')]));

    await harness.client.queryChannel('messaging', channelId: 'general', includeScheduledMessages: true);

    expect(idsOf(harness.client.state.scheduledMessages), ['fresh', 'failed']);
  });

  test(
    'a channel list query replaces the ones in each channel it loads and keeps the ones not on the server yet',
    () async {
      await harness.hold([fakeScheduledMessage('gone'), local, elsewhere]);
      harness.stubQueryChannels([
        carrying([fakeScheduledMessage('fresh')]),
      ]);

      await harness.client.queryChannelsOnline(
        filter: Filter.equal('cid', testCid),
        includeScheduledMessages: true,
      );

      expect(idsOf(harness.client.state.scheduledMessages), ['fresh', 'local', 'there']);
    },
  );

  test('a channel list query fills the state of each channel it loads', () async {
    await harness.hold([fakeScheduledMessage('gone'), local, elsewhere]);
    harness.stubQueryChannels([
      carrying([fakeScheduledMessage('fresh')]),
    ]);

    final [channel] = await harness.client.queryChannelsOnline(
      filter: Filter.equal('cid', testCid),
      includeScheduledMessages: true,
    );

    expect(idsOf(channel.state!.scheduledMessages), ['fresh', 'local']);
  });

  test('a channel list query lists the ones of all its channels at once', () async {
    harness.stubQueryChannels([
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
    final subscription = harness.client.state.scheduledMessagesStream.skip(1).listen((_) => emissions++);
    addTearDown(subscription.cancel);

    await harness.client.queryChannelsOnline(filter: const Filter.empty(), includeScheduledMessages: true);
    await settle();

    expect(emissions, 1);
    expect(idsOf(harness.client.state.scheduledMessages), ['in-a', 'in-b']);
  });

  test("a channel created without them lists the client's ones in that channel", () async {
    await harness.hold([fakeScheduledMessage('here')]);

    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    expect(idsOf(channel.state!.scheduledMessages), ['here']);
  });

  test("a channel created with them lists the client's ones instead", () async {
    await harness.hold([fakeScheduledMessage('held')]);

    final channel = Channel.fromState(harness.client, carrying([fakeScheduledMessage('carried')]));
    addTearDown(channel.dispose);

    expect(idsOf(channel.state!.scheduledMessages), ['held']);
  });

  test("a channel's scheduledMessages leaves out the replies in its threads", () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await harness.hold([fakeScheduledMessage('here'), fakeScheduledMessage('reply', parentId: 'parent')]);

    expect(idsOf(channel.state!.scheduledMessages), ['here']);
  });

  test("a channel's scheduledThreadReplies lists the replies in one of its threads", () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await harness.hold([
      fakeScheduledMessage('here'),
      fakeScheduledMessage('reply', parentId: 'parent'),
      fakeScheduledMessage('other', parentId: 'other-parent'),
    ]);

    expect(idsOf(channel.state!.scheduledThreadReplies('parent')), ['reply']);
  });

  test("a channel's scheduledMessages leaves out the ones in other channels", () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await harness.hold([fakeScheduledMessage('here'), elsewhere]);

    expect(idsOf(channel.state!.scheduledMessages), ['here']);
  });

  test("a scheduledMessageCreated event adds it to the channel's scheduledMessages", () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);

    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('new'));

    expect(idsOf(channel.state!.scheduledMessages), ['new']);
  });

  test("a scheduledMessageUpdated event replaces it in the channel's scheduledMessages", () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);
    await harness.hold([fakeScheduledMessage('a')]);
    final edited = fakeScheduledMessage('a', text: 'Good evening', updatedAt: DateTime.utc(2026, 10, 30));

    await harness.receive(EventType.scheduledMessageUpdated, edited);

    expect(channel.state!.scheduledMessages, [edited]);
  });

  test("a scheduledMessageDeleted event removes it from the channel's scheduledMessages", () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);
    await harness.hold([fakeScheduledMessage('a')]);

    await harness.receive(EventType.scheduledMessageDeleted, fakeScheduledMessage('a'));

    expect(channel.state!.scheduledMessages, isEmpty);
  });

  test("a scheduledMessageSent event removes it from the channel's scheduledMessages", () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);
    await harness.hold([fakeScheduledMessage('a')]);

    await harness.receive(EventType.scheduledMessageSent, fakeScheduledMessage('a'));

    expect(channel.state!.scheduledMessages, isEmpty);
  });

  test('scheduledMessagesStream emits on listen and on each change in the channel', () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);
    final emitted = <List<String>>[];
    final subscription = channel.state!.scheduledMessagesStream.listen((it) => emitted.add(idsOf(it)));
    addTearDown(subscription.cancel);
    await settle();

    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('here'));
    await harness.receive(EventType.scheduledMessageCreated, elsewhere);

    expect(emitted, [
      <String>[],
      ['here'],
    ]);
  });

  test('scheduledThreadRepliesStream emits on listen and on each change in the thread', () async {
    final channel = Channel.fromState(harness.client, ChannelState(channel: ChannelModel(cid: testCid)));
    addTearDown(channel.dispose);
    final emitted = <List<String>>[];
    final replies = channel.state!.scheduledThreadRepliesStream('parent');
    final subscription = replies.listen((it) => emitted.add(idsOf(it)));
    addTearDown(subscription.cancel);
    await settle();

    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('reply', parentId: 'parent'));
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('here'));

    expect(emitted, [
      <String>[],
      ['reply'],
    ]);
  });

  test(
    'a query that carries them replaces the ones in that channel and keeps the ones not on the server yet',
    () async {
      await harness.hold([fakeScheduledMessage('gone'), local, elsewhere]);
      harness.stubQueryChannel(carrying([fakeScheduledMessage('fresh')]));

      await harness.client.queryChannel('messaging', channelId: 'general', includeScheduledMessages: true);

      expect(idsOf(harness.client.state.scheduledMessages), ['fresh', 'local', 'there']);
    },
  );

  test('a query that carries an empty list removes the ones in that channel', () async {
    await harness.hold([fakeScheduledMessage('gone'), elsewhere]);
    harness.stubQueryChannel(carrying(const []));

    await harness.client.queryChannel('messaging', channelId: 'general', includeScheduledMessages: true);

    expect(idsOf(harness.client.state.scheduledMessages), ['there']);
  });

  test('a channel list query that carries an empty list removes the ones in that channel', () async {
    await harness.hold([fakeScheduledMessage('gone'), elsewhere]);
    harness.stubQueryChannels([carrying(const [])]);

    await harness.client.queryChannelsOnline(filter: Filter.equal('cid', testCid), includeScheduledMessages: true);

    expect(idsOf(harness.client.state.scheduledMessages), ['there']);
  });
}

// A channel state for [testCid] carrying [scheduledMessages].
ChannelState carrying(List<ScheduledMessage> scheduledMessages) {
  return ChannelState(
    channel: ChannelModel(cid: testCid),
    scheduledMessages: scheduledMessages,
  );
}
