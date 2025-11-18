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
      expect(read.lastReadMessageId, '8cc1301d-2d47-4305-945a-cd8e19b736d6');
      expect(
        read.lastDeliveredAt,
        DateTime.parse('2020-01-28T22:17:30.966485504Z'),
      );
      expect(
        read.lastDeliveredMessageId,
        '8cc1301d-2d47-4305-945a-cd8e19b736d6',
      );
    });

    test('should serialize to json correctly', () {
      final read = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e'),
        unreadMessages: 10,
        lastReadMessageId: '8cc1301d-2d47-4305-945a-cd8e19b736d6',
        lastDeliveredAt: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        lastDeliveredMessageId: '8cc1301d-2d47-4305-945a-cd8e19b736d6',
      );

      expect(read.toJson(), {
        'user': {
          'id': 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e',
          'teams': [],
          'online': false,
          'banned': false
        },
        'last_read': '2020-01-28T22:17:30.966485Z',
        'unread_messages': 10,
        'last_read_message_id': '8cc1301d-2d47-4305-945a-cd8e19b736d6',
        'last_delivered_at': '2020-01-28T22:17:30.966485Z',
        'last_delivered_message_id': '8cc1301d-2d47-4305-945a-cd8e19b736d6',
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
      expect(read.lastReadMessageId, '8cc1301d-2d47-4305-945a-cd8e19b736d6');

      newRead = read.copyWith(
        user: User(id: 'test'),
        lastRead: DateTime.parse('2021-01-28T22:17:30.966485504Z'),
        unreadMessages: 2,
        lastReadMessageId: 'last_test',
        lastDeliveredAt: DateTime.parse('2021-01-28T22:17:30.966485504Z'),
        lastDeliveredMessageId: 'last_delivered_test',
      );

      expect(
        newRead.lastRead,
        DateTime.parse('2021-01-28T22:17:30.966485504Z'),
      );
      expect(newRead.user.id, 'test');
      expect(newRead.unreadMessages, 2);
      expect(newRead.lastReadMessageId, 'last_test');
      expect(
        newRead.lastDeliveredAt,
        DateTime.parse('2021-01-28T22:17:30.966485504Z'),
      );
      expect(newRead.lastDeliveredMessageId, 'last_delivered_test');
    });

    test('merge with null should return the same instance', () {
      final read = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
        lastReadMessageId: 'message-1',
        lastDeliveredAt: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        lastDeliveredMessageId: 'delivered-1',
      );

      final merged = read.merge(null);

      expect(merged, same(read));
    });

    test('merge should override all fields with other read', () {
      final read1 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
        lastReadMessageId: 'message-1',
        lastDeliveredAt: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        lastDeliveredMessageId: 'delivered-1',
      );

      final read2 = Read(
        lastRead: DateTime.parse('2021-05-15T10:30:00.000000Z'),
        user: User(id: 'user-2'),
        unreadMessages: 5,
        lastReadMessageId: 'message-2',
        lastDeliveredAt: DateTime.parse('2021-05-15T10:30:00.000000Z'),
        lastDeliveredMessageId: 'delivered-2',
      );

      final merged = read1.merge(read2);

      expect(merged.lastRead, read2.lastRead);
      expect(merged.user.id, read2.user.id);
      expect(merged.unreadMessages, read2.unreadMessages);
      expect(merged.lastReadMessageId, read2.lastReadMessageId);
      expect(merged.lastDeliveredAt, read2.lastDeliveredAt);
      expect(merged.lastDeliveredMessageId, read2.lastDeliveredMessageId);
    });

    test('merge should handle null optional fields', () {
      final read1 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
        lastReadMessageId: 'message-1',
        lastDeliveredAt: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        lastDeliveredMessageId: 'delivered-1',
      );

      final read2 = Read(
        lastRead: DateTime.parse('2021-05-15T10:30:00.000000Z'),
        user: User(id: 'user-2'),
        unreadMessages: 0,
      );

      final merged = read1.merge(read2);

      expect(merged.lastRead, read2.lastRead);
      expect(merged.user.id, read2.user.id);
      expect(merged.unreadMessages, 0);
      // When merging, null values in read2 should preserve read1's values
      expect(merged.lastReadMessageId, read1.lastReadMessageId);
      expect(merged.lastDeliveredAt, read1.lastDeliveredAt);
      expect(merged.lastDeliveredMessageId, read1.lastDeliveredMessageId);
    });

    test('equality should return true for identical reads', () {
      final read1 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
        lastReadMessageId: 'message-1',
        lastDeliveredAt: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        lastDeliveredMessageId: 'delivered-1',
      );

      final read2 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
        lastReadMessageId: 'message-1',
        lastDeliveredAt: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        lastDeliveredMessageId: 'delivered-1',
      );

      expect(read1, equals(read2));
      expect(read1.hashCode, equals(read2.hashCode));
    });

    test('equality should return false for different lastRead', () {
      final read1 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
      );

      final read2 = Read(
        lastRead: DateTime.parse('2021-05-15T10:30:00.000000Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
      );

      expect(read1, isNot(equals(read2)));
    });

    test('equality should return false for different user', () {
      final read1 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
      );

      final read2 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-2'),
        unreadMessages: 10,
      );

      expect(read1, isNot(equals(read2)));
    });

    test('equality should return false for different unreadMessages', () {
      final read1 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
      );

      final read2 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 5,
      );

      expect(read1, isNot(equals(read2)));
    });

    test('equality should return false for different lastReadMessageId', () {
      final read1 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
        lastReadMessageId: 'message-1',
      );

      final read2 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
        lastReadMessageId: 'message-2',
      );

      expect(read1, isNot(equals(read2)));
    });

    test('equality should return false for different lastDeliveredAt', () {
      final read1 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
        lastDeliveredAt: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
      );

      final read2 = Read(
        lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
        user: User(id: 'user-1'),
        unreadMessages: 10,
        lastDeliveredAt: DateTime.parse('2021-05-15T10:30:00.000000Z'),
      );

      expect(read1, isNot(equals(read2)));
    });

    test(
      'equality should return false for different lastDeliveredMessageId',
      () {
        final read1 = Read(
          lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
          user: User(id: 'user-1'),
          unreadMessages: 10,
          lastDeliveredMessageId: 'delivered-1',
        );

        final read2 = Read(
          lastRead: DateTime.parse('2020-01-28T22:17:30.966485504Z'),
          user: User(id: 'user-1'),
          unreadMessages: 10,
          lastDeliveredMessageId: 'delivered-2',
        );

        expect(read1, isNot(equals(read2)));
      },
    );
  });
}
