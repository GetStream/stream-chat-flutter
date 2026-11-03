import 'dart:async';

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
    Future<String> tokenProvider(String userId) async => Token.development(userId).rawValue;
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
      await expectLater(
        tokenManager.setTokenOrProvider(userId),
        throwsA(isA<AssertionError>()),
      );
    },
  );

  test(
    '`setTokenOrProvider` should throw if both token and provider is provided',
    () async {
      expect(tokenManager.userId, isNull);

      const userId = 'test-user-id';
      final token = Token.development(userId);
      Future<String> tokenProvider(String userId) async => Token.development(userId).rawValue;
      await expectLater(
        tokenManager.setTokenOrProvider(
          userId,
          token: token,
          provider: tokenProvider,
        ),
        throwsA(isA<AssertionError>()),
      );
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

  test('`.loadToken` fetches a new token after a refresh fails', () async {
    const userId = 'test-user-id';
    final expiredToken = Token.development(userId);
    final newToken = Token.fromRawValue('${expiredToken.rawValue}-new');

    var providerCalls = 0;
    Future<String> tokenProvider(String userId) async {
      providerCalls += 1;
      return switch (providerCalls) {
        1 => expiredToken.rawValue,
        2 => throw Exception('token provider is down'),
        _ => newToken.rawValue,
      };
    }

    await tokenManager.setTokenOrProvider(userId, provider: tokenProvider);

    await expectLater(tokenManager.loadToken(refresh: true), throwsException);

    expect(await tokenManager.loadToken(), newToken);
  });

  test('`.loadToken` keeps a token set while a failed refresh was pending', () async {
    final refresh = Completer<String>();
    var providerCalls = 0;
    Future<String> tokenProvider(String userId) async {
      providerCalls += 1;
      if (providerCalls == 2) return refresh.future;
      return Token.development(userId).rawValue;
    }

    await tokenManager.setTokenOrProvider('user-a', provider: tokenProvider);
    final pendingRefresh = tokenManager.loadToken(refresh: true);

    tokenManager.reset();
    final userBToken = Token.development('user-b');
    await tokenManager.setTokenOrProvider('user-b', token: userBToken);

    refresh.completeError(Exception('token provider is down'));
    await expectLater(pendingRefresh, throwsException);

    expect(await tokenManager.loadToken(), userBToken);
  });

  test('`.reset` should reset the tokenManager', () async {
    const userId = 'test-user-id';
    final token = Token.development(userId);
    await tokenManager.setTokenOrProvider(userId, token: token);
    expect(tokenManager.userId, userId);

    tokenManager.reset();
    expect(tokenManager.userId, isNull);
  });
}
