import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/channel_state', () {
    test('should parse json correctly', () {
      final channelState = ChannelState.fromJson(jsonFixture('channel_state.json'));
      expect(channelState.channel?.cid, 'team:dev');
      expect(channelState.channel?.id, 'dev');
      expect(channelState.channel?.team, 'test');
      expect(channelState.channel?.type, 'team');
      expect(channelState.channel?.config, isA<ChannelConfig>());
      expect(channelState.channel?.config, isNotNull);
      expect(channelState.channel?.config.commands, hasLength(1));
      expect(channelState.channel?.config.commands[0], isA<Command>());
      expect(channelState.channel?.lastMessageAt, DateTime.parse('2020-01-30T13:43:41.062362Z'));
      expect(channelState.channel?.createdAt, DateTime.parse('2019-04-03T18:43:33.213373Z'));
      expect(channelState.channel?.updatedAt, DateTime.parse('2019-04-03T18:43:33.213374Z'));
      expect(channelState.channel?.createdBy, isA<User>());
      expect(channelState.channel?.frozen, true);
      expect(channelState.channel?.extraData['example'], 1);
      expect(channelState.channel?.extraData['name'], '#dev');
      expect(
        channelState.channel?.extraData['image'],
        'https://cdn.chrisshort.net/testing-certificate-chains-in-go/GOPHER_MIC_DROP.png',
      );
      expect(channelState.messages, isNotNull);
      expect(channelState.messages, isNotEmpty);
      expect(channelState.messages, hasLength(25));
      expect(channelState.messages![0], isA<Message>());
      expect(channelState.messages![0], isNotNull);
      expect(
        channelState.messages![0].createdAt,
        DateTime.parse('2020-01-29T03:23:02.843948Z'),
      );
      expect(channelState.messages![0].user, isA<User>());
      expect(
        channelState.messages![0].restrictedVisibility,
        isA<List<String>>(),
      );
      expect(channelState.watcherCount, 5);
    });

    test('should serialize to json correctly', () {
      final j = jsonFixture('channel_state.json');
      final channelState = ChannelState(
        channel: ChannelModel.fromJson(j['channel']),
        members: [],
        messages:
            // ignore: unnecessary_lambdas
            (j['messages'] as List).map((m) => Message.fromJson(m)).toList(),
        read: [],
        watcherCount: 5,
        pinnedMessages: [],
        watchers: [],
        pushPreferences: ChannelPushPreference(
          chatLevel: ChatLevel.all,
          disabledUntil: DateTime.parse('2020-01-30T13:43:41.062362Z'),
        ),
        activeLiveLocations: [],
      );

      expect(
        channelState.toJson(),
        jsonFixture('channel_state_to_json.json'),
      );
    });

    test('should handle draft field correctly', () {
      final now = DateTime.now();
      final draftMessage = DraftMessage(text: 'Draft message');
      final draft = Draft(
        channelCid: 'messaging:123',
        createdAt: now,
        message: draftMessage,
      );

      final channelState = createChannelState(
        id: 'test-channel',
        draft: draft,
      );

      expect(channelState.draft, equals(draft));

      final updatedDraft = Draft(
        channelCid: 'messaging:123',
        createdAt: now,
        message: DraftMessage(text: 'Updated draft'),
      );

      final updatedState = channelState.copyWith(draft: updatedDraft);
      expect(updatedState.draft, equals(updatedDraft));
      expect(updatedState.draft, isNot(equals(draft)));

      final removedDraftState = channelState.copyWith(draft: null);
      expect(removedDraftState.draft, isNull);

      expect(channelState.draft, equals(draft));
    });

    group('ChannelSortField', () {
      test('lastMessageAt orders older messages first', () {
        expectOrders(
          ChannelSortField.lastMessageAt,
          createChannelState(id: 'older', lastMessageAt: DateTime(2023, 6, 10)),
          createChannelState(id: 'newer', lastMessageAt: DateTime(2023, 6, 15)),
        );
      });

      test('lastUpdated orders by the last message', () {
        expectOrders(
          ChannelSortField.lastUpdated,
          createChannelState(id: 'older', createdAt: DateTime(2023, 6, 1), lastMessageAt: DateTime(2023, 6, 10)),
          createChannelState(id: 'newer', createdAt: DateTime(2023, 6, 1), lastMessageAt: DateTime(2023, 6, 15)),
        );
      });

      test('lastUpdated falls back to createdAt for a truncated channel', () {
        // Truncating a channel moves lastMessageAt back instead of clearing
        // it, so the channel must not sink below never-used channels.
        expectOrders(
          ChannelSortField.lastUpdated,
          createChannelState(id: 'truncated', createdAt: DateTime(2023, 6, 10), lastMessageAt: DateTime(1970)),
          createChannelState(id: 'active', createdAt: DateTime(2023, 6, 1), lastMessageAt: DateTime(2023, 6, 15)),
        );
      });

      test('createdAt orders older channels first', () {
        expectOrders(
          ChannelSortField.createdAt,
          createChannelState(id: 'older', createdAt: DateTime(2023, 6, 10)),
          createChannelState(id: 'newer', createdAt: DateTime(2023, 6, 15)),
        );
      });

      test('updatedAt orders older channels first', () {
        expectOrders(
          ChannelSortField.updatedAt,
          createChannelState(id: 'older', updatedAt: DateTime(2023, 6, 10)),
          createChannelState(id: 'newer', updatedAt: DateTime(2023, 6, 12)),
        );
      });

      test('memberCount orders smaller channels first', () {
        expectOrders(
          ChannelSortField.memberCount,
          createChannelState(id: 'smaller', memberCount: 50),
          createChannelState(id: 'larger', memberCount: 100),
        );
      });

      test('a custom field orders by the channel extra data', () {
        expectOrders(
          ChannelSortField.custom('priority'),
          createChannelState(id: 'low', extraData: const {'priority': 1}),
          createChannelState(id: 'high', extraData: const {'priority': 10}),
        );
      });

      test('a custom field the channel does not carry orders nothing', () {
        expectOrdersNothing(
          ChannelSortField.custom('non_existent_key'),
          createChannelState(id: 'plain'),
        );
      });

      test('hasUnread and unreadCount are server-side only', () {
        expectOrdersNothing(ChannelSortField.hasUnread, createChannelState(id: 'plain'));
        expectOrdersNothing(ChannelSortField.unreadCount, createChannelState(id: 'plain'));
      });
    });
  });
}

/// Helper function to create a ChannelState for testing
ChannelState createChannelState({
  required String id,
  String type = 'messaging',
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? lastMessageAt,
  int? memberCount,
  Map<String, Object?>? extraData,
  Draft? draft,
}) {
  return ChannelState(
    channel: ChannelModel(
      cid: '$type:$id',
      id: id,
      type: type,
      lastMessageAt: lastMessageAt,
      createdAt: createdAt ?? DateTime(2023),
      updatedAt: updatedAt ?? DateTime(2023),
      memberCount: memberCount ?? 0,
      extraData: extraData ?? {},
    ),
    membership: Member(userId: 'user1'),
    draft: draft,
  );
}
