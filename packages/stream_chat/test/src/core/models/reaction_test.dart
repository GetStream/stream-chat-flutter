import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

// The reaction in fixtures/reaction.json, built directly.
Reaction _fixtureReaction() {
  final json = jsonFixture('reaction.json');
  return Reaction(
    messageId: json['message_id'] as String,
    type: json['type'] as String,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    userId: json['user_id'] as String,
    score: json['score'] as int,
    emojiCode: json['emoji_code'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}

void main() {
  group('src/models/reaction', () {
    test('copyWith', () {
      final reaction = _fixtureReaction();
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

    group('ReactionSortField', () {
      test('createdAt orders older reactions first', () {
        expectOrders(
          ReactionSortField.createdAt,
          Reaction(type: 'like', createdAt: DateTime(2020, 6, 10)),
          Reaction(type: 'like', createdAt: DateTime(2020, 6, 15)),
        );
      });
    });

    test('merge', () {
      final reaction = _fixtureReaction();
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
