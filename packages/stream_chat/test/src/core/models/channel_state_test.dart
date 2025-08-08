import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/channel_state', () {
    test('should parse json correctly', () {
      final channelState =
          ChannelState.fromJson(jsonFixture('channel_state.json'));
      expect(channelState.channel?.cid, 'team:dev');
      expect(channelState.channel?.id, 'dev');
      expect(channelState.channel?.team, 'test');
      expect(channelState.channel?.type, 'team');
      expect(channelState.channel?.config, isA<ChannelConfig>());
      expect(channelState.channel?.config, isNotNull);
      expect(channelState.channel?.config.commands, hasLength(1));
      expect(channelState.channel?.config.commands[0], isA<Command>());
      expect(channelState.channel?.lastMessageAt,
          DateTime.parse('2020-01-30T13:43:41.062362Z'));
      expect(channelState.channel?.createdAt,
          DateTime.parse('2019-04-03T18:43:33.213373Z'));
      expect(channelState.channel?.updatedAt,
          DateTime.parse('2019-04-03T18:43:33.213374Z'));
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
          chatLevel: ChatLevelPushPreference.all,
          disabledUntil: DateTime.parse('2020-01-30T13:43:41.062362Z'),
        ),
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

    group('ComparableFieldProvider', () {
      test('should return ComparableField for channel.lastMessageAt', () {
        final channelState = createChannelState(
          id: 'test-channel',
          lastMessageAt: DateTime(2023, 6, 15),
        );

        final field = channelState.getComparableField(
          ChannelSortKey.lastMessageAt,
        );

        expect(field, isNotNull);
        expect(field!.value, equals(DateTime(2023, 6, 15)));
      });

      test('should return ComparableField for channel.createdAt', () {
        final channelState = createChannelState(
          id: 'test-channel',
          createdAt: DateTime(2023, 6, 10),
        );

        final field = channelState.getComparableField(ChannelSortKey.createdAt);
        expect(field, isNotNull);
        expect(field!.value, equals(DateTime(2023, 6, 10)));
      });

      test('should return ComparableField for channel.updatedAt', () {
        final channelState = createChannelState(
          id: 'test-channel',
          updatedAt: DateTime(2023, 6, 12),
        );

        final field = channelState.getComparableField(ChannelSortKey.updatedAt);
        expect(field, isNotNull);
        expect(field!.value, equals(DateTime(2023, 6, 12)));
      });

      test('should return ComparableField for channel.memberCount', () {
        final channelState = createChannelState(
          id: 'test-channel',
          memberCount: 42,
        );

        final field =
            channelState.getComparableField(ChannelSortKey.memberCount);
        expect(field, isNotNull);
        expect(field!.value, equals(42));
      });

      test('should return ComparableField for channel.extraData', () {
        final channelState = createChannelState(
          id: 'test-channel',
          extraData: {'priority': 5},
        );

        final field = channelState.getComparableField('priority');
        expect(field, isNotNull);
        expect(field!.value, equals(5));
      });

      test('should return null for non-existent extraData keys', () {
        final channelState = createChannelState(
          id: 'test-channel',
        );

        final field = channelState.getComparableField('non_existent_key');
        expect(field, isNull);
      });

      test('should compare two channel states correctly using createdAt', () {
        final newerChannel = createChannelState(
          id: 'newer',
          createdAt: DateTime(2023, 6, 15),
        );

        final olderChannel = createChannelState(
          id: 'older',
          createdAt: DateTime(2023, 6, 10),
        );

        final newerField = newerChannel.getComparableField(
          ChannelSortKey.createdAt,
        );

        final olderField = olderChannel.getComparableField(
          ChannelSortKey.createdAt,
        );

        expect(newerField!.compareTo(olderField!), greaterThan(0));
        expect(olderField.compareTo(newerField), lessThan(0));
      });

      test('should compare two channel states correctly using memberCount', () {
        final largerChannel = createChannelState(
          id: 'larger',
          memberCount: 100,
        );

        final smallerChannel = createChannelState(
          id: 'smaller',
          memberCount: 50,
        );

        final largerField = largerChannel.getComparableField(
          ChannelSortKey.memberCount,
        );

        final smallerField = smallerChannel.getComparableField(
          ChannelSortKey.memberCount,
        );

        expect(largerField!.compareTo(smallerField!), greaterThan(0));
        expect(smallerField.compareTo(largerField), lessThan(0));
      });

      test('should compare two channel states correctly using extraData', () {
        final highPriorityChannel = createChannelState(
          id: 'high-priority',
          extraData: {'priority': 10},
        );

        final lowPriorityChannel = createChannelState(
          id: 'low-priority',
          extraData: {'priority': 1},
        );

        final highPriorityField = highPriorityChannel.getComparableField(
          'priority',
        );

        final lowPriorityField = lowPriorityChannel.getComparableField(
          'priority',
        );

        expect(highPriorityField!.compareTo(lowPriorityField!), greaterThan(0));
        expect(lowPriorityField.compareTo(highPriorityField), lessThan(0));
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
