// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/message', () {
    test('should parse json correctly', () {
      final message = Message.fromJson(jsonFixture('message.json'));
      expect(message.id, '4637f7e4-a06b-42db-ba5a-8d8270dd926f');
      expect(message.text,
          'https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA');
      expect(message.type, 'regular');
      expect(message.user, isA<User>());
      expect(message.silent, isA<bool>());
      expect(message.attachments, isA<List<Attachment>>());
      expect(message.latestReactions, isA<List<Reaction>>());
      expect(message.ownReactions, isA<List<Reaction>>());
      expect(message.reactionCounts, {'love': 1});
      expect(message.reactionScores, {'love': 1});
      expect(message.createdAt, DateTime.parse('2020-01-28T22:17:31.107978Z'));
      expect(message.updatedAt, DateTime.parse('2020-01-28T22:17:31.130506Z'));
      expect(message.mentionedUsers, isA<List<User>>());
      expect(message.pinned, false);
      expect(message.pinnedAt, null);
      expect(message.pinExpires, null);
      expect(message.pinnedBy, null);
      expect(message.i18n, null);
      expect(message.restrictedVisibility, isA<List<String>>());
    });

    test('should serialize to json correctly', () {
      final message = Message(
        id: '4637f7e4-a06b-42db-ba5a-8d8270dd926f',
        text:
            'https://giphy.com/gifs/the-lion-king-live-action-5zvN79uTGfLMOVfQaA',
        attachments: [
          Attachment.fromJson(const {
            'type': 'giphy',
            'author_name': 'GIPHY',
            'title': 'The Lion King Disney GIF - Find \u0026 Share on GIPHY',
            'title_link':
                'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif',
            'text':
                '''Discover \u0026 share this Lion King Live Action GIF with everyone you know. GIPHY is how you search, share, discover, and create GIFs.''',
            'image_url':
                'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif',
            'thumb_url':
                'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.gif',
            'asset_url':
                'https://media.giphy.com/media/5zvN79uTGfLMOVfQaA/giphy.mp4',
          })
        ],
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
        final message =
            Message(restrictedVisibility: const ['user1', 'user2', 'user3']);
        expect(message.isVisibleTo('user2'), true);
      });

      test('should return false when user is not in restrictedVisibility list',
          () {
        final message =
            Message(restrictedVisibility: const ['user1', 'user2', 'user3']);
        expect(message.isVisibleTo('user4'), false);
      });

      test('should handle case sensitivity correctly', () {
        final message = Message(restrictedVisibility: const ['User1', 'USER2']);
        expect(message.isVisibleTo('user1'), false,
            reason: 'Should be case sensitive');
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
        final message =
            Message(restrictedVisibility: const ['user1', 'user2', 'user3']);
        expect(message.isNotVisibleTo('user2'), false);
      });

      test('should return true when user is not in restrictedVisibility list',
          () {
        final message =
            Message(restrictedVisibility: const ['user1', 'user2', 'user3']);
        expect(message.isNotVisibleTo('user4'), true);
      });

      test('should be the exact opposite of isVisibleTo', () {
        final message = Message(restrictedVisibility: const ['user1', 'user2']);
        const userId = 'testUser';
        expect(message.isNotVisibleTo(userId), !message.isVisibleTo(userId));
      });
    });
  });
}
