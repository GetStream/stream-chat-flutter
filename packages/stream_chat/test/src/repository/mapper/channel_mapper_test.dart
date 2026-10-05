import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/chat_preferences.dart';
import 'package:stream_chat/src/core/models/command.dart';
import 'package:stream_chat/src/core/models/push_level.dart';
import 'package:stream_chat/src/repository/mapper/channel_mapper.dart';
import 'package:stream_chat/src/repository/mapper/user_mapper.dart';
import 'package:test/test.dart';

void main() {
  test('ChannelResponse.toModel maps every field the channel models', () {
    final channel = _channelResponse().toModel();

    expect(channel.id, 'general');
    expect(channel.type, 'messaging');
    expect(channel.cid, 'messaging:general');
    expect(channel.ownCapabilities, [ChannelCapability.sendMessage, ChannelCapability.readEvents]);
    expect(channel.createdBy?.id, 'creator');
    expect(channel.frozen, isTrue);
    expect(channel.lastMessageAt, DateTime.utc(2026, 3, 4));
    expect(channel.createdAt, DateTime.utc(2026));
    expect(channel.updatedAt, DateTime.utc(2026, 2));
    expect(channel.deletedAt, DateTime.utc(2026, 3));
    expect(channel.memberCount, 2);
    expect(channel.members?.single.userId, 'member');
    expect(channel.team, 'blue');
    expect(channel.cooldown, 30);
    expect(channel.disabled, isFalse);
    expect(channel.hidden, isTrue);
    expect(channel.muted, isTrue);
    expect(channel.blocked, isFalse);
    expect(channel.truncatedAt, DateTime.utc(2026, 3, 2));
    expect(channel.truncatedBy?.id, 'truncator');
    expect(channel.autoTranslationEnabled, isTrue);
    expect(channel.autoTranslationLanguage, 'fr');
    expect(channel.messageCount, 42);
    expect(channel.filterTags, ['support']);
  });

  test('ChannelResponse.toModel takes the name and image from the custom data', () {
    final channel = _channelResponse().toModel();

    expect(channel.name, 'General');
    expect(channel.extraData['image'], 'https://example.com/general.png');
  });

  test('ChannelResponse.toModel keeps the custom data and the server fields in extraData', () {
    final channel = _channelResponse().toModel();

    expect(channel.extraData, {
      'name': 'General',
      'image': 'https://example.com/general.png',
      'topic': 'anything',
      'disabled': false,
      'hidden': true,
      'muted': true,
      'blocked': false,
      'truncated_at': DateTime.utc(2026, 3, 2).toIso8601String(),
      'truncated_by': _userResponse('truncator').toModel().toJson(),
      'auto_translation_enabled': true,
      'auto_translation_language': 'fr',
    });
  });

  test('ChannelResponse.toModel drops custom data named like a channel field', () {
    final channel = _channelResponse(custom: const {'hidden': 'shadowed', 'cid': 'shadowed'}).toModel();

    expect(channel.hidden, isTrue);
    expect(channel.extraData, isNot(contains('cid')));
  });

  test('ChannelResponse.toModel falls back to the defaults for the fields the response leaves out', () {
    final channel = api.ChannelResponse(
      cid: 'messaging:general',
      id: 'general',
      type: 'messaging',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026, 2),
      custom: const {},
      disabled: false,
      frozen: false,
    ).toModel();

    expect(channel.memberCount, 0);
    expect(channel.cooldown, 0);
    expect(channel.config.commands, isEmpty);
    expect(channel.members, isNull);
  });

  test('ChannelConfigWithInfo.toModel maps every field the config models', () {
    final config = _channelResponse().config!.toModel();

    expect(config.automod, 'simple');
    expect(config.commands.single.name, 'giphy');
    expect(config.commands.single.description, 'Post a random gif');
    expect(config.commands.single.args, '[text]');
    expect(config.commands.single.set, CommandSet.fun);
    expect(config.connectEvents, isTrue);
    expect(config.createdAt, DateTime.utc(2025));
    expect(config.updatedAt, DateTime.utc(2025, 2));
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
    expect(
      config.chatPreferences,
      const ChatPreferences(
        channelMentions: ChatPreferenceLevel.all,
        defaultPreference: ChatPreferenceLevel.none,
        directMentions: ChatPreferenceLevel.all,
        groupMentions: ChatPreferenceLevel.none,
        hereMentions: ChatPreferenceLevel.all,
        roleMentions: ChatPreferenceLevel.none,
        threadReplies: ChatPreferenceLevel.all,
      ),
    );
    expect(config.typingEvents, isTrue);
    expect(config.uploads, isTrue);
    expect(config.urlEnrichment, isTrue);
    expect(config.skipLastMsgUpdateForSystemMsgs, isTrue);
    expect(config.userMessageReminders, isTrue);
    expect(config.markMessagesPending, isTrue);
    expect(config.deliveryEvents, isTrue);
    expect(config.sharedLocations, isTrue);
  });

  test('ChannelMemberResponse.toModel maps every field the member models', () {
    final member = _memberResponse().toModel();

    expect(member.user?.id, 'member');
    expect(member.userId, 'member');
    expect(member.inviteAcceptedAt, DateTime.utc(2026, 1, 2));
    expect(member.inviteRejectedAt, DateTime.utc(2026, 1, 3));
    expect(member.invited, isTrue);
    expect(member.channelRole, 'channel_moderator');
    expect(member.isModerator, isTrue);
    expect(member.createdAt, DateTime.utc(2026));
    expect(member.updatedAt, DateTime.utc(2026, 2));
    expect(member.banned, isTrue);
    expect(member.banExpires, DateTime.utc(2026, 6));
    expect(member.shadowBanned, isTrue);
    expect(member.pinnedAt, DateTime.utc(2026, 1, 4));
    expect(member.archivedAt, DateTime.utc(2026, 1, 5));
    expect(member.deletedMessages, ['message-1']);
    expect(member.notificationsMuted, isTrue);
    expect(member.status, 'member');
    expect(member.banFromFutureChannels, isTrue);
    expect(member.futureChannelBanExpires, DateTime.utc(2026, 7));
    expect(member.deletedAt, DateTime.utc(2026, 8));
  });

  test('ChannelMemberResponse.toModel keeps the custom data and the server fields in extraData', () {
    final member = _memberResponse().toModel();

    expect(member.extraData, {
      'nickname': 'Mo',
      'role': 'user',
      'notifications_muted': true,
      'status': 'member',
      'ban_from_future_channels': true,
      'future_channel_ban_expires': DateTime.utc(2026, 7).toIso8601String(),
      'deleted_at': DateTime.utc(2026, 8).toIso8601String(),
    });
  });

  test('ChannelMemberResponse.toModel drops custom data named like a member field', () {
    final member = _memberResponse(custom: const {'status': 'shadowed', 'user_id': 'shadowed'}).toModel();

    expect(member.status, 'member');
    expect(member.extraData, isNot(contains('user_id')));
  });

  test('ChannelMemberResponse.toModel falls back to the defaults for the fields the response leaves out', () {
    final member = api.ChannelMemberResponse(
      banned: false,
      channelRole: 'channel_member',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026, 2),
      custom: const {},
      notificationsMuted: false,
      shadowBanned: false,
    ).toModel();

    expect(member.invited, isFalse);
    expect(member.isModerator, isFalse);
    expect(member.deletedMessages, isEmpty);
  });
}

// A response with every field set.
api.ChannelResponse _channelResponse({
  Map<String, Object?> custom = const {
    'name': 'General',
    'image': 'https://example.com/general.png',
    'topic': 'anything',
  },
}) => api.ChannelResponse(
  autoTranslationEnabled: true,
  autoTranslationLanguage: 'fr',
  blocked: false,
  cid: 'messaging:general',
  config: api.ChannelConfigWithInfo(
    allowedFlagReasons: const ['spam'],
    automod: api.ChannelConfigWithInfoAutomod.simple,
    automodBehavior: api.ChannelConfigWithInfoAutomodBehavior.flag,
    blocklist: 'profanity',
    blocklistBehavior: api.ChannelConfigWithInfoBlocklistBehavior.block,
    chatPreferences: const api.ChatPreferences(
      channelMentions: 'all',
      defaultPreference: 'none',
      directMentions: 'all',
      distinctChannelMessages: 'all',
      groupMentions: 'none',
      hereMentions: 'all',
      roleMentions: 'none',
      threadReplies: 'all',
    ),
    commands: [
      api.Command(
        args: '[text]',
        createdAt: DateTime.utc(2025),
        description: 'Post a random gif',
        name: 'giphy',
        set: 'fun_set',
        updatedAt: DateTime.utc(2025, 2),
      ),
    ],
    connectEvents: true,
    countMessages: true,
    createdAt: DateTime.utc(2025),
    customEvents: true,
    deliveryEvents: true,
    grants: const {
      'user': ['read-channel'],
    },
    markMessagesPending: true,
    maxMessageLength: 5000,
    messageRetention: 'infinite',
    mutes: true,
    name: 'messaging',
    partitionSize: 10,
    partitionTtl: '24h',
    polls: true,
    pushLevel: api.ChannelConfigWithInfoPushLevel.directMentions,
    pushNotifications: false,
    quotes: true,
    reactions: true,
    readEvents: true,
    reminders: true,
    replies: true,
    search: true,
    sharedLocations: true,
    skipLastMsgUpdateForSystemMsgs: true,
    typingEvents: true,
    updatedAt: DateTime.utc(2025, 2),
    uploads: true,
    urlEnrichment: true,
    userMessageReminders: true,
  ),
  cooldown: 30,
  createdAt: DateTime.utc(2026),
  createdBy: _userResponse('creator'),
  custom: custom,
  deletedAt: DateTime.utc(2026, 3),
  disabled: false,
  filterTags: const ['support'],
  frozen: true,
  hidden: true,
  hideMessagesBefore: DateTime.utc(2026, 3, 1),
  id: 'general',
  lastMessageAt: DateTime.utc(2026, 3, 4),
  memberCount: 2,
  members: [_memberResponse()],
  messageCount: 42,
  muteExpiresAt: DateTime.utc(2026, 5),
  muted: true,
  ownCapabilities: const [api.ChannelOwnCapability.sendMessage, api.ChannelOwnCapability.readEvents],
  team: 'blue',
  truncatedAt: DateTime.utc(2026, 3, 2),
  truncatedBy: _userResponse('truncator'),
  type: 'messaging',
  updatedAt: DateTime.utc(2026, 2),
);

// A response with every field set.
api.ChannelMemberResponse _memberResponse({Map<String, Object?> custom = const {'nickname': 'Mo'}}) =>
    api.ChannelMemberResponse(
      archivedAt: DateTime.utc(2026, 1, 5),
      banExpires: DateTime.utc(2026, 6),
      banFromFutureChannels: true,
      banned: true,
      channelRole: 'channel_moderator',
      createdAt: DateTime.utc(2026),
      custom: custom,
      deletedAt: DateTime.utc(2026, 8),
      deletedMessages: const ['message-1'],
      futureChannelBanExpires: DateTime.utc(2026, 7),
      inviteAcceptedAt: DateTime.utc(2026, 1, 2),
      inviteRejectedAt: DateTime.utc(2026, 1, 3),
      invited: true,
      isModerator: true,
      notificationsMuted: true,
      pinnedAt: DateTime.utc(2026, 1, 4),
      role: 'user',
      shadowBanned: true,
      status: 'member',
      updatedAt: DateTime.utc(2026, 2),
      user: _userResponse('member'),
      userId: 'member',
    );

api.UserResponse _userResponse(String id) => api.UserResponse(
  banned: false,
  blockedUserIds: const [],
  createdAt: DateTime.utc(2025),
  custom: const {},
  id: id,
  language: 'en',
  online: false,
  role: 'user',
  teams: const [],
  updatedAt: DateTime.utc(2025),
);
