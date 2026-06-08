import 'package:stream_chat/src/core/models/role_type.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/role_type', () {
    test('constants resolve to expected wire strings', () {
      expect(RoleType.user, 'user');
      expect(RoleType.channel, 'channel');
    });
  });
}
