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
      expect(reaction.type, 'wow');
      expect(
        reaction.user?.toJson(),
        User(id: '2de0297c-f3f2-489d-b930-ef77342edccf', extraData: {
          'image': 'https://randomuser.me/api/portraits/women/45.jpg',
          'name': 'Daisy Morgan'
        }).toJson(),
      );
      expect(reaction.score, 1);
      expect(reaction.userId, '2de0297c-f3f2-489d-b930-ef77342edccf');
      expect(reaction.extraData, {'updated_at': '2020-01-28T22:17:31.108742Z'});
    });

    test('should serialize to json correctly', () {
      final reaction = Reaction(
        messageId: '76cd8c82-b557-4e48-9d12-87995d3a0e04',
        createdAt: DateTime.parse('2020-01-28T22:17:31.108742Z'),
        type: 'wow',
        user: User(id: '2de0297c-f3f2-489d-b930-ef77342edccf', extraData: {
          'image': 'https://randomuser.me/api/portraits/women/45.jpg',
          'name': 'Daisy Morgan'
        }),
        userId: '2de0297c-f3f2-489d-b930-ef77342edccf',
        extraData: {'bananas': 'yes'},
        score: 1,
      );

      expect(
        reaction.toJson(),
        {
          'message_id': '76cd8c82-b557-4e48-9d12-87995d3a0e04',
          'type': 'wow',
          'score': 1,
          'bananas': 'yes',
        },
      );
    });

    test('copyWith', () {
      final reaction = Reaction.fromJson(jsonFixture('reaction.json'));
      var newReaction = reaction.copyWith();
      expect(newReaction.messageId, '76cd8c82-b557-4e48-9d12-87995d3a0e04');
      expect(
          newReaction.createdAt, DateTime.parse('2020-01-28T22:17:31.108742Z'));
      expect(newReaction.type, 'wow');
      expect(
        newReaction.user?.toJson(),
        User(id: '2de0297c-f3f2-489d-b930-ef77342edccf', extraData: const {
          'image': 'https://randomuser.me/api/portraits/women/45.jpg',
          'name': 'Daisy Morgan',
        }).toJson(),
      );
      expect(newReaction.score, 1);
      expect(newReaction.userId, '2de0297c-f3f2-489d-b930-ef77342edccf');
      expect(
          newReaction.extraData, {'updated_at': '2020-01-28T22:17:31.108742Z'});

      newReaction = reaction.copyWith(
        type: 'lol',
        createdAt: DateTime.parse('2021-01-28T22:17:31.108742Z'),
        extraData: {},
        messageId: 'test',
        score: 2,
        user: User(id: 'test'),
        userId: 'test',
      );

      expect(newReaction.type, 'lol');
      expect(
        newReaction.createdAt,
        DateTime.parse('2021-01-28T22:17:31.108742Z'),
      );
      expect(newReaction.extraData, {});
      expect(newReaction.messageId, 'test');
      expect(newReaction.score, 2);
      expect(newReaction.user, User(id: 'test'));
      expect(newReaction.userId, 'test');
    });

    test('merge', () {
      final reaction = Reaction.fromJson(jsonFixture('reaction.json'));
      final newReaction = reaction.merge(
        Reaction(
          type: 'lol',
          createdAt: DateTime.parse('2021-01-28T22:17:31.108742Z'),
          extraData: {},
          messageId: 'test',
          score: 2,
          user: User(id: 'test'),
          userId: 'test',
        ),
      );

      expect(
        newReaction.type,
        'lol',
      );
      expect(
        newReaction.createdAt,
        DateTime.parse('2021-01-28T22:17:31.108742Z'),
      );
      expect(
        newReaction.extraData,
        {},
      );
      expect(
        newReaction.messageId,
        'test',
      );
      expect(
        newReaction.score,
        2,
      );
      expect(
        newReaction.user,
        User(id: 'test'),
      );
      expect(
        newReaction.userId,
        'test',
      );
    });
  });
}
