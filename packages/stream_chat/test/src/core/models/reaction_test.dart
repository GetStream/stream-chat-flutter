import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/reaction', () {
    test('should parse json correctly', () {
      final reaction = Reaction.fromJson(jsonFixture('reaction.json'));
      expect(reaction.messageId, '76cd8c82-b557-4e48-9d12-87995d3a0e04');
      expect(reaction.createdAt, DateTime.parse('2020-01-28T22:17:31.108742Z'));
      expect(reaction.updatedAt, DateTime.parse('2020-01-28T22:17:31.108742Z'));
      expect(reaction.type, 'wow');
      expect(
        reaction.user?.toJson(),
        {
          'id': '2de0297c-f3f2-489d-b930-ef77342edccf',
          'role': 'user',
          'teams': [],
          'created_at': '2020-01-28T22:17:30.810011Z',
          'updated_at': '2020-01-28T22:17:31.077195Z',
          'online': false,
          'banned': false,
          'image': 'https://randomuser.me/api/portraits/women/45.jpg',
          'name': 'Daisy Morgan',
        },
      );
      expect(reaction.score, 1);
      expect(reaction.userId, '2de0297c-f3f2-489d-b930-ef77342edccf');
      expect(reaction.emojiCode, '😮');
    });

    test('should serialize to json correctly', () {
      final reaction = Reaction(
        messageId: '76cd8c82-b557-4e48-9d12-87995d3a0e04',
        createdAt: DateTime.parse('2020-01-28T22:17:31.108742Z'),
        updatedAt: DateTime.parse('2020-01-28T22:17:31.108742Z'),
        type: 'wow',
        user: User(
          id: '2de0297c-f3f2-489d-b930-ef77342edccf',
          image: 'https://randomuser.me/api/portraits/women/45.jpg',
          name: 'Daisy Morgan',
        ),
        userId: '2de0297c-f3f2-489d-b930-ef77342edccf',
        extraData: const {'bananas': 'yes'},
        emojiCode: '😮',
      );

      expect(
        reaction.toJson(),
        {
          'type': 'wow',
          'score': 1,
          'emoji_code': '😮',
          'bananas': 'yes',
        },
      );
    });

    test('copyWith', () {
      final reaction = Reaction.fromJson(jsonFixture('reaction.json'));
      var newReaction = reaction.copyWith();
      expect(newReaction.messageId, '76cd8c82-b557-4e48-9d12-87995d3a0e04');
      expect(newReaction.createdAt, DateTime.parse('2020-01-28T22:17:31.108742Z'));
      expect(newReaction.updatedAt, DateTime.parse('2020-01-28T22:17:31.108742Z'));
      expect(newReaction.type, 'wow');
      expect(
        newReaction.user?.toJson(),
        {
          'id': '2de0297c-f3f2-489d-b930-ef77342edccf',
          'role': 'user',
          'teams': [],
          'created_at': '2020-01-28T22:17:30.810011Z',
          'updated_at': '2020-01-28T22:17:31.077195Z',
          'online': false,
          'banned': false,
          'image': 'https://randomuser.me/api/portraits/women/45.jpg',
          'name': 'Daisy Morgan',
        },
      );
      expect(newReaction.score, 1);
      expect(newReaction.userId, '2de0297c-f3f2-489d-b930-ef77342edccf');
      expect(newReaction.emojiCode, '😮');

      final newUserCreateTime = DateTime.now();

      newReaction = reaction.copyWith(
        type: 'lol',
        emojiCode: '😂',
        createdAt: DateTime.parse('2021-01-28T22:17:31.108742Z'),
        updatedAt: DateTime.parse('2021-01-28T22:17:31.108742Z'),
        extraData: {},
        messageId: 'test',
        score: 2,
        user: User(
          id: 'test',
          createdAt: newUserCreateTime,
          updatedAt: newUserCreateTime,
        ),
        userId: 'test',
      );

      expect(newReaction.type, 'lol');
      expect(newReaction.emojiCode, '😂');
      expect(
        newReaction.createdAt,
        DateTime.parse('2021-01-28T22:17:31.108742Z'),
      );
      expect(
        newReaction.updatedAt,
        DateTime.parse('2021-01-28T22:17:31.108742Z'),
      );
      expect(newReaction.extraData, {});
      expect(newReaction.messageId, 'test');
      expect(newReaction.score, 2);
      expect(
        newReaction.user,
        User(
          id: 'test',
          createdAt: newUserCreateTime,
          updatedAt: newUserCreateTime,
        ),
      );
      expect(newReaction.userId, 'test');
    });

    group('ComparableFieldProvider', () {
      test('should return ComparableField for reaction.createdAt', () {
        final createdAt = DateTime(2020, 1, 28);
        final reaction = Reaction(type: 'like', createdAt: createdAt);

        final field = reaction.getComparableField(ReactionSortKey.createdAt);
        expect(field, isNotNull);
        expect(field!.value, equals(createdAt));
      });

      test('should return null for non-existent field keys', () {
        final reaction = Reaction(type: 'like');

        final field = reaction.getComparableField('non_existent_key');
        expect(field, isNull);
      });

      test('should compare two reactions correctly using createdAt', () {
        final recentReaction = Reaction(
          type: 'like',
          createdAt: DateTime(2020, 6, 15),
        );
        final olderReaction = Reaction(
          type: 'like',
          createdAt: DateTime(2020, 6, 10),
        );

        final field1 = recentReaction.getComparableField(ReactionSortKey.createdAt);
        final field2 = olderReaction.getComparableField(ReactionSortKey.createdAt);

        expect(field1!.compareTo(field2!), greaterThan(0)); // more recent > older
        expect(field2.compareTo(field1), lessThan(0)); // older < more recent
      });
    });

    test('merge', () {
      final reaction = Reaction.fromJson(jsonFixture('reaction.json'));
      final newUserCreateTime = DateTime.now();

      final newReaction = reaction.merge(
        Reaction(
          type: 'lol',
          emojiCode: '😂',
          createdAt: DateTime.parse('2021-01-28T22:17:31.108742Z'),
          updatedAt: DateTime.parse('2021-01-28T22:17:31.108742Z'),
          messageId: 'test',
          score: 2,
          user: User(
            id: 'test',
            createdAt: newUserCreateTime,
            updatedAt: newUserCreateTime,
          ),
          userId: 'test',
        ),
      );

      expect(newReaction.type, 'lol');
      expect(newReaction.emojiCode, '😂');
      expect(
        newReaction.createdAt,
        DateTime.parse('2021-01-28T22:17:31.108742Z'),
      );
      expect(
        newReaction.updatedAt,
        DateTime.parse('2021-01-28T22:17:31.108742Z'),
      );
      expect(newReaction.extraData, {});
      expect(newReaction.messageId, 'test');
      expect(newReaction.score, 2);
      expect(
        newReaction.user,
        User(
          id: 'test',
          createdAt: newUserCreateTime,
          updatedAt: newUserCreateTime,
        ),
      );
      expect(newReaction.userId, 'test');
    });
  });
}
