import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/repository/mapper/events_mapper.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';
import 'event_fixtures.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.SendEventRequest(event: api.EventRequest(type: 'any'))));

  test('StreamChatClient.sendEvent maps a channel.frozen event onto an UnknownEvent', () async {
    final frozen = api.ChannelFrozenEvent(
      channelId: eventChannelId,
      channelType: eventChannelType,
      cid: eventCid,
      createdAt: eventCreatedAt,
      custom: eventCustom,
      receivedAt: eventReceivedAt,
      type: 'channel.frozen',
    );

    final event = await _sentEvent<UnknownEvent>(frozen);

    expect(
      event,
      UnknownEvent(
        type: 'channel.frozen',
        rawData: frozen.toJson(),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a channel.kicked event onto an UnknownEvent', () async {
    final kicked = api.ChannelKickedEvent(
      channelCustom: eventChannelCustom,
      channelId: eventChannelId,
      channelMemberCount: eventMemberCount,
      channelMessageCount: eventMessageCount,
      channelType: eventChannelType,
      cid: eventCid,
      createdAt: eventCreatedAt,
      custom: eventCustom,
      receivedAt: eventReceivedAt,
      team: eventTeam,
      type: 'channel.kicked',
    );

    final event = await _sentEvent<UnknownEvent>(kicked);

    expect(
      event,
      UnknownEvent(
        type: 'channel.kicked',
        rawData: kicked.toJson(),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a user.deactivated event onto an UnknownEvent', () async {
    final deactivated = api.UserDeactivatedEvent(
      createdAt: eventCreatedAt,
      createdBy: generatedEventUser('moderator'),
      custom: eventCustom,
      receivedAt: eventReceivedAt,
      type: 'user.deactivated',
      user: generatedEventUser('deactivated'),
    );

    final event = await _sentEvent<UnknownEvent>(deactivated);

    expect(
      event,
      UnknownEvent(
        type: 'user.deactivated',
        rawData: deactivated.toJson(),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test(
    'StreamChatClient.sendEvent maps an event of a type it has no class for onto an UnknownEvent without its user or '
    'counts',
    () async {
      final json = _unknownEventJson();

      final event = await _sentEvent<UnknownEvent>(api.WSEvent.fromJson(json));

      expect(
        event,
        UnknownEvent(
          type: 'party_started',
          rawData: json,
          createdAt: DateTime.utc(2026, 3, 4, 5, 6, 7),
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test('a received event the SDK has no class for leaves the users and unread counts as they were', () async {
    final client = StreamChatClient('test-api-key', defaultApi: MockDefaultApi());
    addTearDown(client.dispose);
    final current = OwnUser(id: 'current-id', totalUnreadCount: 1, unreadChannels: 1, unreadThreads: 1);
    client.state
      ..currentUser = current
      ..subscribeToEvents();

    client
      ..handleEvent(api.WSEvent.fromJson(_unknownEventJson()).toModel())
      ..handleEvent(
        api.UserDeactivatedEvent(
          createdAt: eventCreatedAt,
          custom: eventCustom,
          type: 'user.deactivated',
          user: generatedEventUser('deactivated'),
        ).toModel(),
      )
      ..handleEvent(
        api.NotificationChannelRewoundEvent(
          channel: generatedChannel,
          channelId: eventChannelId,
          channelMemberCount: eventMemberCount,
          channelMessageCount: eventMessageCount,
          channelType: eventChannelType,
          cid: eventCid,
          createdAt: eventCreatedAt,
          custom: eventCustom,
          groupedUnreadChannels: const {'messaging': 4},
          rewind: api.ChannelRewindResponse(
            createdAt: DateTime.utc(2026, 3, 1),
            hiddenCountAtRewind: 6,
            id: 'rewind-id',
            inclusive: true,
            messageId: 'rewound-to-id',
          ),
          totalUnreadCount: 11,
          type: 'notification.channel_rewound',
          unreadChannels: 5,
          unreadCount: 13,
        ).toModel(),
      );
    await Future<void>.delayed(Duration.zero);

    expect(client.state.users.keys, isNot(anyOf(contains('host'), contains('deactivated'))));
    expect(client.state.currentUser, current);
  });

  test('StreamChatClient.sendEvent reads custom data of the wrong type on an unknown event as none', () async {
    final json = {..._unknownEventJson(), 'custom': 42};

    final event = await _sentEvent<UnknownEvent>(api.WSEvent.fromJson(json));

    expect(event.custom, isEmpty);
  });

  test('StreamChatClient.sendEvent reads the time of an unknown event given in epoch nanoseconds', () async {
    final at = DateTime.utc(2026, 3, 4, 5, 6, 7, 123, 456);
    final json = {..._unknownEventJson(), 'created_at': at.microsecondsSinceEpoch * 1000};

    final event = await _sentEvent<UnknownEvent>(api.WSEvent.fromJson(json));

    expect(event.createdAt, at);
  });

  test('StreamChatClient.sendEvent reads an unknown event without custom data as carrying none', () async {
    final json = {..._unknownEventJson()}..remove('custom');

    final event = await _sentEvent<UnknownEvent>(api.WSEvent.fromJson(json));

    expect(event.custom, isEmpty);
  });

  test(
    'StreamChatClient.sendEvent maps a notification.channel_rewound event onto an UnknownEvent',
    () async {
      final rewound = api.NotificationChannelRewoundEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        groupedUnreadChannels: const {'messaging': 4},
        receivedAt: eventReceivedAt,
        rewind: api.ChannelRewindResponse(
          createdAt: DateTime.utc(2026, 3, 1),
          hiddenCountAtRewind: 6,
          id: 'rewind-id',
          inclusive: true,
          messageId: 'rewound-to-id',
        ),
        team: eventTeam,
        totalUnreadCount: 11,
        type: 'notification.channel_rewound',
        unreadChannels: 5,
        unreadCount: 13,
      );

      final event = await _sentEvent<UnknownEvent>(rewound);

      expect(
        event,
        UnknownEvent(
          type: 'notification.channel_rewound',
          rawData: rewound.toJson(),
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test(
    'StreamChatClient.sendEvent maps a channel.created event onto an UnknownEvent',
    () async {
      final created = api.ChannelCreatedEvent(
        channel: generatedChannel,
        channelCustom: eventChannelCustom,
        channelId: eventChannelId,
        channelMemberCount: eventMemberCount,
        channelMessageCount: eventMessageCount,
        channelType: eventChannelType,
        cid: eventCid,
        createdAt: eventCreatedAt,
        custom: eventCustom,
        receivedAt: eventReceivedAt,
        team: eventTeam,
        type: 'channel.created',
        user: generatedEventUser('creator'),
      );

      final event = await _sentEvent<UnknownEvent>(created);

      expect(
        event,
        UnknownEvent(
          type: 'channel.created',
          rawData: created.toJson(),
          createdAt: eventCreatedAt,
          custom: eventCustom,
          isLocal: false,
        ),
      );
    },
  );

  test('StreamChatClient.sendEvent maps a message.pending event onto an UnknownEvent', () async {
    final pending = api.PendingMessageEvent(
      channel: generatedChannel,
      createdAt: eventCreatedAt,
      custom: eventCustom,
      message: generatedLeafMessage('pending-id'),
      metadata: const {'reason': 'review'},
      method: 'moderation',
      receivedAt: eventReceivedAt,
      type: 'message.pending',
      user: fakeUserResponse('pending-sender'),
    );

    final event = await _sentEvent<UnknownEvent>(pending);

    expect(
      event,
      UnknownEvent(
        type: 'message.pending',
        rawData: pending.toJson(),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent maps a custom event of type * onto an UnknownEvent', () async {
    final custom = api.CustomEvent(
      createdAt: eventCreatedAt,
      custom: eventCustom,
      receivedAt: eventReceivedAt,
      type: '*',
    );

    final event = await _sentEvent<UnknownEvent>(custom);

    expect(
      event,
      UnknownEvent(
        type: '*',
        rawData: custom.toJson(),
        createdAt: eventCreatedAt,
        custom: eventCustom,
        isLocal: false,
      ),
    );
  });

  test('StreamChatClient.sendEvent gives an unknown event whose time cannot be read the current time', () async {
    final start = DateTime.now();
    final json = {..._unknownEventJson(), 'created_at': 'yesterday'};

    final event = await _sentEvent<UnknownEvent>(api.WSEvent.fromJson(json));

    expect(event.createdAt.isBefore(start), isFalse);
  });
}

// An event of a type the SDK has no class for: the fields it reads, and a
// channel, user, counts and a field of its own that stay in its raw data.
Map<String, Object?> _unknownEventJson() => {
  'type': 'party_started',
  'cid': eventCid,
  'channel_id': eventChannelId,
  'channel_type': eventChannelType,
  'user': {
    'id': 'host',
    'role': 'user',
    'banned': false,
    'online': false,
    'language': 'en',
    'teams': <String>[],
    'blocked_user_ids': <String>[],
    'custom': <String, Object?>{},
    'created_at': '2025-01-01T00:00:00Z',
    'updated_at': '2025-01-01T00:00:00Z',
  },
  'parent_id': 'thread-parent-id',
  'total_unread_count': 11,
  'unread_channels': 5,
  'unread_threads': 2,
  'channel_member_count': eventMemberCount,
  'channel_message_count': eventMessageCount,
  'created_at': '2026-03-04T05:06:07Z',
  'custom': eventCustom,
  'theme': 'disco',
};

// The event the client returns for a sent event the server answers with
// [event], checked to be a [T].
Future<T> _sentEvent<T extends ChatEvent>(api.WSEvent event) async {
  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.sendEvent(
      type: any(named: 'type'),
      id: any(named: 'id'),
      sendEventRequest: any(named: 'sendEventRequest'),
    ),
  ).thenAnswer((_) async => Result.success(api.EventResponse(duration: '0.01ms', event: event)));
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);

  final res = await client.sendEvent('general', 'messaging', type: event.type);

  final mapped = res.getOrNull()?.event;
  expect(mapped, isA<T>());
  return mapped! as T;
}
