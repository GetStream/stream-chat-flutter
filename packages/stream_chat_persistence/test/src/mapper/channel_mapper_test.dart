import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/channel_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  group('ChannelEntity', () {
    final user = User(id: 'testUserId');
    final entity = ChannelEntity(
      id: 'testId',
      type: 'testType',
      cid: 'testCid',
      ownCapabilities: ['testCapability'],
      config: {
        'max_message_length': 33,
        'push_level': 'all_mentions',
        'push_notifications': false,
        'chat_preferences': {
          'default_preference': 'all',
          'direct_mentions': 'none',
        },
      },
      frozen: math.Random().nextBool(),
      lastMessageAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      memberCount: 33,
      messageCount: 42,
      createdById: user.id,
      filterTags: ['tag1', 'tag2'],
      extraData: {'test_extra_data': 'testData'},
      team: 'testTeam',
    );

    test('toChannelModel should map entity into ChannelModel', () {
      final channelModel = entity.toChannelModel(createdBy: user);
      expect(channelModel, isA<ChannelModel>());
      expect(channelModel.id, entity.id);
      expect(channelModel.ownCapabilities, entity.ownCapabilities);
      expect(channelModel.config.maxMessageLength, 33);
      expect(channelModel.config.pushLevel, PushLevel.allMentions);
      expect(channelModel.config.pushNotifications, false);
      expect(channelModel.config.chatPreferences?.defaultPreference, ChatPreferenceLevel.all);
      expect(channelModel.config.chatPreferences?.directMentions, ChatPreferenceLevel.none);
      expect(channelModel.frozen, entity.frozen);
      expect(channelModel.createdAt, isSameDateAs(entity.createdAt));
      expect(channelModel.updatedAt, isSameDateAs(entity.updatedAt));
      expect(channelModel.memberCount, entity.memberCount);
      expect(channelModel.messageCount, entity.messageCount);
      expect(channelModel.cid, entity.cid);
      expect(channelModel.lastMessageAt, isSameDateAs(entity.lastMessageAt));
      expect(channelModel.deletedAt, isSameDateAs(entity.deletedAt));
      expect(channelModel.createdBy!.id, entity.createdById);
      expect(channelModel.filterTags, entity.filterTags);
      expect(channelModel.extraData, entity.extraData);
      expect(channelModel.team, entity.team);
    });

    test('toChannelState should map entity into ChannelState ', () {
      final members = List.generate(3, (index) => Member());
      final reads = List.generate(
        3,
        (index) => Read(
          user: User(id: 'testUserId$index'),
          lastRead: DateTime.now(),
          lastReadMessageId: 'lastMessageId$index',
        ),
      );
      final messages = List.generate(3, (index) => Message());

      final channelState = entity.toChannelState(
        createdBy: user,
        members: members,
        reads: reads,
        messages: messages,
        pinnedMessages: messages,
      );

      expect(channelState, isA<ChannelState>());
      expect(channelState.members?.length, members.length);
      expect(channelState.read?.length, reads.length);
      expect(channelState.messages?.length, messages.length);
      expect(channelState.pinnedMessages?.length, messages.length);

      final channelModel = channelState.channel!;
      expect(channelModel.id, entity.id);
      expect(channelModel.ownCapabilities, entity.ownCapabilities);
      expect(channelModel.config.maxMessageLength, 33);
      expect(channelModel.config.pushLevel, PushLevel.allMentions);
      expect(channelModel.config.pushNotifications, false);
      expect(channelModel.config.chatPreferences?.defaultPreference, ChatPreferenceLevel.all);
      expect(channelModel.config.chatPreferences?.directMentions, ChatPreferenceLevel.none);
      expect(channelModel.frozen, entity.frozen);
      expect(channelModel.createdAt, isSameDateAs(entity.createdAt));
      expect(channelModel.updatedAt, isSameDateAs(entity.updatedAt));
      expect(channelModel.memberCount, entity.memberCount);
      expect(channelModel.messageCount, entity.messageCount);
      expect(channelModel.cid, entity.cid);
      expect(channelModel.lastMessageAt, isSameDateAs(entity.lastMessageAt));
      expect(channelModel.deletedAt, isSameDateAs(entity.deletedAt));
      expect(channelModel.filterTags, entity.filterTags);
      expect(channelModel.extraData, entity.extraData);
      expect(channelModel.createdBy!.id, entity.createdById);
    });
  });

  test('toEntity should map model into ChannelEntity', () {
    final createdBy = User(id: 'testUserId');
    final model = ChannelModel(
      id: 'testId',
      type: 'testType',
      cid: 'testCid',
      ownCapabilities: ['testCapability'],
      config: ChannelConfig(
        maxMessageLength: 33,
        pushLevel: PushLevel.allMentions,
        pushNotifications: false,
        chatPreferences: const ChatPreferences(
          defaultPreference: ChatPreferenceLevel.all,
          directMentions: ChatPreferenceLevel.none,
        ),
      ),
      frozen: math.Random().nextBool(),
      lastMessageAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      memberCount: 33,
      messageCount: 75,
      createdBy: createdBy,
      filterTags: ['tag1', 'tag2'],
      extraData: {'test_extra_data': 'testData'},
      team: 'testTeam',
    );

    final channelEntity = model.toEntity();
    expect(channelEntity, isA<ChannelEntity>());
    expect(channelEntity.id, model.id);
    expect(channelEntity.ownCapabilities, model.ownCapabilities);
    expect(
      channelEntity.config['max_message_length'],
      model.config.maxMessageLength,
    );
    expect(channelEntity.config['push_level'], model.config.pushLevel);
    expect(channelEntity.config['push_notifications'], model.config.pushNotifications);
    expect(
      channelEntity.config['chat_preferences'],
      {
        'default_preference': ChatPreferenceLevel.all,
        'direct_mentions': ChatPreferenceLevel.none,
      },
    );
    expect(channelEntity.frozen, model.frozen);
    expect(channelEntity.createdAt, isSameDateAs(model.createdAt));
    expect(channelEntity.updatedAt, isSameDateAs(model.updatedAt));
    expect(channelEntity.memberCount, model.memberCount);
    expect(channelEntity.messageCount, model.messageCount);
    expect(channelEntity.cid, model.cid);
    expect(channelEntity.lastMessageAt, isSameDateAs(model.lastMessageAt));
    expect(channelEntity.deletedAt, isSameDateAs(model.deletedAt));
    expect(channelEntity.filterTags, model.filterTags);
    expect(channelEntity.extraData, model.extraData);
    expect(channelEntity.createdById, model.createdBy!.id);
    expect(channelEntity.team, model.team);
  });
}
