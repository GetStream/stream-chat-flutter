import 'package:stream_chat/src/core/models/read.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/read', () {
    test('should parse json correctly', () {
      final read = Read.fromJson(jsonFixture('read.json'));
      expect(read.lastRead, DateTime.parse('2020-01-28T22:17:30.966485504Z'));
      expect(read.user.id, 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e');
      expect(read.unreadMessages, 10);
    });

    test('should serialize to json correctly', () {
      final read = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e'),
        unreadMessages: 10,
      );

      expect(read.toJson(), {
        'user': {'id': 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e'},
        'last_read': '2020-01-28T22:17:30.966485Z',
        'unread_messages': 10,
      });
    });

    test('copyWith', () {
      final read = Read.fromJson(jsonFixture('read.json'));
      var newRead = read.copyWith();
      expect(
        newRead.lastRead,
        DateTime.parse('2020-01-28T22:17:30.966485504Z'),
      );
      expect(newRead.user.id, 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e');
      expect(newRead.unreadMessages, 10);

      newRead = read.copyWith(
        user: User(id: 'test'),
        lastRead: DateTime.parse('2021-01-28T22:17:30.966485504Z'),
        unreadMessages: 2,
      );

      expect(
        newRead.lastRead,
        DateTime.parse('2021-01-28T22:17:30.966485504Z'),
      );
      expect(newRead.user.id, 'test');
      expect(newRead.unreadMessages, 2);
    });
  });
}
