// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/reaction_group.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

void main() {
  group('MessageReactionHelper', () {
    late User testUser;
    late Message emptyMessage;
    late Reaction testReaction;

    setUp(() {
      testUser = User(id: 'test-user-id');
      emptyMessage = Message(id: 'test-message-id');
      testReaction = Reaction(
        type: 'like',
        score: 1,
        user: testUser,
        userId: testUser.id,
        messageId: emptyMessage.id,
      );
    });

    group('addMyReaction', () {
      test('should add reaction to a message without reactions', () {
        final updatedMessage = emptyMessage.addMyReaction(testReaction);

        // Verify own reactions
        expect(updatedMessage.ownReactions, isNotNull);
        expect(updatedMessage.ownReactions!.length, 1);
        expect(updatedMessage.ownReactions!.first.type, 'like');
        expect(updatedMessage.ownReactions!.first.userId, testUser.id);

        // Verify latest reactions
        expect(updatedMessage.latestReactions, isNotNull);
        expect(updatedMessage.latestReactions!.length, 1);
        expect(updatedMessage.latestReactions!.first.type, 'like');
        expect(updatedMessage.latestReactions!.first.userId, testUser.id);

        // Verify reaction groups
        expect(updatedMessage.reactionGroups, isNotNull);
        expect(updatedMessage.reactionGroups!.containsKey('like'), isTrue);
        expect(updatedMessage.reactionGroups!['like']!.count, 1);
        expect(updatedMessage.reactionGroups!['like']!.sumScores, 1);
        expect(updatedMessage.reactionGroups!['like']!.firstReactionAt, testReaction.createdAt);
        expect(updatedMessage.reactionGroups!['like']!.lastReactionAt, testReaction.createdAt);
      });

      test('should add reaction to a message with existing reactions', () {
        // Create a message with existing reactions
        final otherUser = User(id: 'other-user-id');
        final otherReaction = Reaction(
          type: 'love',
          score: 1,
          user: otherUser,
          userId: otherUser.id,
          messageId: emptyMessage.id,
        );

        final existingReactions = [otherReaction];
        final existingGroups = {
          'love': ReactionGroup(
            count: 1,
            sumScores: 1,
            firstReactionAt: otherReaction.createdAt,
            lastReactionAt: otherReaction.createdAt,
          ),
        };

        final messageWithReactions = emptyMessage.copyWith(
          ownReactions: [],
          latestReactions: existingReactions,
          reactionGroups: existingGroups,
        );

        // Add new reaction
        final updatedMessage = messageWithReactions.addMyReaction(testReaction);

        // Verify own reactions
        expect(updatedMessage.ownReactions, isNotNull);
        expect(updatedMessage.ownReactions!.length, 1);
        expect(updatedMessage.ownReactions!.first.type, 'like');

        // Verify latest reactions
        expect(updatedMessage.latestReactions, isNotNull);
        expect(updatedMessage.latestReactions!.length, 2);
        expect(updatedMessage.latestReactions!.first.type, 'like');
        expect(updatedMessage.latestReactions!.last.type, 'love');

        // Verify reaction groups
        expect(updatedMessage.reactionGroups, isNotNull);
        expect(updatedMessage.reactionGroups!.length, 2);
        expect(updatedMessage.reactionGroups!.containsKey('like'), isTrue);
        expect(updatedMessage.reactionGroups!.containsKey('love'), isTrue);
        expect(updatedMessage.reactionGroups!['like']!.count, 1);
        expect(updatedMessage.reactionGroups!['love']!.count, 1);
      });

      test('should replace existing reaction when enforceUnique is true', () {
        // First add a reaction
        final messageWithReaction = emptyMessage.addMyReaction(testReaction);

        // Then add a different reaction with enforceUnique
        final newReaction = Reaction(
          type: 'love',
          score: 1,
          user: testUser,
          userId: testUser.id,
          messageId: emptyMessage.id,
        );

        final updatedMessage = messageWithReaction.addMyReaction(
          newReaction,
          enforceUnique: true,
        );

        // Should only have the love reaction, not the like reaction
        expect(updatedMessage.ownReactions, isNotNull);
        expect(updatedMessage.ownReactions!.length, 1);
        expect(updatedMessage.ownReactions!.first.type, 'love');

        // Verify reaction groups
        expect(updatedMessage.reactionGroups!.containsKey('like'), isFalse);
        expect(updatedMessage.reactionGroups!.containsKey('love'), isTrue);
      });

      test('should keep existing reaction when enforceUnique is false', () {
        // First add a reaction
        final messageWithReaction = emptyMessage.addMyReaction(testReaction);

        // Then add a different reaction without enforceUnique
        final newReaction = Reaction(
          type: 'love',
          score: 1,
          user: testUser,
          userId: testUser.id,
          messageId: emptyMessage.id,
        );

        final updatedMessage = messageWithReaction.addMyReaction(
          newReaction,
          enforceUnique: false,
        );

        // Should have both reactions
        expect(updatedMessage.ownReactions, isNotNull);
        expect(updatedMessage.ownReactions!.length, 2);

        final reactionTypes = updatedMessage.ownReactions!.map((r) => r.type).toList();
        expect(reactionTypes, contains('like'));
        expect(reactionTypes, contains('love'));

        // Verify reaction groups
        expect(updatedMessage.reactionGroups!.containsKey('like'), isTrue);
        expect(updatedMessage.reactionGroups!.containsKey('love'), isTrue);
      });

      test('should update existing reaction group with same type', () {
        // First add a reaction
        final messageWithReaction = emptyMessage.addMyReaction(testReaction);

        // Another user adds same reaction type
        final otherUser = User(id: 'other-user-id');
        final otherReaction = Reaction(
          type: 'like',
          score: 2,
          user: otherUser,
          userId: otherUser.id,
          messageId: emptyMessage.id,
        );

        final updatedMessage = messageWithReaction.addMyReaction(otherReaction);

        // Verify reaction group count and scores are updated
        expect(updatedMessage.reactionGroups!['like']!.count, 2);
        expect(updatedMessage.reactionGroups!['like']!.sumScores, 3); // 1 + 2
      });
    });

    group('deleteMyReaction', () {
      test('should handle message with no reactions', () {
        final updatedMessage = emptyMessage.deleteMyReaction();
        expect(updatedMessage, emptyMessage);
      });

      test('should delete all reactions from current user', () {
        // Setup a message with multiple reactions from test user
        final reaction1 = Reaction(
          type: 'like',
          score: 1,
          user: testUser,
          userId: testUser.id,
          messageId: emptyMessage.id,
        );

        final reaction2 = Reaction(
          type: 'love',
          score: 1,
          user: testUser,
          userId: testUser.id,
          messageId: emptyMessage.id,
        );

        // Add reactions from the test user
        final messageWithReactions = emptyMessage.copyWith(
          ownReactions: [reaction1, reaction2],
          latestReactions: [reaction1, reaction2],
          reactionGroups: {
            'like': ReactionGroup(
              count: 1,
              sumScores: 1,
              firstReactionAt: reaction1.createdAt,
              lastReactionAt: reaction1.createdAt,
            ),
            'love': ReactionGroup(
              count: 1,
              sumScores: 1,
              firstReactionAt: reaction2.createdAt,
              lastReactionAt: reaction2.createdAt,
            ),
          },
        );

        // Delete all reactions
        final updatedMessage = messageWithReactions.deleteMyReaction();

        expect(updatedMessage.ownReactions, isEmpty);
        expect(updatedMessage.latestReactions, isEmpty);
        expect(updatedMessage.reactionGroups, isEmpty);
      });

      test('should delete only specified reaction type', () {
        // Setup a message with multiple reactions from test user
        final reaction1 = Reaction(
          type: 'like',
          score: 1,
          user: testUser,
          userId: testUser.id,
          messageId: emptyMessage.id,
        );

        final reaction2 = Reaction(
          type: 'love',
          score: 1,
          user: testUser,
          userId: testUser.id,
          messageId: emptyMessage.id,
        );

        // Add reactions from the test user
        final messageWithReactions = emptyMessage.copyWith(
          ownReactions: [reaction1, reaction2],
          latestReactions: [reaction1, reaction2],
          reactionGroups: {
            'like': ReactionGroup(
              count: 1,
              sumScores: 1,
              firstReactionAt: reaction1.createdAt,
              lastReactionAt: reaction1.createdAt,
            ),
            'love': ReactionGroup(
              count: 1,
              sumScores: 1,
              firstReactionAt: reaction2.createdAt,
              lastReactionAt: reaction2.createdAt,
            ),
          },
        );

        // Delete only the 'like' reaction
        final updatedMessage = messageWithReactions.deleteMyReaction(
          reactionType: 'like',
        );

        // Should have removed only the 'like' reaction
        expect(updatedMessage.ownReactions!.length, 1);
        expect(updatedMessage.ownReactions!.first.type, 'love');
        expect(updatedMessage.latestReactions!.length, 1);
        expect(updatedMessage.latestReactions!.first.type, 'love');
        expect(updatedMessage.reactionGroups!.length, 1);
        expect(updatedMessage.reactionGroups!.containsKey('love'), isTrue);
        expect(updatedMessage.reactionGroups!.containsKey('like'), isFalse);
      });

      test('should preserve other users reactions when deleting', () {
        // Setup test user reaction
        final reaction1 = Reaction(
          type: 'like',
          score: 1,
          user: testUser,
          userId: testUser.id,
          messageId: emptyMessage.id,
        );

        // Setup other user reaction
        final otherUser = User(id: 'other-user-id');
        final otherReaction = Reaction(
          type: 'like',
          score: 1,
          user: otherUser,
          userId: otherUser.id,
          messageId: emptyMessage.id,
        );

        // Add reactions from both users
        final messageWithReactions = emptyMessage.copyWith(
          ownReactions: [reaction1],
          latestReactions: [reaction1, otherReaction],
          reactionGroups: {
            'like': ReactionGroup(
              count: 2,
              sumScores: 2,
              firstReactionAt: reaction1.createdAt,
              lastReactionAt: otherReaction.createdAt,
            ),
          },
        );

        // Delete test user reaction
        final updatedMessage = messageWithReactions.deleteMyReaction();

        // Should have removed only the test user's reaction
        expect(updatedMessage.ownReactions, isEmpty);
        expect(updatedMessage.latestReactions!.length, 1);
        expect(updatedMessage.latestReactions!.first.userId, otherUser.id);
        expect(updatedMessage.reactionGroups!.length, 1);
        expect(updatedMessage.reactionGroups!['like']!.count, 1);
        expect(updatedMessage.reactionGroups!['like']!.sumScores, 1);
      });

      test('should update reaction group counts when deleting reaction', () {
        // Setup a message with reactions from multiple users
        final reaction1 = Reaction(
          type: 'like',
          score: 3, // Higher score
          user: testUser,
          userId: testUser.id,
          messageId: emptyMessage.id,
        );

        // Add reactions
        final messageWithReactions = emptyMessage.copyWith(
          ownReactions: [reaction1],
          latestReactions: [reaction1],
          reactionGroups: {
            'like': ReactionGroup(
              count: 1,
              sumScores: 3,
              firstReactionAt: reaction1.createdAt,
              lastReactionAt: reaction1.createdAt,
            ),
          },
        );

        // Delete reaction
        final updatedMessage = messageWithReactions.deleteMyReaction();

        // Should have updated the reaction group counts
        expect(updatedMessage.reactionGroups, isEmpty);
      });
    });
  });
}
