import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

void main() {
  test('User copies that differ only in createdAt are not equal', () {
    final user = User(id: 'u1', createdAt: DateTime.utc(2026));

    expect(user.copyWith(createdAt: DateTime.utc(2026, 2)), isNot(user));
  });

  test('User copies that differ only in updatedAt are equal', () {
    final user = User(id: 'u1', updatedAt: DateTime.utc(2026));

    expect(user.copyWith(updatedAt: DateTime.utc(2026, 2)), user);
  });
}
