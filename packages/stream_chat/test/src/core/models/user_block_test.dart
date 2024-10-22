import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/models/user_block.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/user_block', () {
    test('should parse json correctly', () {
      final userBlock = UserBlock.fromJson(jsonFixture('user_block.json'));
      expect(userBlock.userId, 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e');
      expect(userBlock.blockedUserId, 'c1c9b454-2bcc-402d-8bb0-2f3706ce1680');
      expect(
        userBlock.createdAt,
        DateTime.parse('2020-01-28T22:17:30.83015Z'),
      );
      expect(userBlock.user, isNotNull);
      expect(userBlock.blockedUser, isNotNull);
    });

    test('should serialize to json correctly', () {
      final userBlock = UserBlock(
        user: User(id: 'user-1'),
        blockedUser: User(id: 'user-2'),
        userId: 'user-1',
        blockedUserId: 'user-2',
        createdAt: DateTime.parse('2020-01-28T22:17:30.830150Z'),
      );

      expect(
        userBlock.toJson(),
        {
          'user': {'id': 'user-1'},
          'blocked_user': {'id': 'user-2'},
          'user_id': 'user-1',
          'blocked_user_id': 'user-2',
          'created_at': '2020-01-28T22:17:30.830150Z'
        },
      );
    });
  });
}
