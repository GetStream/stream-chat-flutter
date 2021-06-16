import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/user', () {
    test('should parse json correctly', () {
      final user = User.fromJson(jsonFixture('user.json'));
      expect(user.id, 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e');
    });

    test('should serialize to json correctly', () {
      final user = User(
        id: 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e',
        role: 'abc',
      );

      expect(user.toJson(), {
        'id': 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e',
      });
    });
  });
}
