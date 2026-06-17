// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars, deprecated_member_use_from_same_package

import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/message_state.dart';
import 'package:stream_chat/src/core/models/moderation.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/reaction_group.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/models/user_group.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/message', () {
    test('should parse json correctly', () {
      final message = Message.fromJson(jsonFixture('message.json'));
      expect(message.id, '4637f7e4-a06b-42db-ba5a-8d8270dd926f');
      expect(message.text, 'https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA');
      expect(message.type, 'regular');
      expect(message.user, isA<User>());
      expect(message.silent, isA<bool>());
      expect(message.attachments, isA<List<Attachment>>());
      expect(message.latestReactions, isA<List<Reaction>>());
      expect(message.ownReactions, isA<List<Reaction>>());
      expect(message.reactionGroups, isA<Map<String, ReactionGroup>>());
      expect(message.reactionGroups?['love']?.count, 1);
      expect(message.reactionGroups?['love']?.sumScores, 1);
      expect(message.createdAt, DateTime.parse('2020-01-28T22:17:31.107978Z'));
      expect(message.updatedAt, DateTime.parse('2020-01-28T22:17:31.130506Z'));
      expect(message.mentionedUsers, isA<List<User>>());
      expect(message.mentionedUsers, hasLength(1));
      expect(message.mentionedUsers.first.id, 'mentioned-user-1');
      expect(message.mentionedUsers.first.name, 'John Doe');
      expect(message.mentionedChannel, isTrue);
      expect(message.mentionedHere, isFalse);
      expect(message.mentionedRoles, equals(['admin', 'moderator']));
      expect(message.mentionedGroupIds, equals(['group-1', 'group-2']));
      expect(message.mentionedGroups, isA<List<UserGroup>>());
      expect(message.mentionedGroups, hasLength(2));
      expect(message.mentionedGroups![0].id, 'group-1');
      expect(message.mentionedGroups![0].name, 'Engineering');
      expect(message.mentionedGroups![0].description, 'Engineering team');
      expect(message.mentionedGroups![1].id, 'group-2');
      expect(message.mentionedGroups![1].name, 'Design');
      expect(message.mentionedGroups![1].description, isNull);
      expect(message.pinned, false);
      expect(message.pinnedAt, null);
      expect(message.pinExpires, null);
      expect(message.pinnedBy, null);
      expect(message.i18n, null);
      expect(message.restrictedVisibility, isA<List<String>>());
      expect(message.channelRole, 'channel_member');
    });

    test('should serialize to json correctly', () {
      final message = Message(
        id: '4637f7e4-a06b-42db-ba5a-8d8270dd926f',
        text:
            '@channel @admin @moderator '
            'https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA',
        attachments: [
          Attachment.fromJson(const {
            'type': 'giphy',
            'author_name': 'GIPHY',
            'title': 'The Lion King Disney GIF - Find \u0026 Share on GIPHY',
            'title_link': 'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif',
            'text':
                '''Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.''',
            'image_url': 'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif',
            'thumb_url': 'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif',
            'asset_url': 'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4',
          }),
        ],
        mentionedChannel: true,
        mentionedHere: false,
        mentionedRoles: const ['admin', 'moderator'],
        mentionedGroupIds: const ['group-1', 'group-2'],
        showInChannel: true,
        parentId: 'parentId',
        restrictedVisibility: const ['user-id-3'],
        extraData: const {'hey': 'test'},
      );

      expect(
        message.toJson(),
        jsonFixture('message_to_json.json'),
      );
    });

    test(
      'should append command to text field in toJson when command exists',
      () {
        final message = Message(
          id: 'message-id',
          text: 'Hello world',
          command: 'giphy',
        );

        final json = message.toJson();
        expect(json['text'], equals('/giphy Hello world'));
      },
    );

    test('should not modify text field when command is empty', () {
      final message = Message(
        id: 'message-id',
        text: 'Hello world',
        command: '',
      );

      final json = message.toJson();
      expect(json['text'], equals('Hello world'));
    });

    test('should not modify text field when command is null', () {
      final message = Message(
        id: 'message-id',
        text: 'Hello world',
        command: null,
      );

      final json = message.toJson();
      expect(json['text'], equals('Hello world'));
    });

    group('should remove mentions not found in text', () {
      test('drops user mentions whose @id and @name are absent', () {
        final user1 = User(id: 'user1', name: 'User One');
        final user2 = User(id: 'user2', name: 'User Two');
        final user3 = User(id: 'user3', name: 'User Three');

        final message = Message(
          id: 'message-id',
          text: 'Hello @user1 and @User Two',
          mentionedUsers: [user1, user2, user3],
        );

        final mentionedUserIds = (message.toJson()['mentioned_users'] as List).cast<String>();

        // user1 survives via @id, user2 via @name, user3 is dropped.
        expect(mentionedUserIds, containsAll(['user1', 'user2']));
        expect(mentionedUserIds, isNot(contains('user3')));
        expect(mentionedUserIds.length, equals(2));
      });

      test('drops channel mention when @channel is absent', () {
        final withToken = Message(
          id: 'with-token',
          text: 'Heads up @channel',
          mentionedChannel: true,
        );
        final withoutToken = Message(
          id: 'without-token',
          text: 'Heads up everyone',
          mentionedChannel: true,
        );

        expect(withToken.toJson()['mentioned_channel'], isTrue);
        expect(withoutToken.toJson()['mentioned_channel'], isFalse);
      });

      test('drops here mention when @here is absent', () {
        final withToken = Message(
          id: 'with-token',
          text: 'Anyone around @here?',
          mentionedHere: true,
        );
        final withoutToken = Message(
          id: 'without-token',
          text: 'Anyone around?',
          mentionedHere: true,
        );

        expect(withToken.toJson()['mentioned_here'], isTrue);
        expect(withoutToken.toJson()['mentioned_here'], isFalse);
      });

      test('drops role mentions whose @role token is absent', () {
        final message = Message(
          id: 'message-id',
          text: 'Calling @admin for help',
          mentionedRoles: const ['admin', 'moderator'],
        );

        expect(message.toJson()['mentioned_roles'], equals(['admin']));
      });

      test('drops group mentions whose @name is absent and re-derives ids', () {
        final stayingGroup = UserGroup(
          id: 'group-1',
          name: 'Engineering',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        );
        final droppedGroup = UserGroup(
          id: 'group-2',
          name: 'Design',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        );

        final message = Message(
          id: 'message-id',
          text: 'Ping @Engineering',
          mentionedGroupIds: const ['group-1', 'group-2'],
          mentionedGroups: [stayingGroup, droppedGroup],
        );

        final json = message.toJson();

        // Only Engineering survives; ids are re-derived from remaining groups.
        expect(json['mentioned_group_ids'], equals(['group-1']));
      });

      test('handles every mention kind together', () {
        final user1 = User(id: 'user1', name: 'User One');
        final user2 = User(id: 'user2', name: 'User Two');
        final user3 = User(id: 'user3', name: 'User Three');

        final stayingGroup = UserGroup(
          id: 'group-1',
          name: 'Engineering',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        );
        final droppedGroup = UserGroup(
          id: 'group-2',
          name: 'Design',
          createdAt: DateTime(2024),
          updatedAt: DateTime(2024),
        );

        final message = Message(
          id: 'message-id',
          text: 'Hello @user1 and @User Two — heads up @channel @admin @Engineering',
          mentionedUsers: [user1, user2, user3],
          mentionedChannel: true,
          mentionedHere: true,
          mentionedRoles: const ['admin', 'moderator'],
          mentionedGroupIds: const ['group-1', 'group-2'],
          mentionedGroups: [stayingGroup, droppedGroup],
        );

        final json = message.toJson();

        final mentionedUserIds = (json['mentioned_users'] as List).cast<String>();
        expect(mentionedUserIds, containsAll(['user1', 'user2']));
        expect(mentionedUserIds, isNot(contains('user3')));
        expect(mentionedUserIds.length, equals(2));

        expect(json['mentioned_channel'], isTrue);
        expect(json['mentioned_here'], isFalse);
        expect(json['mentioned_roles'], equals(['admin']));
        expect(json['mentioned_group_ids'], equals(['group-1']));
      });

      group('respects @token word boundaries', () {
        test('drops role admin when text only has @administrator', () {
          final message = Message(
            id: 'message-id',
            text: 'Calling @administrator urgently',
            mentionedRoles: const ['admin'],
          );

          expect(message.toJson()['mentioned_roles'], isEmpty);
        });

        test('drops mentionedChannel when text only has @channels', () {
          final message = Message(
            id: 'message-id',
            text: '@channels are useful',
            mentionedChannel: true,
          );

          expect(message.toJson()['mentioned_channel'], isFalse);
        });

        test('drops mentionedHere when text only has @hereafter', () {
          final message = Message(
            id: 'message-id',
            text: '@hereafter please ignore',
            mentionedHere: true,
          );

          expect(message.toJson()['mentioned_here'], isFalse);
        });

        test('drops user mention when text only has a longer @id match', () {
          final admin = User(id: 'admin', name: 'Admin');

          final message = Message(
            id: 'message-id',
            text: 'Calling @administrator urgently',
            mentionedUsers: [admin],
          );

          final mentionedUserIds = (message.toJson()['mentioned_users'] as List).cast<String>();
          expect(mentionedUserIds, isEmpty);
        });

        test('drops user mention when text only has a longer @name match', () {
          final adminUser = User(id: 'u-1', name: 'admin');

          final message = Message(
            id: 'message-id',
            text: 'Calling @administrator urgently',
            mentionedUsers: [adminUser],
          );

          final mentionedUserIds = (message.toJson()['mentioned_users'] as List).cast<String>();
          expect(mentionedUserIds, isEmpty);
        });

        test('drops group eng when text only has @engineering', () {
          final engGroup = UserGroup(
            id: 'group-eng',
            name: 'eng',
            createdAt: DateTime(2024),
            updatedAt: DateTime(2024),
          );

          final message = Message(
            id: 'message-id',
            text: 'Ping @engineering for review',
            mentionedGroupIds: const ['group-eng'],
            mentionedGroups: [engGroup],
          );

          final json = message.toJson();
          expect(json['mentioned_group_ids'], isEmpty);
        });
      });
    });

    group('ComparableFieldProvider', () {
      test('should return ComparableField for message.id', () {
        final message = createTestMessage(
          id: 'test-message-id',
          text: 'Hello world',
        );

        final field = message.getComparableField(MessageSortKey.id);
        expect(field, isNotNull);
        expect(field!.value, equals('test-message-id'));
      });

      test('should return ComparableField for message.createdAt', () {
        final createdAt = DateTime(2023, 6, 15);
        final message = createTestMessage(
          id: 'test-message-id',
          text: 'Hello world',
          createdAt: createdAt,
        );

        final field = message.getComparableField(MessageSortKey.createdAt);
        expect(field, isNotNull);
        expect(field!.value, equals(createdAt));
      });

      test('should return ComparableField for message.updatedAt', () {
        final updatedAt = DateTime(2023, 6, 20);
        final message = createTestMessage(
          id: 'test-message-id',
          text: 'Hello world',
          updatedAt: updatedAt,
        );

        final field = message.getComparableField(MessageSortKey.updatedAt);
        expect(field, isNotNull);
        expect(field!.value, equals(updatedAt));
      });

      test('should return ComparableField for message.extraData', () {
        final message = createTestMessage(
          id: 'test-message-id',
          text: 'Hello world',
          extraData: {'priority': 5},
        );

        final field = message.getComparableField('priority');
        expect(field, isNotNull);
        expect(field!.value, equals(5));
      });

      test('should return null for non-existent extraData keys', () {
        final message = createTestMessage(
          id: 'test-message-id',
          text: 'Hello world',
        );

        final field = message.getComparableField('non_existent_key');
        expect(field, isNull);
      });

      test('should compare two messages correctly using id', () {
        final message1 = createTestMessage(
          id: 'message-a',
          text: 'Message A',
        );

        final message2 = createTestMessage(
          id: 'message-b',
          text: 'Message B',
        );

        final field1 = message1.getComparableField(MessageSortKey.id);
        final field2 = message2.getComparableField(MessageSortKey.id);

        // message-a < message-b
        expect(field1!.compareTo(field2!), lessThan(0));
        // message-b > message-a
        expect(field2.compareTo(field1), greaterThan(0));
      });

      test('should compare two messages correctly using createdAt', () {
        final newerMessage = createTestMessage(
          id: 'newer',
          text: 'Newer Message',
          createdAt: DateTime(2023, 6, 15),
        );

        final olderMessage = createTestMessage(
          id: 'older',
          text: 'Older Message',
          createdAt: DateTime(2023, 6, 10),
        );

        final field1 = newerMessage.getComparableField(
          MessageSortKey.createdAt,
        );

        final field2 = olderMessage.getComparableField(
          MessageSortKey.createdAt,
        );

        // More recent > Less recent
        expect(field1!.compareTo(field2!), greaterThan(0));
        // Less recent < More recent
        expect(field2.compareTo(field1), lessThan(0));
      });

      test('should compare two messages correctly using extraData', () {
        final highPriorityMessage = createTestMessage(
          id: 'high',
          text: 'High Priority Message',
          extraData: {'priority': 10},
        );

        final lowPriorityMessage = createTestMessage(
          id: 'low',
          text: 'Low Priority Message',
          extraData: {'priority': 1},
        );

        final field1 = highPriorityMessage.getComparableField('priority');
        final field2 = lowPriorityMessage.getComparableField('priority');

        expect(field1!.compareTo(field2!), greaterThan(0)); // 10 > 1
        expect(field2.compareTo(field1), lessThan(0)); // 1 < 10
      });
    });

    group('reactionGroups', () {
      final reactionGroupLike = ReactionGroup(
        count: 1,
        sumScores: 1,
        firstReactionAt: DateTime.now(),
        lastReactionAt: DateTime.now(),
      );

      final reactionGroupLove = ReactionGroup(
        count: 2,
        sumScores: 5,
        firstReactionAt: DateTime.now(),
        lastReactionAt: DateTime.now(),
      );

      test('is populated directly if provided in constructor', () {
        final message = Message(
          reactionGroups: {
            'like': reactionGroupLike,
            'love': reactionGroupLove,
          },
        );

        expect(message.reactionGroups, isNotNull);
        expect(message.reactionGroups!['like'], reactionGroupLike);
        expect(message.reactionGroups!['love'], reactionGroupLove);
      });

      test(
        'uses reactionGroups when provided directly in constructor',
        () {
          final message = Message(
            reactionGroups: {
              'like': ReactionGroup(
                count: 1,
                sumScores: 1,
                firstReactionAt: DateTime.now(),
                lastReactionAt: DateTime.now(),
              ),
              'love': ReactionGroup(
                count: 2,
                sumScores: 5,
                firstReactionAt: DateTime.now(),
                lastReactionAt: DateTime.now(),
              ),
            },
          );

          expect(message.reactionGroups, isNotNull);
          expect(message.reactionGroups!.length, 2);
          expect(message.reactionGroups!['like']!.count, 1);
          expect(message.reactionGroups!['like']!.sumScores, 1);
          expect(message.reactionGroups!['love']!.count, 2);
          expect(message.reactionGroups!['love']!.sumScores, 5);
        },
      );
    });
  });

  group('MessageVisibility Extension Tests', () {
    group('hasRestrictedVisibility', () {
      test('should return false when restrictedVisibility is null', () {
        final message = Message(restrictedVisibility: null);
        expect(message.hasRestrictedVisibility, false);
      });

      test('should return false when restrictedVisibility is empty', () {
        final message = Message(restrictedVisibility: const []);
        expect(message.hasRestrictedVisibility, false);
      });

      test('should return true when restrictedVisibility has entries', () {
        final message = Message(restrictedVisibility: const ['user1', 'user2']);
        expect(message.hasRestrictedVisibility, true);
      });
    });

    group('isVisibleTo', () {
      test('should return true when restrictedVisibility is null', () {
        final message = Message(restrictedVisibility: null);
        expect(message.isVisibleTo('anyUser'), true);
      });

      test('should return true when restrictedVisibility is empty', () {
        final message = Message(restrictedVisibility: const []);
        expect(message.isVisibleTo('anyUser'), true);
      });

      test('should return true when user is in restrictedVisibility list', () {
        final message = Message(restrictedVisibility: const ['user1', 'user2', 'user3']);
        expect(message.isVisibleTo('user2'), true);
      });

      test('should return false when user is not in restrictedVisibility list', () {
        final message = Message(restrictedVisibility: const ['user1', 'user2', 'user3']);
        expect(message.isVisibleTo('user4'), false);
      });

      test('should handle case sensitivity correctly', () {
        final message = Message(restrictedVisibility: const ['User1', 'USER2']);
        expect(message.isVisibleTo('user1'), false, reason: 'Should be case sensitive');
        expect(message.isVisibleTo('User1'), true);
      });
    });

    group('isNotVisibleTo', () {
      test('should return false when restrictedVisibility is null', () {
        final message = Message(restrictedVisibility: null);
        expect(message.isNotVisibleTo('anyUser'), false);
      });

      test('should return false when restrictedVisibility is empty', () {
        final message = Message(restrictedVisibility: const []);
        expect(message.isNotVisibleTo('anyUser'), false);
      });

      test('should return false when user is in restrictedVisibility list', () {
        final message = Message(restrictedVisibility: const ['user1', 'user2', 'user3']);
        expect(message.isNotVisibleTo('user2'), false);
      });

      test('should return true when user is not in restrictedVisibility list', () {
        final message = Message(restrictedVisibility: const ['user1', 'user2', 'user3']);
        expect(message.isNotVisibleTo('user4'), true);
      });

      test('should be the exact opposite of isVisibleTo', () {
        final message = Message(restrictedVisibility: const ['user1', 'user2']);
        const userId = 'testUser';
        expect(message.isNotVisibleTo(userId), !message.isVisibleTo(userId));
      });
    });

    group('MessageType Extension Tests', () {
      test('should correctly compare extension type with string values', () {
        final regularMessage = Message(type: MessageType.regular);
        final ephemeralMessage = Message(type: MessageType.ephemeral);
        final errorMessage = Message(type: MessageType.error);
        final replyMessage = Message(type: MessageType.reply);
        final systemMessage = Message(type: MessageType.system);
        final deletedMessage = Message(type: MessageType.deleted);

        // Test comparing extension type with string literals
        expect(regularMessage.type == 'regular', isTrue);
        expect(ephemeralMessage.type == 'ephemeral', isTrue);
        expect(errorMessage.type == 'error', isTrue);
        expect(replyMessage.type == 'reply', isTrue);
        expect(systemMessage.type == 'system', isTrue);
        expect(deletedMessage.type == 'deleted', isTrue);

        // Test the helper methods
        expect(regularMessage.isRegular, isTrue);
        expect(ephemeralMessage.isEphemeral, isTrue);
        expect(errorMessage.isError, isTrue);
        expect(replyMessage.isReply, isTrue);
        expect(systemMessage.isSystem, isTrue);
        expect(deletedMessage.isDeleted, isTrue);
      });

      test('should correctly handle string assignment to MessageType', () {
        final message = Message(type: 'regular');
        expect(message.type, equals(MessageType.regular));
        expect(message.isRegular, isTrue);

        final customTypeMessage = Message(type: 'custom_type');
        expect(customTypeMessage.type, equals('custom_type'));
      });

      test('should correctly serialize and deserialize from json', () {
        expect(MessageType.toJson(MessageType.regular), equals('regular'));
        expect(MessageType.toJson(MessageType.system), equals('system'));
        expect(MessageType.toJson(MessageType.ephemeral), isNull);

        expect(MessageType.fromJson('regular'), equals(MessageType.regular));
        expect(MessageType.fromJson('custom'), equals('custom'));
      });
    });
  });

  group('MessageModerationHelper', () {
    test('should correctly identify different moderation actions', () {
      final flaggedMessage = Message(
        moderation: const Moderation(
          action: ModerationAction.flag,
          originalText: 'original text',
        ),
      );

      final bouncedMessage = Message(
        moderation: const Moderation(
          action: ModerationAction.bounce,
          originalText: 'original text',
        ),
      );

      final removedMessage = Message(
        moderation: const Moderation(
          action: ModerationAction.remove,
          originalText: 'original text',
        ),
      );

      final shadowedMessage = Message(
        moderation: const Moderation(
          action: ModerationAction.shadow,
          originalText: 'original text',
        ),
      );

      // Flagged message
      expect(flaggedMessage.isFlagged, isTrue);
      expect(flaggedMessage.isBounced, isFalse);
      expect(flaggedMessage.isRemoved, isFalse);
      expect(flaggedMessage.isShadowed, isFalse);

      // Bounced message
      expect(bouncedMessage.isFlagged, isFalse);
      expect(bouncedMessage.isBounced, isTrue);
      expect(bouncedMessage.isRemoved, isFalse);
      expect(bouncedMessage.isShadowed, isFalse);

      // Removed message
      expect(removedMessage.isFlagged, isFalse);
      expect(removedMessage.isBounced, isFalse);
      expect(removedMessage.isRemoved, isTrue);
      expect(removedMessage.isShadowed, isFalse);

      // Shadowed message
      expect(shadowedMessage.isFlagged, isFalse);
      expect(shadowedMessage.isBounced, isFalse);
      expect(shadowedMessage.isRemoved, isFalse);
      expect(shadowedMessage.isShadowed, isTrue);
    });

    test('should handle special cases in moderation', () {
      // Bounced message with error
      final bouncedWithErrorMessage = Message(
        type: MessageType.error,
        moderation: const Moderation(
          action: ModerationAction.bounce,
          originalText: 'original text',
        ),
      );
      expect(bouncedWithErrorMessage.isBouncedWithError, isTrue);

      // No moderation
      final noModerationMessage = Message(moderation: null);
      expect(noModerationMessage.isFlagged, isFalse);
      expect(noModerationMessage.isBounced, isFalse);
      expect(noModerationMessage.isRemoved, isFalse);
      expect(noModerationMessage.isShadowed, isFalse);

      // Custom moderation action
      final customModerationMessage = Message(
        moderation: const Moderation(
          action: ModerationAction('custom'),
          originalText: 'original text',
        ),
      );
      expect(customModerationMessage.isFlagged, isFalse);
      expect(customModerationMessage.isBounced, isFalse);
      expect(customModerationMessage.isRemoved, isFalse);
      expect(customModerationMessage.isShadowed, isFalse);
    });

    test('should handle backward compatibility with moderation_details', () {
      final json = {
        'id': 'test-message-id',
        'text': 'Hello world',
        'moderation_details': {
          'action': 'flag',
          'original_text': 'original message text',
        },
      };

      final message = Message.fromJson(json);
      expect(message.moderation, isNotNull);
      expect(message.moderation?.action, ModerationAction.flag);
      expect(message.moderation?.originalText, 'original message text');
      expect(message.isFlagged, isTrue);
    });
  });

  group('syncWith', () {
    test('should preserve local timestamps from the other message', () {
      final localCreatedAt = DateTime(2024, 1, 1);
      final localUpdatedAt = DateTime(2024, 1, 2);
      final localDeletedAt = DateTime(2024, 1, 3);

      final serverMessage = Message(id: 'msg-1', text: 'Hello');
      final localMessage = Message(
        id: 'msg-1',
        text: 'Hello',
        localCreatedAt: localCreatedAt,
        localUpdatedAt: localUpdatedAt,
        localDeletedAt: localDeletedAt,
      );

      final synced = serverMessage.syncWith(localMessage);
      expect(synced.localCreatedAt, localCreatedAt);
      expect(synced.localUpdatedAt, localUpdatedAt);
      expect(synced.localDeletedAt, localDeletedAt);
    });

    test('should return this if other is null', () {
      final message = Message(id: 'msg-1', text: 'Hello');
      final synced = message.syncWith(null);
      expect(identical(synced, message), isTrue);
    });

    test(
      'should preserve deletedForMe from local when server does not have it',
      () {
        final serverMessage = Message(
          id: 'msg-1',
          text: 'Hello',
        );
        final localMessage = Message(
          id: 'msg-1',
          text: 'Hello',
          deletedForMe: true,
          type: MessageType.deleted,
          state: MessageState.deletedForMe,
        );

        final synced = serverMessage.syncWith(localMessage);
        expect(synced.deletedForMe, isTrue);
        expect(synced.type, MessageType.deleted);
        expect(synced.state, MessageState.deletedForMe);
        expect(synced.isDeleted, isTrue);
      },
    );

    test(
      'should keep server deletedForMe when both server and local have it',
      () {
        final serverMessage = Message(
          id: 'msg-1',
          text: 'Hello',
          deletedForMe: true,
          type: MessageType.deleted,
          state: MessageState.deletedForMe,
        );
        final localMessage = Message(
          id: 'msg-1',
          text: 'Hello',
          deletedForMe: true,
          type: MessageType.deleted,
          state: MessageState.deletedForMe,
        );

        final synced = serverMessage.syncWith(localMessage);
        expect(synced.deletedForMe, isTrue);
        expect(synced.type, MessageType.deleted);
        expect(synced.state, MessageState.deletedForMe);
      },
    );

    test(
      'should not set deletedForMe when neither server nor local have it',
      () {
        final serverMessage = Message(id: 'msg-1', text: 'Hello');
        final localMessage = Message(id: 'msg-1', text: 'Hello');

        final synced = serverMessage.syncWith(localMessage);
        expect(synced.deletedForMe, isNull);
        expect(synced.type, isNot(MessageType.deleted));
      },
    );
  });

  group('updateWith', () {
    test('returns this unchanged when other is null', () {
      final message = createTestMessage(id: 'msg-1', text: 'Hello');
      final merged = message.updateWith(null);
      expect(identical(merged, message), isTrue);
    });

    test('preserves local timestamps from this onto the server payload', () {
      final localCreatedAt = DateTime(2024, 1, 1);
      final localUpdatedAt = DateTime(2024, 1, 2);
      final localDeletedAt = DateTime(2024, 1, 3);

      final localMessage = Message(
        id: 'msg-1',
        text: 'Hello',
        localCreatedAt: localCreatedAt,
        localUpdatedAt: localUpdatedAt,
        localDeletedAt: localDeletedAt,
      );
      final serverMessage = Message(id: 'msg-1', text: 'Hello (edited)');

      final merged = localMessage.updateWith(serverMessage);

      expect(merged.text, 'Hello (edited)');
      expect(merged.localCreatedAt, localCreatedAt);
      expect(merged.localUpdatedAt, localUpdatedAt);
      expect(merged.localDeletedAt, localDeletedAt);
    });

    test(
      'promotes deletedForMe + type/state when local was deleted-for-me but '
      'the server payload omits the flag',
      () {
        final localMessage = createTestMessage(
          id: 'msg-1',
          text: 'Hello',
          deletedForMe: true,
          type: MessageType.deleted,
          state: MessageState.deletedForMe,
        );
        final serverMessage = createTestMessage(id: 'msg-1', text: 'Hello');

        final merged = localMessage.updateWith(serverMessage);

        expect(merged.deletedForMe, isTrue);
        expect(merged.type, MessageType.deleted);
        expect(merged.state, MessageState.deletedForMe);
        expect(merged.isDeleted, isTrue);
      },
    );

    test(
      'preserves the local `poll` when the server payload omits it '
      '(regression: thread reply destroys poll on parent message)',
      () {
        final poll = Poll(
          id: 'poll-1',
          name: 'My poll',
          options: const [PollOption(id: 'a', text: 'A')],
          createdById: 'u',
        );
        final localMessage = createTestMessage(id: 'msg-1', text: 'Vote!', poll: poll, pollId: poll.id);

        // Server bumps `replyCount` but does not echo the `poll` object back.
        final serverMessage = createTestMessage(id: 'msg-1', text: 'Vote!', pollId: poll.id, replyCount: 1);

        final merged = localMessage.updateWith(serverMessage);

        expect(merged.replyCount, 1);
        expect(merged.poll, isNotNull);
        expect(merged.poll!.id, poll.id);
        expect(merged.poll!.name, poll.name);
      },
    );

    test('the server `poll`, when present, takes precedence over the local one', () {
      final localPoll = Poll(
        id: 'poll-1',
        name: 'Original',
        options: const [PollOption(id: 'a', text: 'A')],
        createdById: 'u',
      );
      final updatedPoll = localPoll.copyWith(name: 'Edited');

      final localMessage = createTestMessage(id: 'msg-1', text: 'Vote!', poll: localPoll, pollId: localPoll.id);
      final serverMessage = createTestMessage(id: 'msg-1', text: 'Vote!', poll: updatedPoll, pollId: updatedPoll.id);

      final merged = localMessage.updateWith(serverMessage);

      expect(merged.poll!.name, 'Edited');
    });

    test(
      'recursively preserves the embedded quotedMessage poll when the '
      'server returns a stripped nested `quoted_message` (regression #59)',
      () {
        final poll = Poll(
          id: 'poll-1',
          name: 'My poll',
          options: const [PollOption(id: 'a', text: 'A')],
          createdById: 'u',
        );
        final pollMessage = createTestMessage(id: 'poll-msg', poll: poll, pollId: poll.id);
        final localReply = createTestMessage(
          id: 'reply-1',
          text: 'My pick',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
        );
        // Constructed directly because copyWith cannot clear `poll` — see
        // Message.copyWith.
        final strippedQuoted = createTestMessage(id: pollMessage.id, pollId: pollMessage.pollId);
        final serverReply = localReply.copyWith(quotedMessage: strippedQuoted);

        final merged = localReply.updateWith(serverReply);

        expect(merged.quotedMessage, isNotNull);
        expect(merged.quotedMessage!.id, pollMessage.id);
        expect(merged.quotedMessage!.poll, isNotNull);
        expect(merged.quotedMessage!.poll!.id, poll.id);
      },
    );

    test(
      'preserves the entire local quotedMessage when the server payload '
      'has no nested `quoted_message` at all',
      () {
        final quoted = createTestMessage(id: 'quoted-1', text: 'Original');
        final localReply = createTestMessage(
          id: 'reply-1',
          text: 'Reply',
          quotedMessageId: quoted.id,
          quotedMessage: quoted,
        );
        final serverReply = createTestMessage(
          id: 'reply-1',
          text: 'Reply (edited)',
          quotedMessageId: quoted.id,
        );

        final merged = localReply.updateWith(serverReply);

        expect(merged.text, 'Reply (edited)');
        expect(merged.quotedMessage, isNotNull);
        expect(merged.quotedMessage!.id, quoted.id);
        expect(merged.quotedMessage!.text, 'Original');
      },
    );

    test(
      'when the user changes which message is being quoted, the server '
      'payload wins without recursive merging into the previous quote',
      () {
        final originalQuoted = createTestMessage(id: 'quoted-1', text: 'First');
        final newQuoted = createTestMessage(id: 'quoted-2', text: 'Second');
        final localReply = createTestMessage(
          id: 'reply-1',
          text: 'Reply',
          quotedMessageId: originalQuoted.id,
          quotedMessage: originalQuoted,
        );
        final serverReply = createTestMessage(
          id: 'reply-1',
          text: 'Reply',
          quotedMessageId: newQuoted.id,
          quotedMessage: newQuoted,
        );

        final merged = localReply.updateWith(serverReply);

        expect(merged.quotedMessage, isNotNull);
        expect(merged.quotedMessage!.id, newQuoted.id);
        expect(merged.quotedMessage!.text, 'Second');
      },
    );
  });
}

/// Helper function to create a Message for testing
Message createTestMessage({
  String? id,
  String? text,
  String type = 'regular',
  DateTime? createdAt,
  DateTime? updatedAt,
  User? user,
  Map<String, Object?>? extraData,
  List<String>? restrictedVisibility,
  Poll? poll,
  String? pollId,
  Message? quotedMessage,
  String? quotedMessageId,
  int replyCount = 0,
  bool? deletedForMe,
  MessageState state = const MessageState.initial(),
}) {
  return Message(
    id: id,
    text: text,
    type: type,
    state: state,
    localCreatedAt: createdAt,
    localUpdatedAt: updatedAt,
    user: user,
    extraData: extraData ?? {},
    restrictedVisibility: restrictedVisibility,
    poll: poll,
    pollId: pollId,
    quotedMessage: quotedMessage,
    quotedMessageId: quotedMessageId,
    replyCount: replyCount,
    deletedForMe: deletedForMe,
  );
}
