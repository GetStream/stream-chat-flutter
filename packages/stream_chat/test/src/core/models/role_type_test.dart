import 'package:stream_chat/stream_chat.dart' show RoleType;
import 'package:test/test.dart';

void main() {
  group('src/models/role_type', () {
    test('should carry its wire value', () {
      expect(RoleType.user, 'user');
      expect(RoleType.channel, 'channel');
    });

    test('should interchange with a raw string', () {
      const fromLiteral = RoleType('user');

      expect(fromLiteral, RoleType.user);
      expect(RoleType.user.rawType, 'user');
      expect(<String>[RoleType.user, RoleType.channel], ['user', 'channel']);
    });

    test('should accept a value the SDK does not name', () {
      const unknown = RoleType('team');

      expect(unknown, 'team');
    });
  });
}
