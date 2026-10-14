import 'package:stream_chat/stream_chat.dart' show RoleType;
import 'package:test/test.dart';

void main() {
  test('RoleType carries its wire value', () {
    expect(RoleType.user, 'user');
    expect(RoleType.channel, 'channel');
  });

  test('RoleType interchanges with a raw string', () {
    const raw = 'user';

    expect(RoleType.user, raw);
    expect(RoleType.user.rawType, raw);
    expect(<String>[RoleType.user, RoleType.channel], ['user', 'channel']);
  });

  test('RoleType accepts a value the SDK does not name', () {
    const unknown = RoleType('team');

    expect(unknown, 'team');
  });
}
