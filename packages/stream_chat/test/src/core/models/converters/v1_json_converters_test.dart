import 'package:stream_chat/src/core/models/converters/v1_json_converters.dart';
import 'package:stream_chat/src/core/models/device.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/moderation.dart';
import 'package:stream_chat/src/core/models/push_provider.dart';
import 'package:stream_chat/src/core/models/reaction_group.dart';
import 'package:stream_chat/src/core/models/user_group.dart';
import 'package:stream_chat/src/core/models/user_group_member.dart';
import 'package:test/test.dart';

void main() {
  test('DeviceV1JsonConverter.fromJson reads a v1 device, ignoring the fields a Device does not carry', () {
    const converter = DeviceV1JsonConverter();

    final device = converter.fromJson({
      'id': 'device-id',
      'push_provider': 'firebase',
      'push_provider_name': 'staging',
      'user_id': 'user-id',
      'created_at': '2020-04-23T14:36:21.838196Z',
      'disabled': false,
    });

    expect(device, const Device(id: 'device-id', pushProvider: PushProvider.firebase));
  });

  test('DeviceV1JsonConverter.toJson writes the device under its wire keys', () {
    const converter = DeviceV1JsonConverter();

    final json = converter.toJson(const Device(id: 'device-id', pushProvider: PushProvider.apn));

    expect(json, {'id': 'device-id', 'push_provider': 'apn'});
  });

  test('DeviceV1JsonConverter.fromJson reads back what toJson writes', () {
    const converter = DeviceV1JsonConverter();

    final device = converter.fromJson(
      converter.toJson(const Device(id: 'device-id', pushProvider: PushProvider.huawei)),
    );

    expect(device, const Device(id: 'device-id', pushProvider: PushProvider.huawei));
  });

  test('userGroupsFromV1Json reads a group with ISO-8601 dates', () {
    final groups = userGroupsFromV1Json([
      {
        'id': 'g1',
        'name': 'Engineering',
        'description': 'Engineering team',
        'team_id': 'team-1',
        'created_by': 'creator-id',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      },
    ]);

    expect(groups, [
      UserGroup(
        createdAt: DateTime.utc(2024, 1, 1),
        createdBy: 'creator-id',
        description: 'Engineering team',
        id: 'g1',
        name: 'Engineering',
        teamId: 'team-1',
        updatedAt: DateTime.utc(2024, 1, 2),
      ),
    ]);
  });

  test('Message.fromJson reads mentioned groups whose dates are sent as epoch nanoseconds', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'mentioned_groups': [
        {'id': 'g1', 'name': 'Engineering', 'created_at': 1704067200123456000, 'updated_at': 1704153600000000000},
      ],
    });

    expect(message.mentionedGroups!.single.createdAt, DateTime.utc(2024, 1, 1, 0, 0, 0, 123, 456));
    expect(message.mentionedGroups!.single.updatedAt, DateTime.utc(2024, 1, 2));
  });

  test('userGroupsFromV1Json reads members that carry no app_pk', () {
    final groups = userGroupsFromV1Json([
      {
        'id': 'g1',
        'name': 'Engineering',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
        'members': [
          {'group_id': 'g1', 'user_id': 'user-1', 'is_admin': true, 'created_at': '2024-01-03T00:00:00.000Z'},
        ],
      },
    ]);

    expect(groups!.single.members, [
      UserGroupMember(createdAt: DateTime.utc(2024, 1, 3), groupId: 'g1', isAdmin: true, userId: 'user-1'),
    ]);
  });

  test('userGroupsFromV1Json leaves members null when the group carries none', () {
    final groups = userGroupsFromV1Json([
      {
        'id': 'g1',
        'name': 'Engineering',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      },
    ]);

    expect(groups!.single.members, isNull);
  });

  test('userGroupsFromV1Json returns null when the message carries no groups', () {
    expect(userGroupsFromV1Json(null), isNull);
  });

  test('Message.fromJson reads every moderation field from its v1 keys', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'moderation': {
        'action': 'shadow',
        'original_text': 'original message text',
        'text_harms': ['hate', 'profanity'],
        'image_harms': ['explicit'],
        'blocklist_matched': 'profanity',
        'semantic_filter_matched': 'harassment',
        'platform_circumvented': true,
      },
    });

    expect(
      message.moderation,
      const Moderation(
        action: ModerationAction.shadow,
        originalText: 'original message text',
        textHarms: ['hate', 'profanity'],
        imageHarms: ['explicit'],
        blocklistMatched: 'profanity',
        semanticFilterMatched: 'harassment',
        platformCircumvented: true,
      ),
    );
  });

  test('Message.fromJson reads a legacy moderation action as its current name', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'moderation': {'action': 'MESSAGE_RESPONSE_ACTION_BLOCK', 'original_text': 'original message text'},
    });

    expect(message.moderation!.action, ModerationAction.remove);
  });

  test('Message.fromJson reads a moderation without platform_circumvented as not circumvented', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'moderation': {'action': 'flag', 'original_text': 'original message text'},
    });

    expect(
      message.moderation,
      const Moderation(action: ModerationAction.flag, originalText: 'original message text'),
    );
  });

  test('Message.fromJson leaves moderation null when the message carries none', () {
    final message = Message.fromJson(const {'id': 'message-id'});

    expect(message.moderation, isNull);
  });

  test('Message.fromJson reads every reaction group field from its v1 keys', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'reaction_groups': {
        'love': {
          'count': 2,
          'sum_scores': 5,
          'first_reaction_at': '2024-01-01T00:00:00.000Z',
          'last_reaction_at': '2024-01-02T00:00:00.000Z',
        },
      },
    });

    expect(message.reactionGroups, {
      'love': ReactionGroup(
        count: 2,
        sumScores: 5,
        firstReactionAt: DateTime.utc(2024, 1, 1),
        lastReactionAt: DateTime.utc(2024, 1, 2),
      ),
    });
  });

  test('Message.fromJson reads reaction group dates sent as epoch nanoseconds', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'reaction_groups': {
        'love': {
          'count': 1,
          'sum_scores': 1,
          'first_reaction_at': 1704067200123456000,
          'last_reaction_at': 1704153600000000000,
        },
      },
    });

    expect(message.reactionGroups!['love']!.firstReactionAt, DateTime.utc(2024, 1, 1, 0, 0, 0, 123, 456));
    expect(message.reactionGroups!['love']!.lastReactionAt, DateTime.utc(2024, 1, 2));
  });

  test('Message.fromJson leaves reaction groups null when the message carries no reactions', () {
    final message = Message.fromJson(const {'id': 'message-id'});

    expect(message.reactionGroups, isNull);
  });
}
