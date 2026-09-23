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
    expect(token.authType.name, AuthType.anonymous.name);
  });

  test('`.fromRawValue` should create token from rawValue', () {
    const userId = 'test-user-id';
    final devToken = Token.development(userId);
    final token = Token.fromRawValue(devToken.rawValue);
    expect(token, devToken);
  });

  test('`.fromRawValue` should throw if the raw value is not a valid JWT', () {
    const notAJwt = 'bad-token-without-a-user-id';
    expect(() => Token.fromRawValue(notAJwt), throwsA(isA<ArgumentError>()));
  });

  test('`.fromRawValue` should throw if does not contain `user_id`', () {
    // A well-formed JWT whose payload carries no `user_id` claim.
    const header = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';
    const payload = 'eyJmb28iOiJiYXIifQ';
    const tokenWithoutUserId = '$header.$payload.devtoken';

    expect(
      () => Token.fromRawValue(tokenWithoutUserId),
      throwsA(isA<AssertionError>()),
    );
  });

  test('`.development` should create a dev-token with provided user-id', () {
    const userId = 'test-user-id';
    final token = Token.development(userId);
    expect(token, isNotNull);
    expect(token.userId, userId);
    expect(token.rawValue, isNotEmpty);
    expect(token.authType, AuthType.jwt);
    expect(token.authType.name, AuthType.jwt.name);
  });

  test(
    '`.guest` should create a guest-token with provided user and provider',
    () async {
      final user = User(id: 'test-user-id');
      Future<String> provider(User user) async => Token.development(user.id).rawValue;

      final token = await Token.guest(user, provider);
      expect(token, isNotNull);
      expect(token.userId, user.id);
      expect(token.rawValue, isNotEmpty);
      expect(token.authType, AuthType.jwt);
      expect(token.authType.name, AuthType.jwt.name);
    },
  );
}
