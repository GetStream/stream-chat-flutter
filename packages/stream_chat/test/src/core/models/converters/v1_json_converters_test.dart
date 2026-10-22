import 'package:stream_chat/src/core/models/action.dart';
import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/channel_config.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/channel_mute.dart';
import 'package:stream_chat/src/core/models/chat_preferences.dart';
import 'package:stream_chat/src/core/models/command.dart';
import 'package:stream_chat/src/core/models/converters/v1_json_converters.dart';
import 'package:stream_chat/src/core/models/device.dart';
import 'package:stream_chat/src/core/models/draft.dart';
import 'package:stream_chat/src/core/models/location.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/message_reminder.dart';
import 'package:stream_chat/src/core/models/moderation.dart';
import 'package:stream_chat/src/core/models/push_level.dart';
import 'package:stream_chat/src/core/models/push_provider.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/reaction_group.dart';
import 'package:stream_chat/src/core/models/read.dart';
import 'package:stream_chat/src/core/models/thread.dart';
import 'package:stream_chat/src/core/models/thread_participant.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/models/user_group.dart';
import 'package:stream_chat/src/core/models/user_group_member.dart';
import 'package:stream_chat/src/ws/events/event.dart';
import 'package:test/test.dart';

import '../../../utils.dart';

void main() {
  test('Event.fromJson reads every channel config field from its v1 keys', () {
    final channel = Event.fromJson(const {
      'type': 'channel.updated',
      'channel': {
        'id': 'general',
        'type': 'messaging',
        'cid': 'messaging:general',
        'config': {
          'automod': 'simple',
          'commands': [
            {'name': 'giphy', 'description': 'Post a random gif', 'args': '[text]', 'set': 'fun_set'},
          ],
          'connect_events': true,
          'created_at': '2026-01-01T00:00:00Z',
          'updated_at': '2026-02-01T00:00:00Z',
          'max_message_length': 5000,
          'message_retention': 'infinite',
          'mutes': true,
          'reactions': true,
          'read_events': true,
          'replies': true,
          'search': true,
          'polls': true,
          'push_level': 'direct_mentions',
          'push_notifications': false,
          'chat_preferences': {'direct_mentions': 'all'},
          'typing_events': true,
          'uploads': true,
          'url_enrichment': true,
          'skip_last_msg_update_for_system_msgs': true,
          'user_message_reminders': true,
          'mark_messages_pending': true,
          'delivery_events': true,
          'shared_locations': true,
        },
      },
    }).channel!;

    final config = channel.config;
    expect(config.automod, 'simple');
    expect(config.commands.single.name, 'giphy');
    expect(config.commands.single.set, CommandSet.fun);
    expect(config.connectEvents, isTrue);
    expect(config.createdAt, DateTime.utc(2026));
    expect(config.updatedAt, DateTime.utc(2026, 2));
    expect(config.maxMessageLength, 5000);
    expect(config.messageRetention, 'infinite');
    expect(config.mutes, isTrue);
    expect(config.reactions, isTrue);
    expect(config.readEvents, isTrue);
    expect(config.replies, isTrue);
    expect(config.search, isTrue);
    expect(config.polls, isTrue);
    expect(config.pushLevel, PushLevel.directMentions);
    expect(config.pushNotifications, isFalse);
    expect(config.chatPreferences, const ChatPreferences(directMentions: ChatPreferenceLevel.all));
    expect(config.typingEvents, isTrue);
    expect(config.uploads, isTrue);
    expect(config.urlEnrichment, isTrue);
    expect(config.skipLastMsgUpdateForSystemMsgs, isTrue);
    expect(config.userMessageReminders, isTrue);
    expect(config.markMessagesPending, isTrue);
    expect(config.deliveryEvents, isTrue);
    expect(config.sharedLocations, isTrue);
  });

  test('Event.fromJson reads a channel config without its optional keys with the defaults', () {
    final config = Event.fromJson(const {
      'type': 'channel.updated',
      'channel': {
        'id': 'general',
        'type': 'messaging',
        'cid': 'messaging:general',
        'config': <String, Object?>{},
      },
    }).channel!.config;

    expect(config.automod, 'flag');
    expect(config.commands, isEmpty);
    expect(config.pushNotifications, isTrue);
    expect(config.pushLevel, isNull);
    expect(config.chatPreferences, isNull);
    expect(config.maxMessageLength, 0);
  });

  test('Event.fromJson reads a channel without a config with the default config', () {
    final channel = Event.fromJson(const {
      'type': 'channel.updated',
      'channel': {'id': 'general', 'type': 'messaging', 'cid': 'messaging:general'},
    }).channel!;

    // A default config is stamped with the time it is created.
    final createdAt = DateTime.utc(2026);
    expect(
      channel.config.copyWith(createdAt: createdAt, updatedAt: createdAt),
      ChannelConfig(createdAt: createdAt, updatedAt: createdAt),
    );
  });

  test('Event.fromJson reads every member field from its v1 keys, with custom data in custom and without role', () {
    final event = Event.fromJson(const {
      'type': 'member.updated',
      'member': {
        'user': {'id': 'mo', 'role': 'user', 'name': 'Mo'},
        'user_id': 'mo',
        'role': 'user',
        'channel_role': 'channel_member',
        'invited': true,
        'invite_accepted_at': '2020-01-02T00:00:00Z',
        'invite_rejected_at': '2020-01-03T00:00:00Z',
        'is_moderator': true,
        'banned': true,
        'ban_expires': '2020-01-04T00:00:00Z',
        'shadow_banned': true,
        'pinned_at': '2020-01-05T00:00:00Z',
        'archived_at': '2020-01-06T00:00:00Z',
        'created_at': '2020-01-07T00:00:00Z',
        'updated_at': '2020-01-08T00:00:00Z',
        'deleted_messages': ['msg-1', 'msg-2'],
        'notifications_muted': true,
        'status': 'member',
        'ban_from_future_channels': true,
        'future_channel_ban_expires': '2020-01-09T00:00:00Z',
        'deleted_at': '2020-01-10T00:00:00Z',
        'nickname': 'Momo',
      },
    });

    final member = event.member!;
    expect(member.user?.id, 'mo');
    expect(member.userId, 'mo');
    expect(member.channelRole, 'channel_member');
    expect(member.invited, isTrue);
    expect(member.inviteAcceptedAt, DateTime.utc(2020, 1, 2));
    expect(member.inviteRejectedAt, DateTime.utc(2020, 1, 3));
    expect(member.isModerator, isTrue);
    expect(member.banned, isTrue);
    expect(member.banExpires, DateTime.utc(2020, 1, 4));
    expect(member.shadowBanned, isTrue);
    expect(member.pinnedAt, DateTime.utc(2020, 1, 5));
    expect(member.archivedAt, DateTime.utc(2020, 1, 6));
    expect(member.createdAt, DateTime.utc(2020, 1, 7));
    expect(member.updatedAt, DateTime.utc(2020, 1, 8));
    expect(member.deletedMessages, ['msg-1', 'msg-2']);
    expect(member.notificationsMuted, isTrue);
    expect(member.status, 'member');
    expect(member.banFromFutureChannels, isTrue);
    expect(member.futureChannelBanExpires, DateTime.utc(2020, 1, 9));
    expect(member.deletedAt, DateTime.utc(2020, 1, 10));
    expect(member.custom, {'nickname': 'Momo'});
  });

  test('Event.fromJson reads the channel members from their v1 keys', () {
    final channel = Event.fromJson(const {
      'type': 'channel.updated',
      'channel': {
        'id': 'general',
        'type': 'messaging',
        'cid': 'messaging:general',
        'members': [
          {'user_id': 'mo', 'channel_role': 'channel_moderator'},
          {'user_id': 'jo', 'channel_role': 'channel_member'},
        ],
      },
    }).channel!;

    expect(channel.members?.map((it) => (it.userId, it.channelRole)), [
      ('mo', 'channel_moderator'),
      ('jo', 'channel_member'),
    ]);
  });

  test('Event.fromJson reads a v1 channel with its custom data at the root', () {
    final channel = Event.fromJson({'type': 'channel.updated', 'channel': jsonFixture('channel.json')}).channel!;

    expect(channel.custom, {
      'cats': true,
      'fruit': ['bananas', 'apples'],
    });
  });

  test('Event.fromJson reads a zero last_message_at as no date', () {
    final channel = Event.fromJson(const {
      'type': 'channel.truncated',
      'channel': {
        'id': 'general',
        'type': 'messaging',
        'cid': 'messaging:general',
        'last_message_at': '0001-01-01T00:00:00Z',
      },
    }).channel!;

    expect(channel.lastMessageAt, isNull);
  });

  test('Event.fromJson reads every channel field from its v1 keys', () {
    final channel = Event.fromJson(const {
      'type': 'channel.updated',
      'channel': {
        'id': 'general',
        'type': 'messaging',
        'cid': 'messaging:general',
        'own_capabilities': ['send-message', 'read-events'],
        'created_by': {'id': 'creator'},
        'frozen': true,
        'last_message_at': '2026-03-04T00:00:00Z',
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-02-01T00:00:00Z',
        'deleted_at': '2026-03-01T00:00:00Z',
        'member_count': 2,
        'message_count': 42,
        'team': 'blue',
        'cooldown': 30,
        'filter_tags': ['support'],
        'disabled': true,
        'hidden': true,
        'muted': true,
        'blocked': true,
        'truncated_at': '2026-02-02T00:00:00Z',
        'truncated_by': {'id': 'truncator', 'name': 'Truncator'},
        'auto_translation_enabled': true,
        'auto_translation_language': 'fr',
      },
    }).channel!;

    expect(channel.ownCapabilities, [ChannelCapability.sendMessage, ChannelCapability.readEvents]);
    expect(channel.createdBy?.id, 'creator');
    expect(channel.frozen, isTrue);
    expect(channel.lastMessageAt, DateTime.utc(2026, 3, 4));
    expect(channel.createdAt, DateTime.utc(2026));
    expect(channel.updatedAt, DateTime.utc(2026, 2));
    expect(channel.deletedAt, DateTime.utc(2026, 3));
    expect(channel.memberCount, 2);
    expect(channel.messageCount, 42);
    expect(channel.team, 'blue');
    expect(channel.cooldown, 30);
    expect(channel.filterTags, ['support']);
    expect(channel.disabled, isTrue);
    expect(channel.hidden, isTrue);
    expect(channel.muted, isTrue);
    expect(channel.blocked, isTrue);
    expect(channel.truncatedAt, DateTime.utc(2026, 2, 2));
    expect(channel.truncatedBy?.id, 'truncator');
    expect(channel.truncatedBy?.name, 'Truncator');
    expect(channel.autoTranslationEnabled, isTrue);
    expect(channel.autoTranslationLanguage, 'fr');
    expect(channel.custom, isEmpty);
  });

  test('Event.fromJson leaves the channel fields the model does not carry out of its custom data', () {
    final channel = Event.fromJson(const {
      'type': 'channel.updated',
      'channel': {
        'id': 'general',
        'type': 'messaging',
        'cid': 'messaging:general',
        'hide_messages_before': '0001-01-01T00:00:00Z',
        'mute_expires_at': '2026-01-01T00:00:00Z',
        'color': 'red',
      },
    }).channel!;

    expect(channel.custom, {'color': 'red'});
  });

  test('ChannelMute.toJson writes the channel id, type, frozen flag, cooldown and custom data at the root', () {
    final mute = ChannelMute(
      user: User(id: 'mo'),
      channel: ChannelModel(cid: 'messaging:general', frozen: true, cooldown: 30, custom: const {'name': 'General'}),
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

    expect(mute.toJson()['channel'], {
      'id': 'general',
      'type': 'messaging',
      'frozen': true,
      'cooldown': 30,
      'name': 'General',
    });
  });

  test('ChannelMute.toJson leaves out channel custom data named like a channel field', () {
    final mute = ChannelMute(
      user: User(id: 'mo'),
      channel: ChannelModel(cid: 'messaging:general', custom: const {'id': 'custom', 'hidden': true, 'color': 'red'}),
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

    expect(mute.toJson()['channel'], {
      'id': 'general',
      'type': 'messaging',
      'frozen': false,
      'cooldown': 0,
      'color': 'red',
    });
  });

  test('ChannelMute.fromJson reads back the channel toJson writes', () {
    final mute = ChannelMute(
      user: User(id: 'mo'),
      channel: ChannelModel(cid: 'messaging:general', frozen: true, cooldown: 30, custom: const {'name': 'General'}),
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

    final channel = ChannelMute.fromJson(mute.toJson()).channel;

    expect(channel.cid, 'messaging:general');
    expect(channel.frozen, isTrue);
    expect(channel.cooldown, 30);
    expect(channel.custom, {'name': 'General'});
  });

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

  test('Event.fromJson reads every reaction field from its v1 keys, with the rest in custom data', () {
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
        custom: const {'bananas': 'yes'},
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

  test('Event.fromJson reads a reminder sent without a due date', () {
    final event = Event.fromJson(const {
      'type': 'reminder.updated',
      'reminder': {
        'channel_cid': 'messaging:general',
        'message_id': 'message-id',
        'user_id': 'user-id',
        'created_at': '2024-06-01T10:00:00.000Z',
        'updated_at': '2024-06-02T10:00:00.000Z',
      },
    });

    expect(event.reminder?.remindAt, isNull);
  });

  test('Event.fromJson reads every thread field from its v1 keys, with custom data in custom', () {
    const channelJson = {'id': 'general', 'type': 'messaging', 'cid': 'messaging:general'};
    const parentJson = {'id': 'parent-id', 'text': 'Where do we meet?'};
    const replyJson = {'id': 'reply-id', 'text': 'At the station', 'parent_id': 'parent-id'};
    const creatorJson = {'id': 'creator-id'};
    const participantJson = {'id': 'participant-id'};
    const readerJson = {'id': 'reader-id'};
    const draftJson = {
      'channel_cid': 'messaging:general',
      'created_at': '2024-06-05T10:00:00.000Z',
      'parent_id': 'parent-id',
      'message': {'id': 'draft-id', 'text': 'Maybe at noon'},
    };

    final event = Event.fromJson(const {
      'type': 'thread.updated',
      'thread': {
        'active_participant_count': 2,
        'channel_cid': 'messaging:general',
        'channel': channelJson,
        'created_at': '2024-06-01T10:00:00.000Z',
        'updated_at': '2024-06-02T10:00:00.000Z',
        'deleted_at': '2024-06-03T10:00:00.000Z',
        'created_by_user_id': 'creator-id',
        'created_by': creatorJson,
        'title': 'Meeting point',
        'parent_message_id': 'parent-id',
        'parent_message': parentJson,
        'reply_count': 4,
        'participant_count': 3,
        'thread_participants': [
          {
            'channel_cid': 'messaging:general',
            'created_at': '2024-06-01T11:00:00.000Z',
            'last_read_at': '2024-06-02T11:00:00.000Z',
            'last_thread_message_at': '2024-06-02T12:00:00.000Z',
            'left_thread_at': '2024-06-03T12:00:00.000Z',
            'thread_id': 'parent-id',
            'user_id': 'participant-id',
            'user': participantJson,
          },
        ],
        'last_message_at': '2024-06-02T09:00:00.000Z',
        'latest_replies': [replyJson],
        'read': [
          {
            'user': readerJson,
            'last_read': '2024-06-02T13:00:00.000Z',
            'unread_messages': 1,
            'last_read_message_id': 'reply-id',
          },
        ],
        'draft': draftJson,
        'priority': 'high',
      },
    });

    final thread = event.thread!;
    // A channel compares by identity, so it is checked on its own.
    expect(thread.channel?.cid, 'messaging:general');
    expect(
      thread,
      Thread(
        activeParticipantCount: 2,
        channelCid: 'messaging:general',
        channel: thread.channel,
        createdAt: DateTime.utc(2024, 6, 1, 10),
        updatedAt: DateTime.utc(2024, 6, 2, 10),
        deletedAt: DateTime.utc(2024, 6, 3, 10),
        createdByUserId: 'creator-id',
        createdBy: User.fromJson(const {...creatorJson}),
        title: 'Meeting point',
        parentMessageId: 'parent-id',
        parentMessage: Message.fromJson(const {...parentJson}),
        replyCount: 4,
        participantCount: 3,
        threadParticipants: [
          ThreadParticipant(
            channelCid: 'messaging:general',
            createdAt: DateTime.utc(2024, 6, 1, 11),
            lastReadAt: DateTime.utc(2024, 6, 2, 11),
            lastThreadMessageAt: DateTime.utc(2024, 6, 2, 12),
            leftThreadAt: DateTime.utc(2024, 6, 3, 12),
            threadId: 'parent-id',
            userId: 'participant-id',
            user: User.fromJson(const {...participantJson}),
          ),
        ],
        lastMessageAt: DateTime.utc(2024, 6, 2, 9),
        latestReplies: [
          Message.fromJson(const {...replyJson}),
        ],
        read: [
          Read(
            user: User.fromJson(const {...readerJson}),
            lastRead: DateTime.utc(2024, 6, 2, 13),
            unreadMessages: 1,
            lastReadMessageId: 'reply-id',
          ),
        ],
        draft: Draft.fromJson(const {...draftJson}),
        custom: const {'priority': 'high'},
      ),
    );
  });

  test('Event.fromJson reads a thread sent without participants, replies, reads or a draft', () {
    final event = Event.fromJson(const {
      'type': 'message.read',
      'thread': {
        'active_participant_count': 0,
        'channel_cid': 'messaging:general',
        'created_at': '2024-06-01T10:00:00.000Z',
        'updated_at': '2024-06-02T10:00:00.000Z',
        'created_by_user_id': 'creator-id',
        'title': '',
        'parent_message_id': 'parent-id',
        'reply_count': 0,
        'participant_count': 1,
        'last_message_at': '2024-06-02T09:00:00.000Z',
      },
    });

    expect(
      event.thread,
      Thread(
        activeParticipantCount: 0,
        channelCid: 'messaging:general',
        createdAt: DateTime.utc(2024, 6, 1, 10),
        updatedAt: DateTime.utc(2024, 6, 2, 10),
        createdByUserId: 'creator-id',
        title: '',
        parentMessageId: 'parent-id',
        replyCount: 0,
        participantCount: 1,
        lastMessageAt: DateTime.utc(2024, 6, 2, 9),
      ),
    );
  });
}
