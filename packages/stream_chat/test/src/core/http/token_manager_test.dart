import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:test/test.dart';

void main() {
  late TokenManager tokenManager;

  setUp(() {
    tokenManager = TokenManager();
  });

  tearDown(() {
    tokenManager.reset();
  });

  test('`setTokenOrProvider` should set token', () async {
    expect(tokenManager.userId, isNull);

    const userId = 'test-user-id';
    final token = Token.development(userId);
    final returnedToken = await tokenManager.setTokenOrProvider(
      userId,
      token: token,
    );

    expect(returnedToken, token);
    expect(tokenManager.userId, userId);
    expect(tokenManager.isStatic, isTrue);
  });

  test('`setTokenOrProvider` should set tokenProvider', () async {
    expect(tokenManager.userId, isNull);

    const userId = 'test-user-id';
    Future<String> tokenProvider(String userId) async =>
        Token.development(userId).rawValue;
    final returnedToken = await tokenManager.setTokenOrProvider(
      userId,
      provider: tokenProvider,
    );

    expect(returnedToken, isNotNull);
    expect(tokenManager.userId, userId);
    expect(tokenManager.isStatic, isFalse);
  });

  test(
    '''`setTokenOrProvider` should throw if both token and provider is not provided''',
    () async {
      expect(tokenManager.userId, isNull);

      const userId = 'test-user-id';
      try {
        await tokenManager.setTokenOrProvider(userId);
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    },
  );

  test(
    '`setTokenOrProvider` should throw if both token and provider is provided',
    () async {
      expect(tokenManager.userId, isNull);

      const userId = 'test-user-id';
      final token = Token.development(userId);
      Future<String> tokenProvider(String userId) async =>
          Token.development(userId).rawValue;
      try {
        await tokenManager.setTokenOrProvider(
          userId,
          token: token,
          provider: tokenProvider,
        );
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    },
  );

  test(
    '`.loadToken` should return token set via `setToken`',
    () async {
      const userId = 'test-user-id';
      final token = Token.development(userId);
      await tokenManager.setTokenOrProvider(userId, token: token);

      final returnedToken = await tokenManager.loadToken();
      expect(returnedToken, token);
    },
  );

  test(
    '`.loadToken` should return token set via `setProvider`',
    () async {
      const userId = 'test-user-id';
      final token = Token.development(userId);
      Future<String> tokenProvider(String userId) async => token.rawValue;
      await tokenManager.setTokenOrProvider(userId, provider: tokenProvider);

      final returnedToken = await tokenManager.loadToken();
      expect(returnedToken, token);
    },
  );

  test(
    '`.loadToken` should return refreshed token set via `setProvider`',
    () async {
      const userId = 'test-user-id';
      final token = Token.development(userId);
      final refreshToken = Token.development(userId);

      var refresh = false;

      Future<String> tokenProvider(String userId) async {
        if (refresh) return refreshToken.rawValue;
        return token.rawValue;
      }

      await tokenManager.setTokenOrProvider(userId, provider: tokenProvider);

      final returnedToken = await tokenManager.loadToken();
      expect(returnedToken, token);

      refresh = true;
      final returnedRefreshToken = await tokenManager.loadToken(refresh: true);
      expect(returnedRefreshToken, refreshToken);
    },
  );

  test('`.reset` should reset the tokenManager', () async {
    const userId = 'test-user-id';
    final token = Token.development(userId);
    await tokenManager.setTokenOrProvider(userId, token: token);
    expect(tokenManager.userId, userId);

    tokenManager.reset();
    expect(tokenManager.userId, isNull);
  });
}
