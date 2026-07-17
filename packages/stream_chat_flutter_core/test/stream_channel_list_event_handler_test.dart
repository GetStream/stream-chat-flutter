// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/stream_channel_list_event_handler.dart';

import 'mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(<Channel>[]);
    registerFallbackValue(const ChannelState());
  });

  late StreamChannelListEventHandler handler;
  late MockStreamChannelListController controller;

  setUp(() {
    handler = StreamChannelListEventHandler();
    controller = MockStreamChannelListController();
  });

  MockChannel mockChannel(
    String cid, {
    List<Member> members = const [],
    Member? membership,
  }) {
    final channel = MockChannel();
    final [type, id] = cid.split(':');

    when(() => channel.cid).thenReturn(cid);
    when(() => channel.membership).thenReturn(membership);
    when(() => channel.state.members).thenReturn(members);
    when(() => channel.state.channelState).thenReturn(
      ChannelState(
        channel: ChannelModel(cid: cid, id: id, type: type),
        members: members,
      ),
    );

    return channel;
  }

  // Returns the single list passed to the controller's `channels` setter.
  List<Channel> capturedChannels() {
    return verify(() => controller.channels = captureAny()).captured.single as List<Channel>;
  }

  group('onChannelDeleted', () {
    test('removes the event channel from the list', () {
      final kept = mockChannel('messaging:kept');
      final deleted = mockChannel('messaging:deleted');
      when(() => controller.currentItems).thenReturn([kept, deleted]);

      handler.onChannelDeleted(
        Event(type: EventType.channelDeleted, cid: 'messaging:deleted'),
        controller,
      );

      expect(capturedChannels(), equals([kept]));
    });

    test('falls back to the event channel cid', () {
      final kept = mockChannel('messaging:kept');
      final deleted = mockChannel('messaging:deleted');
      when(() => controller.currentItems).thenReturn([kept, deleted]);

      handler.onChannelDeleted(
        Event(
          type: EventType.channelDeleted,
          channel: ChannelModel(cid: 'messaging:deleted'),
        ),
        controller,
      );

      expect(capturedChannels(), equals([kept]));
    });
  });

  group('onChannelHidden', () {
    test('removes the event channel from the list', () {
      final kept = mockChannel('messaging:kept');
      final hidden = mockChannel('messaging:hidden');
      when(() => controller.currentItems).thenReturn([kept, hidden]);

      handler.onChannelHidden(
        Event(type: EventType.channelHidden, cid: 'messaging:hidden'),
        controller,
      );

      expect(capturedChannels(), equals([kept]));
    });
  });

  group('onChannelTruncated', () {
    test('refreshes the whole list', () {
      when(() => controller.refresh()).thenAnswer((_) async {});

      handler.onChannelTruncated(
        Event(type: EventType.channelTruncated),
        controller,
      );

      verify(() => controller.refresh()).called(1);
    });
  });

  group('onChannelUpdated', () {
    test('reassigns the list when the channel is listed', () {
      final a = mockChannel('messaging:a');
      final b = mockChannel('messaging:b');
      when(() => controller.currentItems).thenReturn([a, b]);

      handler.onChannelUpdated(
        Event(type: EventType.channelUpdated, cid: 'messaging:a'),
        controller,
      );

      expect(capturedChannels(), equals([a, b]));
    });

    test('does nothing when the channel is not listed', () {
      final a = mockChannel('messaging:a');
      when(() => controller.currentItems).thenReturn([a]);

      handler.onChannelUpdated(
        Event(type: EventType.channelUpdated, cid: 'messaging:unknown'),
        controller,
      );

      verifyNever(() => controller.channels = any());
    });
  });

  group('onMemberUpdated', () {
    test('reassigns the list when the channel is listed', () {
      final a = mockChannel('messaging:a');
      final b = mockChannel('messaging:b');
      when(() => controller.currentItems).thenReturn([a, b]);

      handler.onMemberUpdated(
        Event(type: EventType.memberUpdated, cid: 'messaging:a'),
        controller,
      );

      expect(capturedChannels(), equals([a, b]));
    });

    test('does nothing when the channel is not listed', () {
      final a = mockChannel('messaging:a');
      when(() => controller.currentItems).thenReturn([a]);

      handler.onMemberUpdated(
        Event(type: EventType.memberUpdated, cid: 'messaging:unknown'),
        controller,
      );

      verifyNever(() => controller.channels = any());
    });
  });

  group('onChannelVisible', () {
    test('adds the fetched channel to the top of the list', () async {
      final existing = mockChannel('messaging:existing');
      final added = mockChannel('messaging:new');
      when(() => controller.currentItems).thenReturn([existing]);
      when(
        () => controller.getChannel(id: 'new', type: 'messaging'),
      ).thenAnswer((_) async => added);

      handler.onChannelVisible(
        Event(
          type: EventType.channelVisible,
          channelId: 'new',
          channelType: 'messaging',
        ),
        controller,
      );
      await pumpEventQueue();

      expect(capturedChannels(), equals([added, existing]));
    });

    test('moves an already-listed channel to the top without duplicating', () async {
      final existing = mockChannel('messaging:existing');
      final stale = mockChannel('messaging:new');
      final fetched = mockChannel('messaging:new');
      when(() => controller.currentItems).thenReturn([existing, stale]);
      when(
        () => controller.getChannel(id: 'new', type: 'messaging'),
      ).thenAnswer((_) async => fetched);

      handler.onChannelVisible(
        Event(
          type: EventType.channelVisible,
          channelId: 'new',
          channelType: 'messaging',
        ),
        controller,
      );
      await pumpEventQueue();

      expect(capturedChannels(), equals([fetched, existing]));
    });

    test('is a no-op when the channel identifiers are missing', () async {
      handler.onChannelVisible(
        Event(type: EventType.channelVisible),
        controller,
      );
      await pumpEventQueue();

      verifyNever(
        () => controller.getChannel(
          id: any(named: 'id'),
          type: any(named: 'type'),
        ),
      );
      verifyNever(() => controller.channels = any());
    });
  });

  group('onConnectionRecovered', () {
    test('refreshes the whole list', () {
      when(() => controller.refresh()).thenAnswer((_) async {});

      handler.onConnectionRecovered(
        Event(type: EventType.connectionRecovered),
        controller,
      );

      verify(() => controller.refresh()).called(1);
    });
  });

  group('onMessageNew', () {
    test('moves the matching channel to the top', () async {
      final a = mockChannel('messaging:a');
      final b = mockChannel('messaging:b');
      final c = mockChannel('messaging:c');
      when(() => controller.currentItems).thenReturn([a, b, c]);

      handler.onMessageNew(
        Event(type: EventType.messageNew, cid: 'messaging:b'),
        controller,
      );
      await pumpEventQueue();

      expect(capturedChannels(), equals([b, a, c]));
    });

    test('refreshes without resetting when the channel is not listed', () async {
      final a = mockChannel('messaging:a');
      when(() => controller.currentItems).thenReturn([a]);
      when(
        () => controller.refresh(resetValue: any(named: 'resetValue')),
      ).thenAnswer((_) async {});

      handler.onMessageNew(
        Event(type: EventType.messageNew, cid: 'messaging:unknown'),
        controller,
      );
      await pumpEventQueue();

      verify(() => controller.refresh(resetValue: false)).called(1);
      verifyNever(() => controller.channels = any());
    });

    test('is a no-op when the event has no cid', () async {
      handler.onMessageNew(Event(type: EventType.messageNew), controller);
      await pumpEventQueue();

      verifyNever(() => controller.channels = any());
      verifyNever(
        () => controller.refresh(resetValue: any(named: 'resetValue')),
      );
    });
  });

  group('onNotificationAddedToChannel', () {
    test('adds the fetched channel to the top of the list', () async {
      final existing = mockChannel('messaging:existing');
      final added = mockChannel('messaging:new');
      when(() => controller.currentItems).thenReturn([existing]);
      when(
        () => controller.getChannel(id: 'new', type: 'messaging'),
      ).thenAnswer((_) async => added);

      handler.onNotificationAddedToChannel(
        Event(
          type: EventType.notificationAddedToChannel,
          channelId: 'new',
          channelType: 'messaging',
        ),
        controller,
      );
      await pumpEventQueue();

      expect(capturedChannels(), equals([added, existing]));
    });
  });

  group('onNotificationMessageNew', () {
    test('adds the fetched channel to the top of the list', () async {
      final existing = mockChannel('messaging:existing');
      final added = mockChannel('messaging:new');
      when(() => controller.currentItems).thenReturn([existing]);
      when(
        () => controller.getChannel(id: 'new', type: 'messaging'),
      ).thenAnswer((_) async => added);

      handler.onNotificationMessageNew(
        Event(
          type: EventType.notificationMessageNew,
          channelId: 'new',
          channelType: 'messaging',
        ),
        controller,
      );
      await pumpEventQueue();

      expect(capturedChannels(), equals([added, existing]));
    });
  });

  group('onNotificationRemovedFromChannel', () {
    test('removes the event channel when it is listed', () {
      final kept = mockChannel('messaging:kept');
      final removed = mockChannel('messaging:removed');
      when(() => controller.currentItems).thenReturn([kept, removed]);

      handler.onNotificationRemovedFromChannel(
        Event(
          type: EventType.notificationRemovedFromChannel,
          channel: ChannelModel(cid: 'messaging:removed'),
        ),
        controller,
      );

      expect(capturedChannels(), equals([kept]));
    });

    test('does nothing when the channel is not listed', () {
      final kept = mockChannel('messaging:kept');
      when(() => controller.currentItems).thenReturn([kept]);

      handler.onNotificationRemovedFromChannel(
        Event(
          type: EventType.notificationRemovedFromChannel,
          channel: ChannelModel(cid: 'messaging:unknown'),
        ),
        controller,
      );

      verifyNever(() => controller.channels = any());
    });
  });

  group('onUserPresenceChanged', () {
    test('updates matching channels and reassigns the list', () {
      final user = User(id: 'u2', name: 'Updated');
      final memberChannel = mockChannel(
        'messaging:a',
        members: [
          Member(userId: 'u1'),
          Member(userId: 'u2'),
        ],
      );
      final otherChannel = mockChannel(
        'messaging:b',
        members: [Member(userId: 'u1')],
      );
      when(
        () => controller.currentItems,
      ).thenReturn([memberChannel, otherChannel]);

      handler.onUserPresenceChanged(
        Event(type: EventType.userPresenceChanged, user: user),
        controller,
      );

      verify(() => memberChannel.state.updateChannelState(any())).called(1);
      verifyNever(() => otherChannel.state.updateChannelState(any()));
      expect(capturedChannels(), equals([memberChannel, otherChannel]));
    });

    test('does nothing when the user is not a member of any channel', () {
      final user = User(id: 'stranger');
      final a = mockChannel('messaging:a', members: [Member(userId: 'u1')]);
      final b = mockChannel('messaging:b', members: [Member(userId: 'u2')]);
      when(() => controller.currentItems).thenReturn([a, b]);

      handler.onUserPresenceChanged(
        Event(type: EventType.userPresenceChanged, user: user),
        controller,
      );

      verifyNever(() => a.state.updateChannelState(any()));
      verifyNever(() => b.state.updateChannelState(any()));
      verifyNever(() => controller.channels = any());
    });

    test('routes user.updated through the same handler', () {
      final user = User(id: 'u1', name: 'Renamed');
      final channel = mockChannel('messaging:a', members: [Member(userId: 'u1')]);
      when(() => controller.currentItems).thenReturn([channel]);

      handler.onUserPresenceChanged(
        Event(type: EventType.userUpdated, user: user),
        controller,
      );

      verify(() => channel.state.updateChannelState(any())).called(1);
    });

    test('is a no-op when the event has no user', () {
      final channel = mockChannel('messaging:a', members: [Member(userId: 'u1')]);
      when(() => controller.currentItems).thenReturn([channel]);

      handler.onUserPresenceChanged(
        Event(type: EventType.userPresenceChanged),
        controller,
      );

      verifyNever(() => channel.state.updateChannelState(any()));
      verifyNever(() => controller.channels = any());
    });
  });
}
