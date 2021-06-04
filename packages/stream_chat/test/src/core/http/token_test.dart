import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  test('`.anonymous` should create anonymous token with passed userId', () {
    const userId = 'test-user-id';
    final token = Token.anonymous(userId: userId);
    expect(token, isNotNull);
    expect(token.userId, userId);
    expect(token.rawValue, isEmpty);
    expect(token.authType, AuthType.anonymous);
    expect(token.authType.raw, AuthType.anonymous.raw);
  });

  test('`.fromRawValue` should create token from rawValue', () {
    const userId = 'test-user-id';
    final devToken = Token.development(userId);
    final token = Token.fromRawValue(devToken.rawValue);
    expect(token, devToken);
  });

  test('`.fromRawValue` should throw if does not contain `user_id`', () {
    const badToken = 'bad-token-without-a-user-id';
    try {
      Token.fromRawValue(badToken);
    } catch (e) {
      expect(e, isA<ArgumentError>());
    }
  });

  test('`.development` should create a dev-token with provided user-id', () {
    const userId = 'test-user-id';
    final token = Token.development(userId);
    expect(token, isNotNull);
    expect(token.userId, userId);
    expect(token.rawValue, isNotEmpty);
    expect(token.authType, AuthType.jwt);
    expect(token.authType.raw, AuthType.jwt.raw);
  });

  test(
    '`.guest` should create a guest-token with provided user and provider',
    () async {
      final user = User(id: 'test-user-id');
      Future<String> provider(User user) async =>
          Token.development(user.id).rawValue;

      final token = await Token.guest(user, provider);
      expect(token, isNotNull);
      expect(token.userId, user.id);
      expect(token.rawValue, isNotEmpty);
      expect(token.authType, AuthType.jwt);
      expect(token.authType.raw, AuthType.jwt.raw);
    },
  );
}
