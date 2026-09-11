// ignore_for_file: avoid_redundant_argument_values, lines_longer_than_80_chars, deprecated_member_use_from_same_package

import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../matchers.dart';
import '../utils.dart';

void main() {
  group('Fake web-socket connection functions', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, ws: ws, chatApi: api);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should work fine', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectUser(user, token);
      expect(res, isNotNull);
      expect(res, isSameUserAs(user));
    });

    test('`.connectUserWithProvider` should work fine', () async {
      final user = User(id: 'test-user-id');
      Future<String> tokenProvider(String userId) async {
        expect(userId, user.id);
        return Token.development(userId).rawValue;
      }

      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectUserWithProvider(user, tokenProvider);
      expect(res, isNotNull);
      expect(res, isSameUserAs(user));
    });

    group('`.connectGuestUser`', () {
      test('should work fine', () async {
        final user = User(id: 'test-user-id');
        final token = Token.development(user.id).rawValue;

        when(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).thenAnswer(
          (_) async => ConnectGuestUserResponse()
            ..user = user
            ..accessToken = token,
        );

        expectLater(
          // skipping first seed status -> ConnectionStatus.disconnected
          client.wsConnectionStatusStream.skip(1),
          emitsInOrder([
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
          ]),
        );

        final res = await client.connectGuestUser(user);
        expect(res, isNotNull);
        expect(res, isSameUserAs(user));

        verify(
          () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        ).called(1);
      });

      test('should throw if `.getGuestUser` fails', () async {
        final user = User(id: 'test-user-id');

        when(
          () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

        expectLater(
          client.wsConnectionStatusStream,
          emitsInOrder([
            // only emits the seed -> disconnected status
            // as the call never reaches `ws.connect`
            ConnectionStatus.disconnected,
          ]),
        );

        try {
          await client.connectGuestUser(user);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        verify(
          () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
        ).called(1);
      });
    });

    test('`.connectAnonymousUser` should work fine', () async {
      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectAnonymousUser();
      expect(res, isNotNull);
    });

    group('`.openConnection`', () {
      test('should throw if state does not contain user', () async {
        expect(client.state.currentUser, isNull);
        try {
          await client.openConnection();
        } catch (e) {
          expect(e, isA<AssertionError>());
        }
      });

      test('should throw if connection is already available', () async {
        expect(client.state.currentUser, isNull);
        try {
          await client.connectAnonymousUser();
          // waiting 300ms for `wsConnectionStatusStream` to emit
          await delay(300);

          await client.openConnection();
        } catch (e) {
          expect(e, isA<StreamChatError>());
          final err = e as StreamChatError;
          expect(
            err.message.contains('Connection already available for'),
            isTrue,
          );
        }
      });

      test('should open connection for closed connection', () async {
        expectLater(
          client.wsConnectionStatusStream.skip(1),
          emitsInOrder([
            // initial connectUser
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
            // close connection
            ConnectionStatus.disconnected,
            // open connection
            ConnectionStatus.connecting,
            ConnectionStatus.connected,
          ]),
        );

        await client.connectAnonymousUser();
        // waiting 300ms for `wsConnectionStatusStream` to emit
        await delay(300);

        client.closeConnection();

        await client.openConnection();
      });
    });
  });

  group('Fake web-socket connection functions failure', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      final ws = FakeWebSocketWithConnectionError();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should throw if `ws.connect` fails', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      try {
        await client.connectUser(user, token);
      } catch (e) {
        expect(e, isA<StreamWebSocketError>());
      }
    });

    test(
      '`.connectUserWithProvider` should throw if `ws.connect` fails',
      () async {
        final user = User(id: 'test-user-id');
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return Token.development(userId).rawValue;
        }

        try {
          await client.connectUserWithProvider(user, tokenProvider);
        } catch (e) {
          expect(e, isA<StreamWebSocketError>());
        }
      },
    );

    test('`.connectGuestUser` should throw if `ws.connect` fails', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      when(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).thenAnswer(
        (_) async => ConnectGuestUserResponse()
          ..user = user
          ..accessToken = token,
      );

      try {
        await client.connectGuestUser(user);
      } catch (e) {
        expect(e, isA<StreamWebSocketError>());
      }
      verify(
        () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
      ).called(1);
    });

    test(
      '`.connectAnonymousUser` should throw if `ws.connect` fails',
      () async {
        try {
          await client.connectAnonymousUser();
        } catch (e) {
          expect(e, isA<StreamWebSocketError>());
        }
      },
    );
  });

  group('Connect user calls with `connectWebSocket`: false', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      client = StreamChatClient(apiKey, chatApi: api);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectUser` should succeed without connecting', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      final res = await client.connectUser(
        user,
        token,
        connectWebSocket: false,
      );
      expect(res, isSameUserAs(user));
      expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
    });

    test(
      '`.connectUserWithProvider` should succeed without connecting',
      () async {
        final user = User(id: 'test-user-id');
        Future<String> tokenProvider(String userId) async {
          expect(userId, user.id);
          return Token.development(userId).rawValue;
        }

        final res = await client.connectUserWithProvider(
          user,
          tokenProvider,
          connectWebSocket: false,
        );
        expect(res, isSameUserAs(user));
        expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
      },
    );

    test('`.connectGuestUser` should succeed without connecting', () async {
      final user = User(id: 'test-user-id');
      final token = Token.development(user.id).rawValue;

      when(() => api.guest.getGuestUser(any(that: isSameUserAs(user)))).thenAnswer(
        (_) async => ConnectGuestUserResponse()
          ..user = user
          ..accessToken = token,
      );

      final res = await client.connectGuestUser(
        user,
        connectWebSocket: false,
      );

      expect(res, isSameUserAs(user));
      expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
      verify(
        () => api.guest.getGuestUser(any(that: isSameUserAs(user))),
      ).called(1);
    });

    test(
      '`.connectAnonymousUser` should succeed without connecting',
      () async {
        final res = await client.connectAnonymousUser(
          connectWebSocket: false,
        );

        expect(res, isNotNull);
        expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
      },
    );
  });

  group('Client with connected user without persistence', () {
    const apiKey = 'test-api-key';
    const userId = 'test-user-id';
    late final api = FakeChatApi();

    final user = User(id: userId);
    final token = Token.development(user.id).rawValue;

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(FakeEvent());
      registerFallbackValue(FakeMessage());
      registerFallbackValue(FakeDraftMessage());
      registerFallbackValue(FakePollVote());
      registerFallbackValue(const PaginationParams());
    });

    setUp(() async {
      // Clear any accumulated interactions from a previous test so that
      // verifyNoMoreInteractions on api.general stays accurate.
      clearInteractions(api.general);

      final ws = FakeWebSocket();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      // Stub getAppSettings so the background fetch after connectUser succeeds.
      when(() => api.general.getAppSettings()).thenAnswer(
        (_) async => GetAppSettingsResponse()..app = const AppSettings(name: 'test'),
      );
      await client.connectUser(user, token);
      await delay(300);
      expect(client.persistenceEnabled, isFalse);
      expect(client.wsConnectionStatus, ConnectionStatus.connected);
    });

    tearDown(() async {
      await client.dispose();
    });
  });
}
