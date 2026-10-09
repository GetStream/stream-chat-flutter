import 'package:stream_chat/src/core/models/action.dart';
import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/converters/v1_json_converters.dart';
import 'package:stream_chat/src/core/models/device.dart';
import 'package:stream_chat/src/core/models/location.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/message_reminder.dart';
import 'package:stream_chat/src/core/models/moderation.dart';
import 'package:stream_chat/src/core/models/push_provider.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/reaction_group.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/models/user_group.dart';
import 'package:stream_chat/src/core/models/user_group_member.dart';
import 'package:stream_chat/src/ws/events/event.dart';
import 'package:test/test.dart';

import '../../../utils.dart';

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

  test('Attachment.fromJson reads every action field from its v1 keys', () {
    final attachment = Attachment.fromJson(const {
      'type': 'giphy',
      'actions': [
        {'name': 'image_action', 'style': 'primary', 'text': 'Send', 'type': 'button', 'value': 'send'},
      ],
    });

    expect(attachment.actions, [
      const Action(name: 'image_action', style: 'primary', text: 'Send', type: 'button', value: 'send'),
    ]);
  });

  test('Attachment.fromJson reads an action without a style as the default style', () {
    final attachment = Attachment.fromJson(const {
      'type': 'giphy',
      'actions': [
        {'name': 'image_action', 'text': 'Cancel', 'type': 'button'},
      ],
    });

    expect(attachment.actions, [const Action(name: 'image_action', text: 'Cancel', type: 'button')]);
  });

  test('Attachment.toJson writes every action key, including a null value', () {
    final attachment = Attachment(
      type: 'giphy',
      actions: const [Action(name: 'image_action', text: 'Cancel', type: 'button')],
    );

    expect(attachment.toJson()['actions'], [
      {'name': 'image_action', 'style': 'default', 'text': 'Cancel', 'type': 'button', 'value': null},
    ]);
  });

  test('Attachment.fromJson reads back the actions written by toJson', () {
    final attachment = Attachment(
      type: 'giphy',
      actions: const [Action(name: 'image_action', style: 'primary', text: 'Send', type: 'button', value: 'send')],
    );

    expect(Attachment.fromJson(attachment.toJson()).actions, attachment.actions);
  });

  test('Event.fromJson reads every reaction field from its v1 keys, with custom data in extraData', () {
    final json = jsonFixture('reaction.json');

    final event = Event.fromJson({
      'type': 'reaction.new',
      'reaction': {...json, 'bananas': 'yes'},
    });

    expect(
      event.reaction,
      Reaction(
        messageId: '76cd8c82-b557-4e48-9d12-87995d3a0e04',
        type: 'wow',
        user: User.fromJson(json['user'] as Map<String, dynamic>),
        userId: '2de0297c-f3f2-489d-b930-ef77342edccf',
        emojiCode: '😮',
        createdAt: DateTime.parse('2020-01-28T22:17:31.108742Z'),
        updatedAt: DateTime.parse('2020-01-28T22:17:31.108742Z'),
        extraData: const {'bananas': 'yes'},
      ),
    );
  });

  test('Event.fromJson reads a reaction without a score as scoring one', () {
    final event = Event.fromJson(const {
      'type': 'reaction.new',
      'reaction': {
        'type': 'like',
        'created_at': '2020-01-28T22:17:31.108742Z',
        'updated_at': '2020-01-28T22:17:31.108742Z',
      },
    });

    expect(event.reaction!.score, 1);
  });

  test('Event.toJson writes the reaction in the request shape, with custom data at the root', () {
    final event = Event(
      type: 'reaction.new',
      reaction: Reaction(
        messageId: 'message-id',
        type: 'wow',
        user: User(id: 'user-id'),
        score: 2,
        emojiCode: '😮',
        extraData: const {'bananas': 'yes'},
      ),
    );

    expect(event.toJson()['reaction'], {'type': 'wow', 'score': 2, 'emoji_code': '😮', 'bananas': 'yes'});
  });

  test('Message.fromJson reads the latest and own reactions', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'latest_reactions': [
        {
          'type': 'like',
          'user_id': 'user-1',
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
        },
      ],
      'own_reactions': [
        {
          'type': 'love',
          'score': 3,
          'user_id': 'user-2',
          'created_at': '2024-01-02T00:00:00.000Z',
          'updated_at': '2024-01-02T00:00:00.000Z',
        },
      ],
    });

    expect(message.latestReactions, [
      Reaction(
        type: 'like',
        userId: 'user-1',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      ),
    ]);
    expect(message.ownReactions, [
      Reaction(
        type: 'love',
        score: 3,
        userId: 'user-2',
        createdAt: DateTime.utc(2024, 1, 2),
        updatedAt: DateTime.utc(2024, 1, 2),
      ),
    ]);
  });

  test('Message.fromJson reads every shared location field from its v1 keys', () {
    final message = Message.fromJson(const {
      'id': 'message-id',
      'shared_location': {
        'channel_cid': 'messaging:general',
        'message_id': 'message-id',
        'user_id': 'user-id',
        'latitude': 37.7749,
        'longitude': -122.4194,
        'created_by_device_id': 'device-id',
        'end_at': '2024-12-31T23:59:59.999Z',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-02T00:00:00.000Z',
      },
    });

    expect(
      message.sharedLocation,
      Location(
        channelCid: 'messaging:general',
        messageId: 'message-id',
        userId: 'user-id',
        latitude: 37.7749,
        longitude: -122.4194,
        createdByDeviceId: 'device-id',
        endAt: DateTime.utc(2024, 12, 31, 23, 59, 59, 999),
        createdAt: DateTime.utc(2024),
        updatedAt: DateTime.utc(2024, 1, 2),
      ),
    );
  });

  test('ChannelState.fromJson reads active live locations with their channel and message', () {
    final state = ChannelState.fromJson(const {
      'active_live_locations': [
        {
          'channel_cid': 'messaging:general',
          'channel': {'id': 'general', 'type': 'messaging', 'cid': 'messaging:general'},
          'message_id': 'message-id',
          'message': {'id': 'message-id', 'text': 'Live location'},
          'latitude': 1,
          'longitude': 2,
          'end_at': '2024-12-31T23:59:59.999Z',
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
        },
      ],
    });

    final location = state.activeLiveLocations!.single;
    expect(location.channel, isA<ChannelModel>().having((it) => it.cid, 'cid', 'messaging:general'));
    expect(location.message, isA<Message>().having((it) => it.text, 'text', 'Live location'));
    expect(location.coordinates.latitude, 1.0);
    expect(location.coordinates.longitude, 2.0);
  });

  test('Message.toJson writes the shared location in the request shape, with the end date in UTC', () {
    final message = Message(
      id: 'message-id',
      sharedLocation: Location(
        channelCid: 'messaging:general',
        messageId: 'message-id',
        userId: 'user-id',
        latitude: 37.7749,
        longitude: -122.4194,
        createdByDeviceId: 'device-id',
        endAt: DateTime.utc(2024, 12, 31, 23, 59, 59, 999),
      ),
    );

    expect(message.toJson()['shared_location'], {
      'latitude': 37.7749,
      'longitude': -122.4194,
      'created_by_device_id': 'device-id',
      'end_at': '2024-12-31T23:59:59.999Z',
    });
  });

  test('Message.toJson leaves the device and end date out of a static location without them', () {
    final message = Message(id: 'message-id', sharedLocation: Location(latitude: 1, longitude: 2));

    expect(message.toJson()['shared_location'], {'latitude': 1.0, 'longitude': 2.0});
  });

  test('Message.fromJson reads every reminder field from its v1 keys', () {
    const channelJson = {'id': 'general', 'type': 'messaging', 'cid': 'messaging:general'};
    const messageJson = {'id': 'message-id', 'text': 'Remember me'};
    const userJson = {'id': 'user-id'};

    final message = Message.fromJson(const {
      'id': 'message-id',
      'reminder': {
        'channel_cid': 'messaging:general',
        'channel': channelJson,
        'message_id': 'message-id',
        'message': messageJson,
        'user_id': 'user-id',
        'user': userJson,
        'remind_at': '2024-06-15T14:30:00.000Z',
        'created_at': '2024-06-01T10:00:00.000Z',
        'updated_at': '2024-06-02T10:00:00.000Z',
      },
    });

    final reminder = message.reminder!;
    // A channel compares by identity, so it is checked on its own.
    expect(reminder.channel?.cid, 'messaging:general');
    expect(
      reminder,
      MessageReminder(
        channelCid: 'messaging:general',
        channel: reminder.channel,
        messageId: 'message-id',
        message: Message.fromJson(const {...messageJson}),
        userId: 'user-id',
        user: User.fromJson(const {...userJson}),
        remindAt: DateTime.utc(2024, 6, 15, 14, 30),
        createdAt: DateTime.utc(2024, 6, 1, 10),
        updatedAt: DateTime.utc(2024, 6, 2, 10),
      ),
    );
  });

  test('Event.fromJson reads reminder dates sent as epoch nanoseconds', () {
    final event = Event.fromJson(const {
      'type': 'reminder.created',
      'reminder': {
        'channel_cid': 'messaging:general',
        'message_id': 'message-id',
        'user_id': 'user-id',
        'remind_at': 1718461800000000000,
        'created_at': 1717236000000000000,
        'updated_at': 1717322400000000000,
      },
    });

    expect(event.reminder?.remindAt, DateTime.utc(2024, 6, 15, 14, 30));
    expect(event.reminder?.createdAt, DateTime.utc(2024, 6, 1, 10));
    expect(event.reminder?.updatedAt, DateTime.utc(2024, 6, 2, 10));
  });

  test("Event.toJson writes the reminder's ids and dates, without its channel, message or user", () {
    final event = Event(
      type: 'reminder.created',
      reminder: MessageReminder(
        channelCid: 'messaging:general',
        channel: ChannelModel(cid: 'messaging:general'),
        messageId: 'message-id',
        message: Message(id: 'message-id'),
        userId: 'user-id',
        user: User(id: 'user-id'),
        remindAt: DateTime.utc(2024, 6, 15, 14, 30),
        createdAt: DateTime.utc(2024, 6, 1, 10),
        updatedAt: DateTime.utc(2024, 6, 2, 10),
      ),
    );

    expect(event.toJson()['reminder'], {
      'channel_cid': 'messaging:general',
      'message_id': 'message-id',
      'user_id': 'user-id',
      'remind_at': '2024-06-15T14:30:00.000Z',
      'created_at': '2024-06-01T10:00:00.000Z',
      'updated_at': '2024-06-02T10:00:00.000Z',
    });
  });

  test('Event.fromJson reads back a reminder without a due date written by toJson', () {
    final reminder = MessageReminder(
      channelCid: 'messaging:general',
      messageId: 'message-id',
      userId: 'user-id',
      createdAt: DateTime.utc(2024, 6, 1, 10),
      updatedAt: DateTime.utc(2024, 6, 2, 10),
    );

    final event = Event.fromJson(Event(type: 'reminder.updated', reminder: reminder).toJson());

    expect(event.reminder, reminder);
  });
}
