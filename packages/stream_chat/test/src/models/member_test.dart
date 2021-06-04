import 'dart:convert';

import 'package:test/test.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/user.dart';

void main() {
  group('src/models/member', () {
    const jsonExample = '''
      {
          "user": {
              "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
              "role": "user",
              "created_at": "2020-01-28T22:17:30.826259Z",
              "updated_at": "2020-01-28T22:17:31.101222Z",
              "banned": false,
              "online": false,
              "name": "Robin Papa",
              "image": "https://pbs.twimg.com/profile_images/669512187778498560/L7wQctBt.jpg"
          },
          "role": "member",
          "created_at": "2020-01-28T22:17:30.95443Z",
          "updated_at": "2020-01-28T22:17:30.95443Z"
      }     
      ''';

    test('should parse json correctly', () {
      final member = Member.fromJson(json.decode(jsonExample));
      expect(member.user, isA<User>());
      expect(member.role, 'member');
      expect(member.createdAt, DateTime.parse('2020-01-28T22:17:30.95443Z'));
      expect(member.updatedAt, DateTime.parse('2020-01-28T22:17:30.95443Z'));
    });
  });
}
