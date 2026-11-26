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
        ChannelDeletedEvent(
          cid: 'messaging:deleted',
          channel: ChannelModel(cid: 'messaging:deleted'),
        ),
        controller,
      );

      expect(capturedChannels(), equals([kept]));
    });

    test('falls back to the event channel cid', () {
      final kept = mockChannel('messaging:kept');
      final deleted = mockChannel('messaging:deleted');
      when(() => controller.currentItems).thenReturn([kept, deleted]);

      handler.onChannelDeleted(
        ChannelDeletedEvent(channel: ChannelModel(cid: 'messaging:deleted')),
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
        ChannelHiddenEvent(
          cid: 'messaging:hidden',
          channel: ChannelModel(cid: 'messaging:hidden'),
        ),
        controller,
      );

      expect(capturedChannels(), equals([kept]));
    });
  });

  group('onChannelTruncated', () {
    test('refreshes the whole list', () {
      when(() => controller.refresh()).thenAnswer((_) async {});

      handler.onChannelTruncated(
        ChannelTruncatedEvent(channel: ChannelModel(cid: 'messaging:a')),
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
        ChannelUpdatedEvent(
          cid: 'messaging:a',
          channel: ChannelModel(cid: 'messaging:a'),
        ),
        controller,
      );

      expect(capturedChannels(), equals([a, b]));
    });

    test('does nothing when the channel is not listed', () {
      final a = mockChannel('messaging:a');
      when(() => controller.currentItems).thenReturn([a]);

      handler.onChannelUpdated(
        ChannelUpdatedEvent(
          cid: 'messaging:unknown',
          channel: ChannelModel(cid: 'messaging:unknown'),
        ),
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
        MemberUpdatedEvent(
          cid: 'messaging:a',
          channel: ChannelModel(cid: 'messaging:a'),
          member: Member(userId: 'u1'),
        ),
        controller,
      );

      expect(capturedChannels(), equals([a, b]));
    });

    test('does nothing when the channel is not listed', () {
      final a = mockChannel('messaging:a');
      when(() => controller.currentItems).thenReturn([a]);

      handler.onMemberUpdated(
        MemberUpdatedEvent(
          cid: 'messaging:unknown',
          channel: ChannelModel(cid: 'messaging:unknown'),
          member: Member(userId: 'u1'),
        ),
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
      ).thenAnswer((_) async => Result.success(added));

      handler.onChannelVisible(
        ChannelVisibleEvent(
          channel: ChannelModel(id: 'new', type: 'messaging'),
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
      ).thenAnswer((_) async => Result.success(fetched));

      handler.onChannelVisible(
        ChannelVisibleEvent(
          channel: ChannelModel(id: 'new', type: 'messaging'),
        ),
        controller,
      );
      await pumpEventQueue();

      expect(capturedChannels(), equals([fetched, existing]));
    });

    test('leaves the list unchanged when the channel cannot be fetched', () async {
      final existing = mockChannel('messaging:existing');
      when(() => controller.currentItems).thenReturn([existing]);
      when(
        () => controller.getChannel(id: 'new', type: 'messaging'),
      ).thenAnswer((_) async => const Result.failure(StreamClientException(message: 'boom')));

      handler.onChannelVisible(
        ChannelVisibleEvent(
          channel: ChannelModel(id: 'new', type: 'messaging'),
        ),
        controller,
      );
      await pumpEventQueue();

      verifyNever(() => controller.channels = any());
    });

    test('is a no-op when the channel identifiers are missing', () async {
      handler.onChannelVisible(
        MessageReadEvent(),
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
        ConnectionRecoveredEvent(),
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
        MessageNewEvent(
          cid: 'messaging:b',
          message: Message(id: 'message-id', text: 'Hello'),
          watcherCount: 1,
        ),
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
        MessageNewEvent(
          cid: 'messaging:unknown',
          message: Message(id: 'message-id', text: 'Hello'),
          watcherCount: 1,
        ),
        controller,
      );
      await pumpEventQueue();

      verify(() => controller.refresh(resetValue: false)).called(1);
      verifyNever(() => controller.channels = any());
    });

    test('is a no-op when the event has no cid', () async {
      handler.onMessageNew(
        MessageNewEvent(
          message: Message(id: 'message-id', text: 'Hello'),
          watcherCount: 1,
        ),
        controller,
      );
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
      ).thenAnswer((_) async => Result.success(added));

      handler.onNotificationAddedToChannel(
        NotificationAddedToChannelEvent(
          channel: ChannelModel(id: 'new', type: 'messaging'),
          member: Member(userId: 'me'),
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
      ).thenAnswer((_) async => Result.success(added));

      handler.onNotificationMessageNew(
        NotificationMessageNewEvent(
          channel: ChannelModel(id: 'new', type: 'messaging'),
          message: Message(id: 'message-id', text: 'Hello'),
          watcherCount: 1,
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
        NotificationRemovedFromChannelEvent(
          channel: ChannelModel(cid: 'messaging:removed'),
          member: Member(userId: 'me'),
        ),
        controller,
      );

      expect(capturedChannels(), equals([kept]));
    });

    test('does nothing when the channel is not listed', () {
      final kept = mockChannel('messaging:kept');
      when(() => controller.currentItems).thenReturn([kept]);

      handler.onNotificationRemovedFromChannel(
        NotificationRemovedFromChannelEvent(
          channel: ChannelModel(cid: 'messaging:unknown'),
          member: Member(userId: 'me'),
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
        UserPresenceChangedEvent(user: user),
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
        UserPresenceChangedEvent(user: user),
        controller,
      );

      verifyNever(() => a.state.updateChannelState(any()));
      verifyNever(() => b.state.updateChannelState(any()));
      verifyNever(() => controller.channels = any());
    });

    test('updates the current user via membership when not a loaded member', () {
      final currentUser = User(id: 'me', name: 'Renamed');
      final channel = mockChannel(
        'messaging:a',
        members: [Member(userId: 'u1')],
        membership: Member(userId: 'me'),
      );
      when(() => controller.currentItems).thenReturn([channel]);

      handler.onUserPresenceChanged(
        UserUpdatedEvent(user: currentUser),
        controller,
      );

      verify(() => channel.state.updateChannelState(any())).called(1);
      expect(capturedChannels(), equals([channel]));
    });

    test('routes user.updated through the same handler', () {
      final user = User(id: 'u1', name: 'Renamed');
      final channel = mockChannel('messaging:a', members: [Member(userId: 'u1')]);
      when(() => controller.currentItems).thenReturn([channel]);

      handler.onUserPresenceChanged(
        UserUpdatedEvent(user: user),
        controller,
      );

      verify(() => channel.state.updateChannelState(any())).called(1);
    });

    test('is a no-op when the event has no user', () {
      final channel = mockChannel('messaging:a', members: [Member(userId: 'u1')]);
      when(() => controller.currentItems).thenReturn([channel]);

      handler.onUserPresenceChanged(
        MessageDeliveredEvent(),
        controller,
      );

      verifyNever(() => channel.state.updateChannelState(any()));
      verifyNever(() => controller.channels = any());
    });
  });
}
