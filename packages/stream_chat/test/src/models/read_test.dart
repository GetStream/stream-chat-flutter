import 'dart:convert';

import 'package:test/test.dart';
import 'package:stream_chat/src/models/read.dart';
import 'package:stream_chat/src/models/user.dart';

void main() {
  group('src/models/read', () {
    const jsonExample = '''
      {
        "user": {
          "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e"
        },
        "last_read": "2020-01-28T22:17:30.966485504Z",
        "unread_messages": 10
      }     
      ''';

    test('should parse json correctly', () {
      final read = Read.fromJson(json.decode(jsonExample));
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
  });
}
