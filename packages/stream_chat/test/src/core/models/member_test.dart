import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/member', () {
    test('should parse json correctly', () {
      final member = Member.fromJson(jsonFixture('member.json'));
      expect(member.user, isA<User>());
      expect(member.role, 'member');
      expect(member.createdAt, DateTime.parse('2020-01-28T22:17:30.95443Z'));
      expect(member.updatedAt, DateTime.parse('2020-01-28T22:17:30.95443Z'));
    });
  });
}
